Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab2CUWYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:24:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35255 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab2CUWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:24:52 -0400
Date: Wed, 21 Mar 2012 23:25:28 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Rebecca Schultz Zavin <rebecca@android.com>
Cc: Rob Clark <rob.clark@linaro.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH] [RFC] dma-buf: mmap support
Message-ID: <20120321222528.GA20712@phenom.ffwll.local>
Mail-Followup-To: Rebecca Schultz Zavin <rebecca@android.com>,
	Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
References: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
 <CAF6AEGsBZ5BBBBGKZ5VSJOr70=9Qpp1pq+2m4d_vgsveW+3Atw@mail.gmail.com>
 <CALJcvx5+g2+tZPp-2PJg04AOzYuv0eZyih542M+ghjQLFeBmFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALJcvx5+g2+tZPp-2PJg04AOzYuv0eZyih542M+ghjQLFeBmFg@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:46:14AM -0700, Rebecca Schultz Zavin wrote:
> I want to make sure I understand how this would work.  I've been planning
> on making cache maintenance implicit, and most of the corresponding
> userspace components I've seen for android expect to do implicit cache
> maintenance on these buffers if they need cached mappings.  The android
> framework has a logical place for this maintenance to take place.  I assume
> that you'd detect a buffer leaving the cpu domain by using the
> dma_data_direction passed to dma_buf_map_attachment?  We're definitely
> pushing a bunch of complexity into the exporter, that at least on android
> could easily be covered by an explicit api.  I'm not dead set against it, I
> just want to make sure I get it right if we go down this road.

Hm, you're talking about implicit cache management, which I read as: The
kernel does some magic so that userspace doesn't have to care. But I guess
you mean what I'd call explicit cache management, where userspace tells
the kernel which ranges to invalidate/flush?

The idea is that the exporter would invalidate cpu caches at fault time.
And when a dma-device wants to read from it (using the direction argument
of dma_buf_map_attachement) it would shoot down the mappings, flush caches
and then allow the dma op to happen. Note that this is obvously only
required if the mapping is not coherent (uc/wc on arm).

I agree that for cached mappings this will suck, but to get dma-buf of the
ground I prefer a simpler interface at the beginning, which could get
extended later on. The issue is that I expect that a few importers simply
can't hanlde cache management with explicit flush/invalidate ioctl calls
from userspace and we hence need coherently-looking mappings anyway.

Imo the best way to enable cached mappings is to later on extend dma-buf
(as soon as we have some actual exporters/importers in the mainline
kernel) with an optional cached_mmap interface which requires explict
prepare_mmap_access/finish_mmap_acces calls. Then if both exporter and
importer support this, it could get used - otherwise the dma-buf layer
could transparently fall back to coherent mappings.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
