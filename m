Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab1JNPev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:34:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45454 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab1JNPem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <4E98085A.8080803@samsung.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<4E98085A.8080803@samsung.com>
Date: Fri, 14 Oct 2011 10:34:40 -0500
X-Google-Sender-Auth: GVXtFYmtZEAP7Ak2occuKQwWFD8
Message-ID: <CAF6AEGv-YEs74Y3fcDmG=aqGaGAio8OQnheiddzNndEux1QC+w@mail.gmail.com>
Subject: Re: [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Rob Clark <rob@ti.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, daniel@ffwll.ch,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 5:00 AM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
>> + * @attach: allows different devices to 'attach' themselves to the given
>> + *         buffer. It might return -EBUSY to signal that backing storage
>> + *         is already allocated and incompatible with the requirements
>> + *         of requesting device. [optional]
>> + * @detach: detach a given device from this buffer. [optional]
>> + * @get_scatterlist: returns list of scatter pages allocated, increases
>> + *                  usecount of the buffer. Requires atleast one attach
>> to be
>> + *                  called before. Returned sg list should already be
>> mapped
>> + *                  into _device_ address space.
>
> You must add a comment that this call 'may sleep'.
>
> I like the get_scatterlist idea. It allows the exported to create a valid
> scatterlist for a client in a elegant way.
>
> I do not like this whole attachment idea. The problem is that currently
> there is no support in DMA framework for allocation for multiple devices. As
> long as no such a support exists, there is no generic way to handle
> attribute negotiations and buffer allocations that involve multiple devices.
> So the exporter drivers would have to implement more or less hacky solutions
> to handle memory requirements and choosing the device that allocated memory.
>
> Currently, AFAIK there is even no generic way for a driver to acquire its
> own DMA memory requirements.

dev->dma_params (struct device_dma_parameters).. for example

it would need to be expanded a bit to have a way to say "it needs to
be physically contiguous"..


> Therefore all logic hidden beneath 'attachment' is pointless. I think that
> support for attach/detach (and related stuff) should be postponed until
> support for multi-device allocation is added to DMA framework.
>
> I don't say the attachment list idea is wrong but adding attachment stuff
> creates an illusion that problem of multi-device allocations is somehow
> magically solved. We should not force the developers of exporter drivers to
> solve the problem that is not solvable yet.
>
> The other problem are the APIs. For example, the V4L2 subsystem assumes that
> memory is allocated after successful VIDIOC_REQBUFS with V4L2_MEMORY_MMAP
> memory type. Therefore attach would be automatically followed by
> get_scatterlist, blocking possibility of any buffer migrations in future.

But this problem really only applies if v4l is your buffer allocator.
I don't think a v4l limitation is a valid argument to remove the
attachment stuff.

> The same situation happens if buffer sharing is added to framebuffer API.
>
> The buffer sharing mechanism is dedicated to improve cooperation between
> multiple APIs. Therefore the common denominator strategy should be applied
> that is buffer-creation == buffer-allocation.

I think it would be sufficient if buffer creators that cannot defer
the allocation just take a worst-case approach and allocate physically
contiguous buffers.  No need to penalize other potential buffer
allocators.  This allows buffer creators with more flexibility the
option for deferring the allocation until it knows whether the buffer
really needs to be contiguous.

>> + * @put_scatterlist: decreases usecount of buffer, might deallocate
>> scatter
>> + *                  pages.
>> + * @mmap: memory map this buffer - optional.
>> + * @release: release this buffer; to be called after the last
>> dma_buf_put.
>> + * @sync_sg_for_cpu: sync the sg list for cpu.
>> + * @sync_sg_for_device: synch the sg list for device.
>> + */
>> +struct dma_buf_ops {
>> +       int (*attach)(struct dma_buf *, struct device *,
>> +                       struct dma_buf_attachment *);
>> +
>> +       void (*detach)(struct dma_buf *, struct dma_buf_attachment *);
>> +
>> +       /* For {get,put}_scatterlist below, any specific buffer attributes
>> +        * required should get added to device_dma_parameters accessible
>> +        * via dev->dma_params.
>> +        */
>> +       struct scatterlist * (*get_scatterlist)(struct dma_buf_attachment
>> *,
>> +                                               enum dma_data_direction,
>> +                                               int *nents);
>> +       void (*put_scatterlist)(struct dma_buf_attachment *,
>> +                                               struct scatterlist *,
>> +                                               int nents);
>> +       /* TODO: Add interruptible and interruptible_timeout versions */
>
> I don't agree the interruptible and interruptible_timeout versions are
> needed. I think that get_scatterlist should alway be interruptible. You can
> add try_get_scatterlist callback that returns ERR_PTR(-EBUSY) if the call
> would be blocking.
>
>> +
>> +       /* allow mmap optionally for devices that need it */
>> +       int (*mmap)(struct dma_buf *, struct vm_area_struct *);
>
> The mmap is not needed for inital version. It could be added at any time in
> the future. The dmabuf client should not be allowed to create mapping of the
> dmabuf from the scatterlist.

fwiw, this wasn't intended for allowing the client to create the
mapping.. the intention was that the buffer creator always be the one
that implements the mmap'ing.  This was just to implement fops->mmap()
for the dmabuf handle, ie. so userspace could mmap the buffer without
having to know *who* allocated it.  Otherwise you have to also pass
around the fd of the allocator and an offset.

BR,
-R
