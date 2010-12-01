Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab0LAF3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:29:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58759 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LAF3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:29:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/2] ksm: annotate ksm_thread_mutex is no deadlock source
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101026163218.B7BF.A69D9226@jp.fujitsu.com>
References: <alpine.LSU.2.00.1010252248210.2939@sister.anvils> <20101026163218.B7BF.A69D9226@jp.fujitsu.com>
Message-Id: <20101201143008.ABCE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 14:29:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 62b61f611e(ksm: memory hotremove migration only) made following
new lockdep warning.

  =======================================================
  [ INFO: possible circular locking dependency detected ]
  -------------------------------------------------------
  bash/1621 is trying to acquire lock:
   ((memory_chain).rwsem){.+.+.+}, at: [<ffffffff81079339>]
  __blocking_notifier_call_chain+0x69/0xc0

  but task is already holding lock:
   (ksm_thread_mutex){+.+.+.}, at: [<ffffffff8113a3aa>]
  ksm_memory_callback+0x3a/0xc0

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (ksm_thread_mutex){+.+.+.}:
       [<ffffffff8108b70a>] lock_acquire+0xaa/0x140
       [<ffffffff81505d74>] __mutex_lock_common+0x44/0x3f0
       [<ffffffff81506228>] mutex_lock_nested+0x48/0x60
       [<ffffffff8113a3aa>] ksm_memory_callback+0x3a/0xc0
       [<ffffffff8150c21c>] notifier_call_chain+0x8c/0xe0
       [<ffffffff8107934e>] __blocking_notifier_call_chain+0x7e/0xc0
       [<ffffffff810793a6>] blocking_notifier_call_chain+0x16/0x20
       [<ffffffff813afbfb>] memory_notify+0x1b/0x20
       [<ffffffff81141b7c>] remove_memory+0x1cc/0x5f0
       [<ffffffff813af53d>] memory_block_change_state+0xfd/0x1a0
       [<ffffffff813afd62>] store_mem_state+0xe2/0xf0
       [<ffffffff813a0bb0>] sysdev_store+0x20/0x30
       [<ffffffff811bc116>] sysfs_write_file+0xe6/0x170
       [<ffffffff8114f398>] vfs_write+0xc8/0x190
       [<ffffffff8114fc14>] sys_write+0x54/0x90
       [<ffffffff810028b2>] system_call_fastpath+0x16/0x1b

  -> #0 ((memory_chain).rwsem){.+.+.+}:
       [<ffffffff8108b5ba>] __lock_acquire+0x155a/0x1600
       [<ffffffff8108b70a>] lock_acquire+0xaa/0x140
       [<ffffffff81506601>] down_read+0x51/0xa0
       [<ffffffff81079339>] __blocking_notifier_call_chain+0x69/0xc0
       [<ffffffff810793a6>] blocking_notifier_call_chain+0x16/0x20
       [<ffffffff813afbfb>] memory_notify+0x1b/0x20
       [<ffffffff81141f1e>] remove_memory+0x56e/0x5f0
       [<ffffffff813af53d>] memory_block_change_state+0xfd/0x1a0
       [<ffffffff813afd62>] store_mem_state+0xe2/0xf0
       [<ffffffff813a0bb0>] sysdev_store+0x20/0x30
       [<ffffffff811bc116>] sysfs_write_file+0xe6/0x170
       [<ffffffff8114f398>] vfs_write+0xc8/0x190
       [<ffffffff8114fc14>] sys_write+0x54/0x90
       [<ffffffff810028b2>] system_call_fastpath+0x16/0x1b

But it's false positive. Both memory_chain.rwsem and ksm_thread_mutex
have outer lock (mem_hotplug_mutex). then, they can't make deadlock.

Thus, This patch annotate ksm_thread_mutex is not deadlock source.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/ksm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 65ab5c7..5aa4900 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1724,8 +1724,10 @@ static int ksm_memory_callback(struct notifier_block *self,
 		/*
 		 * Keep it very simple for now: just lock out ksmd and
 		 * MADV_UNMERGEABLE while any memory is going offline.
+		 * Mutex_lock_nested() is necessary to tell that
+		 * ksm_thread_mutex is not unlocked here intentionally.
 		 */
-		mutex_lock(&ksm_thread_mutex);
+		mutex_lock_nested(&ksm_thread_mutex, SINGLE_DEPTH_NESTING);
 		break;
 
 	case MEM_OFFLINE:
-- 
1.6.5.2



