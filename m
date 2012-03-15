Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161215Ab2CORxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:53:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:41871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031933Ab2CORxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:53:45 -0400
Date: Thu, 15 Mar 2012 18:53:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 1/5] seqlock: Remove unused functions
In-Reply-To: <20120315173937.GC8943@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1203151842180.2466@ionos>
References: <20120314170736.617746873@linutronix.de> <20120314170918.404528547@linutronix.de> <CA+55aFzCQEiV2ZfB3s983fe-zpyFhhc+QvpA58qeLWJxRJtU0A@mail.gmail.com> <20120315173937.GC8943@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Al Viro wrote:
> On Thu, Mar 15, 2012 at 09:29:50AM -0700, Linus Torvalds wrote:
> > So I have to say, I hate this entire series.
> > 
> > Seriously, what the heck is the point of this churn? It's all entirely
> > pointless searc-and-replace as far as I can tell, with absolutely zero
> > upside.
> > 
> > It makes the low-level filesystems have to be aware of things that
> > they don't want to know and *shouldn't* know. Why should a filesystem
> > care that d_lock is a seqlock, and have to use a locking function that
> > they've never seen before and is very specialized?
> > 
> > The "seq" part of the dentry is something only the lookup code and the
> > internal dentry code should care about. NOBODY ELSE should ever care.
> 
> *nod*
> 
> There's another issue I have with that on API level, leaving aside any
> questions of that being a good fit for dcache.  It's simply a bad interface:
> we have variants that lock and play with d_seq, variants that play with
> d_seq alone and, most commonly used, variant that locks but does not
> touch d_seq at all.  IOW, we have traded "writes to d_seq must be under
> d_lock" with "update-seq-without-locking primitive must be used after we'd
> used lock-without-touching-seq one".  Which is not an improvement at all.
> Sure, you can make a direct product out of anything; that doesn't make
> the result a natural object.
> 
> The _only_ relationship between d_seq and d_lock is that the latter happens
> to be serializing updates of the former.  For RT there's another one -
> ->d_lock taken to protect ->d_seq modifications really should not be
> preempted in favour of anything that might do read_seqcount_begin on
> ->d_seq.  The biggest such section is in __d_move(), AFAICS, and it's not
> _that_ big; can't RT simply have them protected by whatever it has that
> really prevents preempt?
> 
> IOW, instead of all that stuff, how about
> 	about_to_modify_seq_holding_lock(&dentry->d_seq, &dentry->d_lock);
> 	done_modifying_seq(&dentry->d_seq, &dentry->d_lock);
> around those 3 or 4 areas in fs/dcache.c, to give RT the missing information?

Fair enough. I thought about that earlier, but I was looking for a
solution which does not required to add extra code to every place
where the sequence count is updated. I accept, that I went overboard
with that approach.

Just come up with another idea, which restricts the lock annotation to
the init function.

struct seqcount {
       unsigned int seq;
#ifdef CONFIG_LOCKDEP       
       spinlock_t *lock;
#endif
};

	seqcount_init(&seq, &protecting_lock);

That way we could do the lock held assertions in the write_seqcount
functions when LOCKDEP is enabled instead of having them in the code
which uses the write_seqcount functions.

RT could enable that as well and use it for its own purposes. Would
something like that work for you?

Thanks,

	tglx






