Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab2CUX3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 19:29:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39935 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab2CUX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 19:29:04 -0400
Date: Thu, 22 Mar 2012 00:29:45 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rebecca Schultz Zavin <rebecca@android.com>
Cc: Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Linaro-mm-sig] [PATCH] [RFC] dma-buf: mmap support
Message-ID: <20120321232945.GC20712@phenom.ffwll.local>
Mail-Followup-To: Rebecca Schultz Zavin <rebecca@android.com>,
	Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
References: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
 <CAF6AEGsBZ5BBBBGKZ5VSJOr70=9Qpp1pq+2m4d_vgsveW+3Atw@mail.gmail.com>
 <CALJcvx5+g2+tZPp-2PJg04AOzYuv0eZyih542M+ghjQLFeBmFg@mail.gmail.com>
 <20120321222528.GA20712@phenom.ffwll.local>
 <CALJcvx422uZ4Wb346=bvDvp1iLGOdSwJ6qKc5nLwRO4NQbQK1Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALJcvx422uZ4Wb346=bvDvp1iLGOdSwJ6qKc5nLwRO4NQbQK1Q@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 03:44:38PM -0700, Rebecca Schultz Zavin wrote:
> Couldn't this just as easily be handled by not having those mappings
> be mapped cached or write combine to userspace?  They'd be coherent,
> just slow.  I'm not sure we can actually say that all these cpu access
> are necessary slow path operations anyway.  On android we do sometimes
> decide to software render things to eliminate the overhead of
> maintaining a hardware context for context switching the gpu.   If you
> want cached or writecombine mappings you'd have to manage them
> explicitly.  If you can't manage them explicitly you have to settle
> for slow.  That seems reasonable to me.

Well the usual approach is writecombine, which doesn't need any explicit
cache management. 

> As far as I can tell with explicit operations I have to invalidate
> before touching from mmap and clean after.  With these implicit ones,
> I stil have to invalidate and clean, but now I also have to remap them
> before and after.  I don't know what the performance hit of this
> remapping step is, but I'd like to if you have any insight.

We have a few inefficiencies in the drm/i915 fault path which makes it
slow, but generally pagefault performance should be rather quick (at least
quicker than flushing the actual data). At least if your fault handler is
somewhat clever and prefaults a few more pages in both x and y direction.

But if that's too slow, I'm open to extending dma-buf later on to support
more explicit cache management for userspace mmaps (like I've explained
below in my previous mail). I just think we should have real benchmark
results (and hence some real users of dma-buf) before we add this
complexity. Atm I have no idea whether it's worth it. After all, as soon
as we expect a lot of rendering/processing, some special dsp/gpu/whatever
is likely to take over.

> > Imo the best way to enable cached mappings is to later on extend dma-buf
> > (as soon as we have some actual exporters/importers in the mainline
> > kernel) with an optional cached_mmap interface which requires explict
> > prepare_mmap_access/finish_mmap_acces calls. Then if both exporter and
> > importer support this, it could get used - otherwise the dma-buf layer
> > could transparently fall back to coherent mappings.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
