Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1I3Q4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab1I3Q4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:56:05 -0400
Date: Fri, 30 Sep 2011 18:52:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20110930165206.GA22048@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Matt Fleming wrote:
>
> However, it's a good first step and
> hopefully by keeping it relatively simple it'll make it easier to
> review.

Cough. I'll try to read this series next week, but currently I feel
I will never able to understand this code. It surely compliacates
things a lot.

But. All I can do is to _try_ to check this series from the correctness
pov. I can't believe (at least at first glance) this worth the trouble,
but otoh I won't argue unless I'll find the bugs.

>  arch/ia64/kernel/signal.c           |    4 +-
>  drivers/block/nbd.c                 |    2 +-
>  drivers/usb/gadget/f_mass_storage.c |    2 +-
>  drivers/usb/gadget/file_storage.c   |    2 +-
>  fs/autofs4/waitq.c                  |    5 +-
>  fs/exec.c                           |   17 +-
>  fs/jffs2/background.c               |    2 +-
>  fs/ncpfs/sock.c                     |    2 +
>  fs/proc/array.c                     |    2 +
>  fs/signalfd.c                       |   11 +-
>  include/linux/init_task.h           |    4 +
>  include/linux/sched.h               |   23 +-
>  kernel/exit.c                       |   29 +-
>  kernel/fork.c                       |    4 +
>  kernel/freezer.c                    |   10 +-
>  kernel/kmod.c                       |    8 +-
>  kernel/posix-timers.c               |    5 +-
>  kernel/ptrace.c                     |   68 ++--
>  kernel/signal.c                     |  737 +++++++++++++++++++++++++++--------
>  net/9p/client.c                     |    6 +-
>  net/sunrpc/svc.c                    |    3 -
>  security/selinux/hooks.c            |   11 +-
>  22 files changed, 677 insertions(+), 280 deletions(-)

And, this patch adds 4 new locks:

	sighand_struct->action_lock

	signal_struct->ctrl_lock
	signal_struct->shared_siglock

	task_struct->siglock

Nice ;) For what? This should be justified, imho.


Hmm. Just out of curiosity, I blindly applied the whole series and poke
the _random_ function to look at, dequeue_signal(). And it looks wrong.

	spin_lock_irqsave(&current->signal->ctrl_lock, flags);
	current->jobctl |= JOBCTL_STOP_DEQUEUED;

This signal->ctrl_lock can't help. A sig_kernel_stop() should be
dequeued under the same lock, and we shouldn't release it unless we
set JOBCTL_STOP_DEQUEUED. Otherwise we race with SIGCONT.

May be do_signal_stop() does something special? At first flance it doesn't.
But wait, it does while_each_thread() under ->ctrl_lock, why this is safe?

May be I was just lucky ;)

Oleg.

