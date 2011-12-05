Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1LEWK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:10:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab1LEWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:10:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Clark <rob@ti.com>, t.stanislaws@samsung.com, linux@arm.linux.org.uk,
        Sumit Semwal <sumit.semwal@ti.com>, jesse.barker@linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, daniel@ffwll.ch,
        m.szyprowski@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Mon, 05 Dec 2011 23:09:56 +0100
Message-ID: <1781399.9f45Chd7K4@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CAF6AEGvyWV0DM2fjBbh-TNHiMmiLF4EQDJ6Uu0=NkopM6SXS6g@mail.gmail.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112051718.48324.arnd@arndb.de> <CAF6AEGvyWV0DM2fjBbh-TNHiMmiLF4EQDJ6Uu0=NkopM6SXS6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wfV/0zBNmKkFAro3R74H6QGLxpBWVp+DTQR/ghp7J62
 01k0qmzLym/vdZQwPKV07XZy6ITNGYStCQVL1hnafyp0cwzTkw
 K9EehRWcIo5aU7fDBX7oqWj/+Ux2GfpMwa18YnhoRKRcOnfjVa
 LNRCnygSAdpUPyv6fmrnPAhdA7JXsyvyQpNOtZML53N/e34nbn
 73EdzbanxvtfDa4N6PLvq8sW7l7/4XxOaqhVD7DKBHHSmQQAa5
 8Lpv5zXJjFe1fXbZDXiGW6VwaDhPg5D3StSCGa1OSZQLO247+t
 zvwo42arVLYyoQyGlLyfauv+el1Ft6nsc64gEUkG+zQC17ZylB
 DQR70DYNXWtbgo0QVs64=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 December 2011 14:46:47 Rob Clark wrote:
> On Mon, Dec 5, 2011 at 11:18 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 02 December 2011, Sumit Semwal wrote:
> >> This is the first step in defining a dma buffer sharing mechanism.
> >
> > This looks very nice, but there are a few things I don't understand yet
> > and a bunch of trivial comments I have about things I spotted.
> >
> > Do you have prototype exporter and consumer drivers that you can post
> > for clarification?
> 
> There is some dummy drivers based on an earlier version.  And airlied
> has a prime (multi-gpu) prototype:
> 
> http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-prime-dmabuf
> 
> I've got a nearly working camera+display prototype:
> 
> https://github.com/robclark/kernel-omap4/commits/dmabuf

Ok, thanks. I think it would be good to post these for reference
in v3, with a clear indication that they are not being submitted
for discussion/inclusion yet.

> > In the patch 2, you have a section about migration that mentions that
> > it is possible to export a buffer that can be migrated after it
> > is already mapped into one user driver. How does that work when
> > the physical addresses are mapped into a consumer device already?
> 
> I think you can do physical migration if you are attached, but
> probably not if you are mapped.

Ok, that's what I thought.

> > You probably mean "if (ret)" here instead of "if (!ret)", right?
> >
> >> +     /* allow allocator to take care of cache ops */
> >> +     void (*sync_sg_for_cpu) (struct dma_buf *, struct device *);
> >> +     void (*sync_sg_for_device)(struct dma_buf *, struct device *);
> >
> > I don't see how this works with multiple consumers: For the streaming
> > DMA mapping, there must be exactly one owner, either the device or
> > the CPU. Obviously, this rule needs to be extended when you get to
> > multiple devices and multiple device drivers, plus possibly user
> > mappings. Simply assigning the buffer to "the device" from one
> > driver does not block other drivers from touching the buffer, and
> > assigning it to "the cpu" does not stop other hardware that the
> > code calling sync_sg_for_cpu is not aware of.
> >
> > The only way to solve this that I can think of right now is to
> > mandate that the mappings are all coherent (i.e. noncachable
> > on noncoherent architectures like ARM). If you do that, you no
> > longer need the sync_sg_for_* calls.
> 
> My original thinking was that you either need DMABUF_CPU_{PREP,FINI}
> ioctls and corresponding dmabuf ops, which userspace is required to
> call before / after CPU access.  Or just remove mmap() and do the
> mmap() via allocating device and use that device's equivalent
> DRM_XYZ_GEM_CPU_{PREP,FINI} or DRM_XYZ_GEM_SET_DOMAIN ioctls.  That
> would give you a way to (a) synchronize with gpu/asynchronous
> pipeline, (b) synchronize w/ multiple hw devices vs cpu accessing
> buffer (ie. wait all devices have dma_buf_unmap_attachment'd).  And
> that gives you a convenient place to do cache operations on
> noncoherent architecture.

I wasn't even thinking of user mappings, as I replied to Daniel, I
think they are easy to solve (maybe not efficiently though)

> I sort of preferred having the DMABUF shim because that lets you pass
> a buffer around userspace without the receiving code knowing about a
> device specific API.  But the problem I eventually came around to: if
> your GL stack (or some other userspace component) is batching up
> commands before submission to kernel, the buffers you need to wait for
> completion might not even be submitted yet.  So from kernel
> perspective they are "ready" for cpu access.  Even though in fact they
> are not in a consistent state from rendering perspective.  I don't
> really know a sane way to deal with that.  Maybe the approach instead
> should be a userspace level API (in libkms/libdrm?) to provide
> abstraction for userspace access to buffers rather than dealing with
> this at the kernel level.

It would be nice if user space had no way to block out kernel drivers,
otherwise we have to be very careful to ensure that each map() operation
can be interrupted by a signal as the last resort to avoid deadlocks.

	Arnd
