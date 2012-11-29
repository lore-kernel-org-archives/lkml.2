Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2K2Kfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:35:38 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6338 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2K2Kfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:35:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 29 Nov 2012 02:35:31 -0800
Message-ID: <50B73B5B.8030008@nvidia.com>
Date: Thu, 29 Nov 2012 12:39:23 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com> <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 10:44, Thierry Reding wrote:
>> diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/dev.c
>> index 98c9c9f..025a820 100644
>> --- a/drivers/video/tegra/host/dev.c
>> +++ b/drivers/video/tegra/host/dev.c
>> @@ -43,6 +43,13 @@ u32 host1x_syncpt_read(u32 id)
>>  }
>>  EXPORT_SYMBOL(host1x_syncpt_read);
>>
>> +int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value)
> 
> The choice of data types is odd here. id refers to a syncpt so a better
> choice would have been unsigned int because the size of the variable
> doesn't actually matter. But as I already said in my reply to patch 1,
> these are resources and should therefore better be abstracted through an
> opaque pointer anyway.
> 
> timeout is usually signed long, so this function should reflect that. As
> for the value this is probably fine as it will effectively be set from a
> register value. Though you also cache them in software using atomics.

32-bits is an architectural limit for the sync point id, so that's why I
used it here. But you're right - it doesn't really matter and could be
changed to unsigned long.

thresh and *value reflects that sync point value is 32-bit, and I'd keep
that as is.

Timeout should be unsigned long, yes.

>> diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c b/drivers/video/tegra/host/host1x/host1x_intr.c
> [...]
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/io.h>
>> +#include <asm/mach/irq.h>
>> +
>> +#include "nvhost_intr.h"
>> +#include "host1x/host1x.h"
>> +
>> +/* Spacing between sync registers */
>> +#define REGISTER_STRIDE 4
> 
> Erm... no. The usual way you should be doing this is either make the
> register definitions account for the stride or use accessors that apply
> the stride. You should be doing the latter anyway to make accesses. For
> example:
> 
>         static inline void host1x_syncpt_writel(struct host1x *host1x,
>                                                 unsigned long value,
>                                                 unsigned long offset)
>         {
>                 writel(value, host1x->regs + SYNCPT_BASE + offset);
>         }
> 
>         static inline unsigned long host1x_syncpt_readl(struct host1x *host1x,
>                                                         unsigned long offset)
>         {
>                 return readl(host1x->regs + SYNCPT_BASE + offset);
>         }
> 
> Alternatively, if you want to pass the register index instead of the
> offset, you can use just multiply the offset in that function:
>
>         writel(value, host1x->regs + SYNCPT_BASE + (offset << 2));
>
> The same can also be done with the non-syncpt registers.

The register number has a stride of 4 when doing writes, and 1 when
adding to command streams. This is why I've kept the register
definitions as is.

I could add helper functions. Just as a side note, the sync register
space has other definitions than just the syncpt registers, so the
naming should be changed a bit.

>> +static irqreturn_t syncpt_thresh_cascade_isr(int irq, void *dev_id)
>> +{
>> +     struct nvhost_master *dev = dev_id;
>> +     void __iomem *sync_regs = dev->sync_aperture;
>> +     struct nvhost_intr *intr = &dev->intr;
>> +     unsigned long reg;
>> +     int i, id;
>> +
>> +     for (i = 0; i < dev->info.nb_pts / BITS_PER_LONG; i++) {
>> +             reg = readl(sync_regs +
>> +                             host1x_sync_syncpt_thresh_cpu0_int_status_r() +
>> +                             i * REGISTER_STRIDE);
>> +             for_each_set_bit(id, &reg, BITS_PER_LONG) {
>> +                     struct nvhost_intr_syncpt *sp =
>> +                             intr->syncpt + (i * BITS_PER_LONG + id);
>> +                     host1x_intr_syncpt_thresh_isr(sp);
>> +                     queue_work(intr->wq, &sp->work);
>> +             }
>> +     }
>> +
>> +     return IRQ_HANDLED;
>> +}
> 
> Maybe it would be better to call the syncpt handlers in interrupt
> context and let them schedule work if they want to. I'm thinking about
> the display controllers which may want to use syncpoints for VBLANK
> support.

Display controller can use the APIs to read, increment and wait for sync
point.

We could do more in isr, but then again, we've noticed that the current
design already gives pretty good latency, so we haven't seen the need to
move code from thread to isr.

