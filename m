Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1LWJxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:53:02 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:54811 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab1LWJw5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:52:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111220163650.GB3964@phenom.dumpdata.com>
References: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
 <1324283611-18344-3-git-send-email-sumit.semwal@ti.com> <20111220163650.GB3964@phenom.dumpdata.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Fri, 23 Dec 2011 15:22:35 +0530
Message-ID: <CAB2ybb_jZNgQma7dv2qojOf8K0-1wutfMkNr3xjqFvfpw2aNTQ@mail.gmail.com>
Subject: Re: [RFC v3 1/2] dma-buf: Introduce dma buffer sharing mechanism
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        t.stanislaws@samsung.com, linux@arm.linux.org.uk, arnd@arndb.de,
        patches@linaro.org, rob@ti.com, Sumit Semwal <sumit.semwal@linaro.org>,
        m.szyprowski@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On Tue, Dec 20, 2011 at 10:06 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Mon, Dec 19, 2011 at 02:03:30PM +0530, Sumit Semwal wrote:
>> This is the first step in defining a dma buffer sharing mechanism.
>>
>> A new buffer object dma_buf is added, with operations and API to allow easy
>> sharing of this buffer object across devices.
>>
>> The framework allows:
>> - different devices to 'attach' themselves to this buffer, to facilitate
>>   backing storage negotiation, using dma_buf_attach() API.
>
> Any thoughts of adding facility to track them? So you can see who is using what?
Not for version 1, but it would be a useful addition once we start
using this mechanism.

>
>> - association of a file pointer with each user-buffer and associated
>>    allocator-defined operations on that buffer. This operation is called the
>>    'export' operation.
>
>  'create'? or 'alloc' ?
>
> export implies an import somwhere and I don't think that is the case here.
I will rephrase it as suggested by Rob as well.

>
>> - this exported buffer-object to be shared with the other entity by asking for
>>    its 'file-descriptor (fd)', and sharing the fd across.
>> - a received fd to get the buffer object back, where it can be accessed using
>>    the associated exporter-defined operations.
>> - the exporter and user to share the scatterlist using map_dma_buf and
>>    unmap_dma_buf operations.
>>
>> Atleast one 'attach()' call is required to be made prior to calling the
>> map_dma_buf() operation.
>
> for the whole memory region or just for the device itself?
Rob has very eloquently and kindly explained it in his reply.

>
>>
<snip>
>> +/*
>> + * is_dma_buf_file - Check if struct file* is associated with dma_buf
>> + */
>> +static inline int is_dma_buf_file(struct file *file)
>> +{
>> +     return file->f_op == &dma_buf_fops;
>> +}
>> +
>> +/**
>
> Wrong kerneldoc.
I looked into scripts/kernel-doc, and
Documentation/kernel-doc-na-HOWTO.txt => both these places mention
that the kernel-doc comments have to start with /**, and I couldn't
spot an error in what's wrong with my usage - would you please
elaborate on what you think is not right?
>
<snip>
>> +/**
>> + * struct dma_buf_attachment - holds device-buffer attachment data
>
> OK, but what is the purpose of it?
I will add that in the comments.
>
>> + * @dmabuf: buffer for this attachment.
>> + * @dev: device attached to the buffer.
>                                ^^^ this
>> + * @node: list_head to allow manipulation of list of dma_buf_attachment.
>
> Just say: "list of dma_buf_attachment"'
ok.
>
>> + * @priv: exporter-specific attachment data.
>
> That "exporter-specific.." brings to my mind custom decleration forms. But maybe that is me.
:) well, in context of dma-buf 'exporter', it makes sense.

>
>> + */
>> +struct dma_buf_attachment {
>> +     struct dma_buf *dmabuf;
>> +     struct device *dev;
>> +     struct list_head node;
>> +     void *priv;
>> +};
>
> Why don't you move the decleration of this below 'struct dma_buf'?
> It would easier than to read this structure..
I could do that, but then anyways I will have to do a
forward-declaration of dma_buf_attachment, since I have to use it in
dma_buf_ops. If it improves readability, I am happy to move it below
struct dma_buf.

>
>> +
>> +/**
>> + * struct dma_buf_ops - operations possible on struct dma_buf
>> + * @attach: allows different devices to 'attach' themselves to the given
>
> register?
>> + *       buffer. It might return -EBUSY to signal that backing storage
>> + *       is already allocated and incompatible with the requirements
>
> Wait.. allocated or attached?
This and above comment on 'register' are already answered by Rob in
his explanation of the sequence in earlier reply. [the Documentation
patch [2/2] also tries to explain it]

>
>> + *       of requesting device. [optional]
>
> What is optional? The return value? Or the 'attach' call? If the later , say
> that in the first paragraph.
>
ok, sure. it is meant for the attach op.
>
>> + * @detach: detach a given device from this buffer. [optional]
>> + * @map_dma_buf: returns list of scatter pages allocated, increases usecount
>> + *            of the buffer. Requires atleast one attach to be called
>> + *            before. Returned sg list should already be mapped into
>> + *            _device_ address space. This call may sleep. May also return
>
> Ok, there is some __might_sleep macro you should put on the function.
>
That's a nice suggestion; I will add it to the wrapper function for
map_dma_buf().

>> + *            -EINTR.
>
> Ok. What is the return code if attach has _not_ been called?
Will document it to return -EINVAL if atleast on attach() hasn't been called.

>
>> + * @unmap_dma_buf: decreases usecount of buffer, might deallocate scatter
>> + *              pages.
>> + * @release: release this buffer; to be called after the last dma_buf_put.
>> + * @sync_sg_for_cpu: sync the sg list for cpu.
>> + * @sync_sg_for_device: synch the sg list for device.
>
> Not seeing those two.
Oops; removed in v3 - will correct.

>> + */
<snip>
>> +     /* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
>
> Ewww. Why? Why not just just the 'map_dma_buf' and return that?
Requirement is to allow for blocking and non-blocking versions of
map_dma_buf. try_map_dma_buf could be used for the non-blocking
version.

>
<snip>
>> +/**
>> + * struct dma_buf - shared buffer object
>
> Missing the 'size'.
Will add.
>
>> + * @file: file pointer used for sharing buffers across, and for refcounting.
>> + * @attachments: list of dma_buf_attachment that denotes all devices attached.
>> + * @ops: dma_buf_ops associated with this buffer object
>> + * @priv: user specific private data
>
>
> Can you elaborate on this? Is this the "exporter" using this? Or is
> it for the "user" using it? If so, why provide it? Wouldn't the
> user of this have something like this:
>
> struct my_dma_bufs {
>        struct dma_buf[20];
>        void *priv;
> }
>
> Anyhow?
My bad - it is meant for the exporter - exporter gives this as one of
the parameters to 'dma_buf_export()' API. I will correct the comment.
>
Thanks for your review!
Best regards,
~Sumit.
