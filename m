Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab1CZEMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 00:12:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63173 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1CZEMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 00:12:40 -0400
X-Nat-Received: from [202.181.97.72]:56448 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301112739.12523
To: peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 26 Mar 2011 13:12:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 25032011 #5145198, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a freeze between "seqlock_t rename_lock" and "DEFINE_BRLOCK(vfsmount_lock)"
in 2.6.38. The bug was already fixed in linux-2.6 git tree.
http://www.spinics.net/lists/linux-fsdevel/msg43078.html

This bug is timing dependent and lockdep shows nothing before the freeze.
I think that lockdep cannot detect this bug because no lock primitives are
called within read_seqbegin().

 /* Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
 	++sl->sequence;
 	smp_wmb();
 }
 
 static inline void write_sequnlock(seqlock_t *sl)
 {
 	smp_wmb();
 	sl->sequence++;
 	spin_unlock(&sl->lock);
 }

 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	unsigned ret;
 
 repeat:
 	ret = sl->sequence;
 	smp_rmb();
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
 
 	return ret;
 }

read_seqbegin() waits until the writer (if any) calls write_sequnlock().
read_seqbegin() acts like a sort of normal spin_lock()+spin_unlock().

--- linux-2.6.38.1.orig/include/linux/seqlock.h
+++ linux-2.6.38.1/include/linux/seqlock.h
@@ -86,6 +86,11 @@ static inline int write_tryseqlock(seqlo
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
 	unsigned ret;
+#ifdef CONFIG_PROVE_LOCKING
+	unsigned long flags;
+	spin_lock_irqsave(&((seqlock_t *) sl)->lock, flags);
+	spin_unlock_irqrestore(&((seqlock_t *) sl)->lock, flags);
+#endif
 
 repeat:
 	ret = sl->sequence;

Therefore, if we apply the patch above, lockdep can detect this bug.

[  179.457160] =======================================================
[  179.458004] [ INFO: possible circular locking dependency detected ]
[  179.458004] 2.6.38.1 #2
[  179.458004] -------------------------------------------------------
[  179.458004] ccs_execute_han/3717 is trying to acquire lock:
[  179.458004]  (vfsmount_lock){++++..}, at: [<c04d9910>] vfsmount_lock_local_lock+0x0/0x60
[  179.458004] 
[  179.458004] but task is already holding lock:
[  179.458004]  (rename_lock){+.+...}, at: [<c04d37dc>] __d_path+0x3c/0x80
[  179.458004] 
[  179.458004] which lock already depends on the new lock.
[  179.458004] 
[  179.458004] 
[  179.458004] the existing dependency chain (in reverse order) is:
[  179.458004] 
[  179.458004] -> #1 (rename_lock){+.+...}:
[  179.458004]        [<c046d5f4>] __lock_acquire+0x244/0x6d0
[  179.458004]        [<c046dafb>] lock_acquire+0x7b/0xa0
[  179.458004]        [<c06c50a5>] _raw_spin_lock_irqsave+0x45/0x80
[  179.458004]        [<c04d308b>] is_subdir+0x2b/0xd0
[  179.458004]        [<c04dac29>] sys_pivot_root+0x219/0x290
[  179.458004]        [<c0402c50>] sysenter_do_call+0x12/0x36
[  179.458004] 
[  179.458004] -> #0 (vfsmount_lock){++++..}:
[  179.458004]        [<c046d39e>] validate_chain+0x10ee/0x1100
[  179.458004]        [<c046d5f4>] __lock_acquire+0x244/0x6d0
[  179.458004]        [<c046dafb>] lock_acquire+0x7b/0xa0
[  179.458004]        [<c04d9943>] vfsmount_lock_local_lock+0x33/0x60
[  179.458004]        [<c04d284c>] prepend_path+0x1c/0x150
[  179.458004]        [<c04d37f4>] __d_path+0x54/0x80
[  179.458004]        [<e090e1f2>] ccs_realpath_from_path+0x122/0x3e0 [ccsecurity]
[  179.458004]        [<e090eca4>] ccs_get_exe+0x54/0x60 [ccsecurity]
[  179.458004]        [<e090ccdb>] ccs_manager+0x6b/0x1e0 [ccsecurity]
[  179.458004]        [<e090d547>] ccs_write_control+0xc7/0x250 [ccsecurity]
[  179.458004]        [<e090dec8>] ccs_write+0x8/0x10 [ccsecurity]
[  179.458004]        [<c050145d>] proc_reg_write+0x5d/0x90
[  179.458004]        [<c04c0256>] vfs_write+0x96/0x140
[  179.458004]        [<c04c080d>] sys_write+0x3d/0x70
[  179.458004]        [<c0402c50>] sysenter_do_call+0x12/0x36
[  179.458004] 
[  179.458004] other info that might help us debug this:
[  179.458004] 
[  179.458004] 4 locks held by ccs_execute_han/3717:
[  179.458004]  #0:  (&head->io_sem){+.+.+.}, at: [<e090d4ea>] ccs_write_control+0x6a/0x250 [ccsecurity]
[  179.458004]  #1:  (&ccs_ss){.+.+.+}, at: [<e090d4f7>] ccs_write_control+0x77/0x250 [ccsecurity]
[  179.458004]  #2:  (&mm->mmap_sem){++++++}, at: [<e090ec72>] ccs_get_exe+0x22/0x60 [ccsecurity]
[  179.458004]  #3:  (rename_lock){+.+...}, at: [<c04d37dc>] __d_path+0x3c/0x80
[  179.458004] 
[  179.458004] stack backtrace:
[  179.458004] Pid: 3717, comm: ccs_execute_han Not tainted 2.6.38.1 #2
[  179.458004] Call Trace:
[  179.458004]  [<c046bceb>] ? print_circular_bug+0xbb/0xc0
[  179.458004]  [<c046d39e>] ? validate_chain+0x10ee/0x1100
[  179.458004]  [<c0431216>] ? scheduler_tick+0x146/0x1f0
[  179.458004]  [<c046d5f4>] ? __lock_acquire+0x244/0x6d0
[  179.458004]  [<c046dafb>] ? lock_acquire+0x7b/0xa0
[  179.458004]  [<c04d9910>] ? vfsmount_lock_local_lock+0x0/0x60
[  179.458004]  [<c04d9943>] ? vfsmount_lock_local_lock+0x33/0x60
[  179.458004]  [<c04d9910>] ? vfsmount_lock_local_lock+0x0/0x60
[  179.458004]  [<c04d284c>] ? prepend_path+0x1c/0x150
[  179.458004]  [<c04d37f4>] ? __d_path+0x54/0x80
[  179.458004]  [<e090e1f2>] ? ccs_realpath_from_path+0x122/0x3e0 [ccsecurity]
[  179.458004]  [<e090ec72>] ? ccs_get_exe+0x22/0x60 [ccsecurity]
[  179.458004]  [<c06c42af>] ? down_read+0x7f/0x90
[  179.458004]  [<e090eca4>] ? ccs_get_exe+0x54/0x60 [ccsecurity]
[  179.458004]  [<e090ccdb>] ? ccs_manager+0x6b/0x1e0 [ccsecurity]
[  179.458004]  [<e090d4f7>] ? ccs_write_control+0x77/0x250 [ccsecurity]
[  179.458004]  [<e090d547>] ? ccs_write_control+0xc7/0x250 [ccsecurity]
[  179.458004]  [<e090d4f7>] ? ccs_write_control+0x77/0x250 [ccsecurity]
[  179.458004]  [<e090dec0>] ? ccs_write+0x0/0x10 [ccsecurity]
[  179.458004]  [<e090dec8>] ? ccs_write+0x8/0x10 [ccsecurity]
[  179.458004]  [<c050145d>] ? proc_reg_write+0x5d/0x90
[  179.458004]  [<c04c0256>] ? vfs_write+0x96/0x140
[  179.458004]  [<c04af2e7>] ? sys_mmap_pgoff+0x77/0x100
[  179.458004]  [<c0501400>] ? proc_reg_write+0x0/0x90
[  179.458004]  [<c04c080d>] ? sys_write+0x3d/0x70
[  179.458004]  [<c0402c50>] ? sysenter_do_call+0x12/0x36

But there is still a problem. It seems to me that lockdep checks for this bug
only when a new locking pattern (a locking pattern which was not already added
to lockdep database) is added. This freeze can be triggered by running

  while :; do newns /sbin/pivot_root /proc/ /proc/sys/; done

on one terminal and running

  while :; do /bin/ls -l /proc/*/exe; done

on another terminal. (The "newns" is a program that unshares the mnt namespace
before execve() using CLONE_NEWNS.) But even after applying the patch above,
lockdep does not show the trace above.

lockdep shows the trace above only after I run test programs for TOMOYO (which
causes a locking pattern that was generated by neither
"/sbin/pivot_root /proc/ /proc/sys/" nor "/bin/ls -l /proc/*/exe" to be added
to lockdep database).

I think that we want some method for rechecking already added locking pattern.
Maybe it is run by (e.g.) every 60 seconds. Maybe it is run when stall checking
mechanisms report the possibility of stall. (The sysrq key didn't work after
the freeze occurred.)

Also, what to do with __read_seqcount_begin() case? Since seqcount_t does not
have a spinlock embedded into the struct, we can't use lock primitives...?

Regards.
