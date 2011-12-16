Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab1LPRZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:25:32 -0500
Received: from zeus.madism.org ([88.190.14.41]:57917 "EHLO zeus.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1LPRZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:25:27 -0500
Date: Fri, 16 Dec 2011 18:25:23 +0100
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
Message-ID: <20111216172523.GB4569@madism.org>
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
 <1324055385.18942.109.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324055385.18942.109.camel@twins>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 06:09:45PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-12-16 at 17:15 +0100, Pierre Habouzit wrote:
> 
> >   As a background, this need is because I have some kind of module code
> >   that uses this facility to evaluate how many of a group of threads are
> >   concurrently running (to regulate a pool of threads).
> 
> Typically such stuff is only merged along with whomever uses it.

Well for now I'm just toying with it, it's nowhere nead to be ready to
be even shown without me having to bury my head from shame ;)

> >   Hence I install those callbacks for the thread registering themselves
> >   and want to keep them until the thread dies. Sadly I have no way to
> >   unregister those callbacks right now, but for horrible hacks (involving
> >   private delayed queues processed regularly walked to kfree() the
> >   structures referencing pids that are dead, urgh).
> 
> kfree_rcu() is the 'normal' way to cheat your way out of this.

Hmm, if when I'm scheduled "out" with the TASK_DEAD bit set, am I sure
the _in/_out callback will never ever be called again?

It experimentally seems that the answer is yes, but I'm not familiar
enough with the scheduler to be a 100% sure. If yes then kfree_rcu is
just fine indeed and I don't need the patch, at all.

If it's not "sure" then I assume I can probably use call_rcu() but that
looks like a total overkill for something that can be fully avoided with
my patch, which incidentally, doesn't slow the typical sched path (there
should be no callbacks and the _safe iterator exits as fast as the non
safe iterator).
-- 
Intersec <http://www.intersec.com>
Pierre Habouzit <pierre.habouzit@intersec.com> | Chief Software Architect
Tél : +33 (0)1 5570 3346
Mob : +33 (0)6 1636 8131
Fax : +33 (0)1 5570 3332
37 Rue Pierre Lhomme
92400 Courbevoie
