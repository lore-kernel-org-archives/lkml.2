Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2JOHUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:20:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:46121 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2JOHUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="205671746"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "ccross@android.com" <ccross@android.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Zhang, Di" <di.zhang@intel.com>, "Ma, Xindong" <xindong.ma@intel.com>,
        "Zuo, Alex" <alex.zuo@intel.com>
Subject: Fix memory leak in binder--version2
Thread-Topic: Fix memory leak in binder--version2
Thread-Index: Ac2qoyERn9VOsHHUS6WvzdrsGtV9EAAAAtogAACO+HA=
Date: Mon, 15 Oct 2012 07:20:01 +0000
Message-ID: <EE928378561BF1449699C96571234A740FE67A7D@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FE67913@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <EE928378561BF1449699C96571234A740FE67913@SHSMSX102.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling kmemleak and run monkey, following memleak is reported:
unreferenced object 0xeed27f80 (size 64):
  comm "Binder_8", pid 641, jiffies 4294946341 (age 2275.810s)
  hex dump (first 32 bytes):
    4f dd 00 00 84 7f d2 ee 84 7f d2 ee 01 00 00 00  O...............
    00 00 00 00 00 00 00 00 00 aa 4c d7 00 00 00 00  ..........L.....
  backtrace:
    [<c184fabc>] kmemleak_alloc+0x3c/0xa0
    [<c12f391e>] kmem_cache_alloc_trace+0x9e/0x180
    [<c1668bb5>] binder_thread_write+0xcf5/0x23a0
    [<c166b091>] binder_ioctl+0x1f1/0x530
    [<c130dcf6>] do_vfs_ioctl+0x86/0x5e0
    [<c130e282>] sys_ioctl+0x32/0x60
    [<c1872e01>] syscall_call+0x7/0xb
    [<ffffffff>] 0xffffffff

The work item in async_todo list is not freed when binder released.
Also the async transaction should also be freed in binder_release_work.

Signed-off-by: Leon Ma <xindong.ma@intel.com>
Signed-off-by: Di Zhang <di.zhang@intel.com>
---
 drivers/staging/android/binder.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 7df2a89..022c9f8 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2509,6 +2509,11 @@ static void binder_release_work(struct list_head *list)
 			t = container_of(w, struct binder_transaction, work);
 			if (t->buffer->target_node && !(t->flags & TF_ONE_WAY))
 				binder_send_failed_reply(t, BR_DEAD_REPLY);
+			else {
+				t->buffer->transaction = NULL;
+				kfree(t);
+				binder_stats_deleted(BINDER_STAT_TRANSACTION);
+			}
 		} break;
 		case BINDER_WORK_TRANSACTION_COMPLETE: {
 			kfree(w);
@@ -2982,6 +2987,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
+		binder_release_work(&node->async_todo);
 		list_del_init(&node->work.entry);
 		if (hlist_empty(&node->refs)) {
 			kfree(node);
-- 
1.7.6

