Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2K2IoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:44:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2K2IoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:44:07 -0500
Date: Thu, 29 Nov 2012 09:44:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
Message-ID: <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:g1Zxk+18oEgShwMbD2PDqRTtzgSSp8X0N/ury6vB08M
 rnvT22/LdKSkN3aeaa2JbVnak+2xnZNuqXyF7K3kAeHPKKF40i
 qlw9s1kb6AD+gH6ifexbZlbigZxPIX+3l8B45Qyanfq4Nak0u+
 YANFS3LKYVp8G9Dw4dh7TFPAMgwqZPQ7nBRml9moep92FHuabT
 jmc7i8ldLnMx+SNUwGOdXclBZX/amQjDaBr7bryt33teJ1Voq0
 NehDUgeIIwsX919Z23kTolYUClrGIi8/FOAru68h0yKww7Yo7k
 BlS41A53/ouHAu17blkn7gceGwBB6tTmThYo2Vf5Ho83YeUWcL
 l9HqkCuxPwVtlHMZh7QqzsqKiF6CHLjh5nlzXcjjy9aaDM7i3H
 McXO4rJyEKp9D1jj36zuWpoxoj6Gm/VyoM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 03:19:08PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegr=
a/host/chip_support.h
[...]
> +struct nvhost_intr_ops {
> +	void (*init_host_sync)(struct nvhost_intr *);
> +	void (*set_host_clocks_per_usec)(
> +		struct nvhost_intr *, u32 clocks);
> +	void (*set_syncpt_threshold)(
> +		struct nvhost_intr *, u32 id, u32 thresh);
> +	void (*enable_syncpt_intr)(struct nvhost_intr *, u32 id);
> +	void (*disable_syncpt_intr)(struct nvhost_intr *, u32 id);
> +	void (*disable_all_syncpt_intrs)(struct nvhost_intr *);
> +	int  (*request_host_general_irq)(struct nvhost_intr *);
> +	void (*free_host_general_irq)(struct nvhost_intr *);
> +	int (*free_syncpt_irq)(struct nvhost_intr *);
> +};
> +
>  struct nvhost_chip_support {
>  	const char *soc_name;
>  	struct nvhost_syncpt_ops syncpt;
> +	struct nvhost_intr_ops intr;
>  };
> =20
>  struct nvhost_chip_support *nvhost_get_chip_ops(void);
> =20
>  #define syncpt_op()		(nvhost_get_chip_ops()->syncpt)
> +#define intr_op()		(nvhost_get_chip_ops()->intr)
> =20
>  int nvhost_init_chip_support(struct nvhost_master *host);
> =20

The same comments apply as for patch 1. Reducing the number of
indirections here make things a lot easier.

> diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/de=
v.c
> index 98c9c9f..025a820 100644
> --- a/drivers/video/tegra/host/dev.c
> +++ b/drivers/video/tegra/host/dev.c
> @@ -43,6 +43,13 @@ u32 host1x_syncpt_read(u32 id)
>  }
>  EXPORT_SYMBOL(host1x_syncpt_read);
> =20
> +int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value)

The choice of data types is odd here. id refers to a syncpt so a better
choice would have been unsigned int because the size of the variable
doesn't actually matter. But as I already said in my reply to patch 1,
these are resources and should therefore better be abstracted through an
opaque pointer anyway.

timeout is usually signed long, so this function should reflect that. As
for the value this is probably fine as it will effectively be set from a
register value. Though you also cache them in software using atomics.

> +static void clock_on_host(struct platform_device *dev)
> +{
> +	struct nvhost_device_data *pdata =3D platform_get_drvdata(dev);
> +	struct nvhost_master *host =3D nvhost_get_private_data(dev);
> +	nvhost_intr_start(&host->intr, clk_get_rate(pdata->clk[0]));
> +}
> +
> +static int clock_off_host(struct platform_device *dev)
> +{
> +	struct nvhost_master *host =3D nvhost_get_private_data(dev);
> +	nvhost_intr_stop(&host->intr);
> +	return 0;
> +}

This is a good example of why these indirections are wasteful. You
constantly need to look up the host pointer just to call another
function on it. With some modifications to the structure layouts it
should be possible to make this a lot more straightforward.

> diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/teg=
ra/host/host1x/host1x.h
> index 76748ac..af9bfef 100644
> --- a/drivers/video/tegra/host/host1x/host1x.h
> +++ b/drivers/video/tegra/host/host1x/host1x.h
> @@ -25,6 +25,7 @@
>  #include <linux/nvhost.h>
> =20
>  #include "nvhost_syncpt.h"
> +#include "nvhost_intr.h"
> =20
>  #define TRACE_MAX_LENGTH	128U
>  #define IFACE_NAME		"nvhost"
> @@ -33,6 +34,7 @@ struct nvhost_master {
>  	void __iomem *aperture;
>  	void __iomem *sync_aperture;
>  	struct nvhost_syncpt syncpt;
> +	struct nvhost_intr intr;
>  	struct platform_device *dev;
>  	struct host1x_device_info info;
>  };
> diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/t=
egra/host/host1x/host1x01.c
> index d53302d..5bf0e6e 100644
> --- a/drivers/video/tegra/host/host1x/host1x01.c
> +++ b/drivers/video/tegra/host/host1x/host1x01.c
> @@ -26,12 +26,14 @@
>  #include "chip_support.h"
> =20
>  #include "host1x/host1x_syncpt.c"
> +#include "host1x/host1x_intr.c"
> =20
>  int nvhost_init_host1x01_support(struct nvhost_master *host,
>  	struct nvhost_chip_support *op)
>  {
>  	host->sync_aperture =3D host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
>  	op->syncpt =3D host1x_syncpt_ops;
> +	op->intr =3D host1x_intr_ops;
> =20
>  	return 0;
>  }

Also you need to touch a lot of files just to add this new feature. This
makes maintenance needlessly difficult.

> diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c b/drivers/vide=
o/tegra/host/host1x/host1x_intr.c
[...]
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +#include <asm/mach/irq.h>
> +
> +#include "nvhost_intr.h"
> +#include "host1x/host1x.h"
> +
> +/* Spacing between sync registers */
> +#define REGISTER_STRIDE 4

Erm... no. The usual way you should be doing this is either make the
register definitions account for the stride or use accessors that apply
the stride. You should be doing the latter anyway to make accesses. For
example:

	static inline void host1x_syncpt_writel(struct host1x *host1x,
						unsigned long value,
						unsigned long offset)
	{
		writel(value, host1x->regs + SYNCPT_BASE + offset);
	}

	static inline unsigned long host1x_syncpt_readl(struct host1x *host1x,
							unsigned long offset)
	{
		return readl(host1x->regs + SYNCPT_BASE + offset);
	}

Alternatively, if you want to pass the register index instead of the
offset, you can use just multiply the offset in that function:

	writel(value, host1x->regs + SYNCPT_BASE + (offset << 2));

The same can also be done with the non-syncpt registers.

> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
> +{
> +	struct nvhost_master *dev =3D dev_id;
> +	void __iomem *sync_regs =3D dev->sync_aperture;
> +	struct nvhost_intr *intr =3D &dev->intr;
> +	unsigned long reg;
> +	int i, id;
> +
> +	for (i =3D 0; i < dev->info.nb_pts / BITS_PER_LONG; i++) {
> +		reg =3D readl(sync_regs +
> +				host1x_sync_syncpt_thresh_cpu0_int_status_r() +
> +				i * REGISTER_STRIDE);
> +		for_each_set_bit(id, &reg, BITS_PER_LONG) {
> +			struct nvhost_intr_syncpt *sp =3D
> +				intr->syncpt + (i * BITS_PER_LONG + id);
> +			host1x_intr_syncpt_thresh_isr(sp);
> +			queue_work(intr->wq, &sp->work);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}

Maybe it would be better to call the syncpt handlers in interrupt
context and let them schedule work if they want to. I'm thinking about
the display controllers which may want to use syncpoints for VBLANK
support.

> +static void host1x_intr_init_host_sync(struct nvhost_intr *intr)
> +{
> +	struct nvhost_master *dev =3D intr_to_dev(intr);
> +	void __iomem *sync_regs =3D dev->sync_aperture;
> +	int i, err, irq;
> +
> +	writel(0xffffffffUL,
> +		sync_regs + host1x_sync_syncpt_thresh_int_disable_r());
> +	writel(0xffffffffUL,
> +		sync_regs + host1x_sync_syncpt_thresh_cpu0_int_status_r());
> +
> +	for (i =3D 0; i < dev->info.nb_pts; i++)
> +		INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
> +
> +	irq =3D platform_get_irq(dev->dev, 0);
> +	WARN_ON(IS_ERR_VALUE(irq));
> +	err =3D devm_request_irq(&dev->dev->dev, irq,
> +				syncpt_thresh_cascade_isr,
> +				IRQF_SHARED, "host_syncpt", dev);
> +	WARN_ON(IS_ERR_VALUE(err));

You should be handling this properly and propagate these errors to the
corresponding .probe().

> +/**
> + * Sync point threshold interrupt service function
> + * Handles sync point threshold triggers, in interrupt context
> + */
> +static void host1x_intr_syncpt_thresh_isr(struct nvhost_intr_syncpt *syn=
cpt)
> +{
> +	unsigned int id =3D syncpt->id;
> +	struct nvhost_intr *intr =3D intr_syncpt_to_intr(syncpt);
> +
> +	void __iomem *sync_regs =3D intr_to_dev(intr)->sync_aperture;
> +
> +	u32 reg =3D BIT_WORD(id) * REGISTER_STRIDE;
> +
> +	writel(BIT_MASK(id), sync_regs +
> +		host1x_sync_syncpt_thresh_int_disable_r() + reg);
> +	writel(BIT_MASK(id), sync_regs +
> +		host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
> +}

So this disables all interrupts and is called from the syncpt interrupt
handler. Where are the interrupts reenabled? Do host1x clients have to
do that manually?

> +static int host1x_intr_request_host_general_irq(struct nvhost_intr *intr)
> +{
> +	void __iomem *sync_regs =3D intr_to_dev(intr)->sync_aperture;
> +	int err;
> +
> +	/* master disable for general (not syncpt) host interrupts */
> +	writel(0, sync_regs + host1x_sync_intmask_r());
> +
> +	/* clear status & extstatus */
> +	writel(0xfffffffful, sync_regs + host1x_sync_hintstatus_ext_r());
> +	writel(0xfffffffful, sync_regs + host1x_sync_hintstatus_r());
> +
> +	err =3D request_irq(intr->host_general_irq, host1x_intr_host1x_isr, 0,
> +			"host_status", intr);
> +	if (err)
> +		return err;
> +
> +	/* enable extra interrupt sources IP_READ_INT and IP_WRITE_INT */
> +	writel(BIT(30) | BIT(31), sync_regs + host1x_sync_hintmask_ext_r());
> +
> +	/* enable extra interrupt sources */
> +	writel(BIT(12) | BIT(31), sync_regs + host1x_sync_hintmask_r());
> +
> +	/* enable host module interrupt to CPU0 */
> +	writel(BIT(0), sync_regs + host1x_sync_intc0mask_r());
> +
> +	/* master enable for general (not syncpt) host interrupts */
> +	writel(BIT(0), sync_regs + host1x_sync_intmask_r());
> +
> +	return err;
> +}

You should add defines for these bits, which will likely make the
comments redundant.

> diff --git a/drivers/video/tegra/host/nvhost_intr.c b/drivers/video/tegra=
/host/nvhost_intr.c
[...]
> +void reset_threshold_interrupt(struct nvhost_intr *intr,
> +			       struct list_head *head,
> +			       unsigned int id)
> +{
> +	u32 thresh =3D list_first_entry(head,
> +				struct nvhost_waitlist, list)->thresh;
> +
> +	intr_op().set_syncpt_threshold(intr, id, thresh);
> +	intr_op().enable_syncpt_intr(intr, id);
> +}

Okay, so this is where syncpoint interrupts are reenabled. The rest of
this whole wait queue code looks overly complex. I'll need to go through
that separately and more thoroughly.

> +void *nvhost_intr_alloc_waiter()
> +{
> +	return kzalloc(sizeof(struct nvhost_waitlist),
> +			GFP_KERNEL|__GFP_REPEAT);
> +}

I don't think we need __GFP_REPEAT here.

> +/*** Init & shutdown ***/
> +
> +int nvhost_intr_init(struct nvhost_intr *intr, u32 irq_gen, u32 irq_sync)

Again, using u32 for interrupt numbers is unusual.

> +{
> +	unsigned int id;
> +	struct nvhost_intr_syncpt *syncpt;
> +	struct nvhost_master *host =3D intr_to_dev(intr);
> +	u32 nb_pts =3D nvhost_syncpt_nb_pts(&host->syncpt);
> +
> +	mutex_init(&intr->mutex);
> +	intr->host_syncpt_irq_base =3D irq_sync;
> +	intr->wq =3D create_workqueue("host_syncpt");

What if create_workqueue() fails?

> +	intr_op().init_host_sync(intr);
> +	intr->host_general_irq =3D irq_gen;
> +	intr_op().request_host_general_irq(intr);
> +
> +	for (id =3D 0, syncpt =3D intr->syncpt;
> +	     id < nb_pts;
> +	     ++id, ++syncpt) {

This fits perfectly well on a single line, no need to wrap it. Also you
could instead of incrementing syncpt, move it into the loop and assign
it based on id.

	for (id =3D 0; id < nb_pts; id++) {
		struct nvhost_intr_syncpt *syncpt =3D &intr->syncpt[id];
		...
	}

> +void nvhost_intr_start(struct nvhost_intr *intr, u32 hz)
> +{
> +	mutex_lock(&intr->mutex);
> +
> +	intr_op().init_host_sync(intr);
> +	intr_op().set_host_clocks_per_usec(intr,
> +					       (hz + 1000000 - 1)/1000000);

DIV_ROUND_UP(hz)?

> diff --git a/drivers/video/tegra/host/nvhost_syncpt.h b/drivers/video/teg=
ra/host/nvhost_syncpt.h
[...]
> index b883442..dbd3890 100644
> --- a/drivers/video/tegra/host/nvhost_syncpt.h
> +++ b/drivers/video/tegra/host/nvhost_syncpt.h
> @@ -126,6 +126,16 @@ u32 nvhost_syncpt_read_wait_base(struct nvhost_syncp=
t *sp, u32 id);
> =20
>  void nvhost_syncpt_incr(struct nvhost_syncpt *sp, u32 id);
> =20
> +int nvhost_syncpt_wait_timeout(struct nvhost_syncpt *sp, u32 id, u32 thr=
esh,
> +			u32 timeout, u32 *value);
> +
> +static inline int nvhost_syncpt_wait(struct nvhost_syncpt *sp,
> +		u32 id, u32 thresh)
> +{
> +	return nvhost_syncpt_wait_timeout(sp, id, thresh,
> +					  MAX_SCHEDULE_TIMEOUT, NULL);
> +}
> +
>  void nvhost_syncpt_debug(struct nvhost_syncpt *sp);
> =20
>  static inline int nvhost_syncpt_is_valid(struct nvhost_syncpt *sp, u32 i=
d)
> diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
> index 20ba2a5..745f31c 100644
> --- a/include/linux/nvhost.h
> +++ b/include/linux/nvhost.h
> @@ -35,6 +35,7 @@ struct nvhost_device_power_attr;
>  #define NVHOST_DEFAULT_CLOCKGATE_DELAY		.clockgate_delay =3D 25
>  #define NVHOST_NAME_SIZE			24
>  #define NVSYNCPT_INVALID			(-1)
> +#define NVHOST_NO_TIMEOUT			(-1)

Couldn't you reuse MAX_SCHEDULE_TIMEOUT instead? You already use it as
the value for the timeout parameter in nvhost_syncpt_wait().

Thierry

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtyBQAAoJEN0jrNd/PrOhkp8P/3Vv1oaPjvB24KEafwt57SZs
Gjv/PHTLTJjojpPMsA1NRDWSm6752B+fQAPDpyYNWBFU3nCHDvro8LkE1cg/OcTd
dVrwSwx9QXGhGAip/s7rIv5rQdtUb1seJLIdWNDtZ8vf87QN0AsKmCNBBClFO8AA
KQT7+YJUHE3BrhK/gppj5uDEb0Z7LzSUtrDKA/So7hsiqpbcc5N+wScppasxRgPS
lK5uGuMtuMhQ/E3mP5afkUyyIOV6Vp1vJno++sSH8SVL4tFaI7yK6AsNqRxzs956
7kpu4LoW/R9gsxWDpuAT0bULxg+dAzry4dsfECMDhZrudkpRDkvEAGunHf0Mv6dD
7XCt62rdXvcPKfoRLHNTthI0QyE+ecL1frkGyQEN/yl6S9BUSKwhhrVrENkfRlYd
9S5zMY5egycVkKUWoO3+wv1awfxkTgRPbPG21OWqFI3ZrVAUcUiJOvZNt71limBM
WSQmLpfz3q64LLGnS5hDgL769MOHQO4AIhyuPaGqwAgzNUsH5k+D3lOcyzweu/31
dDYpm7Ckd+pU2eLbmIc8bPFuMnSMlLcaoGGUxCfr6GG2XPYZ6cPifajUqnFNnchS
8bMC88CqBhMbpnRq+uxCYGtfmvJK9NWG303kyXQ3R+Splb4Bd2Lqi3ArV59wdeO3
g/AWvh/2vEZUjStL+kCZ
=it4p
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
