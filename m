Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0IGS3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab0IGS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:29:06 -0400
Date: Tue, 7 Sep 2010 20:25:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [patch 3/3] audit: Use rcu for task lookup protection
Message-ID: <20100907182536.GA21588@redhat.com>
References: <20100907111326.202980881@linutronix.de> <20100907111349.980032649@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907111349.980032649@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Thomas Gleixner wrote:
>
> Protect the task lookups in audit_receive_msg() with rcu_read_lock()
> instead of tasklist_lock and use lock/unlock_sighand to protect
> against the exit race.

I do not understand audit, but I belive both 1/3 and 3/3 patches are
fine (I didn't get 2/3).



But, sorry, can't resists ;) off-topic nit.

> @@ -873,17 +873,16 @@ static int audit_receive_msg(struct sk_b
>  	case AUDIT_TTY_GET: {
>  		struct audit_tty_status s;
>  		struct task_struct *tsk;
> +		unsigned long flags;
>
> -		read_lock(&tasklist_lock);
> +		rcu_read_lock();
>  		tsk = find_task_by_vpid(pid);
> -		if (!tsk)
> -			err = -ESRCH;
> -		else {
> -			spin_lock_irq(&tsk->sighand->siglock);
> +		if (tsk && lock_task_sighand(tsk, &flags)) {
>  			s.enabled = tsk->signal->audit_tty != 0;

Yes, this is what original code does, it takes ->siglock every time
around read/write of ->audit_tty. And this looks absolutely bogus.
Say, tty_audit_fork(). Why does it take ->siglock ?

As for ->tty_audit_buf, I am not sure ->siglock is the best choice,
perhaps task_lock() would be better.


Once again, I think the patch is fine. Just it seems to me this code
needs more cleanups.

Oleg.

