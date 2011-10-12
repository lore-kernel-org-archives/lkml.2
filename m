Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1JLNfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:35:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50260 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1JLNfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGs6kkGp85NoNVuq5W9i=WE86V8wvAtKydX=D3bQOc+6Pw@mail.gmail.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<CAPM=9tzHOa5Dbe=SQz+AURMMbio4L7qoS8kUT3Ek0+HdtkrH4g@mail.gmail.com>
	<CAF6AEGs6kkGp85NoNVuq5W9i=WE86V8wvAtKydX=D3bQOc+6Pw@mail.gmail.com>
Date: Wed, 12 Oct 2011 14:35:45 +0100
Message-ID: <CAPM=9twft0eBEUoCD11a2gTZHwOaPzFmZvBfE032dfK10eQ27Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Dave Airlie <airlied@gmail.com>
To: Rob Clark <robdclark@gmail.com>
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

>
> well, the mmap is actually implemented by the buffer allocator
> (v4l/drm).. although not sure if this was the point

Then why not use the correct interface? doing some sort of not-quite
generic interface isn't really helping anyone except adding an ABI
that we have to support.

If someone wants to bypass the current kernel APIs we should add a new
API for them not shove it into this generic buffer sharing layer.

> The intent was that this is for well defined formats.. ie. it would
> need to be a format that both v4l and drm understood in the first
> place for sharing to make sense at all..

How will you know the stride to take a simple example? The userspace
had to create this buffer somehow and wants to share it with
"something", you sound like
you really needs another API that is a simple accessor API that can
handle mmaps.

> Anyways, the basic reason is to handle random edge cases where you
> need sw access to the buffer.  For example, you are decoding video and
> pull out a frame to generate a thumbnail w/ a sw jpeg encoder..

Again, doesn't sound like it should be part of this API, and also
sounds like the sw jpeg encoder will need more info about the buffer
anyways like stride and format.

> With this current scheme, synchronization could be handled in
> dmabufops->mmap() and vm_ops->close()..  it is perhaps a bit heavy to
> require mmap/munmap for each sw access, but I suppose this isn't
> really for the high-performance use case.  It is just so that some
> random bit of sw that gets passed a dmabuf handle without knowing who
> allocated it can have sw access if really needed.

So I think thats fine, write a sw accessor providers, don't go
overloading the buffer sharing code.

This API will limit what people can use this buffer sharing for with
pure hw accessors, you might say, oh buts its okay to fail the mmap
then, but the chances of sw handling that I'm not so sure off.

Dave.
