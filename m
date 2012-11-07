Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2KGWbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 17:31:18 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:33018 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2KGWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 17:31:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Michal Hocko <mhocko@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 3.7-rc3
Date: Wed, 07 Nov 2012 23:35:27 +0100
Message-ID: <2223691.vvLeUubcx2@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121107222233.GG2541@linux.vnet.ibm.com>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com> <CA+55aFx+w2hFifGTr_u76D9d_sDKxKJBDd2L4p0GVk-RXCczMA@mail.gmail.com> <20121107222233.GG2541@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 07, 2012 02:22:34 PM Paul E. McKenney wrote:
> On Fri, Nov 02, 2012 at 04:10:34PM -0700, Linus Torvalds wrote:
> > On Fri, Nov 2, 2012 at 3:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >
> > > Well, not everything is rosy in the suspend land, though.  This is a
> > > failure to freeze khubd during the second in a row attempt to suspend to
> > > RAM (your current tree):
> > 
> > Ugh. So khubd is blocked in usb_start_wait_urb(), and apparently the
> > timeout for that block is longer than the freezing timeout.
> > 
> > There's a comment about why khubd needs to be freezable, but I wonder
> > if that whole thing isn't doing something wrong. Causing the suspend
> > to fail is definitely always the wrong thing.
> > 
> > Greg?
> > 
> > > [  125.780766] [ INFO: suspicious RCU usage. ]
> > > [  125.780804] 3.7.0-rc3+ #988 Not tainted
> > > [  125.780838] -------------------------------
> > > [  125.780875] /home/rafael/src/linux/kernel/sched/core.c:4497 suspicious rcu_dereference_check() usage!
> > 
> > Heh. The RCU usage is from the debug printout from sched_show_task(),
> > so it's "related", but it's a totally independent issue.
> > 
> > It's apparently because we've not done a "rcu_read_lock()" around that
> > sequence, but I seriously doubt we care. But it's technically a real
> > bug - even if the fix might be to just not print out the parent pid
> > (or to just ignore the bug and turn the rcu dereference into an
> > ACCESS_ONCE() or something.
> > 
> > Ingo, Peter, any comments about that sched/core.c:4497 RCU usage?
> 
> Rafael, does the following patch fix that problem?

Well, the box I can reproduce that on is not with me now and it's
not readily reproducible anyway, so it may take some time to verify
I'm afraid.

Thanks,
Rafael


> ------------------------------------------------------------------------
> 
> sched: Mark RCU reader in sched_show_task()
> 
> When sched_show_task() is invoked from try_to_freeze_tasks(), there is
> no RCU read-side critical section, resulting in the following splat:
> 
> [  125.780730] ===============================
> [  125.780766] [ INFO: suspicious RCU usage. ]
> [  125.780804] 3.7.0-rc3+ #988 Not tainted
> [  125.780838] -------------------------------
> [  125.780875] /home/rafael/src/linux/kernel/sched/core.c:4497 suspicious rcu_dereference_check() usage!
> [  125.780946]
> [  125.780946] other info that might help us debug this:
> [  125.780946]
> [  125.781031]
> [  125.781031] rcu_scheduler_active = 1, debug_locks = 0
> [  125.781087] 4 locks held by s2ram/4211:
> [  125.781120]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811e2acf>] sysfs_write_file+0x3f/0x160
> [  125.781233]  #1:  (s_active#94){.+.+.+}, at: [<ffffffff811e2b58>] sysfs_write_file+0xc8/0x160
> [  125.781339]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff81090a81>] pm_suspend+0x81/0x230
> [  125.781439]  #3:  (tasklist_lock){.?.?..}, at: [<ffffffff8108feed>] try_to_freeze_tasks+0x2cd/0x3f0
> [  125.781543]
> [  125.781543] stack backtrace:
> [  125.781584] Pid: 4211, comm: s2ram Not tainted 3.7.0-rc3+ #988
> [  125.781632] Call Trace:
> [  125.781662]  [<ffffffff810a3c73>] lockdep_rcu_suspicious+0x103/0x140
> [  125.781719]  [<ffffffff8107cf21>] sched_show_task+0x121/0x180
> [  125.781770]  [<ffffffff8108ffb4>] try_to_freeze_tasks+0x394/0x3f0
> [  125.781823]  [<ffffffff810903b5>] freeze_kernel_threads+0x25/0x80
> [  125.781876]  [<ffffffff81090b65>] pm_suspend+0x165/0x230
> [  125.781924]  [<ffffffff8108fa29>] state_store+0x99/0x100
> [  125.781975]  [<ffffffff812f5867>] kobj_attr_store+0x17/0x20
> [  125.782038]  [<ffffffff811e2b71>] sysfs_write_file+0xe1/0x160
> [  125.782091]  [<ffffffff811667a6>] vfs_write+0xc6/0x180
> [  125.782138]  [<ffffffff81166ada>] sys_write+0x5a/0xa0
> [  125.782185]  [<ffffffff812ff6ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  125.782242]  [<ffffffff81669dd2>] system_call_fastpath+0x16/0x1b
> 
> This commit therefore adds the needed RCU read-side critical section.
> 
> Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 6d4569e..36f2608 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4474,6 +4474,7 @@ static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
>  void sched_show_task(struct task_struct *p)
>  {
>  	unsigned long free = 0;
> +	int ppid;
>  	unsigned state;
>  
>  	state = p->state ? __ffs(p->state) + 1 : 0;
> @@ -4493,8 +4494,11 @@ void sched_show_task(struct task_struct *p)
>  #ifdef CONFIG_DEBUG_STACK_USAGE
>  	free = stack_not_used(p);
>  #endif
> +	rcu_read_lock();
> +	ppid = task_pid_nr(rcu_dereference(p->real_parent));
> +	rcu_read_unlock();
>  	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
> -		task_pid_nr(p), task_pid_nr(rcu_dereference(p->real_parent)),
> +		task_pid_nr(p), ppid,
>  		(unsigned long)task_thread_info(p)->flags);
>  
>  	show_stack(p, NULL);
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
