Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab1DNK5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:57:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38136 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab1DNK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:57:54 -0400
Date: Thu, 14 Apr 2011 11:57:50 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 5/5] signals: Don't hold shared siglock across
 signal delivery
Message-ID: <20110414115750.1a6703b6@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110413201219.GB15330@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-6-git-send-email-matt@console-pimps.org>
	<20110413201219.GB15330@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 22:12:19 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/05, Matt Fleming wrote:
> >
> > To reduce the contention on the shared siglock this patch pushes the
> > responsibility of acquiring and releasing the shared siglock down into
> > the functions that need it. That way, if we don't call a function that
> > needs to be run under the shared siglock, we can run without acquiring
> > it at all.
> 
> This adds new races. And this time I do not even understand the intent.
> I mean, it is not clear to me why this change can really help to speed
> up get_signal_to_deliver().

Again, it's not necessarily speeding up get_signal_to_deliver(), but
rather it's reducing the contention on the shared siglock.

For example, without this patch, if you've got someone sending a signal
to a task group, you can't run get_signal_to_deliver() in parallel
because you'll be waiting for the sending thread to release the shared
siglock. Which, if you were going to dequeue a private signal anyway
and didn't need to access signal->shared_pending, is unnecessary
overhead :-(

As it turns out, the shared siglock protects more than just
signal->shared_pending, so in certain cases you need to acquire it
anyway (like the fatal signal code paths) so this isn't as optimised
as it could be, which is a shame.

> > Note that this does not make signal delivery lockless. A signal must
> > still be dequeued from either the shared or private signal
> > queues. However, in the private signal case we can now get by with
> > just acquiring the per-thread siglock
> 
> OK, we can dequeue the signal. But dequeue_signal()->recalc_sigpending()
> becomes even more wrong. We do not hold any lock, we can race with both
> shared/private signal sending.

Yep, this was covered in the previous patch review.
 
> > Also update tracehook.h to indicate it's not called with siglock held
> > anymore.
> 
> Heh. This breaks this tracehook completely ;) OK, nobody cares about
> the out-of-tree users, forget.

I was hoping you'd say that ;-)

> Also. get_signal_to_deliver() does
> 
> 		signr = dequeue_signal(current, &current->blocked,
> 					       info);
> 		...
> 
> 		ka = &sighand->action[signr-1];
> 
> 		...
> 
> 		if (ka->sa.sa_handler != SIG_DFL) {
> 			/* Run the handler.  */
> 			*return_ka = *ka;
> 
> This memcpy() can race with sys_rt_sigaction(), we can't read *ka
> atomically.

Eek! I hadn't noticed that. Thanks.
 
> Actually, even SIG_DFL/SIG_IGN checks can race, although this is minor...
> But still not correct.
> 
> 			if (ka->sa.sa_flags & SA_ONESHOT) {
> 				write_lock(&sighand->action_lock);
> 				ka->sa.sa_handler = SIG_DFL;
> 				write_unlock(&sighand->action_lock);
> 
> We should check SA_ONESHOT under ->action_lock. But even then this
> will bw racy, although we can probably ignore this... Suppose that
> SA_ONESHOT was set after we dequeued the signal.

Right, most of this side is wrong wrt to the action_lock.

Thanks Oleg.

-- 
Matt Fleming, Intel Open Source Technology Center
