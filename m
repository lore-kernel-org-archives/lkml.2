Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HANmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:42:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43243 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1HANmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:42:04 -0400
From: Richard Weinberger <richard@nod.at>
To: segoon@openwall.com
Subject: shm updates broke UML
Date: Mon, 1 Aug 2011 15:41:59 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: serge.hallyn@canonical.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011541.59640.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy,

5774ed01 (shm: handle separate PID namespaces case)
b34a6b1d (ipc: introduce shm_rmid_forced sysctl)
4c677e2e (shm: optimize locking and ipc_namespace getting)

broke UML on i386.
It crashes while starting up by SIGSEGV.
exit_shm() seems to be the evil doer.

Reverting all three patches make UML work again.

Commit 5774ed01 removed the !ns->shm_rmid_forced check, maybe this is wrong?
The attached patch cures the problem, but I'm sure it's wrong. 8)

---cut---
#13 0x08067efb in hard_handler (sig=11) at arch/um/os-Linux/sys-i386/signal.c:12
#14 <signal handler called>
#15 __list_add (sem=0x824cc98, subclass=0) at include/linux/list.h:44
#16 list_add_tail (sem=0x824cc98, subclass=0) at include/linux/list.h:76
#17 __down_write_nested (sem=0x824cc98, subclass=0) at lib/rwsem-spinlock.c:232
#18 0x081c7ba1 in __down_write (sem=0x824cc98) at lib/rwsem-spinlock.c:252
#19 0x081c74a3 in down_write (sem=0x824cc98) at kernel/rwsem.c:51
#20 0x08139913 in exit_shm (task=0x9c73b60) at ipc/shm.c:308
#21 0x08075649 in do_exit (code=0) at kernel/exit.c:983
#22 0x08081dd2 in ____call_usermodehelper (data=0x9c6bce0) at kernel/kmod.c:187
#23 0x08065c18 in run_kernel_thread (fn=0x8081ce4 <____call_usermodehelper>, arg=0x9c6bce0, 
jmp_ptr=0x9c73d94)
    at arch/um/os-Linux/process.c:268
#24 0x080588cb in new_thread_handler () at arch/um/kernel/process.c:153
#25 0x00000000 in ?? ()
---cut---

Not-Signed-off-by: Richard Weinberger <richard@nod.at>
---
diff --git a/ipc/shm.c b/ipc/shm.c
index 9fb044f3b..2196a0d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -304,6 +304,9 @@ void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 
+	if(!ns->shm_rmid_forced)
+		return;
+
 	/* Destroy all already created segments, but not mapped yet */
 	down_write(&shm_ids(ns).rw_mutex);
 	if (&shm_ids(ns).in_use)
