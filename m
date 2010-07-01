Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0GALT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:19:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:55254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab0GALT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:19:28 -0400
Message-Id: <89k77n$o7p5no@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,519,1272870000"; 
   d="scan'208";a="813471480"
Date: Thu, 01 Jul 2010 12:19:21 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
Cc: Dave Airlie <airlied@gmail.com>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org,
       Vefa Bicakci <bicave@superonline.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain> <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LFD.2.00.1001270738220.24253@localhost.localdomain> <89k77n$ms73l9@fmsmga001.fm.intel.com> <alpine.LFD.2.00.1001270917120.24253@localhost.localdomain> <AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com> <89khjo$fr177d@orsmga002.jf.intel.com> <AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com> <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 18:24:04 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jun 30, 2010 at 4:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That commit changes the page cache allocation to use
> >
> > +                                          mapping_gfp_mask (mapping) |
> > +                                          __GFP_COLD |
> > +                                          gfpmask);
> >
> > if I read it right. And the default mapping_gfp_mask() is
> > GFP_HIGHUSER_MOVABLE, so I think you get all of
> > (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | __GFP_HIGHMEM)
> > set by default.
> 
> .. and then I left out the one flag I _meant_ to have there, namely
> __GFP_MOVABLE.
> 
> > The old code didn't just play games with ~__GFP_NORETRY and change
> > that at runtime (which was buggy - no locking, no protection, no
> > nothing), it also initialized the gfp mask. And that code also got
> > removed:

That code I added with the original shrinker patch, and the flags lifted
from the shmem defaults, tweaked to what seemed sane with the addition of
NORETRY and friends. I see that i915 is unique in using shmem as the page
allocator, which perhaps explains why this failure is not observed with
the ttm drivers. ttm uses two sets of gfp mask: HIGHUSER and USER | DMA32.
So replacing the mapping_gfp_mask() with HIGHUSER would seem appropriate.
And the interaction of MOVABLE could explain why hibernate broke with the
introduction of GEM.

* turns to his trusty copy of LDD to explain the various meanings of
gfp_t...
-- 
Chris Wilson, Intel Open Source Technology Centre