>> +static void host1x_intr_init_host_sync(struct nvhost_intr *intr)
>> +{
>> +     struct nvhost_master *dev = intr_to_dev(intr);
>> +     void __iomem *sync_regs = dev->sync_aperture;
>> +     int i, err, irq;
>> +
>> +     writel(0xffffffffUL,
>> +             sync_regs + host1x_sync_syncpt_thresh_int_disable_r());
>> +     writel(0xffffffffUL,
>> +             sync_regs + host1x_sync_syncpt_thresh_cpu0_int_status_r());
>> +
>> +     for (i = 0; i < dev->info.nb_pts; i++)
>> +             INIT_WORK(&intr->syncpt[i].work, syncpt_thresh_cascade_fn);
>> +
>> +     irq = platform_get_irq(dev->dev, 0);
>> +     WARN_ON(IS_ERR_VALUE(irq));
>> +     err = devm_request_irq(&dev->dev->dev, irq,
>> +                             syncpt_thresh_cascade_isr,
>> +                             IRQF_SHARED, "host_syncpt", dev);
>> +     WARN_ON(IS_ERR_VALUE(err));
> 
> You should be handling this properly and propagate these errors to the
> corresponding .probe().

Yes, will do. And the strange part is that nvhost_intr actually already
contains the irq number, so actually there's no need to retrieve it from
platform_device.

>> +/**
>> + * Sync point threshold interrupt service function
>> + * Handles sync point threshold triggers, in interrupt context
>> + */
>> +static void host1x_intr_syncpt_thresh_isr(struct nvhost_intr_syncpt *syncpt)
>> +{
>> +     unsigned int id = syncpt->id;
>> +     struct nvhost_intr *intr = intr_syncpt_to_intr(syncpt);
>> +
>> +     void __iomem *sync_regs = intr_to_dev(intr)->sync_aperture;
>> +
>> +     u32 reg = BIT_WORD(id) * REGISTER_STRIDE;
>> +
>> +     writel(BIT_MASK(id), sync_regs +
>> +             host1x_sync_syncpt_thresh_int_disable_r() + reg);
>> +     writel(BIT_MASK(id), sync_regs +
>> +             host1x_sync_syncpt_thresh_cpu0_int_status_r() + reg);
>> +}
> 
> So this disables all interrupts and is called from the syncpt interrupt
> handler. Where are the interrupts reenabled? Do host1x clients have to
> do that manually?

The thread re-enables once it's done. It checks the next value we're
interested in, and programs that to host1x syncpt threshold.


>> +     /* enable extra interrupt sources IP_READ_INT and IP_WRITE_INT */
>> +     writel(BIT(30) | BIT(31), sync_regs + host1x_sync_hintmask_ext_r());
>> +
>> +     /* enable extra interrupt sources */
>> +     writel(BIT(12) | BIT(31), sync_regs + host1x_sync_hintmask_r());
>> +
>> +     /* enable host module interrupt to CPU0 */
>> +     writel(BIT(0), sync_regs + host1x_sync_intc0mask_r());
>> +
>> +     /* master enable for general (not syncpt) host interrupts */
>> +     writel(BIT(0), sync_regs + host1x_sync_intmask_r());
>> +
>> +     return err;
>> +}
> 
> You should add defines for these bits, which will likely make the
> comments redundant.

I'm actually thinking that I might just remove the generic interrupts.
We have no use for it in upstream kernel.

> Okay, so this is where syncpoint interrupts are reenabled. The rest of
> this whole wait queue code looks overly complex. I'll need to go through
> that separately and more thoroughly.

Thanks.

>> +void *nvhost_intr_alloc_waiter()
>> +{
>> +     return kzalloc(sizeof(struct nvhost_waitlist),
>> +                     GFP_KERNEL|__GFP_REPEAT);
>> +}
> 
> I don't think we need __GFP_REPEAT here.

This used to be called from code where failed alloc was fatal, but not
anymore, so __GFP_REPEAT isn't needed anymore.

>> +/*** Init & shutdown ***/
>> +
>> +int nvhost_intr_init(struct nvhost_intr *intr, u32 irq_gen, u32 irq_sync)
> 
> Again, using u32 for interrupt numbers is unusual.

Ok.

>> +     mutex_init(&intr->mutex);
>> +     intr->host_syncpt_irq_base = irq_sync;
>> +     intr->wq = create_workqueue("host_syncpt");
> 
> What if create_workqueue() fails?

Hmm, we panic? Not good.

> 
>> +     intr_op().init_host_sync(intr);
>> +     intr->host_general_irq = irq_gen;
>> +     intr_op().request_host_general_irq(intr);
>> +
>> +     for (id = 0, syncpt = intr->syncpt;
>> +          id < nb_pts;
>> +          ++id, ++syncpt) {
> 
> This fits perfectly well on a single line, no need to wrap it. Also you
> could instead of incrementing syncpt, move it into the loop and assign
> it based on id.
> 
>         for (id = 0; id < nb_pts; id++) {
>                 struct nvhost_intr_syncpt *syncpt = &intr->syncpt[id];
>                 ...
>         }

Looks better, yes.

>> +void nvhost_intr_start(struct nvhost_intr *intr, u32 hz)
>> +{
>> +     mutex_lock(&intr->mutex);
>> +
>> +     intr_op().init_host_sync(intr);
>> +     intr_op().set_host_clocks_per_usec(intr,
>> +                                            (hz + 1000000 - 1)/1000000);
> 
> DIV_ROUND_UP(hz)?

Yes, that's what we should use. I didn't know we have that.

>> +#define NVHOST_NO_TIMEOUT                    (-1)
> 
> Couldn't you reuse MAX_SCHEDULE_TIMEOUT instead? You already use it as
> the value for the timeout parameter in nvhost_syncpt_wait().

I guess NVHOST_NO_TIMEOUT is anyway a bad idea, and I could just remove
it. The caller can just pass LONG_MAX if it wants to wait for a _really_
long time, but having no timeout is not good.

Terje
