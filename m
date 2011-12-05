Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1LEJsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:48:25 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:39721 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250Ab1LEJsX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:48:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111202171117.GA27322@phenom.dumpdata.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
 <1322816252-19955-2-git-send-email-sumit.semwal@ti.com> <20111202171117.GA27322@phenom.dumpdata.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Mon, 5 Dec 2011 15:18:00 +0530
Message-ID: <CAB2ybb-G=4igL+XdRgH6oFSFdsBLuCoany4KeNaFfnLEaQzgdw@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        t.stanislaws@samsung.com, linux@arm.linux.org.uk, arnd@arndb.de,
        rob@ti.com, Sumit Semwal <sumit.semwal@linaro.org>,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Fri, Dec 2, 2011 at 10:41 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Dec 02, 2011 at 02:27:31PM +0530, Sumit Semwal wrote:
>> This is the first step in defining a dma buffer sharing mechanism.
>>
<snip>
>>
>> [1]: https://wiki.linaro.org/OfficeofCTO/MemoryManagement
>> [2]: http://lwn.net/Articles/454389
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
>
> You have a clone? You only need one SOB.
:) Thanks for your review - Well, not a clone, but I have two 'employers' :))

I have a rather weird reason for this - I am employed with Texas
Instruments, but working with Linaro as well. And due to some
'non-technical' reasons, I need to send this work from @ti.com mail
ID. At the same time, I would like to acknowledge that this work was
done as part of the Linaro umbrella, so I put another SOB @linaro.org.

