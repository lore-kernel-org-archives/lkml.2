Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1ATGbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:31:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab1ATGba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
References: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com> <AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Jan 2011 22:22:48 -0800
Message-ID: <AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com>
Subject: Re: more intel drm issues (was Re: [git pull] drm intel only fixes)
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 8:55 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> Rafael send out two patches earlier. Could be related. I was facing
> issue during resume.

No, I'm aware of the rcu-synchronize thing, this isn't it. This is
really at the suspend stage, and I had bisected it down to the drm
changes.

In fact, by now I have bisected it down to a single commit. It's
another merge commit, which makes me a bit nervous (I bisected another
issue today, and it turned out to simply not be repeatable).

But this time the merge commit actually has a real conflict that got
fixed up in the merge, and the code around the conflict waits for
three seconds, and three seconds is also exactly how long the delay at
suspend time is. So I get the feeling that this time it's a real
issue, and what happened was that the merge may have been a mismerge.

Chris: as of commit 8d5203ca6253 ("Merge branch 'drm-intel-fixes' into
drm-intel-next") I'm getting that 3-second delay at suspend time. And
the merge diff looks like this:

 +	struct drm_device *dev = ring->dev;
 +	struct drm_i915_private *dev_priv = dev->dev_private;
  	unsigned long end;
 -	drm_i915_private_t *dev_priv = dev->dev_private;
  	u32 head;

- 	head = intel_read_status_page(ring, 4);
- 	if (head) {
- 		ring->head = head & HEAD_ADDR;
- 		ring->space = ring->head - (ring->tail + 8);
- 		if (ring->space < 0)
- 			ring->space += ring->size;
- 		if (ring->space >= n)
- 			return 0;
- 	}
-
  	trace_i915_ring_wait_begin (dev);
  	end = jiffies + 3 * HZ;
  	do {

and that whole do-loop with a 3-second timeout makes me *very*
suspicious. It used to have (in _one_ of the parent branches) that
code before it to return early if there was space in the ring, now it
doesn't any more - and that merge co-incides with my suspend suddenly
taking 3 seconds.

The same check that is deleted does exist inside the loop too, but
there it has some extra code it in (compare to "actual_head" and so
on), so I wonder if the fast-case was somehow hiding this issue.

But I don't know the code. I just see that whole "PM: suspend of
devices complete after x.xxx msecs" issue, and I can see the machine
taking too long to suspend.

                     Linus
