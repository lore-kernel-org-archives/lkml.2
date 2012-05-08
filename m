Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2EHWvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:51:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab2EHWvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:51:17 -0400
Date: Tue, 8 May 2012 15:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 3/3] pidns: Make killed children autoreap
Message-Id: <20120508155116.d5a34e11.akpm@linux-foundation.org>
In-Reply-To: <87zk9k6d5p.fsf_-_@xmission.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com>
	<m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<87havs7rvv.fsf_-_@xmission.com>
	<87zk9k6d5p.fsf_-_@xmission.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 May 2012 17:35:46 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> Force SIGCHLD handling to SIG_IGN so that signals are not generated
> and so that the children autoreap.  This increases the parallelize
> and in general the speed of network namespace shutdown.
> 
> Note self reaping childrean can exist past zap_pid_ns_processess but
> they will all be reaped before we allow the pid namespace init task
> with pid == 1 to be reaped.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  kernel/pid_namespace.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 57bc1fd..b98b0ed 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -149,7 +149,12 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  {
>  	int nr;
>  	int rc;
> -	struct task_struct *task;
> +	struct task_struct *task, *me = current;
> +
> +	/* Ignore SIGCHLD causing any terminated children to autoreap */
> +	spin_lock_irq(&me->sighand->siglock);
> +	me->sighand->action[SIGCHLD -1].sa.sa_handler = SIG_IGN;
> +	spin_unlock_irq(&me->sighand->siglock);

Taking a lock around a single atomic write is always fishy.  What
exactly is this locking here for?

