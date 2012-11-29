Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab2K2K45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:56:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4818 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2K2K4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:56:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 29 Nov 2012 02:56:32 -0800
Message-ID: <50B74058.9020904@nvidia.com>
Date: Thu, 29 Nov 2012 13:00:40 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 3/8] video: tegra: host: Add channel and client support
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com> <20121129100405.GB28781@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129100405.GB28781@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 12:04, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Nov 26, 2012 at 03:19:09PM +0200, Terje Bergstrom wrote:
> 
> I've skipped a lot of code here that I need more time to review.

Thanks already for the very good comments! It's great getting comments
on the code from fresh eyes.

> Looking some more at how this is used, I'm starting to think that it
> might be easier to export the various handlers and allow them to be
> passed to the nvhost_intr_add_action() explicitly.

Oh, so you mean like "nvhost_intr_add_action(intr, id, threshold,
nvhost_intr_action_submit_complete, channel, waiter, priv), and
nvhost_intr_action_submit_complete is the function pointer?

There's one case to take care of: we merge the waits for the jobs into
one waiter to save us from having too many irq calls. Perhaps that could
be handled by a flag, or something like that.

>> +/* Magic to use to fill freed handle slots */
>> +#define BAD_MAGIC 0xdeadbeef
> 
> This isn't currently used.

Will remove.

