Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1JDI4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:56:31 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45005 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755120Ab1JDI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:56:30 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20111003131610.GA26823@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <20110930165206.GA22048@redhat.com>
	 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20111003131610.GA26823@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 09:56:17 +0100
Message-ID: <1317718577.3375.103.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 15:16 +0200, Oleg Nesterov wrote:
> Why do we have? Usually SIGCONT is ignored. But this doesn't matter,
> SIGCONT acts at the sending time.
> 
> If SIGCONT is sent - the process must not stop. Since we drop the lock
> we can't guarantee this.

OK, I see, thanks.

> > > May be do_signal_stop() does something special? At first flance it doesn't.
> > > But wait, it does while_each_thread() under ->ctrl_lock, why this is safe?
> >
> > Why is it not safe? What scenario are you thinking of where that isn't
> > safe?
> 
> This series doesn't add ->ctrl_lock into copy_process/__unhash_process
> or I misread the patches. This means we can't trust >thread_group list.

*facepalm*

Arrrrggghh! This is why I complain about sighand->siglock protecting too
much, I didn't even _REALISE_ it protected the ->thread_group list.
Thanks for pointing that out, Oleg!

> Even this is safe (say, we can rely on rcu), we can't calculate
> ->group_stop_count correctly. In particular, without ->siglock we can
> race with exit_signals() which sets PF_EXITING. Note that PF_EXITING
> check in task_set_jobctl_pending() is important.

Ah, I think it was these lines that confused me into thinking
->ctrl_lock wasn't required around PF_EXITING,

void exit_signals(struct task_struct *tsk)
{
        int group_stop = 0;
        sigset_t unblocked;

        if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
                tsk->flags |= PF_EXITING;
                return;
        }

But I guess that's safe because either we're the only thread in the
group or the group is already going to exit?

-- 
Matt Fleming, Intel Open Source Technology Center

