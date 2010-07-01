Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0GBAII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:08:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab0GBAIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:08:06 -0400
MIME-Version: 1.0
In-Reply-To: <4C2D180C.5050805@superonline.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
	<4C2D180C.5050805@superonline.com>
Date: Thu, 1 Jul 2010 16:59:50 -0700
Message-ID: <AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@gmail.com>,
       earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
       intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 3:34 PM, M. Vefa Bicakci <bicave@superonline.com> wrote:
>
> Based on my testing, I am happy to report that the change you suggest
> fixes the "memory corruption (segfaults) after thaw" issue for me.
> I can't thank you enough times for this.

Hey, goodie. And you're the one to be thanked - bisecting it down to
that commit that wasn't _meant_ to have any real semantic changes
(except for the bug-fix of racy mapping gfp-flags update) is what
really cracked the lid on the problem.

> Now, the obligatory question: Could we have this fix applied to 2.6.32,
> 2.6.33 and 2.6.34 ?

No problem, except we should first determine exactly what flags are
the appropriate ones. My original patch was obviously not even
compile-tested, and I actually meant for people to use GFP_HIGHUSER
rather than __GFP_HIGHMEM. That contains all the "regular" allocation
flags (but not the __GFP_MOVABLE, which is still just a suspicion of
being the core reason for the problem).

And the original DRM code had:

   GFP_HIGHUSER |
   __GFP_COLD |
   __GFP_FS |
   __GFP_RECLAIMABLE |
   __GFP_NORETRY |
   __GFP_NOWARN |
   __GFP_NOMEMALLOC

which is not entirely sensible (__GFP_FS is already part of
GFP_HIGHUSER, for example), and two of the flags (NORETRY and NOWARN)
are the ones the driver wants to do conditionally.

But that still leaves the question about __GFP_COLD (probably sane),
__GFP_RECLAIMABLE (I wonder about that one) and __GFP_NOMEMALLOC
(usually used together with NORETRY, and I'm not at all sure it makes
sense as a base flag).

So I suspect the final patch should not look like the one you tested,
but instead likely have

   GFP_HIGHUSER | __GFP_COLD

and possibly the __GFP_RECLAIMABLE flag too instead of just the bare
__GFP_HIGHMEM..

(Well, we already had that __GFP_COLD there from before, so it's
really about replacing __GFP_HIGHMEM with something like "GFP_HIGHUSER
| __GFP_RECLAIMABLE").

But its' great to hear that this does seem to be the underlying cause.
If you could test with that GFP_HIGHUSER | __GFP_RECLAIMABLE, that
would be a good thing. After all - maybe the problem was triggered by
some other flag than __GFP_MOVABLE, and as such, having some
additional testing with a bigger set of allocation flags would be a
really good thing.

                    Linus
