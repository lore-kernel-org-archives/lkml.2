Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1CYT5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:57:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1CYT5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:57:04 -0400
Date: Fri, 25 Mar 2011 20:56:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de, laijs@cn.fujitsu.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements on
 UP
Message-ID: <20110325195643.GB7346@elte.hu>
References: <20110317192208.444147791@goodmis.org>
 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
 <1301076981.14261.197.camel@gandalf.stny.rr.com>
 <1301077163.14261.199.camel@gandalf.stny.rr.com>
 <20110325193128.GA5839@p183.telecom.by>
 <1301082034.14261.202.camel@gandalf.stny.rr.com>
 <20110325194729.GA6192@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325194729.GA6192@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Mar 25, 2011 at 03:40:34PM -0400, Steven Rostedt wrote:
> > On Fri, 2011-03-25 at 21:31 +0200, Alexey Dobriyan wrote:
> > 
> > > > Would you like me to add a comment that states:
> > > > 
> > > > 	/*
> > > > 	 * Use ({0;}) as just "0" will cause gcc to output:
> > > > 	 *   warning: statement with no effect
> > > > 	 */
> > > 
> > > Try ((void)0)
> > 
> > Maybe I should update the comment to stop further confusion:
> 
> Ah!
> 
> I always thought if (WARN_ON(x)) is confusing and should be banned.

I'd encourage you to read kernel/lockdep.c one day:

		return DEBUG_LOCKS_WARN_ON(1);
		DEBUG_LOCKS_WARN_ON(1);
	if (DEBUG_LOCKS_WARN_ON(class->subclass != subclass))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
	if (DEBUG_LOCKS_WARN_ON(unlikely(early_boot_irqs_disabled)))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
	if (DEBUG_LOCKS_WARN_ON(current->hardirq_context))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
		DEBUG_LOCKS_WARN_ON(!softirq_count());
	if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
	if (DEBUG_LOCKS_WARN_ON(!name)) {
	if (DEBUG_LOCKS_WARN_ON(!key))
		DEBUG_LOCKS_WARN_ON(1);
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
	if (DEBUG_LOCKS_WARN_ON(depth >= MAX_LOCK_DEPTH))
	if (DEBUG_LOCKS_WARN_ON(!class))
	if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
		if (DEBUG_LOCKS_WARN_ON(chain_key != 0))
	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
		if (DEBUG_LOCKS_WARN_ON(!class))
		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
	if (DEBUG_LOCKS_WARN_ON(!depth))
	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
	if (DEBUG_LOCKS_WARN_ON(!depth))
	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth - 1))
	if (DEBUG_LOCKS_WARN_ON(!depth && (hlock->prev_chain_key != 0)))
		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
			DEBUG_LOCKS_WARN_ON(current->softirqs_enabled);
			DEBUG_LOCKS_WARN_ON(!current->softirqs_enabled);
	if (DEBUG_LOCKS_WARN_ON(!depth))
	if (DEBUG_LOCKS_WARN_ON(!depth))

These conditional warnings made the flow a lot clearer and simpler - while 
still giving us a very robust lockdep machinery that wont crash no matter what 
kind of anomaly happens.

But yes, i can imagine such constructs being misused as well when mixed into 
real, non-debug functionality. As usual, it's just a tool, with good and evil 
uses as well - so your 'it should be banned' position is too extreme IMHO.

Thanks,

	Ingo
