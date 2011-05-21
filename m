Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab1EUWX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 18:23:59 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58991 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1EUWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 18:23:57 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20110521210013.GJ2271@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 00:23:50 +0200
Message-ID: <1306016630.2066.44.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Sat, 2011-05-21 at 14:00 -0700, Paul E. McKenney wrote:
> On Thu, May 19, 2011 at 06:24:04PM -0400, Vivek Goyal wrote:
> It does look like a tough one!

Thank you!

> > Is it possible? We have looked at the code many a times and we think
> > that rcu locking around it is fine. Is it possible that a call_rcu()
> > can fire before rcu grace period is over.
> 
> If it does, that would be a bug in RCU.
> 
> > I had put a debug patch in CFQ (details are in bugzilla) and I can
> > see that after decoupling the object from the hash list, it got
> > freed while we were still under rcu_read_lock().
> > 
> > Is there any known issue or is there any quick tip on how can I 
> > go about debugging it further from rcu point of view.
> 
> First for uses of RCU:
> 
> o	One thing to try would be CONFIG_PROVE_RCU, which could help
> 	find missing rcu_read_lock()s and similar.  Some years back, it
> 	used to be the case that spin_lock() implied rcu_read_lock(),
> 	but it no longer does.	There might still be some cases where
> 	spin_lock() needs to have an rcu_read_lock() added.
> 
> o	There are a few entries in the bugzilla mentioning that elements
> 	are being removed more often than expected.  There is a config
> 	option CONFIG_DEBUG_OBJECTS_RCU_HEAD that complains if the same
> 	object is passed to call_rcu() before the grace period ends for
> 	the first round.
> 
> o	Try switching between CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU.
> 	These two settings are each sensitive to different forms of abuse.
> 	For example, if you have CONFIG_PREEMPT=n and CONFIG_TREE_RCU=y,
> 	illegally placing a synchronize_rcu() -- or anything else that
> 	blocks -- in an RCU read-side critical section will silently
> 	partition that RCU read-side critical section.  In contrast,
> 	CONFIG_TREE_PREEMPT_RCU=y will complain about this.
> 
> Second, for RCU itself, CONFIG_RCU_TRACE enables counter-based tracing
> in RCU.  Sampling each of the files in the debugfs directory "rcu"
> before and after the badness (if possible) could help me see if anything
> untoward is happening.

Before we go down that route, I'd like to note that I seem to be unable
to reproduce this Oops under v2.6.39 (either using the first v2.6.39 rpm
for i686 shipped for Fedora Rawhide, or two versions of that rpm I built
locally).

Is anyone able to spot one or more commits in v2.6.39-rc7..v2.6.39 that
might have fixed this Oops? Or did my chance of hitting this Oops,
somehow, just got a lot smaller in v.2.6.39?

Please note that I have tried to reproduce this Oops very often, using
quite a number of kernels, so there's a non-zero chance I tricked myself
in seeing a pattern where there actually is none.


Paul Bolle

