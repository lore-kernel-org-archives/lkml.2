Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab1LPRma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:42:30 -0500
Received: from zeus.madism.org ([88.190.14.41]:47077 "EHLO zeus.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1LPRmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:42:21 -0500
Date: Fri, 16 Dec 2011 18:42:16 +0100
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
Message-ID: <20111216174216.GC4569@madism.org>
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
 <1324055385.18942.109.camel@twins>
 <20111216172523.GB4569@madism.org>
 <1324056787.18942.118.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324056787.18942.118.camel@twins>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:33:07PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-12-16 at 18:25 +0100, Pierre Habouzit wrote:
> > On Fri, Dec 16, 2011 at 06:09:45PM +0100, Peter Zijlstra wrote:
> > > On Fri, 2011-12-16 at 17:15 +0100, Pierre Habouzit wrote:
> > > >   Hence I install those callbacks for the thread registering themselves
> > > >   and want to keep them until the thread dies. Sadly I have no way to
> > > >   unregister those callbacks right now, but for horrible hacks (involving
> > > >   private delayed queues processed regularly walked to kfree() the
> > > >   structures referencing pids that are dead, urgh).
> > > 
> > > kfree_rcu() is the 'normal' way to cheat your way out of this.
> > 
> > Hmm, if when I'm scheduled "out" with the TASK_DEAD bit set, am I sure
> > the _in/_out callback will never ever be called again?
> 
> Yep.

Good then kfree_rcu (or call_rcu if I need more at some point) is good
enough, which is nice because it will allow me to run on "any" kernel
whether my patch is ever applied or not.

> > It experimentally seems that the answer is yes, but I'm not familiar
> > enough with the scheduler to be a 100% sure. If yes then kfree_rcu is
> > just fine indeed and I don't need the patch, at all.
> > 
> > If it's not "sure" then I assume I can probably use call_rcu() but that
> 
> kfree_rcu() is a convenient macro wrapped around call_rcu().

Yes I've seen, what I meant was a shortcut for "if kfree_rcu isn't
allowed because I may kfree() callbacks still registered and that _in or
_out events could be still fired then I'll write something that safely
unregisters callbacks from a longer call_rcu" :)

I reckon this "shortcut" wasn't obvious for the reader. But I won't need
that since you answered "yes" to my previous question.

> > looks like a total overkill for something that can be fully avoided with
> > my patch, which incidentally, doesn't slow the typical sched path (there
> > should be no callbacks and the _safe iterator exits as fast as the non
> > safe iterator).
> 
> Ah, you're right, I thought it frobbed the extra variable too, but
> looking at it it only does that when there's anything on the list.

Yeah that's the reason why I submitted the patch in the first place
since it doesn't change the performance for the usual case. But well,
given your answers, I don't really care whether it's applied or not
anymore, I still find it cumbersome that people couldn't unregister from
a callback, that's really something that I expected to work :) It may be
worth a comment in preempt.h to save some experimenters a kernel panic
or two :P

Thank you for your answers.

(for the story but well, I understand you couldn't care less, it sadly
caused me a kernel panic and 2 subsequent ones because btrfs kind of
didn't like the panics. Okay, I've got the message, I've been a lazy boy
to develop kernel code for almost the first time directly in my running
linux instead of a qemu :P)
-- 
Intersec <http://www.intersec.com>
Pierre Habouzit <pierre.habouzit@intersec.com> | Chief Software Architect
Tél : +33 (0)1 5570 3346
Mob : +33 (0)6 1636 8131
Fax : +33 (0)1 5570 3332
37 Rue Pierre Lhomme
92400 Courbevoie
