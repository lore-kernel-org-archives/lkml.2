Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0HAGxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:53:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40134 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0HAGxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:53:20 -0400
MIME-Version: 1.0
In-Reply-To: <1279738541.4640.15.camel@Joe-Laptop.home>
References: <1279738541.4640.15.camel@Joe-Laptop.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 1 Aug 2010 00:53:00 -0600
X-Google-Sender-Auth: srJizNLX1RQ9lahQX1fQjbcjAGE
Message-ID: <AANLkTi=gQCOvd8AD3dqBuFrmhgnGNdDhXtxehFjpFJcS@mail.gmail.com>
Subject: Re: [PATCH] drivers/spi: Convert printks to pr_<level>
To: Joe Perches <joe@perches.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:55 PM, Joe Perches <joe@perches.com> wrote:
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Convert printks to pr_<level>
> Convert a test w/ errmsg to a more normal form
>
> Uncompiled, untested

Hi Joe,

If going through the bother of changing printk statements, then most
of these should be converted to dev_err/info/dbg() instead of pr_*().
Nack.

Cheers,
g.

>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/spi/amba-pl022.c    |    6 ++++--
>  drivers/spi/au1550_spi.c    |    5 +++--
>  drivers/spi/dw_spi.c        |    6 +++---
>  drivers/spi/dw_spi_pci.c    |    2 +-
>  drivers/spi/omap_spi_100k.c |    2 +-
>  drivers/spi/omap_uwire.c    |    3 +--
>  drivers/spi/spi_lm70llp.c   |   23 +++++++++++------------
>  7 files changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
> index f0a1418..427fa44 100644
> --- a/drivers/spi/amba-pl022.c
> +++ b/drivers/spi/amba-pl022.c
> @@ -30,6 +30,8 @@
>  * - add generic DMA framework support
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
> @@ -1775,8 +1777,8 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
>                status = -ENOMEM;
>                goto err_no_ioremap;
>        }
> -       printk(KERN_INFO "pl022: mapped registers from 0x%08x to %p\n",
> -              adev->res.start, pl022->virtbase);
> +       pr_info("mapped registers from 0x%08llx to %p\n",
> +               (unsigned long long)adev->res.start, pl022->virtbase);
>
>        pl022->clk = clk_get(&adev->dev, NULL);
>        if (IS_ERR(pl022->clk)) {
> diff --git a/drivers/spi/au1550_spi.c b/drivers/spi/au1550_spi.c
> index 3c9ade6..d95a54e 100644
> --- a/drivers/spi/au1550_spi.c
> +++ b/drivers/spi/au1550_spi.c
> @@ -21,6 +21,8 @@
>  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/slab.h>
> @@ -1012,8 +1014,7 @@ static int __init au1550_spi_init(void)
>        if (usedma) {
>                ddma_memid = au1xxx_ddma_add_device(&au1550_spi_mem_dbdev);
>                if (!ddma_memid)
> -                       printk(KERN_ERR "au1550-spi: cannot add memory"
> -                                       "dbdma device\n");
> +                       pr_err("cannot add memory dbdma device\n");
>        }
>        return platform_driver_probe(&au1550_spi_drv, au1550_spi_probe);
>  }
> diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
> index d256cb0..c5d15d4 100644
> --- a/drivers/spi/dw_spi.c
> +++ b/drivers/spi/dw_spi.c
> @@ -490,8 +490,8 @@ static void pump_transfers(unsigned long data)
>                if (transfer->speed_hz != speed) {
>                        speed = transfer->speed_hz;
>                        if (speed > dws->max_freq) {
> -                               printk(KERN_ERR "MRST SPI0: unsupported"
> -                                       "freq: %dHz\n", speed);
> +                               pr_err("MRST SPI0: unsupported freq: %dHz\n",
> +                                      speed);
>                                message->status = -EIO;
>                                goto early_exit;
>                        }
> @@ -525,7 +525,7 @@ static void pump_transfers(unsigned long data)
>                                        u16_writer : null_writer;
>                        break;
>                default:
> -                       printk(KERN_ERR "MRST SPI0: unsupported bits:"
> +                       pr_err("MRST SPI0: unsupported bits:"
>                                "%db\n", bits);
>                        message->status = -EIO;
>                        goto early_exit;
> diff --git a/drivers/spi/dw_spi_pci.c b/drivers/spi/dw_spi_pci.c
> index 1f52755..35f1811 100644
> --- a/drivers/spi/dw_spi_pci.c
> +++ b/drivers/spi/dw_spi_pci.c
> @@ -38,7 +38,7 @@ static int __devinit spi_pci_probe(struct pci_dev *pdev,
>        int pci_bar = 0;
>        int ret;
>
> -       printk(KERN_INFO "DW: found PCI SPI controller(ID: %04x:%04x)\n",
> +       pr_info("DW: found PCI SPI controller(ID: %04x:%04x)\n",
>                pdev->vendor, pdev->device);
>
>        ret = pci_enable_device(pdev);
> diff --git a/drivers/spi/omap_spi_100k.c b/drivers/spi/omap_spi_100k.c
> index 9bd1c92..b8b23f2 100644
> --- a/drivers/spi/omap_spi_100k.c
> +++ b/drivers/spi/omap_spi_100k.c
> @@ -425,7 +425,7 @@ static void omap1_spi100k_work(struct work_struct *work)
>        spin_unlock_irq(&spi100k->lock);
>
>        if (status < 0)
> -               printk(KERN_WARNING "spi transfer failed with %d\n", status);
> +               pr_warning("spi transfer failed with %d\n", status);
>  }
>
>  static int omap1_spi100k_transfer(struct spi_device *spi, struct spi_message *m)
> diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
> index 160d326..445a454 100644
> --- a/drivers/spi/omap_uwire.c
> +++ b/drivers/spi/omap_uwire.c
> @@ -154,8 +154,7 @@ static int wait_uwire_csr_flag(u16 mask, u16 val, int might_not_catch)
>                if ((w & mask) == val)
>                        break;
>                if (time_after(jiffies, max_jiffies)) {
> -                       printk(KERN_ERR "%s: timeout. reg=%#06x "
> -                                       "mask=%#06x val=%#06x\n",
> +                       pr_err("%s: timeout. reg=%#06x mask=%#06x val=%#06x\n",
>                               __func__, w, mask, val);
>                        return -1;
>                }
> diff --git a/drivers/spi/spi_lm70llp.c b/drivers/spi/spi_lm70llp.c
> index 7746a41..ac3a13d 100644
> --- a/drivers/spi/spi_lm70llp.c
> +++ b/drivers/spi/spi_lm70llp.c
> @@ -18,6 +18,8 @@
>  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> @@ -202,9 +204,7 @@ static void spi_lm70llp_attach(struct parport *p)
>        int                     status;
>
>        if (lm70llp) {
> -               printk(KERN_WARNING
> -                       "%s: spi_lm70llp instance already loaded. Aborting.\n",
> -                       DRVNAME);
> +               pr_warning("instance already loaded. Aborting\n");
>                return;
>        }
>
> @@ -252,9 +252,8 @@ static void spi_lm70llp_attach(struct parport *p)
>         */
>        status = spi_bitbang_start(&pp->bitbang);
>        if (status < 0) {
> -               printk(KERN_WARNING
> -                       "%s: spi_bitbang_start failed with status %d\n",
> -                       DRVNAME, status);
> +               pr_warning("spi_bitbang_start failed with status %d\n",
> +                          status);
>                goto out_off_and_release;
>        }
>
> @@ -277,14 +276,14 @@ static void spi_lm70llp_attach(struct parport *p)
>         */
>        pp->info.controller_data = pp;
>        pp->spidev_lm70 = spi_new_device(pp->bitbang.master, &pp->info);
> -       if (pp->spidev_lm70)
> -               dev_dbg(&pp->spidev_lm70->dev, "spidev_lm70 at %s\n",
> -                               dev_name(&pp->spidev_lm70->dev));
> -       else {
> -               printk(KERN_WARNING "%s: spi_new_device failed\n", DRVNAME);
> +       if (!pp->spidev_lm70) {
> +               pr_warning("spi_new_device failed\n");
>                status = -ENODEV;
>                goto out_bitbang_stop;
>        }
> +       dev_dbg(&pp->spidev_lm70->dev, "spidev_lm70 at %s\n",
> +               dev_name(&pp->spidev_lm70->dev));
> +
>        pp->spidev_lm70->bits_per_word = 8;
>
>        lm70llp = pp;
> @@ -302,7 +301,7 @@ out_parport_unreg:
>  out_free_master:
>        (void) spi_master_put(master);
>  out_fail:
> -       pr_info("%s: spi_lm70llp probe fail, status %d\n", DRVNAME, status);
> +       pr_info("probe fail, status %d\n", status);
>  }
>
>  static void spi_lm70llp_detach(struct parport *p)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
