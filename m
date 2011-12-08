Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab1LHAw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:52:28 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:43193 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab1LHAw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:52:27 -0500
Date: Wed, 7 Dec 2011 16:52:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [PATCH] sys_getppid: add missing rcu_dereference
Message-ID: <20111208005218.GF2367@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1323225914-23985-1-git-send-email-msb@chromium.org>
 <CAGXu5j+Epkypk-AKi0QWrKewW9BX8k8xaW0bkPb82mHnYVECtw@mail.gmail.com>
 <20111208002420.GG13529@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111208002420.GG13529@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120800-1780-0000-0000-0000017C6335
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000238; HX=3.00000179; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00094179; UDB=6.00024751; UTC=2011-12-08
 00:52:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:24:20PM -0800, Mandeep Singh Baines wrote:
> Kees Cook (keescook@chromium.org) wrote:
> > On Tue, Dec 6, 2011 at 6:45 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> > > In order to safely dereference current->real_parent inside an
> > > rcu_read_lock, we need an rcu_dereference.
> > >
> > > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Pavel Emelyanov <xemul@openvz.org>
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > ---
> > >  kernel/timer.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/kernel/timer.c b/kernel/timer.c
> > > index dbaa624..9c3c62b 100644
> > > --- a/kernel/timer.c
> > > +++ b/kernel/timer.c
> > > @@ -1368,7 +1368,7 @@ SYSCALL_DEFINE0(getppid)
> > >        int pid;
> > >
> > >        rcu_read_lock();
> > > -       pid = task_tgid_vnr(current->real_parent);
> > > +       pid = task_tgid_vnr(rcu_dereference(current->real_parent));
> > >        rcu_read_unlock();
> > >
> > >        return pid;
> > 
> > Should parent and real_parent also be marked in sched.h with __rcu so
> > sparse can find other missing rcu_dereference()s? And if not, why?
> > (tasklist lock?)
> > 
> 
> Good idea. I was thinking the same thing. There's gotta be some way of
> finding these bugs via lockdep or sparse.

Indeed there is!  There is a CONFIG_SPARSE_RCU_POINTER kernel parameter
that tells sparse to check for proper use of RCU-protected pointers.
For this to work, the RCU-protected pointer in question must be marked
with "__rcu".  Sparse will then complain if the pointer is accessed
without using one of the rcu_dereference() family of functions.

> One idea I had was to create a ->real_parent accessor and insert an
> rcu_dereference_check there. That way lockdep could catch these bugs.
> 
> static inline struct task_struct *task_real_parent(struct task_struct *task)
> {
>         return rcu_dereference_check(task->real_parent,
> 			             lockdep_is_held(&tasklist_lock));
> }

The above is useful for common code that might be called from both
RCU readers (where rcu_read_lock() is in effect) and updaters
(which hold tasklist_lock).  But although a task_real_parent()-style
function can be extremely useful, it will not catch cases where
rcu_dereference() was not used but should have been.  For that,
as noted above, we have CONFIG_SPARSE_RCU_POINTER. __rcu, and sparse.

							Thanx, Paul

> > I think I see at least are few other users (security/apparmor/audit.c,
> > security/tomoyo/common.h, kernel/sched.c) that need rcu_dereference()
> > when accessing real_parent, there are probably more.
> > 
> > -Kees
> > 
> > -- 
> > Kees Cook
> > ChromeOS Security
> 

