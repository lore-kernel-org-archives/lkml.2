Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032033Ab2CORjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:39:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464Ab2CORjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:39:43 -0400
Date: Thu, 15 Mar 2012 17:39:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 1/5] seqlock: Remove unused functions
Message-ID: <20120315173937.GC8943@ZenIV.linux.org.uk>
References: <20120314170736.617746873@linutronix.de>
 <20120314170918.404528547@linutronix.de>
 <CA+55aFzCQEiV2ZfB3s983fe-zpyFhhc+QvpA58qeLWJxRJtU0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCQEiV2ZfB3s983fe-zpyFhhc+QvpA58qeLWJxRJtU0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:29:50AM -0700, Linus Torvalds wrote:
> So I have to say, I hate this entire series.
> 
> Seriously, what the heck is the point of this churn? It's all entirely
> pointless searc-and-replace as far as I can tell, with absolutely zero
> upside.
> 
> It makes the low-level filesystems have to be aware of things that
> they don't want to know and *shouldn't* know. Why should a filesystem
> care that d_lock is a seqlock, and have to use a locking function that
> they've never seen before and is very specialized?
> 
> The "seq" part of the dentry is something only the lookup code and the
> internal dentry code should care about. NOBODY ELSE should ever care.

*nod*

There's another issue I have with that on API level, leaving aside any
questions of that being a good fit for dcache.  It's simply a bad interface:
we have variants that lock and play with d_seq, variants that play with
d_seq alone and, most commonly used, variant that locks but does not
touch d_seq at all.  IOW, we have traded "writes to d_seq must be under
d_lock" with "update-seq-without-locking primitive must be used after we'd
used lock-without-touching-seq one".  Which is not an improvement at all.
Sure, you can make a direct product out of anything; that doesn't make
the result a natural object.

The _only_ relationship between d_seq and d_lock is that the latter happens
to be serializing updates of the former.  For RT there's another one -
->d_lock taken to protect ->d_seq modifications really should not be
preempted in favour of anything that might do read_seqcount_begin on
->d_seq.  The biggest such section is in __d_move(), AFAICS, and it's not
_that_ big; can't RT simply have them protected by whatever it has that
really prevents preempt?

IOW, instead of all that stuff, how about
	about_to_modify_seq_holding_lock(&dentry->d_seq, &dentry->d_lock);
	done_modifying_seq(&dentry->d_seq, &dentry->d_lock);
around those 3 or 4 areas in fs/dcache.c, to give RT the missing information?
