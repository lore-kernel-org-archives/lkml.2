Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1EaR3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:29:24 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5160 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1EaR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:29:22 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM2LWT-01-4H4-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <stable@kernel.org>
Subject: [PATCH 3/3] oprofile, dcookies: Fix possible circular locking
Date: Tue, 31 May 2011 18:46:46 +0200
Message-ID: <1306860406-6094-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
References: <1306860406-6094-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockdep warning below detects a possible A->B/B->A locking
dependency of mm->mmap_sem and dcookie_mutex. The order in
sync_buffer() is mm->mmap_sem/dcookie_mutex, while in
sys_lookup_dcookie() it is vice versa.

Fixing it in sys_lookup_dcookie() by unlocking dcookie_mutex before
copy_to_user().

oprofiled/4432 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff810b444b>] might_fault+0x53/0xa3

but task is already holding lock:
 (dcookie_mutex){+.+.+.}, at: [<ffffffff81124d28>] sys_lookup_dcookie+0x45/0x149

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (dcookie_mutex){+.+.+.}:
       [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
       [<ffffffff814634f0>] mutex_lock_nested+0x63/0x309
       [<ffffffff81124e5c>] get_dcookie+0x30/0x144
       [<ffffffffa0000fba>] sync_buffer+0x196/0x3ec [oprofile]
       [<ffffffffa0001226>] task_exit_notify+0x16/0x1a [oprofile]
       [<ffffffff81467b96>] notifier_call_chain+0x37/0x63
       [<ffffffff8105803d>] __blocking_notifier_call_chain+0x50/0x67
       [<ffffffff81058068>] blocking_notifier_call_chain+0x14/0x16
       [<ffffffff8105a718>] profile_task_exit+0x1a/0x1c
       [<ffffffff81039e8f>] do_exit+0x2a/0x6fc
       [<ffffffff8103a5e4>] do_group_exit+0x83/0xae
       [<ffffffff8103a626>] sys_exit_group+0x17/0x1b
       [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

-> #0 (&mm->mmap_sem){++++++}:
       [<ffffffff81064dfb>] __lock_acquire+0x1085/0x1711
       [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
       [<ffffffff810b4478>] might_fault+0x80/0xa3
       [<ffffffff81124de7>] sys_lookup_dcookie+0x104/0x149
       [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by oprofiled/4432:
 #0:  (dcookie_mutex){+.+.+.}, at: [<ffffffff81124d28>] sys_lookup_dcookie+0x45/0x149

stack backtrace:
Pid: 4432, comm: oprofiled Not tainted 2.6.39-00008-ge5a450d #9
Call Trace:
 [<ffffffff81063193>] print_circular_bug+0xae/0xbc
 [<ffffffff81064dfb>] __lock_acquire+0x1085/0x1711
 [<ffffffff8102ef13>] ? get_parent_ip+0x11/0x42
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff810d7d54>] ? path_put+0x22/0x27
 [<ffffffff810b4478>] might_fault+0x80/0xa3
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff81124de7>] sys_lookup_dcookie+0x104/0x149
 [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

References: https://bugzilla.kernel.org/show_bug.cgi?id=13809
Cc: <stable@kernel.org> # .27+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 fs/dcookies.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index a21cabd..dda0dc7 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -178,6 +178,8 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 	/* FIXME: (deleted) ? */
 	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
+	mutex_unlock(&dcookie_mutex);
+
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
 		goto out_free;
@@ -194,6 +196,7 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cookie64, char __user * buf, size_t len)
 
 out_free:
 	kfree(kbuf);
+	return err;
 out:
 	mutex_unlock(&dcookie_mutex);
 	return err;
-- 
1.7.5.rc3


