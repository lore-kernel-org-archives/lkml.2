Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2DROY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:24:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49144 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2DROYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:24:54 -0400
Date: Wed, 18 Apr 2012 16:24:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, Rob Clark <rob.clark@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH] dma-buf: mmap support
Message-ID: <20120418142438.GA20469@phenom.ffwll.local>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, Rob Clark <rob.clark@linaro.org>,
	Rebecca Schultz Zavin <rebecca@android.com>
References: <1334757146-28335-1-git-send-email-daniel.vetter@ffwll.ch>
 <201204181406.14159.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204181406.14159.arnd@arndb.de>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 02:06:13PM +0000, Arnd Bergmann wrote:
> On Wednesday 18 April 2012, Daniel Vetter wrote:
> > +   Because existing importing subsystems might presume coherent mappings for
> > +   userspace, the exporter needs to set up a coherent mapping. If that's not
> > +   possible, it needs to fake coherency by manually shooting down ptes when
> > +   leaving the cpu domain and flushing caches at fault time. Note that all the
> > +   dma_buf files share the same anon inode, hence the exporter needs to replace
> > +   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
> > +   requred. This is because the kernel uses the underlying inode's address_space
> > +   for vma tracking (and hence pte tracking at shootdown time with
> > +   unmap_mapping_range).
> > +
> > +   If the above shootdown dance turns out to be too expensive in certain
> > +   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
> > +   for userspace mappings. But the current assumption is that using mmap is
> > +   always a slower path, so some inefficiencies should be acceptable.
> > +
> > +   Exporters that shoot down mappings (for any reasons) shall not do any
> > +   synchronization at fault time with outstanding device operations.
> > +   Synchronization is an orthogonal issue to sharing the backing storage of a
> > +   buffer and hence should not be handled by dma-buf itself. This is explictly
> > +   mentioned here because many people seem to want something like this, but if
> > +   different exporters handle this differently, buffer sharing can fail in
> > +   interesting ways depending upong the exporter (if userspace starts depending
> > +   upon this implicit synchronization).
> 
> How do you ensure that no device can do DMA on the buffer while it's mapped
> into user space in a noncoherent manner?

We don't. Letting userspace shoot into it's foot is part of the interface.
drm drivers and afaik also v4l has some explicit interfaces where
userspace and the kernel can communicate who is allowed to stomp on a
buffer (and sync up access with various degrees of sophistication).
Userspace still needs to use this interfaces to ensure that any dma
activity it wants to have completed is completed.

To ensure coherency for userspace that does not try to get unnecessary
holes in its feet, the exporter needs to zap all ptes pointing to a dma
buf object and flush relevant parts of the cpu cache before device dma
starts (signalled with dma_buf_map_sg from the importer atm, but we'll
eventually grow streaming support I guess). On page fault time it has then
to invalidate any cpu caches, so that userspace does not read stale data.

Like I've said in the above blurb in the documentation, I think
synchronization is an orthogonal issue to sharing memory.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
