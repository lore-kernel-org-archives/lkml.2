Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2EELdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:33:43 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37038 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2EELdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:33:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<1336014721.7370.32.camel@marge.simpson.net>
	<1336057018.8119.46.camel@marge.simpson.net>
	<1336105676.7356.42.camel@marge.simpson.net>
	<m1aa1oidmn.fsf@fess.ebiederm.org>
	<1336124716.25479.36.camel@marge.simpson.net>
	<m1vckcdoey.fsf@fess.ebiederm.org>
	<1336142995.25479.49.camel@marge.simpson.net>
	<m1zk9oc61j.fsf@fess.ebiederm.org>
	<1336150643.7502.4.camel@marge.simpson.net>
	<m1fwbfd71h.fsf@fess.ebiederm.org>
	<1336197362.7346.9.camel@marge.simpson.net>
	<1336198093.7346.11.camel@marge.simpson.net>
	<1336201977.7346.22.camel@marge.simpson.net>
Date: Sat, 05 May 2012 04:37:51 -0700
In-Reply-To: <1336201977.7346.22.camel@marge.simpson.net> (Mike Galbraith's
	message of "Sat, 05 May 2012 09:12:57 +0200")
Message-ID: <m1obq2kgds.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1//UGNYdX8lR5/zYACV+PWL53/iSfpX1Y0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Mike Galbraith <efault@gmx.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

> On Sat, 2012-05-05 at 08:08 +0200, Mike Galbraith wrote:
>
>> egrep 'synchronize|rcu_barrier' /trace 
>> 
>>           vsftpd-7981  [003] ....   577.164997: synchronize_sched <-switch_task_namespaces
>>           vsftpd-7981  [003] ....   577.164998: _cond_resched <-synchronize_sched
>>           vsftpd-7981  [003] ....   577.164998: wait_rcu_gp <-synchronize_sched
>>           vsftpd-7982  [003] ....   577.166583: synchronize_sched <-switch_task_namespaces
>>           vsftpd-7982  [003] ....   577.166583: _cond_resched <-synchronize_sched
>
>> vsftpd-7977  [003] ....   577.171519: rcu_barrier_sched <-rcu_barrier
>>           vsftpd-7977  [003] ....   577.171519: _rcu_barrier.isra.31 <-rcu_barrier_sched
>>           vsftpd-7977  [003] ....   577.171519: mutex_lock <-_rcu_barrier.isra.31
>>           vsftpd-7977  [003] ....   577.171520: __init_waitqueue_head <-_rcu_barrier.isra.31
>>           vsftpd-7977  [003] ....   577.171520: on_each_cpu <-_rcu_barrier.isra.31
>>           vsftpd-7977  [003] d...   577.171532: rcu_barrier_func <-on_each_cpu
>>           vsftpd-7977  [003] d...   577.171532: call_rcu_sched <-rcu_barrier_func
>>           vsftpd-7977  [003] ....   577.171533: wait_for_completion <-_rcu_barrier.isra.31
>>      ksoftirqd/3-16    [003] ..s.   577.171691: rcu_barrier_callback <-__rcu_process_callbacks
>>           vsftpd-7977  [003] ....   577.176443: mutex_unlock <-_rcu_barrier.isra.31
> ...
>
> Ok, so CLONE_NEWPID | SIGCHLD + waitpid is a bad idea given extreme
> unmount synchronization, but why does it take four softirqs?  Seems this
> could have gone a lot faster. 

It is just taking one 4millisecond or 1 jiffy at 250hz which seems
correct operation for rcu_barrier.

To recap for anyone watching.  We have:

sys_wait4
   do_wait
     ...
        release_task
           proc_flush_task
              pid_ns_release_proc
                 kern_unmount
                    mntput
                      mntput_no_expire
                         mntfree
                            deactivate_super
                               deactivate_locked_super
                                  rcu_barrier

So each instance of sys_wait4 winds up taking 4ms sad.  But that
does explain what it takes so long to reap the zombies we are
synchronous.

The ipc namespace is also going to suffer from this deactivate_super
delay but more likely in exit_namespaces() so the delay should not
be synchronized across a bunch of processes.  Aka the wait should
be done before the parent is notified.

I had a nefarious plan to combine the proc mount reference count with
the pid namespace reference count (to break the loop).  I will see if I
can reawaken that.  If that plan comes to fruition the final put_pid on
the pid namespace should happen in a call_rcu after release_task so
wait4 should not be bottlenecked.

I am still mystified why adding the rest of the namespaces adds so much
of a slowdown.  Those task existing should have been parallized before
do_wait..

The rcu_barrier is new as of 2.6.38-rc5 with commit d863b50ab on Feb 10 2011:

commit d863b50ab01333659314c2034890cb76d9fdc3c7
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Thu Feb 10 15:01:20 2011 -0800

    vfs: call rcu_barrier after ->kill_sb()
    
    In commit fa0d7e3de6d6 ("fs: icache RCU free inodes"), we use rcu free
    inode instead of freeing the inode directly.  It causes a crash when we
    rmmod immediately after we umount the volume[1].
    
    So we need to call rcu_barrier after we kill_sb so that the inode is
    freed before we do rmmod.  The idea is inspired by Aneesh Kumar.
    rcu_barrier will wait for all callbacks to end before preceding.  The
    original patch was done by Tao Ma, but synchronize_rcu() is not enough
    here.
    
    1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
    
    Tested-by: Tao Ma <boyu.mt@taobao.com>
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
    Cc: Nick Piggin <npiggin@kernel.dk>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Chris Mason <chris.mason@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/super.c b/fs/super.c
index 74e149e..7e9dd4c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -177,6 +177,11 @@ void deactivate_locked_super(struct super_block *s)
        struct file_system_type *fs = s->s_type;
        if (atomic_dec_and_test(&s->s_active)) {
                fs->kill_sb(s);
+               /*
+                * We need to call rcu_barrier so all the delayed rcu free
+                * inodes are flushed before we release the fs module.
+                */
+               rcu_barrier();
                put_filesystem(fs);
                put_super(s);
        } else {


