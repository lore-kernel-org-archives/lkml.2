Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab2CNS6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:58:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64301 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2CNS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:58:48 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] vfs namespace: Don't assume mount namespace has valid root
Date: Wed, 14 Mar 2012 16:58:30 -0400
Message-Id: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the assumption that a mnt namespace will always have a valid
root object.

This fixes a NULL ptr deref on unshare():

[   23.652282] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[   23.653105] IP: [<ffffffff81201e67>] dup_mnt_ns.clone.15+0x37/0x2a0
[   23.653105] PGD 35dd2067 PUD 35dd3067 PMD 0
[   23.653105] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   23.653105] CPU 2
[   23.653105] Pid: 3068, comm: trinity Not tainted 3.3.0-rc6-next-20120309-sasha-00001-g10cf0bc-dirty #42
[   23.653105] RIP: 0010:[<ffffffff81201e67>]  [<ffffffff81201e67>] dup_mnt_ns.clone.15+0x37/0x2a0
[   23.653105] RSP: 0018:ffff880032b09e48  EFLAGS: 00010282
[   23.653105] RAX: ffffffff81201e67 RBX: ffff880032b14200 RCX: 0000000000000000
[   23.653105] RDX: ffffffff83cde6a0 RSI: ffffffff844ce960 RDI: 0000000000000282
[   23.653105] RBP: ffff880032b09ea8 R08: 0000000000000001 R09: 0000000000000000
[   23.653105] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   23.653105] R13: ffff8800368db000 R14: ffff880032b388e8 R15: 00007fffb6d26e78
[   23.653105] FS:  00007f89447c8700(0000) GS:ffff88003e200000(006b) knlGS:0000000000f50030
[   23.653105] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.666575] CR2: 0000000000000020 CR3: 0000000035df4000 CR4: 00000000000406e0
[   23.666575] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.666575] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.666575] Process trinity (pid: 3068, threadinfo ffff880032b08000, task ffff8800368db000)
[   23.666575] Stack:
[   23.666575]  00000000000000d0 ffff88003d82d488 ffff88003d3d6178 00000000000000d0
[   23.666575]  ffff880032b09ec8 ffffffff811c2983 ffffffff810de328 ffff880032b608e8
[   23.666575]  0000000004060a00 ffff8800368db000 ffff880032b14200 00007fffb6d26e78
[   23.666575] Call Trace:
[   23.666575]  [<ffffffff811c2983>] ? kmem_cache_alloc+0x123/0x180
[   23.666575]  [<ffffffff810de328>] ? finish_task_switch+0x78/0x100
[   23.666575]  [<ffffffff81202790>] copy_mnt_ns+0x30/0x50
[   23.666575]  [<ffffffff810d889d>] create_new_namespaces+0x5d/0x190
[   23.666575]  [<ffffffff810d8b93>] unshare_nsproxy_namespaces+0x63/0x90
[   23.666575]  [<ffffffff810adc07>] sys_unshare+0x107/0x240
[   23.666575]  [<ffffffff826f10fd>] system_call_fastpath+0x1a/0x1f
[   23.666575] Code: 49 89 fc 53 48 89 f3 48 83 ec 38 e8 f4 cb ff ff 49 89 c6 48 3d 00 f0 ff ff 0f 87 96 01 00 00 48 c7 c7 00 e9 4c 84 e8 49 b9 4e 01 <49> 8b 74 24 20 ba 05 00 00 00 4c 89 e7 e8 77 f3 ff ff 49 89 c5
[   23.666575] RIP  [<ffffffff81201e67>] dup_mnt_ns.clone.15+0x37/0x2a0
[   23.666575]  RSP <ffff880032b09e48>
[   23.666575] CR2: 0000000000000020
[   23.693853] ---[ end trace 1a8ec15272933df5 ]---

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/namespace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5a6208b..6b6bec7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2238,6 +2238,9 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	struct mount *old = mnt_ns->root;
 	struct mount *new;
 
+	if (old == NULL)
+		return ERR_PTR(-EINVAL);
+
 	new_ns = alloc_mnt_ns();
 	if (IS_ERR(new_ns))
 		return new_ns;
-- 
1.7.8.4

