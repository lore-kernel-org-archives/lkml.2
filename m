Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2LVE6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:58:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54573 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2LVE6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:58:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
References: <87d2y2elbi.fsf@xmission.com>
Date: Fri, 21 Dec 2012 20:58:43 -0800
In-Reply-To: <87d2y2elbi.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 21 Dec 2012 20:56:49 -0800")
Message-ID: <87sj6yd6nw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ph+OkNKWm57UE8qOUTi9bBvPqXInRaEc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH review 3/3] proc: Allow proc_free_inum to be called from any context
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While testing the pid namespace code I hit this nasty warning.

[  176.262617] ------------[ cut here ]------------
[  176.263388] WARNING: at /home/eric/projects/linux/linux-userns-devel/kernel/softirq.c:160 local_bh_enable_ip+0x7a/0xa0()
[  176.265145] Hardware name: Bochs
[  176.265677] Modules linked in:
[  176.266341] Pid: 742, comm: bash Not tainted 3.7.0userns+ #18
[  176.266564] Call Trace:
[  176.266564]  [<ffffffff810a539f>] warn_slowpath_common+0x7f/0xc0
[  176.266564]  [<ffffffff810a53fa>] warn_slowpath_null+0x1a/0x20
[  176.266564]  [<ffffffff810ad9ea>] local_bh_enable_ip+0x7a/0xa0
[  176.266564]  [<ffffffff819308c9>] _raw_spin_unlock_bh+0x19/0x20
[  176.266564]  [<ffffffff8123dbda>] proc_free_inum+0x3a/0x50
[  176.266564]  [<ffffffff8111d0dc>] free_pid_ns+0x1c/0x80
[  176.266564]  [<ffffffff8111d195>] put_pid_ns+0x35/0x50
[  176.266564]  [<ffffffff810c608a>] put_pid+0x4a/0x60
[  176.266564]  [<ffffffff8146b177>] tty_ioctl+0x717/0xc10
[  176.266564]  [<ffffffff810aa4d5>] ? wait_consider_task+0x855/0xb90
[  176.266564]  [<ffffffff81086bf9>] ? default_spin_lock_flags+0x9/0x10
[  176.266564]  [<ffffffff810cab0a>] ? remove_wait_queue+0x5a/0x70
[  176.266564]  [<ffffffff811e37e8>] do_vfs_ioctl+0x98/0x550
[  176.266564]  [<ffffffff810b8a0f>] ? recalc_sigpending+0x1f/0x60
[  176.266564]  [<ffffffff810b9127>] ? __set_task_blocked+0x37/0x80
[  176.266564]  [<ffffffff810ab95b>] ? sys_wait4+0xab/0xf0
[  176.266564]  [<ffffffff811e3d31>] sys_ioctl+0x91/0xb0
[  176.266564]  [<ffffffff810a95f0>] ? task_stopped_code+0x50/0x50
[  176.266564]  [<ffffffff81939199>] system_call_fastpath+0x16/0x1b
[  176.266564] ---[ end trace 387af88219ad6143 ]---

It turns out that spin_unlock_bh(proc_inum_lock) is not safe when
put_pid is called with another spinlock held and irqs disabled.

For now take the easy path and use spin_lock_irqsave(proc_inum_lock)
in proc_free_inum and spin_loc_irq in proc_alloc_inum(proc_inum_lock).

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/generic.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index e064f56..76ddae8 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -352,18 +352,18 @@ retry:
 	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
 		return -ENOMEM;
 
-	spin_lock_bh(&proc_inum_lock);
+	spin_lock_irq(&proc_inum_lock);
 	error = ida_get_new(&proc_inum_ida, &i);
-	spin_unlock_bh(&proc_inum_lock);
+	spin_unlock_irq(&proc_inum_lock);
 	if (error == -EAGAIN)
 		goto retry;
 	else if (error)
 		return error;
 
 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
-		spin_lock_bh(&proc_inum_lock);
+		spin_lock_irq(&proc_inum_lock);
 		ida_remove(&proc_inum_ida, i);
-		spin_unlock_bh(&proc_inum_lock);
+		spin_unlock_irq(&proc_inum_lock);
 		return -ENOSPC;
 	}
 	*inum = PROC_DYNAMIC_FIRST + i;
@@ -372,9 +372,10 @@ retry:
 
 void proc_free_inum(unsigned int inum)
 {
-	spin_lock_bh(&proc_inum_lock);
+	unsigned long flags;
+	spin_lock_irqsave(&proc_inum_lock, flags);
 	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
-	spin_unlock_bh(&proc_inum_lock);
+	spin_unlock_irqrestore(&proc_inum_lock, flags);
 }
 
 static void *proc_follow_link(struct dentry *dentry, struct nameidata *nd)
-- 
1.7.5.4

