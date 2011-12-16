Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab1LPReL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:34:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222Ab1LPReG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:34:06 -0500
Message-ID: <1324056787.18942.118.camel@twins>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
From: Peter Zijlstra <peterz@infradead.org>
To: Pierre Habouzit <pierre.habouzit@intersec.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 16 Dec 2011 18:33:07 +0100
In-Reply-To: <20111216172523.GB4569@madism.org>
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
	 <1324055385.18942.109.camel@twins> <20111216172523.GB4569@madism.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 18:25 +0100, Pierre Habouzit wrote:
> On Fri, Dec 16, 2011 at 06:09:45PM +0100, Peter Zijlstra wrote:
> > On Fri, 2011-12-16 at 17:15 +0100, Pierre Habouzit wrote:
> > 
> > >   As a background, this need is because I have some kind of module code
> > >   that uses this facility to evaluate how many of a group of threads are
> > >   concurrently running (to regulate a pool of threads).
> > 
> > Typically such stuff is only merged along with whomever uses it.
> 
> Well for now I'm just toying with it, it's nowhere nead to be ready to
> be even shown without me having to bury my head from shame ;)

:-) no worries just keep something like this along until you're ready..

> > >   Hence I install those callbacks for the thread registering themselves
> > >   and want to keep them until the thread dies. Sadly I have no way to
> > >   unregister those callbacks right now, but for horrible hacks (involving
> > >   private delayed queues processed regularly walked to kfree() the
> > >   structures referencing pids that are dead, urgh).
> > 
> > kfree_rcu() is the 'normal' way to cheat your way out of this.
> 
> Hmm, if when I'm scheduled "out" with the TASK_DEAD bit set, am I sure
> the _in/_out callback will never ever be called again?

Yep.

> It experimentally seems that the answer is yes, but I'm not familiar
> enough with the scheduler to be a 100% sure. If yes then kfree_rcu is
> just fine indeed and I don't need the patch, at all.
> 
> If it's not "sure" then I assume I can probably use call_rcu() but that

kfree_rcu() is a convenient macro wrapped around call_rcu().

> looks like a total overkill for something that can be fully avoided with
> my patch, which incidentally, doesn't slow the typical sched path (there
> should be no callbacks and the _safe iterator exits as fast as the non
> safe iterator).

Ah, you're right, I thought it frobbed the extra variable too, but
looking at it it only does that when there's anything on the list.



