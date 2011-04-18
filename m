Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1DRQuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:50:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1DRQuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:50:09 -0400
Subject: Re: [RFC][PATCH 4/7] lockdep: Seperate lock ids for read/write
 acquires
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303145177.7181.46.camel@gandalf.stny.rr.com>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.123045423@chello.nl>
	 <1303145177.7181.46.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:49:38 +0200
Message-ID: <1303145378.32491.889.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 12:46 -0400, Steven Rostedt wrote:
> > +/*
> > + * A lock's class id is used to calculate the chain-key. Since we need to
> > + * differentiate between the chains which contain the read acquire of
> > + * a lock from the chains having write acquire of the same lock,
> > + * we offset the class_idx by MAX_LOCKDEP_KEYS if it is a read acquire.
> 
> Don't we only care to do this if we have a recursive read? I thought
> simple reads still work fine with the current algorithm?
> 
> > + *
> > + * Thus the the lock's key during a chain-key calculation can be in the range
> > + * 1 to 2 * MAX_LOCKDEP_KEYS - 1.
> > + *
> > + * LOCKDEP_CHAIN_KEY_BITS holds the number of bits required to
> > + * represent this range.
> > + */
> > +#define LOCKDEP_CHAIN_KEY_BITS       (MAX_LOCKDEP_KEYS_BITS + 1)
> >  struct held_lock {
> >       /*
> >        * One-way hash of the dependency chain up to this point. We
> > Index: linux-2.6/kernel/lockdep.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/lockdep.c
> > +++ linux-2.6/kernel/lockdep.c
> > @@ -303,8 +303,8 @@ static struct list_head chainhash_table[
> >   * unique.
> >   */
> >  #define iterate_chain_key(key1, key2) \
> > -     (((key1) << MAX_LOCKDEP_KEYS_BITS) ^ \
> > -     ((key1) >> (64-MAX_LOCKDEP_KEYS_BITS)) ^ \
> > +     (((key1) << LOCKDEP_CHAIN_KEY_BITS) ^ \
> > +     ((key1) >> (64 - LOCKDEP_CHAIN_KEY_BITS)) ^ \
> >       (key2))
> >  
> >  void lockdep_off(void)
> > @@ -1988,6 +1988,9 @@ static void check_chain_key(struct task_
> >               if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
> >                       return;
> >  
> > +             if (is_read(hlock->rw_state))
> > +                     id += MAX_LOCKDEP_KEYS;
> 
> Again, isn't this about recursive reads? Or am I just confused ;) 

So what we do here is split off the write chain, the above could have
been writeen if (!is_write()) to clarify that.

Everything except recursive read validation will traverse both chains,
the recursive read validation will only traverse the write chains and
ignore the combined read/recursive-read chain.
