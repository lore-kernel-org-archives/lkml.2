Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2LJNBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:01:10 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60405 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2LJNBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:01:08 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 21:01:07 +0800
Message-ID: <CAKWKT+b_bjQ8mB1OsBpbUym0VK52pYT-SH8p+A+=e1vS-SBcRw@mail.gmail.com>
Subject: kernel panic when doing do_exit
From: Qiang Gao <gaoqiangscut@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS version: centos 6.2   kernel: 2.6.32-220.7.1

call trace from the vmcore:

crash> bt
PID: 31437  TASK: ffff880832e260c0  CPU: 13  COMMAND: "tt"
 #0 [ffff88082b751b30] die at ffffffff8100ef7f
 #1 [ffff88082b751b60] do_general_protection at ffffffff814a5492
 #2 [ffff88082b751b90] general_protection at ffffffff814a4f05
    [exception RIP: update_cfs_shares+50]
    RIP: ffffffff81052202  RSP: ffff88082b751c48  RFLAGS: 00010086
    RAX: dead000000000000  RBX: ffff88082ee7d880  RCX: ffff880434af4cc0
    RDX: 000000000000000d  RSI: 0000000091771fba  RDI: ffff88082ee7d880
    RBP: ffff88082b751c68   R8: ffff880434af4cc0   R9: 0000000000989680
    R10: 0000000000000400  R11: 0000000000000000  R12: ffff880832e26100
    R13: 0000000000000001  R14: 0000000000000001  R15: ffff88044e4b4840
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
 #3 [ffff88082b751c70] dequeue_task_fair at ffffffff8105243f
 #4 [ffff88082b751cb0] dequeue_task at ffffffff8104dc73
 #5 [ffff88082b751ce0] deactivate_task at ffffffff8104dcc4
 #6 [ffff88082b751cf0] thread_return at ffffffff814a22ef
 #7 [ffff88082b751e30] do_exit at ffffffff810625ea
 #8 [ffff88082b751f40] do_group_exit at ffffffff81062951
 #9 [ffff88082b751f70] sys_exit_group at ffffffff810629d7
#10 [ffff88082b751f80] system_call_fastpath at ffffffff8100afb2
    RIP: 00000038e849a3cf  RSP: 00007fff8febc268  RFLAGS: 00010246
    RAX: 00000000000000e7  RBX: ffffffff8100afb2  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 000000000000003c  RDI: 0000000000000000
    RBP: 0000000000000000   R8: 00000000000000e7   R9: ffffffffffffffb0
    R10: 0000000000000000  R11: 0000000000000246  R12: ffffffff810629d7
    R13: ffff88082b751f78  R14: 0000000000000000  R15: 00007fff8febc360
    ORIG_RAX: 00000000000000e7  CS: 0033  SS: 002b


static void update_cfs_shares(struct cfs_rq *cfs_rq)
{
    struct task_group *tg;
    struct sched_entity *se;
    long load_weight, load, shares;

    tg = cfs_rq->tg;
    se = tg->se[cpu_of(rq_of(cfs_rq))];  <------dies  here
...........
}

    tg->se=0xdead000000000000  because I set it when it was freed.


command "tt" does nothing bug loop for many times and then exit  and I put "tt"
in a cpu-cgroup.

it seems that  if a context switch happens between  cgroup_exit and
the last schedule() ,
 the cgroup-releated structures will be freed and later dereference
will result in a kernel panic

I'm not quite familar with this code and anyone has any idea ?


    exit_thread();
    cgroup_exit(tsk, 1);    <-------------here

    if (group_dead && tsk->signal->leader)
        disassociate_ctty(1);

    module_put(task_thread_info(tsk)->exec_domain->module);

    proc_exit_connector(tsk);

    /*
     * Flush inherited counters to the parent - before the parent
     * gets woken up by child-exit notifications.
     */
    perf_event_exit_task(tsk);

    exit_notify(tsk, group_dead);
#ifdef CONFIG_NUMA
    task_lock(tsk);
    mpol_put(tsk->mempolicy);
    tsk->mempolicy = NULL;
    task_unlock(tsk);
#endif
#ifdef CONFIG_FUTEX
    if (unlikely(current->pi_state_cache))
        kfree(current->pi_state_cache);
#endif
    /*
     * Make sure we are holding no locks:
     */
    debug_check_no_locks_held(tsk);
    /*
     * We can do this unlocked here. The futex code uses this flag
     * just to verify whether the pi state cleanup has been done
     * or not. In the worst case it loops once more.
     */
    tsk->flags |= PF_EXITPIDONE;

    if (tsk->io_context)
        exit_io_context();

    if (tsk->splice_pipe)
        __free_pipe_info(tsk->splice_pipe);

    validate_creds_for_do_exit(tsk);
   /* actually,I insert some code here to make it easy to
reproduce.
{
    volatile int i=0;
    volatile int j=0;
    volatile int k=0;
    for(j=0;j<3;j++)
    {
        i=0;
        while(i++<100000000)
        {
            k++;
        }
        //schedule();
    }
    return k;
}
*/
    preempt_disable();
    exit_rcu();
    /* causes final put_task_struct in finish_task_switch(). */
    tsk->state = TASK_DEAD;
    schedule();   <------------------------------------here
    BUG();
    /* Avoid "noreturn function does return".  */
    for (;;)
        cpu_relax();    /* For when BUG is null */
