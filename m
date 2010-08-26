Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0HZLjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 07:39:06 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:29822 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab0HZLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 07:39:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGPsdUx5Ld90/2dsb2JhbACgQnK6CIU3BA
Date: Thu, 26 Aug 2010 21:38:58 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
Message-ID: <20100826113858.GA6856@amd>
References: <20100825132815.108d8217@bike.lwn.net>
 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
 <4C762BF9.5010305@kernel.org>
 <20100826094613.GA6411@amd>
 <4C7638B7.9060306@kernel.org>
 <1282817329.1975.486.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282817329.1975.486.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 12:08:49PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-26 at 11:49 +0200, Tejun Heo wrote:
> > If there's a pressing need, doing stop_machine for
> > onlining too is definitely an option. 
> 
> I would argue against that.. we should try and rid ourselves of
> stopmachine, not add more dependencies on it. If you want to sync
> against preempt_disable thingies synchronize_sched() is your friend.

I don't think it's that easy to do it in hotplug handlers.

Say take a brlock (not the best example because the write side
is a slowpath itself, but I could imagine better cases), then
you actually want to be able to prevent cpu online map from
changing for the entire period of a lock/unlock.

The lock/unlock is preempt disabled. synchronize_sched in the
plug handler will not really do anything, because there could
be subsequent write locks coming in from other CPUs at any
time during the handler, before or after synchronize_sched runs.

I think for CPU plug, stop_machine is reasonable (especially
considering it is required in unload, which means any frequent
amount of cpu plug activity already will require stop_machine to
run anyway).

