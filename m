Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab0IHMrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758693Ab0IHMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:47:31 -0400
Date: Wed, 8 Sep 2010 14:44:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [patch 3/3] audit: Use rcu for task lookup protection
Message-ID: <20100908124406.GA5271@redhat.com>
References: <20100907111326.202980881@linutronix.de> <20100907111349.980032649@linutronix.de> <20100907182536.GA21588@redhat.com> <alpine.LFD.2.00.1009072224080.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009072224080.2477@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Thomas Gleixner wrote:
>
> On Tue, 7 Sep 2010, Oleg Nesterov wrote:
>
> > But, sorry, can't resists ;) off-topic nit.
> >
> > > @@ -873,17 +873,16 @@ static int audit_receive_msg(struct sk_b
> > >  	case AUDIT_TTY_GET: {
> > >  		struct audit_tty_status s;
> > >  		struct task_struct *tsk;
> > > +		unsigned long flags;
> > >
> > > -		read_lock(&tasklist_lock);
> > > +		rcu_read_lock();
> > >  		tsk = find_task_by_vpid(pid);
> > > -		if (!tsk)
> > > -			err = -ESRCH;
> > > -		else {
> > > -			spin_lock_irq(&tsk->sighand->siglock);
> > > +		if (tsk && lock_task_sighand(tsk, &flags)) {
> > >  			s.enabled = tsk->signal->audit_tty != 0;
> >
> > Yes, this is what original code does, it takes ->siglock every time
> > around read/write of ->audit_tty. And this looks absolutely bogus.
> > Say, tty_audit_fork(). Why does it take ->siglock ?

Yes, I still think ->audit_tty doesn't need the locking.

> > As for ->tty_audit_buf, I am not sure ->siglock is the best choice,
> > perhaps task_lock() would be better.

OOPS, I misread the code. ->tty_audit_buf is per-process (of course!).
Well, unless I missed something again, tty_audit_push() and
tty_audit_tiocsti() can access ->tty_audit_buf lockless.

> > Once again, I think the patch is fine. Just it seems to me this code
> > needs more cleanups.
>
> Yeah, thought about that, but that's not in the scope of what I was
> working on. I leave that to the audit folks. :)

Yes, yes, sure.

Oleg.

