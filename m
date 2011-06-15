Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1FOKOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:14:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1FOKOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yw4li0WoqTT+wUriypOMtGdsaDq8caDf1uIwjppa1Pm5rZuTqjDPjzfDDvU6UauMP6
         v9BVfqtvr9UYma7gY4dN1hHxU+1SDYQtiKHenNB/wZIwzkVNgiIHW2uCCUy4MqjLzevf
         8Rf8De/2cjbdv5QBJG+/gL0fxacc/DlZZUnqc=
Date: Wed, 15 Jun 2011 12:14:36 +0200
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v2] ahci: fix pmp softreset with HDD
Message-ID: <20110615101436.GT8141@htj.dyndns.org>
References: <20110614065213.GD8141@htj.dyndns.org>
 <1308132252-1981-1-git-send-email-yuanlmm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308132252-1981-1-git-send-email-yuanlmm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 15, 2011 at 06:04:12PM +0800, Yuan-Hsin Chen wrote:
> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
> 
> When enabling both port multiplier and platform ahci sata,
> ahci times out while connecting to HDD directly. This is
> because soft reset fails with IPMS set. Do soft reset
> again to port 0.
> 
> The soft reset sequence is copied from ahci.c.
> 
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

Getting closer.

> +config SATA_PMP_RST
> +	bool "SATA PMP softreset"
> +	depends on SATA_PMP
> +	default n
> +	help
> +	  When enabling both port multiplier and platform ahci sata,
> +	  ahci times out while connecting to HDD directly in some
> +	  ahci controller. This is because soft reset fails with
> +	  IPMS set. Do soft reset again to port 0.
> +

Hmmm... Is there any way to detect the specific controller from
ahci_platform.c?  This is workaround for a controller bug.  It should
be enabled automatically.  Making it a config option doesn't make
whole lot of sense.

> @@ -1329,6 +1338,56 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
>  }
>  EXPORT_SYMBOL_GPL(ahci_do_softreset);
>  
> +static int ahci_pmp_check_ready(struct ata_link *link)
> +{
> +	void __iomem *port_mmio = ahci_port_base(link->ap);
> +	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
> +	u32 irq_status = readl(port_mmio + PORT_IRQ_STAT);
> +
> +	/*
> +	 * There is no need to check TFDATA if BAD PMP is found due to HW bug,
> +	 * which can save timeout delay.
> +	 */
> +	if (irq_status & PORT_IRQ_BAD_PMP)
> +		return -EIO;
> +
> +	printk("%s:TFT 0x%x\n", __func__, status);
> +	return ata_check_ready(status);
> +}
> +
> +static int ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
> +				unsigned long deadline)
> +{
> +	struct ata_port *ap = link->ap;
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	int pmp = sata_srst_pmp(link);
> +	int rc;
> +	u32 irq_sts;
> +
> +	DPRINTK("ENTER\n");
> +
> +	rc = ahci_do_softreset(link, class, pmp, deadline,
> +			       ahci_pmp_check_ready);
> +
> +	/*
> +	 * Soft reset fails with IPMS set when PMP is enabled but
> +	 * SATA HDD/ODD is connected to SATA port, do soft reset
> +	 * again to port 0.
> +	 */
> +	if (rc == -EIO) {
> +		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
> +		if (irq_sts & PORT_IRQ_BAD_PMP) {
> +			ata_link_printk(link, KERN_WARNING,
> +					"applying PMP SRST workaround "
> +					"and retrying\n");
> +			rc = ahci_do_softreset(link, class, 0, deadline,
> +					       ahci_check_ready);
> +		}
> +	}
> +
> +	return rc;
> +}

Please make two separate patches.  One to rename & move sb600 ops to
libahci.c and another to use it for platform.  There's no reason to
have two identical sets of functions doing the same thing.

Thanks.

-- 
tejun
