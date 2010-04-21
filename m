Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0DUU6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:58:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:57458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab0DUU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:58:20 -0400
Subject: Re: Considerations on sched APIs under RT patch
From: Peter Zijlstra <peterz@infradead.org>
To: Primiano Tucci <p.tucci@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>
In-Reply-To: <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <1271755208.1676.422.camel@laptop>
	 <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
	 <1271804453.10448.168.camel@gandalf.stny.rr.com>
	 <t2nc5b2c05b1004202216pd159c9b4mbfc1dc7658fc20e7@mail.gmail.com>
	 <1271839772.1776.58.camel@laptop>
	 <1271854016.10448.172.camel@gandalf.stny.rr.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 22:58:16 +0200
Message-ID: <1271883496.1776.263.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 22:38 +0200, Primiano Tucci wrote:
> > No, any syscall can end up blocking/scheduling there are no exceptions.
> > But blocking doesn't mean its non-deterministic, esp. when coupled with
> > things like PI.
> >
> > But you do have to treat system resources as such, that is they can (and
> > will) create cross-cpu dependencies, if you do not take that into
> > account you will of course be surprised.
> >
> I actually don't understand why do you recall PI so frequently, it
> seems to be the unique point of interest.

PI keeps preemptible locks working in a RT environment. Non-preemptible
or preemptible+PI are both valid RT constructs that can be analyzed 

> Actually I take care about not sharing cross-cpu resources, but I
> cannot take care of what the kernel should do.

An SMP kernel must be treated as a cross-cpu resource. There's just no
way around that. For instance, Unix allows two processes on different
cpus to invoke sched_setscheduler/sched_setaffinity or any number of
system calls on the same target process. Filesystems are shared etc..

> In my viewpoint is unacceptable that the scheduler apis can led into a
> rescheduling.

They can even lead to pagefaults and disk IO if you're not careful.

I'm not sure if there are blocking locks left thereabout, but spinlocks
or rt_mutex, both create cross-cpu dependencies that need to be
analyzed, !preempt isn't magic in any way.

> It voids any form of process control.
> If I lose the control while controlling other processes, Quis
> custodiet ipsos custodes?
> 
> P.S. It actually does not happen in other RTOSes, e.g., VxWorks SMP

I don't know any of those, but its impossible to migrate tasks from one
cpu to another without creating cross-cpu dependencies.

Whether locks are preemptible or not doesn't make them any less
analyzable, if you use system-calls in your RT program, their
implementation needs to be considered.



