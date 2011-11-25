Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1KYQBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 11:01:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60824 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1KYQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 11:01:53 -0500
Date: Fri, 25 Nov 2011 17:02:54 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, daniel@ffwll.ch
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing
 mechanism
Message-ID: <20111125160254.GA3980@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
 <1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
 <CAPM=9tzAgCSDgdvi=9QZa-gEVXwKp_gpCPTtQ10XS=Z9K4805w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9tzAgCSDgdvi=9QZa-gEVXwKp_gpCPTtQ10XS=Z9K4805w@mail.gmail.com>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 02:13:22PM +0000, Dave Airlie wrote:
> On Tue, Oct 11, 2011 at 10:23 AM, Sumit Semwal <sumit.semwal@ti.com> wrote:
> > This is the first step in defining a dma buffer sharing mechanism.
> >
> > A new buffer object dma_buf is added, with operations and API to allow easy
> > sharing of this buffer object across devices.
> >
> > The framework allows:
> > - a new buffer-object to be created with fixed size.
> > - different devices to 'attach' themselves to this buffer, to facilitate
> >  backing storage negotiation, using dma_buf_attach() API.
> > - association of a file pointer with each user-buffer and associated
> >   allocator-defined operations on that buffer. This operation is called the
> >   'export' operation.
> > - this exported buffer-object to be shared with the other entity by asking for
> >   its 'file-descriptor (fd)', and sharing the fd across.
> > - a received fd to get the buffer object back, where it can be accessed using
> >   the associated exporter-defined operations.
> > - the exporter and user to share the scatterlist using get_scatterlist and
> >   put_scatterlist operations.
> >
> > Atleast one 'attach()' call is required to be made prior to calling the
> > get_scatterlist() operation.
> >
> > Couple of building blocks in get_scatterlist() are added to ease introduction
> > of sync'ing across exporter and users, and late allocation by the exporter.
> >
> > mmap() file operation is provided for the associated 'fd', as wrapper over the
> > optional allocator defined mmap(), to be used by devices that might need one.
> >
> > More details are there in the documentation patch.
> >
> 
> Some questions, I've started playing around with using this framework
> to do buffer sharing between DRM devices,
> 
> Why struct scatterlist and not struct sg_table? it seems like I really
> want to use an sg_table,

No reason at all besides that intel-gtt is using scatterlist internally
(and only kludges the sg_table together in an ad-hoc fashion) and so I
haven't noticed. sg_table for more consistency with the dma api sounds
good.

> I'm not convinced fd's are really useful over just some idr allocated
> handle, so far I'm just returning the "fd" to userspace as a handle,
> and passing it back in the other side, so I'm not really sure what an
> fd wins us here, apart from the mmap thing which I think shouldn't be
> here anyways.
> (if fd's do win us more we should probably record that in the docs patch).

Imo fds are nice because their known and there's already all the
preexisting infrastructure for them around. And if we ever get fancy with
e.g. sync objects we can easily add poll support (or some insane ioctls).
But I agree that "we can mmap" is bust as a reason and should just die.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