> 
>> +static size_t job_size(u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
>> +{
>> +     u32 num_unpins = num_cmdbufs + num_relocs;
>> +     s64 total;
>> +
>> +     if (num_relocs < 0 || num_waitchks < 0 || num_cmdbufs < 0)
>> +             return 0;
>> +
>> +     total = sizeof(struct nvhost_job)
>> +                     + num_relocs * sizeof(struct nvhost_reloc)
>> +                     + num_unpins * sizeof(struct nvhost_job_unpin_data)
>> +                     + num_waitchks * sizeof(struct nvhost_waitchk)
>> +                     + num_cmdbufs * sizeof(struct nvhost_job_gather);
>> +
>> +     if (total > ULONG_MAX)
>> +             return 0;
>> +     return (size_t)total;
>> +}
>> +
>> +
>> +static void init_fields(struct nvhost_job *job,
>> +             u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
>> +{
>> +     u32 num_unpins = num_cmdbufs + num_relocs;
>> +     void *mem = job;
>> +
>> +     /* First init state to zero */
>> +
>> +     /*
>> +      * Redistribute memory to the structs.
>> +      * Overflows and negative conditions have
>> +      * already been checked in job_alloc().
>> +      */
>> +     mem += sizeof(struct nvhost_job);
>> +     job->relocarray = num_relocs ? mem : NULL;
>> +     mem += num_relocs * sizeof(struct nvhost_reloc);
>> +     job->unpins = num_unpins ? mem : NULL;
>> +     mem += num_unpins * sizeof(struct nvhost_job_unpin_data);
>> +     job->waitchk = num_waitchks ? mem : NULL;
>> +     mem += num_waitchks * sizeof(struct nvhost_waitchk);
>> +     job->gathers = num_cmdbufs ? mem : NULL;
>> +     mem += num_cmdbufs * sizeof(struct nvhost_job_gather);
>> +     job->addr_phys = (num_cmdbufs || num_relocs) ? mem : NULL;
>> +
>> +     job->reloc_addr_phys = job->addr_phys;
>> +     job->gather_addr_phys = &job->addr_phys[num_relocs];
>> +}
> 
> I wouldn't bother splitting out the above two functions.

You're right, I'll merge them back in. There was a historical reason for
the split, but not anymore.

> 
>> +
>> +struct nvhost_job *nvhost_job_alloc(struct nvhost_channel *ch,
>> +             int num_cmdbufs, int num_relocs, int num_waitchks)
>> +{
>> +     struct nvhost_job *job = NULL;
>> +     size_t size = job_size(num_cmdbufs, num_relocs, num_waitchks);
>> +
>> +     if (!size)
>> +             return NULL;
>> +     job = vzalloc(size);
> 
> Why vzalloc()?

I guess it's basically moot, but we tried that when we had some memory
fragmentation issues and it was left even though we did find out it's
not needed.

>> +void nvhost_job_add_gather(struct nvhost_job *job,
>> +             u32 mem_id, u32 words, u32 offset)
>> +{
>> +     struct nvhost_job_gather *cur_gather =
>> +                     &job->gathers[job->num_gathers];
>> +
>> +     cur_gather->words = words;
>> +     cur_gather->mem_id = mem_id;
>> +     cur_gather->offset = offset;
>> +     job->num_gathers += 1;
> 
> job->num_gathers++

OK.

>> +static int pin_job_mem(struct nvhost_job *job)
>> +{
>> +     int i;
>> +     int count = 0;
>> +     int result;
>> +     long unsigned *ids =
>> +                     kmalloc(sizeof(u32 *) *
>> +                             (job->num_relocs + job->num_gathers),
>> +                             GFP_KERNEL);
> 
> Maybe this should be allocated along with the nvhost_job and the other
> fields to avoid having to allocate, and potentially fail, here?

Yes, you're right.

>> +             __raw_writel(
>> +                     (job->reloc_addr_phys[i] +
>> +                             reloc->target_offset) >> reloc->shift,
>> +                     (cmdbuf_page_addr +
>> +                             (reloc->cmdbuf_offset & ~PAGE_MASK)));
> 
> You're not writing to I/O memory, so you shouldn't be using
> __raw_writel() here.

Will change.

> 
>> +int nvhost_job_pin(struct nvhost_job *job, struct platform_device *pdev)
>> +{
>> +     int err = 0, i = 0, j = 0;
>> +     struct nvhost_syncpt *sp = &nvhost_get_host(pdev)->syncpt;
>> +     unsigned long waitchk_mask[nvhost_syncpt_nb_pts(sp) / BITS_PER_LONG];
> 
> You should use a bitmap instead. See DECLARE_BITMAP in linux/types.h...

Oh, nice. Will do.

> 
>> +
>> +     memset(&waitchk_mask[0], 0, sizeof(waitchk_mask));
> 
> and run bitmap_zero() here...
> 
>> +     for (i = 0; i < job->num_waitchk; i++) {
>> +             u32 syncpt_id = job->waitchk[i].syncpt_id;
>> +             if (syncpt_id < nvhost_syncpt_nb_pts(sp))
>> +                     waitchk_mask[BIT_WORD(syncpt_id)] |=
>> +                             BIT_MASK(syncpt_id);
> 
> and use _set_bit here.

Will do.

> 
>> +     }
>> +
>> +     /* get current syncpt values for waitchk */
>> +     for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
>> +             nvhost_syncpt_update_min(sp, i);
> 
> Or since you only use the mask here, why not move the
> nvhost_syncpt_update_min() into the above loop?

I want to call nvhost_syncpt_update_min() only once per syncpt register.
If the job has 100 sync point increments for 2D sync point, I'd read the
value from hardware 100 times, which is expensive.

>> +     /* patch gathers */
>> +     for (i = 0; i < job->num_gathers; i++) {
>> +             struct nvhost_job_gather *g = &job->gathers[i];
>> +
>> +             /* process each gather mem only once */
>> +             if (!g->ref) {
>> +                     g->ref = nvhost_memmgr_get(g->mem_id, job->ch->dev);
>> +                     if (IS_ERR(g->ref)) {
>> +                             err = PTR_ERR(g->ref);
>> +                             g->ref = NULL;
>> +                             break;
>> +                     }
>> +
>> +                     g->mem_base = job->gather_addr_phys[i];
>> +
>> +                     for (j = 0; j < job->num_gathers; j++) {
>> +                             struct nvhost_job_gather *tmp =
>> +                                     &job->gathers[j];
>> +                             if (!tmp->ref && tmp->mem_id == g->mem_id) {
>> +                                     tmp->ref = g->ref;
>> +                                     tmp->mem_base = g->mem_base;
>> +                             }
>> +                     }
>> +                     err = do_relocs(job, g->mem_id,  g->ref);
>> +                     if (!err)
>> +                             err = do_waitchks(job, sp,
>> +                                             g->mem_id, g->ref);
>> +                     nvhost_memmgr_put(g->ref);
>> +                     if (err)
>> +                             break;
>> +             }
>> +     }
>> +fail:
>> +     wmb();
> 
> What do you need this write barrier for?

A good question. It looks we've sprinkled barriers around the code with
no proper reason.

> 
>> diff --git a/drivers/video/tegra/host/nvhost_memmgr.c b/drivers/video/tegra/host/nvhost_memmgr.c
>> new file mode 100644
>> index 0000000..bdceb74
>> --- /dev/null
>> +++ b/drivers/video/tegra/host/nvhost_memmgr.c
>> @@ -0,0 +1,160 @@
>> +/*
>> + * drivers/video/tegra/host/nvhost_memmgr.c
>> + *
>> + * Tegra host1x Memory Management Abstraction
>> + *
>> + * Copyright (c) 2012, NVIDIA Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/err.h>
>> +
>> +#include "nvhost_memmgr.h"
>> +#include "dmabuf.h"
>> +#include "chip_support.h"
>> +
>> +struct mem_handle *nvhost_memmgr_alloc(size_t size, size_t align, int flags)
>> +{
>> +     struct mem_handle *h = NULL;
>> +     h = nvhost_dmabuf_alloc(size, align, flags);
>> +
>> +     return h;
>> +}
>> +
>> +struct mem_handle *nvhost_memmgr_get(u32 id, struct platform_device *dev)
>> +{
>> +     struct mem_handle *h = NULL;
>> +
>> +     switch (nvhost_memmgr_type(id)) {
>> +     case mem_mgr_type_dmabuf:
>> +             h = (struct mem_handle *) nvhost_dmabuf_get(id, dev);
>> +             break;
>> +     default:
>> +             break;
>> +     }
>> +
>> +     return h;
>> +}
> 
> Heh, this would actually be a case where I'd argue in favour of an ops
> structure. But Lucas already mentioned that we may want to revise how
> the memory manager works and ideally we'd only have a single type of
> buffers anyway so this would largely become obsolete anyway.

Hmm, damn, and I've spent actually significant amount of time of
bypassing the ops here. Actually downstream memory manager uses ops
indirection. :-) I started removing it when I noticed that the ops
should actually be per handle, and not per SoC as the mem_ops() was.

We did discuss with Arto and he proposed that we'd just import dma_buf
fds into CMA GEM objects. That'd allow us to only support CMA GEM
objects inside nvhost. He started already by implementing CMA GEM buffer
support in nvhost as a new buffer type.

I'm not sure if importing is better than just supporting both CMA GEM
and dma_buf handles, but I guess we'll find out by trying it.

> I think we already agreed that we want to do dynamic allocation of
> syncpoints so these definitions can go away.

Yep.

> 
>>  enum nvhost_power_sysfs_attributes {
>>       NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY = 0,
>>       NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY,
>> @@ -142,4 +157,138 @@ void host1x_syncpt_incr(u32 id);
>>  u32 host1x_syncpt_read(u32 id);
>>  int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value);
>>
>> +/* Register device */
>> +int nvhost_client_device_init(struct platform_device *dev);
> 
> Again, I think this should be made easier on the clients. Ideally
> there'd be a single call to register a client with host1x which would
> already initialize the appropriate fields. There can be other, separate
> functions for resource allocations such as syncpoints and channels,
> though.

I'll try to cook up something to make this clearer.

>> +int nvhost_client_device_suspend(struct platform_device *dev);
> Again, I think this should be handled via runtime PM.

Referring to my previous comment.

> 
>> +struct nvhost_channel *nvhost_getchannel(struct nvhost_channel *ch);
>> +void nvhost_putchannel(struct nvhost_channel *ch);
> 
> These are oddly named. Better names would be nvhost_channel_get() or
> nvhost_channel_put().

Sounds good to me.

>> +int nvhost_channel_submit(struct nvhost_job *job);
>> +
>> +enum host1x_class {
>> +     NV_HOST1X_CLASS_ID              = 0x1,
>> +     NV_GRAPHICS_2D_CLASS_ID         = 0x51,
>> +};
> 
> Maybe this enumeration should be made more consistent, somewhat along
> the lines of:
> 
>         enum host1x_class {
>                 HOST1X_CLASS_HOST1X = 0x01,
>                 HOST1X_CLASS_2D = 0x51,
>         };

Sure.

> Again, I'll need more time to go over the rest of the code but the good
> news is that I'm starting to form a better picture of how things work.

Thanks. I've collected a massive amount of feedback already. v3 will
take quite a while to appear after we've finished all the reviews of v2.

Terje
