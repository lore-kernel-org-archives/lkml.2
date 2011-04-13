Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab1DMUNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525Ab1DMUNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:13:11 -0400
Date: Wed, 13 Apr 2011 22:12:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 5/5] signals: Don't hold shared siglock across
	signal delivery
Message-ID: <20110413201219.GB15330@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-6-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302031310-1765-6-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Matt Fleming wrote:
>
> To reduce the contention on the shared siglock this patch pushes the
> responsibility of acquiring and releasing the shared siglock down into
> the functions that need it. That way, if we don't call a function that
> needs to be run under the shared siglock, we can run without acquiring
> it at all.

This adds new races. And this time I do not even understand the intent.
I mean, it is not clear to me why this change can really help to speed
up get_signal_to_deliver().

> Note that this does not make signal delivery lockless. A signal must
> still be dequeued from either the shared or private signal
> queues. However, in the private signal case we can now get by with
> just acquiring the per-thread siglock

OK, we can dequeue the signal. But dequeue_signal()->recalc_sigpending()
becomes even more wrong. We do not hold any lock, we can race with both
shared/private signal sending.

> Also update tracehook.h to indicate it's not called with siglock held
> anymore.

Heh. This breaks this tracehook completely ;) OK, nobody cares about
the out-of-tree users, forget.

Also. get_signal_to_deliver() does

		signr = dequeue_signal(current, &current->blocked,
					       info);
		...

		ka = &sighand->action[signr-1];

		...

		if (ka->sa.sa_handler != SIG_DFL) {
			/* Run the handler.  */
			*return_ka = *ka;

This memcpy() can race with sys_rt_sigaction(), we can't read *ka
atomically.

Actually, even SIG_DFL/SIG_IGN checks can race, although this is minor...
But still not correct.

			if (ka->sa.sa_flags & SA_ONESHOT) {
				write_lock(&sighand->action_lock);
				ka->sa.sa_handler = SIG_DFL;
				write_unlock(&sighand->action_lock);

We should check SA_ONESHOT under ->action_lock. But even then this
will bw racy, although we can probably ignore this... Suppose that
SA_ONESHOT was set after we dequeued the signal.

Oleg.