>
>
<snip>
>> + * Copyright(C) 2011 Linaro Limited. All rights reserved.
>> + * Author: Sumit Semwal <sumit.semwal@ti.com>
>
> OK, so the SOB should be from @ti.com then.
>
>> + *
<snip>
>> +static int dma_buf_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     struct dma_buf *dmabuf;
>> +
>> +     if (!is_dma_buf_file(file))
>> +             return -EINVAL;
>> +
>> +     dmabuf = file->private_data;
>> +
>
> Should you check if dmabuf is NULL and or dmabuf->ops is NULL too?
>
> Hm, you probably don't need to check for dmabuf, but from
> looking at  dma_buf_export one could pass  a NULL for the ops.
see next comment
>
>> +     if (!dmabuf->ops->mmap)
>> +             return -EINVAL;
>> +
>> +     return dmabuf->ops->mmap(dmabuf, vma);
>> +}
>> +
>> +static int dma_buf_release(struct inode *inode, struct file *file)
>> +{
>> +     struct dma_buf *dmabuf;
>> +
>> +     if (!is_dma_buf_file(file))
>> +             return -EINVAL;
>> +
>> +     dmabuf = file->private_data;
>> +
>
> No checking here for ops or ops->release?
Hmmm.. you're right, of course. for this common check in mmap and
release, I guess I'd add it to 'is_dma_buf_file()' helper [maybe call
it is_valid_dma_buf_file() or something similar]
>
<snip>
>> +
>> +/**
>
> I don't think the ** is anymore the current kernel doc format.
thanks for catching this :) - will correct.
>
>> + * dma_buf_export - Creates a new dma_buf, and associates an anon file
>> + * with this buffer,so it can be exported.
>
> Put a space there.
ok
>
>> + * Also connect the allocator specific data and ops to the buffer.
>> + *
>> + * @priv:    [in]    Attach private data of allocator to this buffer
>> + * @ops:     [in]    Attach allocator-defined dma buf ops to the new buffer.
>> + * @flags:   [in]    mode flags for the file.
>> + *
>> + * Returns, on success, a newly created dma_buf object, which wraps the
>> + * supplied private data and operations for dma_buf_ops. On failure to
>> + * allocate the dma_buf object, it can return NULL.
>
> "it can" I think the right word is "it will".
Right.
>
>> + *
>> + */
>> +struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
>> +                             int flags)
>> +{
>> +     struct dma_buf *dmabuf;
>> +     struct file *file;
>> +
>> +     BUG_ON(!priv || !ops);
>
> Whoa. Crash the whole kernel b/c of this? No no. You should
> use WARN_ON and just return NULL.
ok
>
>> +
>> +     dmabuf = kzalloc(sizeof(struct dma_buf), GFP_KERNEL);
>> +     if (dmabuf == NULL)
>> +             return dmabuf;
>
> Hmm, why not return ERR_PTR(-ENOMEM); ?
ok
>
>> +
>> +     dmabuf->priv = priv;
>> +     dmabuf->ops = ops;
>> +
>> +     file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
>> +
>> +     dmabuf->file = file;
>> +
>> +     mutex_init(&dmabuf->lock);
>> +     INIT_LIST_HEAD(&dmabuf->attachments);
>> +
>> +     return dmabuf;
>> +}
>> +EXPORT_SYMBOL(dma_buf_export);
>
> _GPL ?
sure; will change it.
>
>> +
>> +
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
>
> Should you check if dmabuf is NULL first?
yes.
>
>> +     if (!dmabuf->file)
>> +             return -EINVAL;
>> +
>> +     error = get_unused_fd_flags(0);
>> +     if (error < 0)
>> +             return error;
>> +     fd = error;
>> +
>> +     fd_install(fd, dmabuf->file);
>> +
>> +     return fd;
>> +}
>> +EXPORT_SYMBOL(dma_buf_fd);
>
> GPL?
sure; will change it.
>> +
>> +/**
>> + * dma_buf_get - returns the dma_buf structure related to an fd
>> + * @fd:      [in]    fd associated with the dma_buf to be returned
>> + *
>> + * On success, returns the dma_buf structure associated with an fd; uses
>> + * file's refcounting done by fget to increase refcount. returns ERR_PTR
>> + * otherwise.
>> + */
>> +struct dma_buf *dma_buf_get(int fd)
>> +{
>> +     struct file *file;
>> +
>> +     file = fget(fd);
>> +
>> +     if (!file)
>> +             return ERR_PTR(-EBADF);
>> +
>> +     if (!is_dma_buf_file(file)) {
>> +             fput(file);
>> +             return ERR_PTR(-EINVAL);
>> +     }
>> +
>> +     return file->private_data;
>> +}
>> +EXPORT_SYMBOL(dma_buf_get);
>
> GPL
sure; will change it.
>> +
>> +/**
>> + * dma_buf_put - decreases refcount of the buffer
>> + * @dmabuf:  [in]    buffer to reduce refcount of
>> + *
>> + * Uses file's refcounting done implicitly by fput()
>> + */
>> +void dma_buf_put(struct dma_buf *dmabuf)
>> +{
>> +     BUG_ON(!dmabuf->file);
>
> Yikes. BUG_ON? Can't you do WARN_ON and continue on without
> doing the refcounting?
ok
>
>> +
>> +     fput(dmabuf->file);
>> +}
>> +EXPORT_SYMBOL(dma_buf_put);
>> +
>> +/**
>> + * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
>> + * calls attach() of dma_buf_ops to allow device-specific attach functionality
>> + * @dmabuf:  [in]    buffer to attach device to.
>> + * @dev:     [in]    device to be attached.
>> + *
>> + * Returns struct dma_buf_attachment * for this attachment; may return NULL.
>> + *
>> + */
>> +struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>> +                                             struct device *dev)
>
> 'struct device' should be at the same column as 'struct dma_buf' ..
>
>> +{
>> +     struct dma_buf_attachment *attach;
>> +     int ret;
>> +
>> +     BUG_ON(!dmabuf || !dev);
>
> Again, BUG_ON...
will correct
>
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
>
> No checking first of dmabuf->ops?
Attach is told to be a mandatory operation for dmabuf exporter, but I
understand your point - checking for it won't hurt.
>
>> +             ret = dmabuf->ops->attach(dmabuf, dev, attach);
>> +             if (!ret)
>> +                     goto err_attach;
>> +     }
>> +     list_add(&attach->node, &dmabuf->attachments);
>> +
>> +     mutex_unlock(&dmabuf->lock);
>> +
>> +err_alloc:
>> +     return attach;
>> +err_attach:
>> +     kfree(attach);
>> +     mutex_unlock(&dmabuf->lock);
>> +     return ERR_PTR(ret);
>> +}
>> +EXPORT_SYMBOL(dma_buf_attach);
>
> GPL
sure; will change it.
<snip>

Thanks and regards,
~Sumit.
