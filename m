Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2HMLO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:14:57 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51551 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2HMLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:14:55 -0400
Message-ID: <5028E1A8.4010402@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:14:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 05/12] thp: remove wake_up_interruptible in the exit path
References: <5028E12C.70101@linux.vnet.ibm.com>
In-Reply-To: <5028E12C.70101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-2674-0000-0000-00000594BE93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the check of kthread_should_stop() to the conditions which are used
to wakeup on khugepaged_wait, then kthread_stop is enough to let the
thread exit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 mm/huge_memory.c |   35 +++++++++++++++++++++--------------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b218700..86f71af 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -154,8 +154,6 @@ static int start_khugepaged(void)

 		set_recommended_min_free_kbytes();
 	} else if (khugepaged_thread) {
-		/* wakeup to exit */
-		wake_up_interruptible(&khugepaged_wait);
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
@@ -2236,7 +2234,7 @@ static int khugepaged_has_work(void)
 static int khugepaged_wait_event(void)
 {
 	return !list_empty(&khugepaged_scan.mm_head) ||
-		!khugepaged_enabled();
+		kthread_should_stop();
 }

 static void khugepaged_do_scan(struct page **hpage)
@@ -2303,6 +2301,24 @@ static struct page *khugepaged_alloc_hugepage(void)
 }
 #endif

+static void khugepaged_wait_work(void)
+{
+	try_to_freeze();
+
+	if (khugepaged_has_work()) {
+		if (!khugepaged_scan_sleep_millisecs)
+			return;
+
+		wait_event_freezable_timeout(khugepaged_wait,
+					     kthread_should_stop(),
+			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
+		return;
+	}
+
+	if (khugepaged_enabled())
+		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
+}
+
 static void khugepaged_loop(void)
 {
 	struct page *hpage;
@@ -2327,17 +2343,8 @@ static void khugepaged_loop(void)
 		if (hpage)
 			put_page(hpage);
 #endif
-		try_to_freeze();
-		if (unlikely(kthread_should_stop()))
-			break;
-		if (khugepaged_has_work()) {
-			if (!khugepaged_scan_sleep_millisecs)
-				continue;
-			wait_event_freezable_timeout(khugepaged_wait, false,
-			    msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
-		} else if (khugepaged_enabled())
-			wait_event_freezable(khugepaged_wait,
-					     khugepaged_wait_event());
+
+		khugepaged_wait_work();
 	}
 }

-- 
1.7.7.6

