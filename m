Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab1ANMQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 07:16:51 -0500
Received: from shutemov.name ([188.40.19.243]:38531 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062Ab1ANMQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 07:16:44 -0500
From: "Kirill A. Shutemov" <kas@openvz.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kas@openvz.org>
Subject: [PATCH] list_bl: fix oops on UP with DEBUG_SPINLOCK
Date: Fri, 14 Jan 2011 14:16:39 +0200
Message-Id: <1295007399-7279-1-git-send-email-kas@openvz.org>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch partly reverts 2c6755988a.

spin_[un]lock_bucket() uses bit_spin_[un]lock() to set/clear first
bit of ->head.first. bit_spin_[un]lock() touches the bit on UP if
DEBUG_SPINLOCK enabled.

So we have to define LIST_BL_LOCKMASK to 1, if DEBUG_SPINLOCK enabled.
Other way is reimplementation of spin_[un]lock_bucket().

[    0.140008] BUG: unable to handle kernel NULL pointer dereference at 00000005
[    0.140008] IP: [<c10a7cdf>] __d_rehash+0x6f/0xc0
[    0.140008] *pde = 00000000
[    0.140008] Oops: 0002 [#1]
[    0.140008] last sysfs file:
[    0.140008] Modules linked in:
[    0.140008]
[    0.140008] Pid: 1, comm: swapper Not tainted 2.6.37+ #150 /Bochs
[    0.140008] EIP: 0060:[<c10a7cdf>] EFLAGS: 00010202 CPU: 0
[    0.140008] EIP is at __d_rehash+0x6f/0xc0
[    0.140008] EAX: 00000022 EBX: c7402460 ECX: 00000000 EDX: c7402468
[    0.140008] ESI: c7ee157c EDI: 00000001 EBP: c782bedc ESP: c782bec4
[    0.140008]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    0.140008] Process swapper (pid: 1, ti=c782a000 task=c7830000 task.ti=c782a000)
[    0.140008] Stack:
[    0.140008]  c13b698f 00000001 c7402468 02eef038 c7402460 c7402460 c782bee8 c10a7d69
[    0.140008]  c74024b0 c782bef8 c10a7d90 c7402460 c7400430 c782bf04 c10b32f4 c1304380
[    0.140008]  c782bf1c c109dcd2 00000000 00000000 c74023c0 c7400430 c782bf3c c109df85
[    0.140008] Call Trace:
[    0.140008]  [<c10a7d69>] _d_rehash+0x39/0x40
[    0.140008]  [<c10a7d90>] d_rehash+0x20/0x40
[    0.140008]  [<c10b32f4>] simple_lookup+0x34/0x40
[    0.140008]  [<c109dcd2>] d_alloc_and_lookup+0x32/0x60
[    0.140008]  [<c109df85>] __lookup_hash+0xc5/0x160
[    0.140008]  [<c109f2ae>] lookup_one_len+0x8e/0xe0
[    0.140008]  [<c111e997>] debugfs_create_file+0x77/0x200
[    0.140008]  [<c11bc7c9>] ? __class_create+0x29/0x80
[    0.140008]  [<c143f6ec>] ? kernel_init+0x0/0x120
[    0.140008]  [<c111ebb1>] debugfs_create_dir+0x21/0x30
[    0.140008]  [<c144c256>] bdi_class_init+0x33/0x3c
[    0.140008]  [<c1001100>] do_one_initcall+0x30/0x160
[    0.140008]  [<c144c223>] ? bdi_class_init+0x0/0x3c
[    0.140008]  [<c143f6ec>] ? kernel_init+0x0/0x120
[    0.140008]  [<c143f778>] kernel_init+0x8c/0x120
[    0.140008]  [<c1003096>] kernel_thread_helper+0x6/0x10
[    0.140008] Code: 9e d0 3d c1 e8 19 14 25 00 8b 3e 8d 53 08 89 55 f0 89 7c 24 04 c7 04 24 8f 69 3b c1 e8 01 14 25 00 85 ff 8b 55 f0 89 7b 08 74 03 <89> 57 04 89 73 0c 89 16 c7 04 24 6c dc 3d c1 e8 e3 13 25 00 8b
[    0.140008] EIP: [<c10a7cdf>] __d_rehash+0x6f/0xc0 SS:ESP 0068:c782bec4
[    0.140008] CR2: 0000000000000005
[    0.144008] ---[ end trace 4eaa2a86a8e2da22 ]---

Signed-off-by: Kirill A. Shutemov <kas@openvz.org>
---
 include/linux/list_bl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index b2adbb4..5bad17d 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -16,7 +16,7 @@
  * some fast and compact auxiliary data.
  */
 
-#if defined(CONFIG_SMP)
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 #define LIST_BL_LOCKMASK	1UL
 #else
 #define LIST_BL_LOCKMASK	0UL
-- 
1.7.3.4

