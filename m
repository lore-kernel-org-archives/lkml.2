Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1DEUuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 16:50:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38907 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354Ab1DEUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 16:50:07 -0400
Date: Tue, 5 Apr 2011 21:50:03 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
 'shared_pending'
Message-ID: <20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110405201958.GA1404@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-2-git-send-email-matt@console-pimps.org>
	<20110405201958.GA1404@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 22:19:58 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Hi Matt,
> 
> I'll try to study this series, but not before Friday, sorry.

No problem!

> Only one thing,
> 
> On 04/05, Matt Fleming wrote:
> > 
> > Because SIGCONT and SIGSTOP affect an entire thread group,
> 
> Yes, the effect is global, but
> 
> > we can
> > place them on the 'shared_pending' queue.
> 
> I don't think we can.
> 
>  -	pending = group ? &t->signal->shared_pending : &t->pending;
> > +	/*
> > +	 * We always enqueue SIGSTOP or SIGCONT signals on the
> > shared
> > +	 * queue. This means that a SIGSTOP or SIGCONT signal
> > _cannot_
> > +	 * be present on a thread's private pending queue.
> > +	 *
> > +	 * This makes prepare_signal() more optimal as we do not
> > have
> > +	 * to remove signals from each thread's pending queue and
> > so
> > +	 * can avoid iterating over all threads in the thread group
> > +	 * (and therefore avoid the locking that would be
> > necessary to
> > +	 * do that safely).
> > +	 */
> > +	if (group || sig_kernel_stop(sig) || sig == SIGCONT)
> > +		pending = &t->signal->shared_pending;
> > +	else
> > +		pending = &t->pending;
> 
> How so? Suppose the process has a handler for SIGCONT. Suppose this
> process is not stopped. tkill(SIGCONT) should deliver the signal to
> the right thread.

D'oh, yes. I think I got confused here. You're right, this won't work.
 
> SIGSTOP can't have the handler, still we shouldn't place it on the
> shared list, debuggers won't be happy.

Urgh, debuggers actually peek at shared_pending and pending?

> Also. This code was changed very much, please do these changes on
> top of
> http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=refs/heads/ptrace

My patches are already based on that tree.

-- 
Matt Fleming, Intel Open Source Technology Center
