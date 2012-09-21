Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2IURYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:24:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab2IURX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:23:59 -0400
Date: Fri, 21 Sep 2012 10:23:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 12/13] execute the whole memcg freeing in rcu
 callback
Message-ID: <20120921172355.GD7264@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-13-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977050-29476-13-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Tue, Sep 18, 2012 at 06:04:09PM +0400, Glauber Costa wrote:
> A lot of the initialization we do in mem_cgroup_create() is done with softirqs
> enabled. This include grabbing a css id, which holds &ss->id_lock->rlock, and
> the per-zone trees, which holds rtpz->lock->rlock. All of those signal to the
> lockdep mechanism that those locks can be used in SOFTIRQ-ON-W context. This
> means that the freeing of memcg structure must happen in a compatible context,
> otherwise we'll get a deadlock.

Lockdep requires lock to be softirq or irq safe iff the lock is
actually acquired from the said context.  Merely using a lock with bh
/ irq disabled doesn't signal that to lockdep; otherwise, we'll end up
with enormous number of spurious warnings.

> The reference counting mechanism we use allows the memcg structure to be freed
> later and outlive the actual memcg destruction from the filesystem. However, we
> have little, if any, means to guarantee in which context the last memcg_put
> will happen. The best we can do is test it and try to make sure no invalid
> context releases are happening. But as we add more code to memcg, the possible
> interactions grow in number and expose more ways to get context conflicts.
> 
> We already moved a part of the freeing to a worker thread to be context-safe
> for the static branches disabling. I see no reason not to do it for the whole
> freeing action. I consider this to be the safe choice.

And the above description too makes me scratch my head quite a bit.  I
can see what the patch is doing but can't understand the why.

* Why was it punting the freeing to workqueue anyway?  ISTR something
  about static_keys but my memory fails.  What changed?  Why don't we
  need it anymore?

* As for locking context, the above description seems a bit misleading
  to me.  Synchronization constructs involved there currently doesn't
  require softirq or irq safe context.  If that needs to change,
  that's fine but that's a completely different reason than given
  above.

Thanks.

-- 
tejun
