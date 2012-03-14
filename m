Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2CNWy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:54:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40074 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2CNWyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <1331603857.3436.24.camel@minggr>
References: <1331603857.3436.24.camel@minggr>
Date: Wed, 14 Mar 2012 23:49:39 +0100
Message-ID: <CAG-aW06hebVsVrFZvTMMuS6v6VNGf65H8h1X3eMaNXZo_QmbBQ@mail.gmail.com>
Subject: Re: [PATCH v2] libata: disable runtime pm for hotpluggable port
From: Matt <jackdachef@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, jslaby@suse.cz, cwillu@cwillu.com,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 2:57 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Currently, hotplug doesn't work if port is already runtime suspended.
> For now, we simply disable runtime pm for hotpluggable port.
> Later, we should add runtime pm support for hotpluggable port too.
>
> Bug report:
> https://lkml.org/lkml/2012/2/19/70
>
> v2:
> - Use bit 2 and 3 for flags ATA_FLAG_EXTERNAL and ATA_FLAG_PLUGGABLE.
>
> TODO: add similar hotpluggable port check for controllers other than
> AHCI.
>
> Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
> Reported-and-tested-by: cwillu@cwillu.com
> Reported-and-tested-by: jackdachef@gmail.com
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/ata/ahci.c             |    3 +++
>  drivers/ata/ahci.h             |    3 +++
>  drivers/ata/libahci.c          |   20 ++++++++++++++++++++
>  drivers/ata/libata-transport.c |    6 ++++--
>  include/linux/libata.h         |    2 ++
>  5 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index d07bf03..02e93ff 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1145,6 +1145,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>        if (hpriv->cap & HOST_CAP_PMP)
>                pi.flags |= ATA_FLAG_PMP;
>
> +       if (hpriv->cap & HOST_CAP_SXS)
> +               pi.flags |= ATA_FLAG_EXTERNAL;
> +
>        ahci_set_em_messages(hpriv, &pi);
>
>        if (ahci_broken_system_poweroff(pdev)) {
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index b175000..92f7172 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -172,6 +172,9 @@ enum {
>        PORT_CMD_ALPE           = (1 << 26), /* Aggressive Link PM enable */
>        PORT_CMD_ATAPI          = (1 << 24), /* Device is ATAPI */
>        PORT_CMD_FBSCP          = (1 << 22), /* FBS Capable Port */
> +       PORT_CMD_ESP            = (1 << 21), /* External SATA Port */
> +       PORT_CMD_MPSP           = (1 << 19), /* Mechanical Presence Switch Attached to Port */
> +       PORT_CMD_HPCP           = (1 << 18), /* Hot Plug Capable Port */
>        PORT_CMD_PMP            = (1 << 17), /* PMP attached */
>        PORT_CMD_LIST_ON        = (1 << 15), /* cmd list DMA engine running */
>        PORT_CMD_FIS_ON         = (1 << 14), /* FIS DMA engine running */
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index a72bfd0..7d72d3c 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1097,6 +1097,23 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
>        writel(1 << port_no, mmio + HOST_IRQ_STAT);
>  }
>
> +static bool ahci_port_pluggable(struct ata_port *ap)
> +{
> +       void __iomem *port_mmio = ahci_port_base(ap);
> +       u32 cmd;
> +
> +       cmd = readl(port_mmio + PORT_CMD);
> +
> +       if ((ap->flags & ATA_FLAG_EXTERNAL) &&
> +           (cmd & PORT_CMD_ESP))
> +               return true;
> +
> +       if (cmd & (PORT_CMD_MPSP | PORT_CMD_HPCP))
> +               return true;
> +
> +       return false;
> +}
> +
>  void ahci_init_controller(struct ata_host *host)
>  {
>        struct ahci_host_priv *hpriv = host->private_data;
> @@ -1112,6 +1129,9 @@ void ahci_init_controller(struct ata_host *host)
>                if (ata_port_is_dummy(ap))
>                        continue;
>
> +               if (ahci_port_pluggable(ap))
> +                       ap->flags |= ATA_FLAG_PLUGGABLE;
> +
>                ahci_port_init(host->dev, ap, i, mmio, port_mmio);
>        }
>
> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index 74aaee3..a7166b9 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -292,8 +292,10 @@ int ata_tport_add(struct device *parent,
>        }
>
>        device_enable_async_suspend(dev);
> -       pm_runtime_set_active(dev);
> -       pm_runtime_enable(dev);
> +       if (!(ap->flags & ATA_FLAG_PLUGGABLE)) {
> +               pm_runtime_set_active(dev);
> +               pm_runtime_enable(dev);
> +       }
>
>        transport_add_device(dev);
>        transport_configure_device(dev);
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index cafc09a..f46961d 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -187,6 +187,8 @@ enum {
>        ATA_FLAG_SLAVE_POSS     = (1 << 0), /* host supports slave dev */
>                                            /* (doesn't imply presence) */
>        ATA_FLAG_SATA           = (1 << 1),
> +       ATA_FLAG_EXTERNAL       = (1 << 2), /* Controller supports external SATA */
> +       ATA_FLAG_PLUGGABLE      = (1 << 3), /* Port is hotpluggable */
>        ATA_FLAG_NO_ATAPI       = (1 << 6), /* No ATAPI support */
>        ATA_FLAG_PIO_DMA        = (1 << 7), /* PIO cmds via DMA */
>        ATA_FLAG_PIO_LBA48      = (1 << 8), /* Host DMA engine is LBA28 only */
> --
> 1.7.2.5
>
>
>

Hi Lin Ming,

thanks for CCing on the updated patch

I just finished testing it with 3.3-rc7 and it works as advertised


Kind Regards

Matt
