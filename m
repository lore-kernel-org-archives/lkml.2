Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab0F3XHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:07:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561Ab0F3XHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <89khjo$fr177d@orsmga002.jf.intel.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
Date: Wed, 30 Jun 2010 16:07:01 -0700
Message-ID: <AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 12:05 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Reviewing the patch again, we no longer set the default gfpmask on the
> inode to contain NORETRY and instead add the NORETRY at the one spot in
> the code where we are trying to do a large allocation and our shrinker
> would be prevented from running (due to contention on struct_mutex).
>
> I do not know how this causes memory corruption across hibernate and would
> appreciate any insights.

Hmm. More likely is the __GFP_MOVABLE flag, I think.

That commit changes the page cache allocation to use

+                                          mapping_gfp_mask (mapping) |
+                                          __GFP_COLD |
+                                          gfpmask);

if I read it right. And the default mapping_gfp_mask() is
GFP_HIGHUSER_MOVABLE, so I think you get all of
(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | __GFP_HIGHMEM)
set by default.

The old code didn't just play games with ~__GFP_NORETRY and change
that at runtime (which was buggy - no locking, no protection, no
nothing), it also initialized the gfp mask. And that code also got
removed:

-       /* Basically we want to disable the OOM killer and handle ENOMEM
-        * ourselves by sacrificing pages from cached buffers.
-        * XXX shmem_file_[gs]et_gfp_mask()
-        */
-       mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
-                            GFP_HIGHUSER |
-                            __GFP_COLD |
-                            __GFP_FS |
-                            __GFP_RECLAIMABLE |
-                            __GFP_NORETRY |
-                            __GFP_NOWARN |
-                            __GFP_NOMEMALLOC);

(and note how it doesn't have __GFP_MOVABLE set).

So I wonder if we shouldn't re-instate that mapping_set_gfp_mask() for
the _initial_ setting when the file descriptor is created. That part
wasn't the bug - the bug was the code that used to try to do that
whole per-allocation dance with the bits incorrectly (ie this part of
the change:

-               gfp = i915_gem_object_get_page_gfp_mask(obj);
-               i915_gem_object_set_page_gfp_mask(obj, gfp & ~__GFP_NORETRY);
-               ret = i915_gem_object_get_pages(obj);
-               i915_gem_object_set_page_gfp_mask (obj, gfp);

in that patch).

I could easily see that something would get very unhappy and corrupt
memory if the suspend-to-disk phase ends up compacting memory and
moving the pages around from under the i915 driver.

I dunno. But that seems more likely than the __GFP_NORETRY flag, which
should have no semantic meaning (except making it more likely for
allocations to fail, of course, but that's what the i915 code
_wanted_).

                      Linus
