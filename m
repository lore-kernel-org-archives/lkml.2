Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1EFJw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:52:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1EFJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=te6dlz8q9YGnFcW80KTOyEmtVOpoY0ktMqmdaLJ9unQnxwSyP72NQ2PR+dUmHPoRyM
         23kvBJGP942yBBnE04xKpPvs6sUIcMAsjJi6oVDexj7X9aQncGhk/2N/Y4bMvaoTiZri
         k5rVdxQSt4tIBWDvlZi8i4DCN6g88Yico/iKc=
Date: Fri, 6 May 2011 11:52:22 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
 task_clear_group_stop_trapping()
Message-ID: <20110506095222.GB8824@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GROUP_STOP_TRAPPING waiting mechanism piggybacks on
signal->wait_chldexit which is primarily used to implement waiting for
wait(2) and friends.  When do_wait() waits on signal->wait_chldexit,
it uses a custom wake up callback, child_wait_callback(), which
expects the child task which is waking up the parent to be passed in
as @key to filter out spurious wakeups.

task_clear_group_stop_trapping() used __wake_up_sync() which uses NULL
@key causing the following oops if the parent was doing do_wait().

  BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
  IP: [<ffffffff810499f9>] child_wait_callback+0x29/0x80
  PGD 1d899067 PUD 1e418067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP
  last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/local_cpus
  CPU 2
  Modules linked in:

  Pid: 4498, comm: test-continued Not tainted 2.6.39-rc6-work+ #32 Bochs Bochs
  RIP: 0010:[<ffffffff810499f9>]  [<ffffffff810499f9>] child_wait_callback+0x29/0x80
  RSP: 0000:ffff88001b889bf8  EFLAGS: 00010046
  RAX: 0000000000000000 RBX: ffff88001fab3af8 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffff88001d91df20
  RBP: ffff88001b889c08 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
  R13: ffff88001fb70550 R14: 0000000000000000 R15: 0000000000000001
  FS:  00007f26ccae4700(0000) GS:ffff88001fd00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00000000000002d8 CR3: 000000001b8ac000 CR4: 00000000000006e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process test-continued (pid: 4498, threadinfo ffff88001b888000, task ffff88001fb88000)
  Stack:
   ffff88001b889c18 ffff88001fb70538 ffff88001b889c58 ffffffff810312f9
   0000000000000001 0000000200000001 ffff88001b889c58 ffff88001fb70518
   0000000000000002 0000000000000082 0000000000000001 0000000000000000
  Call Trace:
   [<ffffffff810312f9>] __wake_up_common+0x59/0x90
   [<ffffffff81035263>] __wake_up_sync_key+0x53/0x80
   [<ffffffff810352a0>] __wake_up_sync+0x10/0x20
   [<ffffffff8105a984>] task_clear_jobctl_trapping+0x44/0x50
   [<ffffffff8105bcbc>] ptrace_stop+0x7c/0x290
   [<ffffffff8105c20a>] do_signal_stop+0x28a/0x2d0
   [<ffffffff8105d27f>] get_signal_to_deliver+0x14f/0x5a0
   [<ffffffff81002175>] do_signal+0x75/0x7b0
   [<ffffffff8100292d>] do_notify_resume+0x5d/0x70
   [<ffffffff8182e36a>] retint_signal+0x46/0x8c
  Code: 00 00 55 48 89 e5 53 48 83 ec 08 0f 1f 44 00 00 8b 47 d8 83 f8 03 74 3a 85 c0 49 89 c8 75 23 89 c0 48 8b 5f e0 4c 8d 0c 40 31 c0 <4b> 39 9c c8 d8 02 00 00 74 1d 48 83 c4 08 5b c9 c3 66 0f 1f 44

Fix it by using __wake_up_sync_key() and passing in the child as @key.

I still think it's a mistake to piggyback on wait_chldexit for this.
Given the relative low frequency of ptrace use, we would be much
better off leaving already complex wait_chldexit alone and using bit
waitqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/kernel/signal.c
===================================================================
--- work.orig/kernel/signal.c
+++ work/kernel/signal.c
@@ -238,8 +238,8 @@ static void task_clear_group_stop_trappi
 {
 	if (unlikely(task->group_stop & GROUP_STOP_TRAPPING)) {
 		task->group_stop &= ~GROUP_STOP_TRAPPING;
-		__wake_up_sync(&task->parent->signal->wait_chldexit,
-			       TASK_UNINTERRUPTIBLE, 1);
+		__wake_up_sync_key(&task->parent->signal->wait_chldexit,
+				   TASK_UNINTERRUPTIBLE, 1, task);
 	}
 }
 
