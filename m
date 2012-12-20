Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab2LTWLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:11:23 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50628 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:11:16 -0500
X-Greylist: delayed 1573 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 17:11:16 EST
MIME-Version: 1.0
In-Reply-To: <CAF6AEGtkgwtPON+FvWYKVYPVBvkwoPOLkpT-pvVC-QuuvoYCJA@mail.gmail.com>
References: <50D255F5.5030602@nvidia.com>
	<1356009263-15822-1-git-send-email-daniel.vetter@ffwll.ch>
	<CAF6AEGtkgwtPON+FvWYKVYPVBvkwoPOLkpT-pvVC-QuuvoYCJA@mail.gmail.com>
Date: Thu, 20 Dec 2012 15:45:02 -0600
Message-ID: <CAF6AEGtbh7CxvJXh=9THbRREG36n8Co9aDyRjL9YQ8um=qO9dg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] dma-buf: implement vmap refcounting in the
 interface logic
From: Rob Clark <robdclark@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Plattner <aplattner@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:50 AM, Rob Clark <robdclark@gmail.com> wrote:
> On Thu, Dec 20, 2012 at 7:14 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> All drivers which implement this need to have some sort of refcount to
>> allow concurrent vmap usage. Hence implement this in the dma-buf core.
>>
>> To protect against concurrent calls we need a lock, which potentially
>> causes new funny locking inversions. But this shouldn't be a problem
>> for exporters with statically allocated backing storage, and more
>> dynamic drivers have decent issues already anyway.
>>
>> Inspired by some refactoring patches from Aaron Plattner, who
>> implemented the same idea, but only for drm/prime drivers.
>>
>> v2: Check in dma_buf_release that no dangling vmaps are left.
>> Suggested by Aaron Plattner. We might want to do similar checks for
>> attachments, but that's for another patch. Also fix up ERR_PTR return
>> for vmap.
>>
>> v3: Check whether the passed-in vmap address matches with the cached
>> one for vunmap. Eventually we might want to remove that parameter -
>> compared to the kmap functions there's no need for the vaddr for
>> unmapping.  Suggested by Chris Wilson.
>>
>> v4: Fix a brown-paper-bag bug spotted by Aaron Plattner.
>
> yeah, I think the locking does worry me a bit but hopefully should be
> able to do something better when reservations land
>
> Signed-off-by: Rob Clark <rob@ti.com>

or even,

Reviewed-by: Rob Clark <rob@ti.com>


>
>> Cc: Aaron Plattner <aplattner@nvidia.com>
>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>> ---
>>  Documentation/dma-buf-sharing.txt |  6 +++++-
>>  drivers/base/dma-buf.c            | 43 ++++++++++++++++++++++++++++++++++-----
>>  include/linux/dma-buf.h           |  4 +++-
>>  3 files changed, 46 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
>> index 0188903..4966b1b 100644
>> --- a/Documentation/dma-buf-sharing.txt
>> +++ b/Documentation/dma-buf-sharing.txt
>> @@ -302,7 +302,11 @@ Access to a dma_buf from the kernel context involves three steps:
>>        void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>>
>>     The vmap call can fail if there is no vmap support in the exporter, or if it
>> -   runs out of vmalloc space. Fallback to kmap should be implemented.
>> +   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
>> +   the dma-buf layer keeps a reference count for all vmap access and calls down
>> +   into the exporter's vmap function only when no vmapping exists, and only
>> +   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
>> +   by taking the dma_buf->lock mutex.
>>
>>  3. Finish access
>>
>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> index a3f79c4..26b68de 100644
>> --- a/drivers/base/dma-buf.c
>> +++ b/drivers/base/dma-buf.c
>> @@ -39,6 +39,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>>
>>         dmabuf = file->private_data;
>>
>> +       BUG_ON(dmabuf->vmapping_counter);
>> +
>>         dmabuf->ops->release(dmabuf);
>>         kfree(dmabuf);
>>         return 0;
>> @@ -482,12 +484,34 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
>>   */
>>  void *dma_buf_vmap(struct dma_buf *dmabuf)
>>  {
>> +       void *ptr;
>> +
>>         if (WARN_ON(!dmabuf))
>>                 return NULL;
>>
>> -       if (dmabuf->ops->vmap)
>> -               return dmabuf->ops->vmap(dmabuf);
>> -       return NULL;
>> +       if (!dmabuf->ops->vmap)
>> +               return NULL;
>> +
>> +       mutex_lock(&dmabuf->lock);
>> +       if (dmabuf->vmapping_counter) {
>> +               dmabuf->vmapping_counter++;
>> +               BUG_ON(!dmabuf->vmap_ptr);
>> +               ptr = dmabuf->vmap_ptr;
>> +               goto out_unlock;
>> +       }
>> +
>> +       BUG_ON(dmabuf->vmap_ptr);
>> +
>> +       ptr = dmabuf->ops->vmap(dmabuf);
>> +       if (IS_ERR_OR_NULL(ptr))
>> +               goto out_unlock;
>> +
>> +       dmabuf->vmap_ptr = ptr;
>> +       dmabuf->vmapping_counter = 1;
>> +
>> +out_unlock:
>> +       mutex_unlock(&dmabuf->lock);
>> +       return ptr;
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_vmap);
>>
>> @@ -501,7 +525,16 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>>         if (WARN_ON(!dmabuf))
>>                 return;
>>
>> -       if (dmabuf->ops->vunmap)
>> -               dmabuf->ops->vunmap(dmabuf, vaddr);
>> +       BUG_ON(!dmabuf->vmap_ptr);
>> +       BUG_ON(dmabuf->vmapping_counter == 0);
>> +       BUG_ON(dmabuf->vmap_ptr != vaddr);
>> +
>> +       mutex_lock(&dmabuf->lock);
>> +       if (--dmabuf->vmapping_counter == 0) {
>> +               if (dmabuf->ops->vunmap)
>> +                       dmabuf->ops->vunmap(dmabuf, vaddr);
>> +               dmabuf->vmap_ptr = NULL;
>> +       }
>> +       mutex_unlock(&dmabuf->lock);
>>  }
>>  EXPORT_SYMBOL_GPL(dma_buf_vunmap);
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index bd2e52c..e3bf2f6 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -119,8 +119,10 @@ struct dma_buf {
>>         struct file *file;
>>         struct list_head attachments;
>>         const struct dma_buf_ops *ops;
>> -       /* mutex to serialize list manipulation and attach/detach */
>> +       /* mutex to serialize list manipulation, attach/detach and vmap/unmap */
>>         struct mutex lock;
>> +       unsigned vmapping_counter;
>> +       void *vmap_ptr;
>>         void *priv;
>>  };
>>
>> --
>> 1.7.11.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
