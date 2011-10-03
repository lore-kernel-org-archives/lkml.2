Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1JCNUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1JCNUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:20:13 -0400
Date: Mon, 3 Oct 2011 15:16:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111003131610.GA26823@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Matt Fleming wrote:
>
> On Fri, 2011-09-30 at 18:52 +0200, Oleg Nesterov wrote:
>
> > Hmm. Just out of curiosity, I blindly applied the whole series and poke
> > the _random_ function to look at, dequeue_signal(). And it looks wrong.
> >
> > 	spin_lock_irqsave(&current->signal->ctrl_lock, flags);
> > 	current->jobctl |= JOBCTL_STOP_DEQUEUED;
> >
> > This signal->ctrl_lock can't help. A sig_kernel_stop() should be
> > dequeued under the same lock, and we shouldn't release it unless we

s/unless/until/

> > set JOBCTL_STOP_DEQUEUED. Otherwise we race with SIGCONT.
>
> Hmm.. is that really a problem? Does the dequeue and setting
> JOBCTL_STOP_DEQUEUED actually need to be atomic?

It should be atomic wrt SIGCONT.

> Does it matter if we
> have SIGCONT on the signal queue when we set JOBCTL_STOP_DEQUEUED?

Why do we have? Usually SIGCONT is ignored. But this doesn't matter,
SIGCONT acts at the sending time.

If SIGCONT is sent - the process must not stop. Since we drop the lock
we can't guarantee this.

> > May be do_signal_stop() does something special? At first flance it doesn't.
> > But wait, it does while_each_thread() under ->ctrl_lock, why this is safe?
>
> Why is it not safe? What scenario are you thinking of where that isn't
> safe?

This series doesn't add ->ctrl_lock into copy_process/__unhash_process
or I misread the patches. This means we can't trust >thread_group list.

Even this is safe (say, we can rely on rcu), we can't calculate
->group_stop_count correctly. In particular, without ->siglock we can
race with exit_signals() which sets PF_EXITING. Note that PF_EXITING
check in task_set_jobctl_pending() is important.

Oleg.

