Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2DWVp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:45:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5836 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab2DWVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:45:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6690"; a="184252303"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] spinlock_debug: Print kallsyms name for lock
Date: Mon, 23 Apr 2012 14:45:25 -0700
Message-Id: <1335217525-30709-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.10.227.gd1ca7
In-Reply-To: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
References: <1335217525-30709-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a spinlock warning is printed we usually get

 BUG: spinlock bad magic on CPU#0, modprobe/111
  lock: 0xdff09f38, .magic: 00000000, .owner: /0, .owner_cpu: 0

but it's nicer to print the symbol for the lock if we have it so
that we can avoid 'grep dff09f38 /proc/kallsyms' to find out
which lock it was. Use kallsyms to print the symbol name so we
get something a bit easier to read

 BUG: spinlock bad magic on CPU#0, modprobe/112
  lock: test_lock, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0

If the lock is not in kallsyms %ps will fall back to printing the address
directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 lib/spinlock_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 525d160..d0ec4f3 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -58,7 +58,7 @@ static void spin_dump(raw_spinlock_t *lock, const char *msg)
 	printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
-	printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
+	printk(KERN_EMERG " lock: %ps, .magic: %08x, .owner: %s/%d, "
 			".owner_cpu: %d\n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

