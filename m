Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab1LEUqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:46:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53982 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1LEUqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:46:49 -0500
MIME-Version: 1.0
In-Reply-To: <201112051718.48324.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
	<201112051718.48324.arnd@arndb.de>
Date: Mon, 5 Dec 2011 14:46:47 -0600
X-Google-Sender-Auth: gvfqyfrIXRdmUZ04WWny-OfZru8
Message-ID: <CAF6AEGvyWV0DM2fjBbh-TNHiMmiLF4EQDJ6Uu0=NkopM6SXS6g@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Rob Clark <rob@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
        t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 11:18 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 02 December 2011, Sumit Semwal wrote:
>> This is the first step in defining a dma buffer sharing mechanism.
>
> This looks very nice, but there are a few things I don't understand yet
> and a bunch of trivial comments I have about things I spotted.
>
> Do you have prototype exporter and consumer drivers that you can post
> for clarification?

There is some dummy drivers based on an earlier version.  And airlied
has a prime (multi-gpu) prototype:

http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-prime-dmabuf

I've got a nearly working camera+display prototype:

https://github.com/robclark/kernel-omap4/commits/dmabuf

> In the patch 2, you have a section about migration that mentions that
> it is possible to export a buffer that can be migrated after it
> is already mapped into one user driver. How does that work when
> the physical addresses are mapped into a consumer device already?

I think you can do physical migration if you are attached, but
probably not if you are mapped.

>> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
>> index 21cf46f..07d8095 100644
>> --- a/drivers/base/Kconfig
>> +++ b/drivers/base/Kconfig
>> @@ -174,4 +174,14 @@ config SYS_HYPERVISOR
>>
>>  source "drivers/base/regmap/Kconfig"
>>
>> +config DMA_SHARED_BUFFER
>> +     bool "Buffer framework to be shared between drivers"
>> +     default n
>> +     depends on ANON_INODES
>
> I would make this 'select ANON_INODES', like the other users of this
> feature.
>
>> +     return dmabuf;
>> +}
>> +EXPORT_SYMBOL(dma_buf_export);
>
> I agree with Konrad, this should definitely be EXPORT_SYMBOL_GPL,
> because it's really a low-level function that I would expect
> to get used by in-kernel subsystems providing the feature to
> users and having back-end drivers, but it's not the kind of thing
> we want out-of-tree drivers to mess with.
>
>> +/**
>> + * dma_buf_fd - returns a file descriptor for the given dma_buf
>> + * @dmabuf:  [in]    pointer to dma_buf for which fd is required.
>> + *
>> + * On success, returns an associated 'fd'. Else, returns error.
>> + */
>> +int dma_buf_fd(struct dma_buf *dmabuf)
>> +{
>> +     int error, fd;
>> +
>> +     if (!dmabuf->file)
>> +             return -EINVAL;
>> +
>> +     error = get_unused_fd_flags(0);
>
> Why not simply get_unused_fd()?
>
>> +/**
>> + * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
>> + * calls attach() of dma_buf_ops to allow device-specific attach functionality
>> + * @dmabuf:  [in]    buffer to attach device to.
>> + * @dev:     [in]    device to be attached.
>> + *
>> + * Returns struct dma_buf_attachment * for this attachment; may return NULL.
>> + *
>
> Or may return a negative error code. It's better to be consistent here:
> either always return NULL on error, or change the allocation error to
> ERR_PTR(-ENOMEM).
>
>> + */
>> +struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>> +                                             struct device *dev)
>> +{
>> +     struct dma_buf_attachment *attach;
>> +     int ret;
>> +
>> +     BUG_ON(!dmabuf || !dev);
>> +
>> +     attach = kzalloc(sizeof(struct dma_buf_attachment), GFP_KERNEL);
>> +     if (attach == NULL)
>> +             goto err_alloc;
>> +
>> +     mutex_lock(&dmabuf->lock);
>> +
>> +     attach->dev = dev;
>> +     attach->dmabuf = dmabuf;
>> +     if (dmabuf->ops->attach) {
>> +             ret = dmabuf->ops->attach(dmabuf, dev, attach);
>> +             if (!ret)
>> +                     goto err_attach;
>
> You probably mean "if (ret)" here instead of "if (!ret)", right?
>
>> +     /* allow allocator to take care of cache ops */
>> +     void (*sync_sg_for_cpu) (struct dma_buf *, struct device *);
>> +     void (*sync_sg_for_device)(struct dma_buf *, struct device *);
>
> I don't see how this works with multiple consumers: For the streaming
> DMA mapping, there must be exactly one owner, either the device or
> the CPU. Obviously, this rule needs to be extended when you get to
> multiple devices and multiple device drivers, plus possibly user
> mappings. Simply assigning the buffer to "the device" from one
> driver does not block other drivers from touching the buffer, and
> assigning it to "the cpu" does not stop other hardware that the
> code calling sync_sg_for_cpu is not aware of.
>
> The only way to solve this that I can think of right now is to
> mandate that the mappings are all coherent (i.e. noncachable
> on noncoherent architectures like ARM). If you do that, you no
> longer need the sync_sg_for_* calls.

My original thinking was that you either need DMABUF_CPU_{PREP,FINI}
ioctls and corresponding dmabuf ops, which userspace is required to
call before / after CPU access.  Or just remove mmap() and do the
mmap() via allocating device and use that device's equivalent
DRM_XYZ_GEM_CPU_{PREP,FINI} or DRM_XYZ_GEM_SET_DOMAIN ioctls.  That
would give you a way to (a) synchronize with gpu/asynchronous
pipeline, (b) synchronize w/ multiple hw devices vs cpu accessing
buffer (ie. wait all devices have dma_buf_unmap_attachment'd).  And
that gives you a convenient place to do cache operations on
noncoherent architecture.

I sort of preferred having the DMABUF shim because that lets you pass
a buffer around userspace without the receiving code knowing about a
device specific API.  But the problem I eventually came around to: if
your GL stack (or some other userspace component) is batching up
commands before submission to kernel, the buffers you need to wait for
completion might not even be submitted yet.  So from kernel
perspective they are "ready" for cpu access.  Even though in fact they
are not in a consistent state from rendering perspective.  I don't
really know a sane way to deal with that.  Maybe the approach instead
should be a userspace level API (in libkms/libdrm?) to provide
abstraction for userspace access to buffers rather than dealing with
this at the kernel level.

BR,
-R

>> +#ifdef CONFIG_DMA_SHARED_BUFFER
>
> Do you have a use case for making the interface compile-time disabled?
> I had assumed that any code using it would make no sense if it's not
> available so you don't actually need this.
>
>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
