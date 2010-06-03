Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208Ab0FCG1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:27:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54722 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab0FCG1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:27:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 12/12] oom: give current access to memory reserves if it has been killed
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603152653.726B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 15:27:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

It's possible to livelock the page allocator if a thread has
mm->mmap_sem and fails to make forward progress because the
oom killer selects another thread sharing the same ->mm to
kill that cannot exit until the semaphore is dropped.

The oom killer will not kill multiple tasks at the same time; each oom
killed task must exit before another task may be killed.  Thus, if one
thread is holding mm->mmap_sem and cannot allocate memory, all threads
sharing the same ->mm are blocked from exiting as well.  In the oom kill
case, that means the thread holding mm->mmap_sem will never free
additional memory since it cannot get access to memory reserves and the
thread that depends on it with access to memory reserves cannot exit
because it cannot acquire the semaphore.  Thus, the page allocators
livelocks.

When the oom killer is called and current happens to have a pending
SIGKILL, this patch automatically gives it access to memory reserves and
returns.  Upon returning to the page allocator, its allocation will
hopefully succeed so it can quickly exit and free its memory.  If not,
the page allocator will fail the allocation if it is not __GFP_NOFAIL.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 67b5fa5..ad85e1b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -638,6 +638,16 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	}
 
 	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_tsk_thread_flag(current, TIF_MEMDIE);
+		return;
+	}
+
+	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-- 
1.6.5.2



