Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1A3Jzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:55:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:32065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1A3Jzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:55:39 -0500
Message-Id: <849307$bc24ct@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,400,1291622400"; 
   d="scan'208";a="381751709"
Date: Sun, 30 Jan 2011 09:55:34 +0000
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
References: <20110123011221.GB1805@nowhere> <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk> <20110123175945.GA1760@nowhere> <alpine.LSU.2.00.1101232246380.3691@sister.anvils> <849307$b9dvii@azsmga001.ch.intel.com> <alpine.LSU.2.00.1101281347200.1759@sister.anvils> <EB643972-4918-4B89-B325-59D03648F2F9@tuebingen.mpg.de> <AANLkTikLTuxYsHUHO3hdSrc_9rSBgmiyePHs6D=7VzjK@mail.gmail.com> <93AF69C5-2308-41F2-80C1-3467B190CA0C@tuebingen.mpg.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <93AF69C5-2308-41F2-80C1-3467B190CA0C@tuebingen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jan 30, 2011, at 1:28 AM, Hugh Dickins wrote:
> > I just tried setting the debug to 7 for a few seconds on 2.6.37, where
> > I see no problem: I appear to get the "pipe a underrun" messages with
> > that too; and the drm_ioctl messages, but much much fewer of them.
> > Though I've been veering between i386 and x86_64 in these tests, so
> > keep that in mind if what I'm saying makes no sense: the huge number
> > of drm_ioctls was with 2.6.36-rc2 (plus some of Chris's fixes) on
> > i386; the 64 underruns per second was with 2.6.36-rc2 (plus some of

There shouldn't be any difference between the drm_ioctl() calls between
2.6.37 and 2.6.38 as the userspace is the same. I think this might the
crux of the issue. Can you attach a drm.debug=0xe boot dmesg, and a sample
of drm.debug=0x7 during the busy period for .37 and .38? And also your
Xorg.0.log.

Running fvwm and a couple of xterms you should not be utilizing vblanks at
all (not even suffering the vblank interrupt being enabled) so this code
should not even be causing unwanted side-effects. Bizarre.

The delay in characters showing up is a bug in the ddx; the render queue
is not being flushed before X goes to sleep. It's either the batch not
being submitted or the render cache not being flushed to the scan out in a
timely manner. (And these bugs can be complicated further by the
introduction of a compositing WM.) Both bugs have existed off-and-on in
the ddx over the years. And over time, we have weaned the kernel from
flushing the graphics caches unnecessarily; though the larger impact would
have been during the .37 cycle, at least the ones that sprang to mind as
likely candidates.

The pipe-a underrun is a nuisance; at best nothing will happen, there's an
outside chance that your display may flicker and at worst your machine may
hard hang.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
