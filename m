Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1AFJm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:42:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52395 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1AFJmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:42:55 -0500
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.724459093@chello.nl>
	 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
	 <1294054362.2016.74.camel@laptop> <20110104064542.GF3402@amd>
	 <1294254867.2016.281.camel@laptop>
	 <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 10:32:33 +0100
Message-ID: <1294306353.2016.304.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:43 -0800, Linus Torvalds wrote:
> On Wed, Jan 5, 2011 at 11:14 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > There appear to be only two callsites of said horror, one in the exit
> > path and one in ata-eh, neither appear to be performance critical so I
> > replaced them with a simple lock-unlock sequence.
> 
> Again, WHY?
> 
> What's the problem with the current code? Instead of generating ugly
> patches to change it, and instead of removing it, just say what the
> PROBLEM is.

Well, I don't care about the primitive anymore, and Nick had some
reasonable arguments on why its not a good primitive to have. So in a
brief moment I decided to see what it would take to make it go away.

Apparently you don't like it, I'm fine with that, consider the patch
discarded.

> Some simple helper functions to extract the tail/head part of the
> ticket lock to make the comparisons understandable,

Jeremy has a number of pending patches making things more pretty. If you
wish I can revisit this once that work hits your tree.

  http://lkml.org/lkml/2010/11/16/479

He makes the thing looks like:

+#if (CONFIG_NR_CPUS < 256)
+typedef u8  __ticket_t;
+#else
+typedef u16 __ticket_t;
+#endif
+
+#define TICKET_SHIFT   (sizeof(__ticket_t) * 8)
+#define TICKET_MASK    ((__ticket_t)((1 << TICKET_SHIFT) - 1))
+
 typedef struct arch_spinlock {
+       union {
+               unsigned int slock;
+               struct __raw_tickets {
+                       __ticket_t head, tail;
+               } tickets;
+       };
 } arch_spinlock_t;

>  together with
> always accessing the lock with the proper ACCESS_ONCE() would have
> made your previous patch acceptable.

I'm still not quite seeing where I was missing an ACCESS_ONCE(), the
second loop had a cpu_relax() in, which is a compiler barrier so it
forces a reload that way.

>  But you ignored that feedback,
> and instead you now want to do a "let's just remove it entirely patch"
> that is even worse.

My locking improved and became a lot more obvious by not using the
primitive, so for the work I was doing not using it seemed the better
solution.

And as said, this was inspired by Nick's comments and it was a quick
edit to see what it would take.
