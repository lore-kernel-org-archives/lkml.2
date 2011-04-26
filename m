Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1DZJqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:46:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54630 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab1DZJqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:46:19 -0400
Date: Tue, 26 Apr 2011 10:46:15 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFC][PATCH 2/5] signals: Introduce per-thread siglock and
 action rwlock
Message-ID: <20110426104615.2293168b@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418164513.GA25930@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-3-git-send-email-matt@console-pimps.org>
	<20110413194231.GA15330@redhat.com>
	<20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com>
	<20110414190012.GA23517@redhat.com>
	<20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com>
	<20110418164513.GA25930@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry it's taken me so long to reply to this email]

On Mon, 18 Apr 2011 18:45:13 +0200
Oleg Nesterov <oleg@redhat.com> wrote:
 
> Can't understand...
> 
> OK, someone does get_sighand(). Now, what de_thread() should do if it
> wants to change ->sighand?
> 
> And I don't really understand the point. You can read *sighand lockless.
> But you need some per-CLONE_SIGHAND lock if you want to modify it anyway.

I think at this stage the best thing for me to do is to write a patch to
demonstrate what I'm talking about.
 
> > Now, at the moment that suggestion just seems like needless overhead
> > because siglock already provides the features we want. But, my problem
> > with siglock is,
> >
> > 	1. It needs to be acquired to stop a task passing through
> > 	__exit_signal().
> >
> > 	2. It protects bits of signal_struct and that struct is getting
> > 	pretty bloated and siglock is being used to protect lots of
> > 	different things.
> 
> Yes, this is the main problem: it is overused.
> 
> We need the better locking. Honestly, _personally_ I do not really care
> about scalability (but perhaps I should) when it comes to signals, but
> there are other problems. And, apart from the already mentioned problems
> with signals-from-irq, I think the main problem is tasklist_lock in
> do_wait/exit/etc pathes.

Is the tasklist_lock problem that we acquire the write lock for these
paths? Or is it a problem acquiring the read lock too?
 
> And we still have the problems with signals which should be fixed.
> de_thread() can miss a signal, vfork() should be interruptible,
> do_coredump() should be interruptible. But first of all we need to
> define better the behaviour of explicit SIGKILL and what it means
> after exit_signals(). This should be fixed first, I think.

Hmm.. interesting. Does the SIGKILL case cause any bugs? Or is it more
of a theoretical scenario? I must admit that I can't see any problems.

> > Do you have any recollection of the cleanups? signal_struct needs to be
> > put on a diet for sure.
> 
> I was going to remove ->sighand from fs/proc first, probably I should
> try to resend these patches... Then we should remove the "sighand != NULL"
> checks, we need the new helper, and btw it should be used instead of
> pid_alive(). Then something else... boring ;)

Heh. I'd be interested in reviewing these patches if you could find and
submit them.

-- 
Matt Fleming, Intel Open Source Technology Center
