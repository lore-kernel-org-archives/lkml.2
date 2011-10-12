Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1JLN2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:28:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1JLN2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
Date: Wed, 12 Oct 2011 08:28:44 -0500
Message-ID: <CAF6AEGs6kkGp85NoNVuq5W9i=WE86V8wvAtKydX=D3bQOc+6Pw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Rob Clark <robdclark@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 7:41 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Oct 11, 2011 at 10:23 AM, Sumit Semwal <sumit.semwal@ti.com> wrote:
>> This is the first step in defining a dma buffer sharing mechanism.
>>
>> A new buffer object dma_buf is added, with operations and API to allow easy
>> sharing of this buffer object across devices.
>>
>> The framework allows:
>> - a new buffer-object to be created with fixed size.
>> - different devices to 'attach' themselves to this buffer, to facilitate
>>  backing storage negotiation, using dma_buf_attach() API.
>> - association of a file pointer with each user-buffer and associated
>>   allocator-defined operations on that buffer. This operation is called the
>>   'export' operation.
>> - this exported buffer-object to be shared with the other entity by asking for
>>   its 'file-descriptor (fd)', and sharing the fd across.
>> - a received fd to get the buffer object back, where it can be accessed using
>>   the associated exporter-defined operations.
>> - the exporter and user to share the scatterlist using get_scatterlist and
>>   put_scatterlist operations.
>>
>> Atleast one 'attach()' call is required to be made prior to calling the
>> get_scatterlist() operation.
>>
>> Couple of building blocks in get_scatterlist() are added to ease introduction
>> of sync'ing across exporter and users, and late allocation by the exporter.
>>
>> mmap() file operation is provided for the associated 'fd', as wrapper over the
>> optional allocator defined mmap(), to be used by devices that might need one.
>
> Why is this needed? it really doesn't make sense to be mmaping objects
> independent of some front-end like drm or v4l.

well, the mmap is actually implemented by the buffer allocator
(v4l/drm).. although not sure if this was the point

> how will you know what contents are in them, how will you synchronise
> access. Unless someone has a hard use-case for this I'd say we drop it
> until someone does.

The intent was that this is for well defined formats.. ie. it would
need to be a format that both v4l and drm understood in the first
place for sharing to make sense at all..

Anyways, the basic reason is to handle random edge cases where you
need sw access to the buffer.  For example, you are decoding video and
pull out a frame to generate a thumbnail w/ a sw jpeg encoder..

On gstreamer 0.11 branch, for example, there is already a map/unmap
virtual method on the gst buffer for sw access (ie. same purpose as
PrepareAccess/FinishAccess in EXA).  The idea w/ dmabuf mmap() support
is that we could implement support to mmap()/munmap() before/after sw
access.

With this current scheme, synchronization could be handled in
dmabufops->mmap() and vm_ops->close()..  it is perhaps a bit heavy to
require mmap/munmap for each sw access, but I suppose this isn't
really for the high-performance use case.  It is just so that some
random bit of sw that gets passed a dmabuf handle without knowing who
allocated it can have sw access if really needed.

BR,
-R

> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
