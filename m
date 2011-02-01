Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1BACSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 21:18:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39355 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab1BACSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 21:18:35 -0500
Date: Mon, 31 Jan 2011 18:18:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: call_function_many: fix list delete vs add race
Message-ID: <20110201021831.GB2158@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110112150740.77dde58c@kryten>
 <1295288253.30950.280.camel@laptop>
 <smp-call-function-peter-reply@mdm.bga.com>
 <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop>
 <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com>
 <1296508677.26581.84.camel@laptop>
 <1296519764.2349.325.camel@pasglop>
 <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:39:13AM +1000, Linus Torvalds wrote:
> On Tue, Feb 1, 2011 at 10:22 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Mon, 2011-01-31 at 22:17 +0100, Peter Zijlstra wrote:
> >> That's wrong:
> >>
> >>  ->foo =
> >>  LOCK
> >>  UNLOCK
> >>  ->bar =
> >>
> >> can be re-ordered as:
> >>
> >>  LOCK
> >>  ->bar =
> >>  ->foo =
> >>  UNLOCK
> >
> > Can it ? I though UNLOCK had a write barrier semantic ?
> 
> The re-ordering of ->foo and UNLOCK that Peter claims is definitely
> possible, and the unlock is not guaranteed to be a write barrier. The
> unlock just guarantees "release" consistency, which means that no
> previous reads or writes will be migrated down from within the locked
> region, but it is very much a one-way barrier, so a subsequent write -
> or more commonly a read - could easily migrate up past the unlock.
> 
> (Same for lock, except the permeability is obviously the other way
> around - "acquire" consistency)
> 
> > So yes, ->bar = can leak into the lock, as can ->foo =, but they can't
> > be re-ordered vs. each other because the implied barrier will keep ->foo
> > = in the same "domain" as the unlock itself.
> >
> > Or do other archs do something really nasty here that don't provide this
> > guarantee ?
> 
> I think we actually allow the accesses to ->bar and ->foo to be
> re-ordered wrt each other, exactly because they can *both* get
> re-ordered first into the locked region, and then after that they can
> get re-ordered wrt each other (because there is no other memory
> barrier).
> 
> So a "unlock+lock" is guaranteed to be equivalent to a full memory
> barrier (because an operation before the unlock cannot pass the
> unlock, and an access after the lock cannot percolate up before it).
> But the regular "lock+unlock" sequence is not, exactly because
> accesses outside of it are allowed to first leak in, and then not have
> ordering constraints within the locked region.
> 
> That said, we may have some confusion there, and I would *STRONGLY*
> suggest that architectures should have stronger lock consistency
> guarantees than the theoretical ones. Especially since x86 has such
> strong rules, and locking is a full memory barrier. Anybody with very
> weak ordering is likely to just hit more bugs.
> 
> And so while I'm not sure it's ever been documented, I do think it is
> likely a good idea to just make sure that "lock+unlock" is a full
> memory barrier, the same way "unlock+lock" is. I think it's
> practically true anyway on all architectures (with the possible
> exception of ia64, which I think actually implements real
> acquire/release semantics)

Documentation/memory-barriers.txt specifies this.

	Therefore, from (1), (2) and (4) an UNLOCK followed by an
	unconditional LOCK is equivalent to a full barrier, but a LOCK
	followed by an UNLOCK is not.

							Thanx, Paul

> (Practically speaking, there really aren't many reasons to allow
> writes to be re-ordered wrt lock/unlock operations, and there is no
> reason to ever move reads later, only earlier. Writes are _not_
> performance-sensitive the way reads are, so there is no real reason to
> really take advantage of the one-way permeability for them. It's reads
> that you really want to speculate and do early, not writes, and so
> allowing a read after a UNLOCK to percolate into the critical region
> is really the only relevant case from a performance perspective).
> 
>                     Linus
