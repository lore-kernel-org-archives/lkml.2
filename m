Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab0HEUA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:00:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382Ab0HEUAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:00:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Thu, 5 Aug 2010 21:58:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@lists.osdl.org, stephan.diestelhorst@amd.com
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C52DF50.80009@kernel.org> <4C5AE1E2.6070601@gmail.com>
In-Reply-To: <4C5AE1E2.6070601@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008052158.36385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 05, 2010, Tejun Heo wrote:
> Hello, Rafael.
> 
> Can you please try the following patch and see whether the problem
> goes away?

I'm going to LinuxCon shortly and I'm afraid I won't be able to test it until
I get back home.  However, it seems that Stephan could reproduce the issue
more easily, so parhaps he'll be able to test it earlier.

Thanks,
Rafael


>  drivers/ata/ahci.c          |    3
>  drivers/ata/ahci.h          |    1
>  drivers/ata/ahci_platform.c |    3
>  drivers/ata/ata_piix.c      |   24 +++
>  drivers/ata/libahci.c       |  161 +++++++-------------------
>  drivers/ata/libata-core.c   |  269 ++++++++++----------------------------------
>  drivers/ata/libata-eh.c     |  176 +++++++++++++++++++++++++---
>  drivers/ata/libata-pmp.c    |   49 +++++++-
>  drivers/ata/libata-scsi.c   |   74 ++++--------
>  drivers/ata/libata.h        |   12 +
>  include/linux/libata.h      |   40 +++---
>  11 files changed, 393 insertions(+), 419 deletions(-)
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index f252253..cfdc22b 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1190,9 +1190,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
>  				   0x100 + ap->port_no * 0x80, "port");
> 
> -		/* set initial link pm policy */
> -		ap->pm_policy = NOT_AVAILABLE;
> -
>  		/* set enclosure management message type */
>  		if (ap->flags & ATA_FLAG_EM)
>  			ap->em_message_type = hpriv->em_msg_type;
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 7113c57..6d07948 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -201,7 +201,6 @@ enum {
>  	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
>  	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
>  	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
> -	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
>  	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
>  	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
>  	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 5e11b16..0f69afe 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -120,9 +120,6 @@ static int __init ahci_probe(struct platform_device *pdev)
>  		ata_port_desc(ap, "mmio %pR", mem);
>  		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
> 
> -		/* set initial link pm policy */
> -		ap->pm_policy = NOT_AVAILABLE;
> -
>  		/* set enclosure management message type */
>  		if (ap->flags & ATA_FLAG_EM)
>  			ap->em_message_type = hpriv->em_msg_type;
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 7409f98..0df0477 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -174,6 +174,8 @@ static int piix_sidpr_scr_read(struct ata_link *link,
>  			       unsigned int reg, u32 *val);
>  static int piix_sidpr_scr_write(struct ata_link *link,
>  				unsigned int reg, u32 val);
> +static int piix_sidpr_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			      unsigned hints);
>  static bool piix_irq_check(struct ata_port *ap);
>  #ifdef CONFIG_PM
>  static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
> @@ -343,11 +345,22 @@ static struct ata_port_operations ich_pata_ops = {
>  	.set_dmamode		= ich_set_dmamode,
>  };
> 
> +static struct device_attribute *piix_sidpr_shost_attrs[] = {
> +	&dev_attr_link_power_management_policy,
> +	NULL
> +};
> +
> +static struct scsi_host_template piix_sidpr_sht = {
> +	ATA_BMDMA_SHT(DRV_NAME),
> +	.shost_attrs		= piix_sidpr_shost_attrs,
> +};
> +
>  static struct ata_port_operations piix_sidpr_sata_ops = {
>  	.inherits		= &piix_sata_ops,
>  	.hardreset		= sata_std_hardreset,
>  	.scr_read		= piix_sidpr_scr_read,
>  	.scr_write		= piix_sidpr_scr_write,
> +	.set_ipm		= piix_sidpr_set_ipm,
>  };
> 
>  static const struct piix_map_db ich5_map_db = {
> @@ -973,6 +986,12 @@ static int piix_sidpr_scr_write(struct ata_link *link,
>  	return 0;
>  }
> 
> +static int piix_sidpr_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			      unsigned hints)
> +{
> +	return sata_link_scr_ipm(link, policy, false);
> +}
> +
>  static bool piix_irq_check(struct ata_port *ap)
>  {
>  	if (unlikely(!ap->ioaddr.bmdma_addr))
> @@ -1532,6 +1551,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
>  	struct device *dev = &pdev->dev;
>  	struct ata_port_info port_info[2];
>  	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
> +	struct scsi_host_template *sht = &piix_sht;
>  	unsigned long port_flags;
>  	struct ata_host *host;
>  	struct piix_host_priv *hpriv;
> @@ -1600,6 +1620,8 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
>  		rc = piix_init_sidpr(host);
>  		if (rc)
>  			return rc;
> +		if (host->ports[0]->ops == &piix_sidpr_sata_ops)
> +			sht = &piix_sidpr_sht;
>  	}
> 
>  	/* apply IOCFG bit18 quirk */
> @@ -1626,7 +1648,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
>  	host->flags |= ATA_HOST_PARALLEL_SCAN;
> 
>  	pci_set_master(pdev);
> -	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &piix_sht);
> +	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
>  }
> 
>  static void piix_remove_one(struct pci_dev *pdev)
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index 81e772a..2c5f3df 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -56,9 +56,8 @@ MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)
>  module_param_named(ignore_sss, ahci_ignore_sss, int, 0444);
>  MODULE_PARM_DESC(ignore_sss, "Ignore staggered spinup flag (0=don't ignore, 1=ignore)");
> 
> -static int ahci_enable_alpm(struct ata_port *ap,
> -		enum link_pm policy);
> -static void ahci_disable_alpm(struct ata_port *ap);
> +static int ahci_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			unsigned hints);
>  static ssize_t ahci_led_show(struct ata_port *ap, char *buf);
>  static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
>  			      size_t size);
> @@ -172,8 +171,7 @@ struct ata_port_operations ahci_ops = {
>  	.pmp_attach		= ahci_pmp_attach,
>  	.pmp_detach		= ahci_pmp_detach,
> 
> -	.enable_pm		= ahci_enable_alpm,
> -	.disable_pm		= ahci_disable_alpm,
> +	.set_ipm		= ahci_set_ipm,
>  	.em_show		= ahci_led_show,
>  	.em_store		= ahci_led_store,
>  	.sw_activity_show	= ahci_activity_show,
> @@ -644,127 +642,59 @@ static void ahci_power_up(struct ata_port *ap)
>  	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
>  }
> 
> -static void ahci_disable_alpm(struct ata_port *ap)
> +static int ahci_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			unsigned int hints)
>  {
> +	struct ata_port *ap = link->ap;
>  	struct ahci_host_priv *hpriv = ap->host->private_data;
> -	void __iomem *port_mmio = ahci_port_base(ap);
> -	u32 cmd;
>  	struct ahci_port_priv *pp = ap->private_data;
> -
> -	/* IPM bits should be disabled by libata-core */
> -	/* get the existing command bits */
> -	cmd = readl(port_mmio + PORT_CMD);
> -
> -	/* disable ALPM and ASP */
> -	cmd &= ~PORT_CMD_ASP;
> -	cmd &= ~PORT_CMD_ALPE;
> -
> -	/* force the interface back to active */
> -	cmd |= PORT_CMD_ICC_ACTIVE;
> -
> -	/* write out new cmd value */
> -	writel(cmd, port_mmio + PORT_CMD);
> -	cmd = readl(port_mmio + PORT_CMD);
> -
> -	/* wait 10ms to be sure we've come out of any low power state */
> -	msleep(10);
> -
> -	/* clear out any PhyRdy stuff from interrupt status */
> -	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
> -
> -	/* go ahead and clean out PhyRdy Change from Serror too */
> -	ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
> -
> -	/*
> -	 * Clear flag to indicate that we should ignore all PhyRdy
> -	 * state changes
> -	 */
> -	hpriv->flags &= ~AHCI_HFLAG_NO_HOTPLUG;
> -
> -	/*
> -	 * Enable interrupts on Phy Ready.
> -	 */
> -	pp->intr_mask |= PORT_IRQ_PHYRDY;
> -	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
> -
> -	/*
> -	 * don't change the link pm policy - we can be called
> -	 * just to turn of link pm temporarily
> -	 */
> -}
> -
> -static int ahci_enable_alpm(struct ata_port *ap,
> -	enum link_pm policy)
> -{
> -	struct ahci_host_priv *hpriv = ap->host->private_data;
>  	void __iomem *port_mmio = ahci_port_base(ap);
> -	u32 cmd;
> -	struct ahci_port_priv *pp = ap->private_data;
> -	u32 asp;
> 
> -	/* Make sure the host is capable of link power management */
> -	if (!(hpriv->cap & HOST_CAP_ALPM))
> -		return -EINVAL;
> +	ata_link_printk(link, KERN_INFO, "XXX ahci_set_ipm: pol=%d hints=%x\n",
> +			policy, hints);
> 
> -	switch (policy) {
> -	case MAX_PERFORMANCE:
> -	case NOT_AVAILABLE:
> +	if (policy != ATA_IPM_MAX_POWER) {
>  		/*
> -		 * if we came here with NOT_AVAILABLE,
> -		 * it just means this is the first time we
> -		 * have tried to enable - default to max performance,
> -		 * and let the user go to lower power modes on request.
> +		 * Disable interrupts on Phy Ready. This keeps us from
> +		 * getting woken up due to spurious phy ready
> +		 * interrupts.
>  		 */
> -		ahci_disable_alpm(ap);
> -		return 0;
> -	case MIN_POWER:
> -		/* configure HBA to enter SLUMBER */
> -		asp = PORT_CMD_ASP;
> -		break;
> -	case MEDIUM_POWER:
> -		/* configure HBA to enter PARTIAL */
> -		asp = 0;
> -		break;
> -	default:
> -		return -EINVAL;
> +		pp->intr_mask &= ~PORT_IRQ_PHYRDY;
> +		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
> +
> +		sata_link_scr_ipm(link, policy, false);
>  	}
> 
> -	/*
> -	 * Disable interrupts on Phy Ready. This keeps us from
> -	 * getting woken up due to spurious phy ready interrupts
> -	 * TBD - Hot plug should be done via polling now, is
> -	 * that even supported?
> -	 */
> -	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
> -	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
> +	if (hpriv->cap & HOST_CAP_ALPM) {
> +		u32 cmd = readl(port_mmio + PORT_CMD);
> 
> -	/*
> -	 * Set a flag to indicate that we should ignore all PhyRdy
> -	 * state changes since these can happen now whenever we
> -	 * change link state
> -	 */
> -	hpriv->flags |= AHCI_HFLAG_NO_HOTPLUG;
> +		if (policy == ATA_IPM_MAX_POWER || !(hints & ATA_IPM_HIPM)) {
> +			cmd &= ~(PORT_CMD_ASP | PORT_CMD_ALPE);
> +			cmd |= PORT_CMD_ICC_ACTIVE;
> 
> -	/* get the existing command bits */
> -	cmd = readl(port_mmio + PORT_CMD);
> +			writel(cmd, port_mmio + PORT_CMD);
> +			readl(port_mmio + PORT_CMD);
> 
> -	/*
> -	 * Set ASP based on Policy
> -	 */
> -	cmd |= asp;
> +			/* wait 10ms to be sure we've come out of IPM state */
> +			msleep(10);
> +		} else {
> +			cmd |= PORT_CMD_ALPE;
> +			if (policy == ATA_IPM_MIN_POWER)
> +				cmd |= PORT_CMD_ASP;
> 
> -	/*
> -	 * Setting this bit will instruct the HBA to aggressively
> -	 * enter a lower power link state when it's appropriate and
> -	 * based on the value set above for ASP
> -	 */
> -	cmd |= PORT_CMD_ALPE;
> +			/* write out new cmd value */
> +			writel(cmd, port_mmio + PORT_CMD);
> +		}
> +	}
> 
> -	/* write out new cmd value */
> -	writel(cmd, port_mmio + PORT_CMD);
> -	cmd = readl(port_mmio + PORT_CMD);
> +	if (policy == ATA_IPM_MAX_POWER) {
> +		sata_link_scr_ipm(link, policy, false);
> +
> +		/* turn PHYRDY IRQ back on */
> +		pp->intr_mask |= PORT_IRQ_PHYRDY;
> +		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
> +	}
> 
> -	/* IPM bits should be set by libata-core */
>  	return 0;
>  }
> 
> @@ -1662,15 +1592,10 @@ static void ahci_port_intr(struct ata_port *ap)
>  	if (unlikely(resetting))
>  		status &= ~PORT_IRQ_BAD_PMP;
> 
> -	/* If we are getting PhyRdy, this is
> -	 * just a power state change, we should
> -	 * clear out this, plus the PhyRdy/Comm
> -	 * Wake bits from Serror
> -	 */
> -	if ((hpriv->flags & AHCI_HFLAG_NO_HOTPLUG) &&
> -		(status & PORT_IRQ_PHYRDY)) {
> +	/* if IPM is enabled, PHYRDY doesn't mean anything */
> +	if (ap->link.ipm_policy > ATA_IPM_MAX_POWER) {
>  		status &= ~PORT_IRQ_PHYRDY;
> -		ahci_scr_write(&ap->link, SCR_ERROR, ((1 << 16) | (1 << 18)));
> +		ahci_scr_write(&ap->link, SCR_ERROR, SERR_PHYRDY_CHG);
>  	}
> 
>  	if (unlikely(status & PORT_IRQ_ERROR)) {
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ddf8e48..5d1eeb1 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -91,8 +91,6 @@ const struct ata_port_operations sata_port_ops = {
>  static unsigned int ata_dev_init_params(struct ata_device *dev,
>  					u16 heads, u16 sectors);
>  static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
> -static unsigned int ata_dev_set_feature(struct ata_device *dev,
> -					u8 enable, u8 feature);
>  static void ata_dev_xfermask(struct ata_device *dev);
>  static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
> 
> @@ -1032,182 +1030,6 @@ static const char *sata_spd_string(unsigned int spd)
>  	return spd_str[spd - 1];
>  }
> 
> -static int ata_dev_set_dipm(struct ata_device *dev, enum link_pm policy)
> -{
> -	struct ata_link *link = dev->link;
> -	struct ata_port *ap = link->ap;
> -	u32 scontrol;
> -	unsigned int err_mask;
> -	int rc;
> -
> -	/*
> -	 * disallow DIPM for drivers which haven't set
> -	 * ATA_FLAG_IPM.  This is because when DIPM is enabled,
> -	 * phy ready will be set in the interrupt status on
> -	 * state changes, which will cause some drivers to
> -	 * think there are errors - additionally drivers will
> -	 * need to disable hot plug.
> -	 */
> -	if (!(ap->flags & ATA_FLAG_IPM) || !ata_dev_enabled(dev)) {
> -		ap->pm_policy = NOT_AVAILABLE;
> -		return -EINVAL;
> -	}
> -
> -	/*
> -	 * For DIPM, we will only enable it for the
> -	 * min_power setting.
> -	 *
> -	 * Why?  Because Disks are too stupid to know that
> -	 * If the host rejects a request to go to SLUMBER
> -	 * they should retry at PARTIAL, and instead it
> -	 * just would give up.  So, for medium_power to
> -	 * work at all, we need to only allow HIPM.
> -	 */
> -	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
> -	if (rc)
> -		return rc;
> -
> -	switch (policy) {
> -	case MIN_POWER:
> -		/* no restrictions on IPM transitions */
> -		scontrol &= ~(0x3 << 8);
> -		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
> -		if (rc)
> -			return rc;
> -
> -		/* enable DIPM */
> -		if (dev->flags & ATA_DFLAG_DIPM)
> -			err_mask = ata_dev_set_feature(dev,
> -					SETFEATURES_SATA_ENABLE, SATA_DIPM);
> -		break;
> -	case MEDIUM_POWER:
> -		/* allow IPM to PARTIAL */
> -		scontrol &= ~(0x1 << 8);
> -		scontrol |= (0x2 << 8);
> -		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
> -		if (rc)
> -			return rc;
> -
> -		/*
> -		 * we don't have to disable DIPM since IPM flags
> -		 * disallow transitions to SLUMBER, which effectively
> -		 * disable DIPM if it does not support PARTIAL
> -		 */
> -		break;
> -	case NOT_AVAILABLE:
> -	case MAX_PERFORMANCE:
> -		/* disable all IPM transitions */
> -		scontrol |= (0x3 << 8);
> -		rc = sata_scr_write(link, SCR_CONTROL, scontrol);
> -		if (rc)
> -			return rc;
> -
> -		/*
> -		 * we don't have to disable DIPM since IPM flags
> -		 * disallow all transitions which effectively
> -		 * disable DIPM anyway.
> -		 */
> -		break;
> -	}
> -
> -	/* FIXME: handle SET FEATURES failure */
> -	(void) err_mask;
> -
> -	return 0;
> -}
> -
> -/**
> - *	ata_dev_enable_pm - enable SATA interface power management
> - *	@dev:  device to enable power management
> - *	@policy: the link power management policy
> - *
> - *	Enable SATA Interface power management.  This will enable
> - *	Device Interface Power Management (DIPM) for min_power
> - * 	policy, and then call driver specific callbacks for
> - *	enabling Host Initiated Power management.
> - *
> - *	Locking: Caller.
> - *	Returns: -EINVAL if IPM is not supported, 0 otherwise.
> - */
> -void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy)
> -{
> -	int rc = 0;
> -	struct ata_port *ap = dev->link->ap;
> -
> -	/* set HIPM first, then DIPM */
> -	if (ap->ops->enable_pm)
> -		rc = ap->ops->enable_pm(ap, policy);
> -	if (rc)
> -		goto enable_pm_out;
> -	rc = ata_dev_set_dipm(dev, policy);
> -
> -enable_pm_out:
> -	if (rc)
> -		ap->pm_policy = MAX_PERFORMANCE;
> -	else
> -		ap->pm_policy = policy;
> -	return /* rc */;	/* hopefully we can use 'rc' eventually */
> -}
> -
> -#ifdef CONFIG_PM
> -/**
> - *	ata_dev_disable_pm - disable SATA interface power management
> - *	@dev: device to disable power management
> - *
> - *	Disable SATA Interface power management.  This will disable
> - *	Device Interface Power Management (DIPM) without changing
> - * 	policy,  call driver specific callbacks for disabling Host
> - * 	Initiated Power management.
> - *
> - *	Locking: Caller.
> - *	Returns: void
> - */
> -static void ata_dev_disable_pm(struct ata_device *dev)
> -{
> -	struct ata_port *ap = dev->link->ap;
> -
> -	ata_dev_set_dipm(dev, MAX_PERFORMANCE);
> -	if (ap->ops->disable_pm)
> -		ap->ops->disable_pm(ap);
> -}
> -#endif	/* CONFIG_PM */
> -
> -void ata_lpm_schedule(struct ata_port *ap, enum link_pm policy)
> -{
> -	ap->pm_policy = policy;
> -	ap->link.eh_info.action |= ATA_EH_LPM;
> -	ap->link.eh_info.flags |= ATA_EHI_NO_AUTOPSY;
> -	ata_port_schedule_eh(ap);
> -}
> -
> -#ifdef CONFIG_PM
> -static void ata_lpm_enable(struct ata_host *host)
> -{
> -	struct ata_link *link;
> -	struct ata_port *ap;
> -	struct ata_device *dev;
> -	int i;
> -
> -	for (i = 0; i < host->n_ports; i++) {
> -		ap = host->ports[i];
> -		ata_for_each_link(link, ap, EDGE) {
> -			ata_for_each_dev(dev, link, ALL)
> -				ata_dev_disable_pm(dev);
> -		}
> -	}
> -}
> -
> -static void ata_lpm_disable(struct ata_host *host)
> -{
> -	int i;
> -
> -	for (i = 0; i < host->n_ports; i++) {
> -		struct ata_port *ap = host->ports[i];
> -		ata_lpm_schedule(ap, ap->pm_policy);
> -	}
> -}
> -#endif	/* CONFIG_PM */
> -
>  /**
>   *	ata_dev_classify - determine device type based on ATA-spec signature
>   *	@tf: ATA taskfile register set for device to be identified
> @@ -2566,13 +2388,6 @@ int ata_dev_configure(struct ata_device *dev)
>  	if (dev->flags & ATA_DFLAG_LBA48)
>  		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
> 
> -	if (!(dev->horkage & ATA_HORKAGE_IPM)) {
> -		if (ata_id_has_hipm(dev->id))
> -			dev->flags |= ATA_DFLAG_HIPM;
> -		if (ata_id_has_dipm(dev->id))
> -			dev->flags |= ATA_DFLAG_DIPM;
> -	}
> -
>  	/* Limit PATA drive on SATA cable bridge transfers to udma5,
>  	   200 sectors */
>  	if (ata_dev_knobble(dev)) {
> @@ -2593,13 +2408,6 @@ int ata_dev_configure(struct ata_device *dev)
>  		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
>  					 dev->max_sectors);
> 
> -	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_IPM) {
> -		dev->horkage |= ATA_HORKAGE_IPM;
> -
> -		/* reset link pm_policy for this port to no pm */
> -		ap->pm_policy = MAX_PERFORMANCE;
> -	}
> -
>  	if (ap->ops->dev_config)
>  		ap->ops->dev_config(dev);
> 
> @@ -3630,7 +3438,7 @@ int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
>   *	@params: timing parameters { interval, duratinon, timeout } in msec
>   *	@deadline: deadline jiffies for the operation
>   *
> -*	Make sure SStatus of @link reaches stable state, determined by
> + *	Make sure SStatus of @link reaches stable state, determined by
>   *	holding the same value where DET is not 1 for @duration polled
>   *	every @interval, before @timeout.  Timeout constraints the
>   *	beginning of the stable state.  Because DET gets stuck at 1 on
> @@ -3761,6 +3569,65 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
>  	return rc != -EINVAL ? rc : 0;
>  }
> 
> +int sata_link_scr_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +		      bool spm_wakeup)
> +{
> +	struct ata_eh_context *ehc = &link->eh_context;
> +	bool woken_up = false;
> +	u32 scontrol;
> +	int rc;
> +
> +	ata_link_printk(link, KERN_INFO,
> +			"XXX sata_link_scr_ipm: pol=%d spm_wakeup=%d\n",
> +			policy, spm_wakeup);
> +	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
> +	if (rc)
> +		return rc;
> +
> +	switch (policy) {
> +	case ATA_IPM_MAX_POWER:
> +		/* disable all IPM transitions */
> +		scontrol |= (0x3 << 8);
> +		/* initiate transition to active state */
> +		if (spm_wakeup) {
> +			scontrol |= (0x4 << 12);
> +			woken_up = true;
> +		}
> +		break;
> +	case ATA_IPM_MED_POWER:
> +		/* allow IPM to PARTIAL */
> +		scontrol &= ~(0x1 << 8);
> +		scontrol |= (0x2 << 8);
> +		break;
> +	case ATA_IPM_MIN_POWER:
> +		/* no restrictions on IPM transitions */
> +		scontrol &= ~(0x3 << 8);
> +		break;
> +	default:
> +		WARN_ON(1);
> +	}
> +
> +	ata_link_printk(link, KERN_INFO,
> +			"XXX sata_link_scr_ipm: updating sctl to %x\n",
> +			scontrol);
> +	rc = sata_scr_write(link, SCR_CONTROL, scontrol);
> +	if (rc)
> +		return rc;
> +
> +	/* give the link time to transit out of IPM state */
> +	if (woken_up) {
> +		msleep(10);
> +		ata_link_printk(link, KERN_INFO,
> +				"XXX sata_link_scr_ipm: sleeping 10msec\n");
> +	}
> +
> +	/* clear PHYRDY_CHG from SError */
> +	ata_link_printk(link, KERN_INFO,
> +			"XXX sata_link_scr_ipm: clearing serr\n");
> +	ehc->i.serror &= ~SERR_PHYRDY_CHG;
> +	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
> +}
> +
>  /**
>   *	ata_std_prereset - prepare for reset
>   *	@link: ATA link to be reset
> @@ -4570,6 +4437,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
>  	DPRINTK("EXIT, err_mask=%x\n", err_mask);
>  	return err_mask;
>  }
> +
>  /**
>   *	ata_dev_set_feature - Issue SET FEATURES - SATA FEATURES
>   *	@dev: Device to which command will be sent
> @@ -4585,8 +4453,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
>   *	RETURNS:
>   *	0 on success, AC_ERR_* mask otherwise.
>   */
> -static unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable,
> -					u8 feature)
> +unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable, u8 feature)
>  {
>  	struct ata_taskfile tf;
>  	unsigned int err_mask;
> @@ -5436,12 +5303,6 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
>  {
>  	int rc;
> 
> -	/*
> -	 * disable link pm on all ports before requesting
> -	 * any pm activity
> -	 */
> -	ata_lpm_enable(host);
> -
>  	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
>  	if (rc == 0)
>  		host->dev->power.power_state = mesg;
> @@ -5464,9 +5325,6 @@ void ata_host_resume(struct ata_host *host)
>  	ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
>  			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
>  	host->dev->power.power_state = PMSG_ON;
> -
> -	/* reenable link pm */
> -	ata_lpm_disable(host);
>  }
>  #endif
> 
> @@ -6025,7 +5883,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
>  		spin_lock_irqsave(ap->lock, flags);
> 
>  		ehi->probe_mask |= ATA_ALL_DEVICES;
> -		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
> +		ehi->action |= ATA_EH_RESET;
>  		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
> 
>  		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
> @@ -6698,6 +6556,7 @@ EXPORT_SYMBOL_GPL(sata_set_spd);
>  EXPORT_SYMBOL_GPL(ata_wait_after_reset);
>  EXPORT_SYMBOL_GPL(sata_link_debounce);
>  EXPORT_SYMBOL_GPL(sata_link_resume);
> +EXPORT_SYMBOL_GPL(sata_link_scr_ipm);
>  EXPORT_SYMBOL_GPL(ata_std_prereset);
>  EXPORT_SYMBOL_GPL(sata_link_hardreset);
>  EXPORT_SYMBOL_GPL(sata_std_hardreset);
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index f77a673..bd77d94 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -1568,14 +1568,15 @@ static void ata_eh_analyze_serror(struct ata_link *link)
>  		action |= ATA_EH_RESET;
>  	}
> 
> -	/* Determine whether a hotplug event has occurred.  Both
> +	/*
> +	 * Determine whether a hotplug event has occurred.  Both
>  	 * SError.N/X are considered hotplug events for enabled or
>  	 * host links.  For disabled PMP links, only N bit is
>  	 * considered as X bit is left at 1 for link plugging.
>  	 */
> -	hotplug_mask = 0;
> -
> -	if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
> +	if (link->ipm_policy != ATA_IPM_MAX_POWER)
> +		hotplug_mask = 0;	/* hotplug doesn't work w/ IPM */
> +	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
>  		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;
>  	else
>  		hotplug_mask = SERR_PHYRDY_CHG;
> @@ -2776,8 +2777,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
>  	ata_eh_done(link, NULL, ATA_EH_RESET);
>  	if (slave)
>  		ata_eh_done(slave, NULL, ATA_EH_RESET);
> -	ehc->last_reset = jiffies;	/* update to completion time */
> +	ehc->last_reset = jiffies;		/* update to completion time */
>  	ehc->i.action |= ATA_EH_REVALIDATE;
> +	link->ipm_policy = ATA_IPM_UNKNOWN;	/* reset IPM state */
> 
>  	rc = 0;
>   out:
> @@ -3203,6 +3205,124 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
>  	return rc;
>  }
> 
> +/**
> + *	ata_eh_set_ipm - configure SATA interface power management
> + *	@link: link to configure power management
> + *	@policy: the link power management policy
> + *	@r_failed_dev: out parameter for failed device
> + *
> + *	Enable SATA Interface power management.  This will enable
> + *	Device Interface Power Management (DIPM) for min_power
> + * 	policy, and then call driver specific callbacks for
> + *	enabling Host Initiated Power management.
> + *
> + *	LOCKING:
> + *	EH context.
> + *
> + *	RETURNS:
> + *	0 on success, -errno on failure.
> + */
> +static int ata_eh_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			  struct ata_device **r_failed_dev)
> +{
> +	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
> +	struct ata_eh_context *ehc = &link->eh_context;
> +	struct ata_device *dev, *link_dev = NULL, *ipm_dev = NULL;
> +	unsigned int hints = ATA_IPM_EMPTY | ATA_IPM_HIPM;
> +	unsigned int err_mask;
> +	int rc;
> +
> +	/* if the link or host doesn't do IPM, noop */
> +	if ((link->flags & ATA_LFLAG_NO_IPM) || (ap && !ap->ops->set_ipm))
> +		return 0;
> +
> +	/*
> +	 * DIPM is enabled only for MIN_POWER as some devices
> +	 * misbehave when the host NACKs transition to SLUMBER.  Order
> +	 * device and link configurations such that the host always
> +	 * allows DIPM requests.
> +	 */
> +	ata_for_each_dev(dev, link, ENABLED) {
> +		bool hipm = ata_id_has_hipm(dev->id);
> +		bool dipm = ata_id_has_dipm(dev->id);
> +
> +		/* find the first enabled and IPM enabled devices */
> +		if (!link_dev)
> +			link_dev = dev;
> +
> +		if (!ipm_dev && (hipm || dipm))
> +			ipm_dev = dev;
> +
> +		hints &= ~ATA_IPM_EMPTY;
> +		if (!hipm)
> +			hints &= ~ATA_IPM_HIPM;
> +
> +		/* disable DIPM before changing link config */
> +		if (policy != ATA_IPM_MIN_POWER && dipm) {
> +			ata_dev_printk(dev, KERN_INFO, "XXX ata_eh_set_ipm: disabling DIPM\n");
> +			err_mask = ata_dev_set_feature(dev,
> +					SETFEATURES_SATA_DISABLE, SATA_DIPM);
> +			if (err_mask && err_mask != AC_ERR_DEV) {
> +				ata_dev_printk(dev, KERN_WARNING,
> +					       "error while disabling DIPM\n");
> +				rc = -EIO;
> +				goto fail;
> +			}
> +		}
> +	}
> +
> +	if (ap) {
> +		rc = ap->ops->set_ipm(link, policy, hints);
> +		if (!rc && ap->slave_link)
> +			rc = ap->ops->set_ipm(ap->slave_link, policy, hints);
> +	} else
> +		rc = sata_pmp_set_ipm(link, policy, hints);
> +
> +	/*
> +	 * Attribute link config failure to the first (IPM) enabled
> +	 * device on the link.
> +	 */
> +	if (rc) {
> +		if (rc == -EOPNOTSUPP) {
> +			link->flags |= ATA_LFLAG_NO_IPM;
> +			return 0;
> +		}
> +		dev = ipm_dev ? ipm_dev : link_dev;
> +		goto fail;
> +	}
> +
> +	/* host config updated, enable DIPM if transitioning to MIN_POWER */
> +	ata_for_each_dev(dev, link, ENABLED) {
> +		if (policy == ATA_IPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
> +			ata_dev_printk(dev, KERN_INFO, "XXX ata_eh_set_ipm: enabling DIPM\n");
> +			err_mask = ata_dev_set_feature(dev,
> +					SETFEATURES_SATA_ENABLE, SATA_DIPM);
> +			if (err_mask && err_mask != AC_ERR_DEV) {
> +				ata_dev_printk(dev, KERN_WARNING,
> +					       "error while enabling DIPM\n");
> +				rc = -EIO;
> +				goto fail;
> +			}
> +		}
> +	}
> +
> +	link->ipm_policy = policy;
> +	if (ap && ap->slave_link)
> +		ap->slave_link->ipm_policy = policy;
> +	return 0;
> +
> +fail:
> +	/* if no device or the last chance for the device, disable IPM */
> +	if (!dev || ehc->tries[dev->devno] == 1) {
> +		ata_link_printk(link, KERN_WARNING,
> +				"disabling IPM on the link\n");
> +		link->flags |= ATA_LFLAG_NO_IPM;
> +	}
> +	if (r_failed_dev)
> +		*r_failed_dev = dev;
> +	return rc;
> +}
> +
>  static int ata_link_nr_enabled(struct ata_link *link)
>  {
>  	struct ata_device *dev;
> @@ -3283,6 +3403,16 @@ static int ata_eh_schedule_probe(struct ata_device *dev)
>  	ehc->saved_xfer_mode[dev->devno] = 0;
>  	ehc->saved_ncq_enabled &= ~(1 << dev->devno);
> 
> +	/* the link maybe in a deep sleep, wake it up */
> +	if (link->ipm_policy > ATA_IPM_MAX_POWER) {
> +		if (ata_is_host_link(link))
> +			link->ap->ops->set_ipm(link, ATA_IPM_MAX_POWER,
> +					       ATA_IPM_EMPTY);
> +		else
> +			sata_pmp_set_ipm(link, ATA_IPM_MAX_POWER,
> +					 ATA_IPM_EMPTY);
> +	}
> +
>  	/* Record and count probe trials on the ering.  The specific
>  	 * error mask used is irrelevant.  Because a successful device
>  	 * detection clears the ering, this count accumulates only if
> @@ -3384,8 +3514,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  {
>  	struct ata_link *link;
>  	struct ata_device *dev;
> -	int nr_failed_devs;
> -	int rc;
> +	int rc, nr_fails;
>  	unsigned long flags, deadline;
> 
>  	DPRINTK("ENTER\n");
> @@ -3426,7 +3555,6 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
> 
>   retry:
>  	rc = 0;
> -	nr_failed_devs = 0;
> 
>  	/* if UNLOADING, finish immediately */
>  	if (ap->pflags & ATA_PFLAG_UNLOADING)
> @@ -3511,13 +3639,17 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  	}
> 
>  	/* the rest */
> -	ata_for_each_link(link, ap, EDGE) {
> +	nr_fails = 0;
> +	ata_for_each_link(link, ap, PMP_FIRST) {
>  		struct ata_eh_context *ehc = &link->eh_context;
> 
> +		if (sata_pmp_attached(ap) && ata_is_host_link(link))
> +			goto config_ipm;
> +
>  		/* revalidate existing devices and attach new ones */
>  		rc = ata_eh_revalidate_and_attach(link, &dev);
>  		if (rc)
> -			goto dev_fail;
> +			goto rest_fail;
> 
>  		/* if PMP got attached, return, pmp EH will take care of it */
>  		if (link->device->class == ATA_DEV_PMP) {
> @@ -3529,7 +3661,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  		if (ehc->i.flags & ATA_EHI_SETMODE) {
>  			rc = ata_set_mode(link, &dev);
>  			if (rc)
> -				goto dev_fail;
> +				goto rest_fail;
>  			ehc->i.flags &= ~ATA_EHI_SETMODE;
>  		}
> 
> @@ -3542,7 +3674,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  					continue;
>  				rc = atapi_eh_clear_ua(dev);
>  				if (rc)
> -					goto dev_fail;
> +					goto rest_fail;
>  			}
>  		}
> 
> @@ -3552,21 +3684,25 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>  				continue;
>  			rc = ata_eh_maybe_retry_flush(dev);
>  			if (rc)
> -				goto dev_fail;
> +				goto rest_fail;
>  		}
> 
> +	config_ipm:
>  		/* configure link power saving */
> -		if (ehc->i.action & ATA_EH_LPM)
> -			ata_for_each_dev(dev, link, ALL)
> -				ata_dev_enable_pm(dev, ap->pm_policy);
> +		if (link->ipm_policy != ap->target_ipm_policy) {
> +			rc = ata_eh_set_ipm(link, ap->target_ipm_policy, &dev);
> +			if (rc)
> +				goto rest_fail;
> +		}
> 
>  		/* this link is okay now */
>  		ehc->i.flags = 0;
>  		continue;
> 
> -dev_fail:
> -		nr_failed_devs++;
> -		ata_eh_handle_dev_fail(dev, rc);
> +	rest_fail:
> +		nr_fails++;
> +		if (dev)
> +			ata_eh_handle_dev_fail(dev, rc);
> 
>  		if (ap->pflags & ATA_PFLAG_FROZEN) {
>  			/* PMP reset requires working host port.
> @@ -3578,7 +3714,7 @@ dev_fail:
>  		}
>  	}
> 
> -	if (nr_failed_devs)
> +	if (nr_fails)
>  		goto retry;
> 
>   out:
> diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
> index 224faab..06a66ca 100644
> --- a/drivers/ata/libata-pmp.c
> +++ b/drivers/ata/libata-pmp.c
> @@ -185,6 +185,27 @@ int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
>  }
> 
>  /**
> + *	sata_pmp_set_ipm - configure IPM for a PMP link
> + *	@link: PMP link to configure IPM for
> + *	@policy: target IPM policy
> + *	@hints: IPM hints
> + *
> + *	Configure IPM for @link.  This function will contain any PMP
> + *	specific workarounds if necessary.
> + *
> + *	LOCKING:
> + *	EH context.
> + *
> + *	RETURNS:
> + *	0 on success, -errno on failure.
> + */
> +int sata_pmp_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +		     unsigned hints)
> +{
> +	return sata_link_scr_ipm(link, policy, true);
> +}
> +
> +/**
>   *	sata_pmp_read_gscr - read GSCR block of SATA PMP
>   *	@dev: PMP device
>   *	@gscr: buffer to read GSCR block into
> @@ -351,6 +372,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
>  	if (vendor == 0x1095 && devid == 0x3726) {
>  		/* sil3726 quirks */
>  		ata_for_each_link(link, ap, EDGE) {
> +			/* link reports offline after IPM */
> +			link->flags |= ATA_LFLAG_NO_IPM;
> +
>  			/* Class code report is unreliable and SRST
>  			 * times out under certain configurations.
>  			 */
> @@ -366,6 +390,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
>  	} else if (vendor == 0x1095 && devid == 0x4723) {
>  		/* sil4723 quirks */
>  		ata_for_each_link(link, ap, EDGE) {
> +			/* link reports offline after IPM */
> +			link->flags |= ATA_LFLAG_NO_IPM;
> +
>  			/* class code report is unreliable */
>  			if (link->pmp < 2)
>  				link->flags |= ATA_LFLAG_ASSUME_ATA;
> @@ -378,6 +405,9 @@ static void sata_pmp_quirks(struct ata_port *ap)
>  	} else if (vendor == 0x1095 && devid == 0x4726) {
>  		/* sil4726 quirks */
>  		ata_for_each_link(link, ap, EDGE) {
> +			/* link reports offline after IPM */
> +			link->flags |= ATA_LFLAG_NO_IPM;
> +
>  			/* Class code report is unreliable and SRST
>  			 * times out under certain configurations.
>  			 * Config device can be at port 0 or 5 and
> @@ -938,15 +968,26 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
>  	if (rc)
>  		goto link_fail;
> 
> -	/* Connection status might have changed while resetting other
> -	 * links, check SATA_PMP_GSCR_ERROR before returning.
> -	 */
> -
> +	
>  	/* clear SNotification */
>  	rc = sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf);
>  	if (rc == 0)
>  		sata_scr_write(&ap->link, SCR_NOTIFICATION, sntf);
> 
> +	/*
> +	 * If IPM is active on any fan-out port, hotplug wouldn't
> +	 * work.  Return w/ PHY event notification disabled.
> +	 */
> +	ata_for_each_link(link, ap, EDGE)
> +		if (link->ipm_policy > ATA_IPM_MAX_POWER)
> +			return 0;
> +
> +	/*
> +	 * Connection status might have changed while resetting other
> +	 * links, enable notification and check SATA_PMP_GSCR_ERROR
> +	 * before returning.
> +	 */
> +
>  	/* enable notification */
>  	if (pmp_dev->flags & ATA_DFLAG_AN) {
>  		gscr[SATA_PMP_GSCR_FEAT_EN] |= SATA_PMP_FEAT_NOTIFY;
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a54273d..8801342 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -116,73 +116,55 @@ static struct scsi_transport_template ata_scsi_transport_template = {
>  	.user_scan		= ata_scsi_user_scan,
>  };
> 
> -
> -static const struct {
> -	enum link_pm	value;
> -	const char	*name;
> -} link_pm_policy[] = {
> -	{ NOT_AVAILABLE, "max_performance" },
> -	{ MIN_POWER, "min_power" },
> -	{ MAX_PERFORMANCE, "max_performance" },
> -	{ MEDIUM_POWER, "medium_power" },
> +static const char *ata_ipm_policy_names[] = {
> +	[ATA_IPM_UNKNOWN]	= "max_performance",
> +	[ATA_IPM_MAX_POWER]	= "max_performance",
> +	[ATA_IPM_MED_POWER]	= "medium_power",
> +	[ATA_IPM_MIN_POWER]	= "min_power",
>  };
> 
> -static const char *ata_scsi_lpm_get(enum link_pm policy)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(link_pm_policy); i++)
> -		if (link_pm_policy[i].value == policy)
> -			return link_pm_policy[i].name;
> -
> -	return NULL;
> -}
> -
> -static ssize_t ata_scsi_lpm_put(struct device *dev,
> -				struct device_attribute *attr,
> -				const char *buf, size_t count)
> +static ssize_t ata_scsi_ipm_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ata_port *ap = ata_shost_to_port(shost);
> -	enum link_pm policy = 0;
> -	int i;
> +	enum ata_ipm_policy policy;
> +	unsigned long flags;
> 
> -	/*
> -	 * we are skipping array location 0 on purpose - this
> -	 * is because a value of NOT_AVAILABLE is displayed
> -	 * to the user as max_performance, but when the user
> -	 * writes "max_performance", they actually want the
> -	 * value to match MAX_PERFORMANCE.
> -	 */
> -	for (i = 1; i < ARRAY_SIZE(link_pm_policy); i++) {
> -		const int len = strlen(link_pm_policy[i].name);
> -		if (strncmp(link_pm_policy[i].name, buf, len) == 0) {
> -			policy = link_pm_policy[i].value;
> +	/* UNKNOWN is internal state, iterate from MAX_POWER */
> +	for (policy = ATA_IPM_MAX_POWER;
> +	     policy < ARRAY_SIZE(ata_ipm_policy_names); policy++) {
> +		const char *name = ata_ipm_policy_names[policy];
> +
> +		if (strncmp(name, buf, strlen(name)) == 0)
>  			break;
> -		}
>  	}
> -	if (!policy)
> +	if (policy == ARRAY_SIZE(ata_ipm_policy_names))
>  		return -EINVAL;
> 
> -	ata_lpm_schedule(ap, policy);
> +	spin_lock_irqsave(ap->lock, flags);
> +	ap->target_ipm_policy = policy;
> +	ata_port_schedule_eh(ap);
> +	spin_unlock_irqrestore(ap->lock, flags);
> +
>  	return count;
>  }
> 
> -static ssize_t
> -ata_scsi_lpm_show(struct device *dev, struct device_attribute *attr, char *buf)
> +static ssize_t ata_scsi_ipm_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	struct ata_port *ap = ata_shost_to_port(shost);
> -	const char *policy =
> -		ata_scsi_lpm_get(ap->pm_policy);
> 
> -	if (!policy)
> +	if (ap->target_ipm_policy >= ARRAY_SIZE(ata_ipm_policy_names))
>  		return -EINVAL;
> 
> -	return snprintf(buf, 23, "%s\n", policy);
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			ata_ipm_policy_names[ap->target_ipm_policy]);
>  }
>  DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
> -		ata_scsi_lpm_show, ata_scsi_lpm_put);
> +	    ata_scsi_ipm_show, ata_scsi_ipm_store);
>  EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
> 
>  static ssize_t ata_scsi_park_show(struct device *device,
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 4b84ed6..2dd0dfe 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -87,6 +87,8 @@ extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
>  extern int ata_dev_configure(struct ata_device *dev);
>  extern int sata_down_spd_limit(struct ata_link *link, u32 spd_limit);
>  extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
> +extern unsigned int ata_dev_set_feature(struct ata_device *dev,
> +					u8 enable, u8 feature);
>  extern void ata_sg_clean(struct ata_queued_cmd *qc);
>  extern void ata_qc_free(struct ata_queued_cmd *qc);
>  extern void ata_qc_issue(struct ata_queued_cmd *qc);
> @@ -101,8 +103,6 @@ extern int sata_link_init_spd(struct ata_link *link);
>  extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
>  extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
>  extern struct ata_port *ata_port_alloc(struct ata_host *host);
> -extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
> -extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
> 
>  /* libata-acpi.c */
>  #ifdef CONFIG_ATA_ACPI
> @@ -170,6 +170,8 @@ extern void ata_eh_finish(struct ata_port *ap);
>  #ifdef CONFIG_SATA_PMP
>  extern int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *val);
>  extern int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val);
> +extern int sata_pmp_set_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			    unsigned hints);
>  extern int sata_pmp_attach(struct ata_device *dev);
>  #else /* CONFIG_SATA_PMP */
>  static inline int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *val)
> @@ -182,6 +184,12 @@ static inline int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
>  	return -EINVAL;
>  }
> 
> +static inline int sata_pmp_set_ipm(struct ata_link *link,
> +				   enum ata_ipm_policy policy, unsigned hints)
> +{
> +	return -EINVAL;
> +}
> +
>  static inline int sata_pmp_attach(struct ata_device *dev)
>  {
>  	return -EINVAL;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index b85f3ff..1f90dc5 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -172,6 +172,7 @@ enum {
>  	ATA_LFLAG_NO_RETRY	= (1 << 5), /* don't retry this link */
>  	ATA_LFLAG_DISABLED	= (1 << 6), /* link is disabled */
>  	ATA_LFLAG_SW_ACTIVITY	= (1 << 7), /* keep activity stats */
> +	ATA_LFLAG_NO_IPM	= (1 << 8), /* disable IPM on this link */
> 
>  	/* struct ata_port flags */
>  	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
> @@ -324,12 +325,11 @@ enum {
>  	ATA_EH_HARDRESET	= (1 << 2), /* meaningful only in ->prereset */
>  	ATA_EH_RESET		= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
>  	ATA_EH_ENABLE_LINK	= (1 << 3),
> -	ATA_EH_LPM		= (1 << 4),  /* link power management action */
>  	ATA_EH_PARK		= (1 << 5), /* unload heads and stop I/O */
> 
>  	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_PARK,
>  	ATA_EH_ALL_ACTIONS	= ATA_EH_REVALIDATE | ATA_EH_RESET |
> -				  ATA_EH_ENABLE_LINK | ATA_EH_LPM,
> +				  ATA_EH_ENABLE_LINK,
> 
>  	/* ata_eh_info->flags */
>  	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
> @@ -376,7 +376,6 @@ enum {
>  	ATA_HORKAGE_BROKEN_HPA	= (1 << 4),	/* Broken HPA */
>  	ATA_HORKAGE_DISABLE	= (1 << 5),	/* Disable it */
>  	ATA_HORKAGE_HPA_SIZE	= (1 << 6),	/* native size off by one */
> -	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
>  	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
>  	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
>  	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
> @@ -463,6 +462,22 @@ enum ata_completion_errors {
>  	AC_ERR_NCQ		= (1 << 10), /* marker for offending NCQ qc */
>  };
> 
> +/*
> + * Link pm policy: If you alter this, you also need to alter
> + * libata-scsi.c (for the ascii descriptions)
> + */
> +enum ata_ipm_policy {
> +	ATA_IPM_UNKNOWN,
> +	ATA_IPM_MAX_POWER,
> +	ATA_IPM_MED_POWER,
> +	ATA_IPM_MIN_POWER,
> +};
> +
> +enum ata_ipm_hints {
> +	ATA_IPM_EMPTY		= (1 << 0), /* port empty/probing */
> +	ATA_IPM_HIPM		= (1 << 1), /* may use HIPM */
> +};
> +
>  /* forward declarations */
>  struct scsi_device;
>  struct ata_port_operations;
> @@ -477,16 +492,6 @@ typedef int (*ata_reset_fn_t)(struct ata_link *link, unsigned int *classes,
>  			      unsigned long deadline);
>  typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes);
> 
> -/*
> - * host pm policy: If you alter this, you also need to alter libata-scsi.c
> - * (for the ascii descriptions)
> - */
> -enum link_pm {
> -	NOT_AVAILABLE,
> -	MIN_POWER,
> -	MAX_PERFORMANCE,
> -	MEDIUM_POWER,
> -};
>  extern struct device_attribute dev_attr_link_power_management_policy;
>  extern struct device_attribute dev_attr_unload_heads;
>  extern struct device_attribute dev_attr_em_message_type;
> @@ -698,6 +703,7 @@ struct ata_link {
>  	unsigned int		hw_sata_spd_limit;
>  	unsigned int		sata_spd_limit;
>  	unsigned int		sata_spd;	/* current SATA PHY speed */
> +	enum ata_ipm_policy	ipm_policy;
> 
>  	/* record runtime error info, protected by host_set lock */
>  	struct ata_eh_info	eh_info;
> @@ -764,7 +770,7 @@ struct ata_port {
> 
>  	pm_message_t		pm_mesg;
>  	int			*pm_result;
> -	enum link_pm		pm_policy;
> +	enum ata_ipm_policy	target_ipm_policy;
> 
>  	struct timer_list	fastdrain_timer;
>  	unsigned long		fastdrain_cnt;
> @@ -830,8 +836,8 @@ struct ata_port_operations {
>  	int  (*scr_write)(struct ata_link *link, unsigned int sc_reg, u32 val);
>  	void (*pmp_attach)(struct ata_port *ap);
>  	void (*pmp_detach)(struct ata_port *ap);
> -	int  (*enable_pm)(struct ata_port *ap, enum link_pm policy);
> -	void (*disable_pm)(struct ata_port *ap);
> +	int  (*set_ipm)(struct ata_link *link, enum ata_ipm_policy policy,
> +			unsigned hints);
> 
>  	/*
>  	 * Start, stop, suspend and resume
> @@ -943,6 +949,8 @@ extern int sata_link_debounce(struct ata_link *link,
>  			const unsigned long *params, unsigned long deadline);
>  extern int sata_link_resume(struct ata_link *link, const unsigned long *params,
>  			    unsigned long deadline);
> +extern int sata_link_scr_ipm(struct ata_link *link, enum ata_ipm_policy policy,
> +			     bool spm_wakeup);
>  extern int sata_link_hardreset(struct ata_link *link,
>  			const unsigned long *timing, unsigned long deadline,
>  			bool *online, int (*check_ready)(struct ata_link *));
> 
> 

