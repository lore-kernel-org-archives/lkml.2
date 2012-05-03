Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2ECRbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:31:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58199 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab2ECRbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:31:31 -0400
Date: Thu, 3 May 2012 21:31:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: khlebnikov@openvz.org, xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120503173125.GF19347@moon>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502172756.GD2301@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 09:27:56PM +0400, Cyrill Gorcunov wrote:
> > 
> > My theory is that files under map_files shouldn't be executable,
> > but since I'm not sure what the usermode code for c/r does exactly,
> > I should probably confirm that first. If it's indeed the case, you
> > can probably skip the rest of this mail.
> 
> Thanks Sasha, I'll take a look!

Sasha, the patch below should fix the lock problem (still I would
prefer to obtain confirm on patch from Vasiliy, CC'ed).

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, proc: Fix ABBA deadlock in case of execution attempt of map_files/ entries

map_files/ entries are never supposed to be executed, still curious
minds might try to run them, which leads to the following deadlock

[  270.895009] ======================================================
[  270.895054] [ INFO: possible circular locking dependency detected ]
[  270.895100] 3.4.0-rc4-24406-g841e6a6 #121 Not tainted
[  270.895144] -------------------------------------------------------
[  270.895189] bash/1556 is trying to acquire lock:
[  270.895235]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<ffffffff8116917f>] do_lookup+0x267/0x2b1
[  270.895612] 
[  270.895613] but task is already holding lock:
[  270.895731]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81165244>] prepare_bprm_creds+0x2d/0x69
[  270.896081] 
[  270.896082] which lock already depends on the new lock.
[  270.896083] 
[  270.896220] 
[  270.896221] the existing dependency chain (in reverse order) is:
[  270.896340] 
[  270.896341] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[  270.896637]        [<ffffffff810b346c>] validate_chain+0x444/0x4f4
[  270.896734]        [<ffffffff810b409f>] __lock_acquire+0x387/0x3f8
[  270.896847]        [<ffffffff810b423b>] lock_acquire+0x12b/0x158
[  270.896950]        [<ffffffff81bd322c>] __mutex_lock_common+0x56/0x3a9
[  270.897056]        [<ffffffff81bd3604>] mutex_lock_killable_nested+0x40/0x45
[  270.897155]        [<ffffffff811b48e2>] lock_trace+0x24/0x59
[  270.897253]        [<ffffffff811b6903>] proc_map_files_lookup+0x5a/0x165
[  270.897365]        [<ffffffff81168ef7>] __lookup_hash+0x52/0x73
[  270.897463]        [<ffffffff8116918e>] do_lookup+0x276/0x2b1
[  270.897560]        [<ffffffff8116ab9a>] walk_component+0x3d/0x114
[  270.897657]        [<ffffffff8116ad6d>] do_last+0xfc/0x540
[  270.897753]        [<ffffffff8116b7a0>] path_openat+0xd3/0x306
[  270.897864]        [<ffffffff8116bacc>] do_filp_open+0x3d/0x89
[  270.897967]        [<ffffffff8115d7a8>] do_sys_open+0x74/0x106
[  270.898068]        [<ffffffff8115d871>] sys_open+0x21/0x23
[  270.898164]        [<ffffffff81bd6c50>] tracesys+0xdd/0xe2
[  270.898262] 
[  270.898263] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
[  270.898598]        [<ffffffff810b22eb>] check_prev_add+0x6a/0x1ef
[  270.898696]        [<ffffffff810b346c>] validate_chain+0x444/0x4f4
[  270.898810]        [<ffffffff810b409f>] __lock_acquire+0x387/0x3f8
[  270.898908]        [<ffffffff810b423b>] lock_acquire+0x12b/0x158
[  270.899005]        [<ffffffff81bd322c>] __mutex_lock_common+0x56/0x3a9
[  270.899103]        [<ffffffff81bd368e>] mutex_lock_nested+0x40/0x45
[  270.899200]        [<ffffffff8116917f>] do_lookup+0x267/0x2b1
[  270.899309]        [<ffffffff8116ab9a>] walk_component+0x3d/0x114
[  270.899408]        [<ffffffff8116b3aa>] link_path_walk+0x1f9/0x48f
[  270.899505]        [<ffffffff8116b783>] path_openat+0xb6/0x306
[  270.899602]        [<ffffffff8116bacc>] do_filp_open+0x3d/0x89
[  270.899699]        [<ffffffff81165bcb>] open_exec+0x25/0xa0
[  270.899809]        [<ffffffff811664af>] do_execve_common+0xea/0x2f9
[  270.899907]        [<ffffffff81166752>] do_execve+0x43/0x45
[  270.900004]        [<ffffffff81018ac0>] sys_execve+0x43/0x5a
[  270.900102]        [<ffffffff81bd6eec>] stub_execve+0x6c/0xc0

This is because prepare_bprm_creds grabs task->signal->cred_guard_mutex
and when do_lookup happens we try to grab task->signal->cred_guard_mutex
again in lock_trace.

Fix it using plain ptrace_may_access() helper, proc_map_files_lookup is
guarded by CAP_SYS_ADMIN.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/proc/base.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.git/fs/proc/base.c
===================================================================
--- linux-2.6.git.orig/fs/proc/base.c
+++ linux-2.6.git/fs/proc/base.c
@@ -2226,16 +2226,16 @@ static struct dentry *proc_map_files_loo
 		goto out;
 
 	result = ERR_PTR(-EACCES);
-	if (lock_trace(task))
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
 		goto out_put_task;
 
 	result = ERR_PTR(-ENOENT);
 	if (dname_to_vma_addr(dentry, &vm_start, &vm_end))
-		goto out_unlock;
+		goto out_put_task;
 
 	mm = get_task_mm(task);
 	if (!mm)
-		goto out_unlock;
+		goto out_put_task;
 
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
@@ -2247,8 +2247,6 @@ static struct dentry *proc_map_files_loo
 out_no_vma:
 	up_read(&mm->mmap_sem);
 	mmput(mm);
-out_unlock:
-	unlock_trace(task);
 out_put_task:
 	put_task_struct(task);
 out:
