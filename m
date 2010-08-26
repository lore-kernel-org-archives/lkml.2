Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0HZJqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:46:19 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37527 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab0HZJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:46:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMbTdUx5Ld90/2dsb2JhbACgQnK5ZYU3BA
Date: Thu, 26 Aug 2010 19:46:13 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
Message-ID: <20100826094613.GA6411@amd>
References: <20100825132815.108d8217@bike.lwn.net>
 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
 <4C762BF9.5010305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C762BF9.5010305@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:55:21AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 08/25/2010 10:00 PM, Linus Torvalds wrote:
> >> lg_lock_global() currently only acquires spinlocks for online CPUs, but
> >> it's meant to lock all possible CPUs.  At Nick's suggestion, change
> >> for_each_online_cpu() to for_each_possible_cpu() to get the expected
> >> behavior.
> > 
> > Can you say what this actually matters for? Don't we do stop-machine
> > for CPU hotplug anyway? And if we don't, shouldn't we? Exactly because
> > otherwise "for_each_online_cpu()" is always racy (and that has nothing
> > to do with the lglock).
> 
> We only do stop-machine for cpu downs not ups, so code running w/
> preemption disabled is guaranteed that no cpu goes down while it's
> running but not the other way around.  There are two ways to achieve
> synchronization against cpu up/down operations.  One is explicitly
> using get/put_online_cpus() and the other is via cpu notifiers with
> proper synchronization.

Oh, I thought we quiesce / preempt all online cpus before adding
another one. That sucks if we don't because then you need a big
heavy get_online_cpus when a simple preempt_disable would have
worked.

Why is that? Don't tell me realtime people want some latency "guarantee"
while onlining CPUs? :)

> 
> So, yeah, given that there's no cpu notifier implemented, the use of
> for_each_online_cpu for brlock seems fishy to me.  It probably should
> use for_each_possible_cpu().

It should if that's the case, yes.

Thanks,
Nick

