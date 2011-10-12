Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1JLNu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:50:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60319 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1JLNuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twft0eBEUoCD11a2gTZHwOaPzFmZvBfE032dfK10eQ27Q@mail.gmail.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
	<CAF6AEGs6kkGp85NoNVuq5W9i=WE86V8wvAtKydX=D3bQOc+6Pw@mail.gmail.com>
	<CAPM=9twft0eBEUoCD11a2gTZHwOaPzFmZvBfE032dfK10eQ27Q@mail.gmail.com>
Date: Wed, 12 Oct 2011 08:50:53 -0500
Message-ID: <CAF6AEGuwMt6Snq=YSN4iddTv_Cu56aR_2BY1d3hjVvTdkom5MQ@mail.gmail.com>
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

On Wed, Oct 12, 2011 at 8:35 AM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> well, the mmap is actually implemented by the buffer allocator
>> (v4l/drm).. although not sure if this was the point
>
> Then why not use the correct interface? doing some sort of not-quite
> generic interface isn't really helping anyone except adding an ABI
> that we have to support.

But what if you don't know who allocated the buffer?  How do you know
what interface to use to mmap?

> If someone wants to bypass the current kernel APIs we should add a new
> API for them not shove it into this generic buffer sharing layer.
>
>> The intent was that this is for well defined formats.. ie. it would
>> need to be a format that both v4l and drm understood in the first
>> place for sharing to make sense at all..
>
> How will you know the stride to take a simple example? The userspace
> had to create this buffer somehow and wants to share it with
> "something", you sound like
> you really needs another API that is a simple accessor API that can
> handle mmaps.

Well, things like stride, width, height, color format, userspace needs
to know all this already, even for malloc()'d sw buffers.  The
assumption is userspace already has a way to pass this information
around so it was not required to be duplicated by dmabuf.

>> Anyways, the basic reason is to handle random edge cases where you
>> need sw access to the buffer.  For example, you are decoding video and
>> pull out a frame to generate a thumbnail w/ a sw jpeg encoder..
>
> Again, doesn't sound like it should be part of this API, and also
> sounds like the sw jpeg encoder will need more info about the buffer
> anyways like stride and format.
>
>> With this current scheme, synchronization could be handled in
>> dmabufops->mmap() and vm_ops->close()..  it is perhaps a bit heavy to
>> require mmap/munmap for each sw access, but I suppose this isn't
>> really for the high-performance use case.  It is just so that some
>> random bit of sw that gets passed a dmabuf handle without knowing who
>> allocated it can have sw access if really needed.
>
> So I think thats fine, write a sw accessor providers, don't go
> overloading the buffer sharing code.

But then we'd need a different set of accessors for every different
drm/v4l/etc driver, wouldn't we?

> This API will limit what people can use this buffer sharing for with
> pure hw accessors, you might say, oh buts its okay to fail the mmap
> then, but the chances of sw handling that I'm not so sure off.

I'm not entirely sure the case you are worried about.. sharing buffers
between multiple GPU's that understand same tiled formats?  I guess
that is a bit different from a case like a jpeg encoder that is passed
a dmabuf handle without any idea where it came from..

I guess if sharing a buffer between multiple drm devices, there is
nothing stopping you from having some NOT_DMABUF_MMAPABLE flag you
pass when the buffer is allocated, then you don't have to support
dmabuf->mmap(), and instead mmap via device and use some sort of
DRM_CPU_PREP/FINI ioctls for synchronization..

BR,
-R

> Dave.
>
