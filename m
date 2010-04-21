Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab0DUIth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:49:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0DUItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:49:35 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 10:49:32 +0200
Message-ID: <1271839772.1776.58.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 07:16 +0200, Primiano Tucci wrote:
> Hi steve
> > read_locks are converted into "special" rt_mutexes. The only thing
> > special about them, is the owner may grab the same read lock more than
> > once (recursive).
> >
> > If a lower priority process currently holds the tasklist_lock for write,
> > when a high priority process tries to take it for read (or write for
> > that matter) it will block on the lower priority process. But that lower
> > priority process will acquire the priority of the higher priority
> > process (priority inheritance) and will run at that priority until it
> > releases the lock. Then it will go back to its low priority and the
> > higher priority process will then preempt it and acquire the lock for
> > read.
> 
> In your example you implied that the low priority process, holding the
> lock for write, runs on the same CPU of the higher priority process
> that wants to lock it for read. This is clear to me.
> My problem is, in a SMP environment, what happens if a process (let's
> say T1 on CPU #1) holds the lock for write (its priority does not
> matter, it is not a PI problem) and now a process T0 on cpu #0 wants
> to lock it for read?
> The process T0 will be blocked! But who will run now on CPU 0, until
> the rwlock is held by T1? Probably the next ready process on CPU #'0.
> Is it right?

Yes. This is the reality of SMP systems, nothing much you can do about
that. System resources are shared between all cpus, irrespective of task
affinities.

