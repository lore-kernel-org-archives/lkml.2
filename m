Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0FDKy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:54:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab0FDKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:54:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 13/12] oom: dump_header() need tasklist_lock
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20100603152652.GA8743@redhat.com>
References: <20100603152350.725F.A69D9226@jp.fujitsu.com> <20100603152652.GA8743@redhat.com>
Message-Id: <20100604120844.72A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Jun 2010 19:54:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (off-topic)
> 
> out_of_memory() calls dump_header()->dump_tasks() lockless, we
> need tasklist.

Makes perfectly sense. Thank you!


================================================================
Commit 1b604d75(oom: dump stack and VM state when oom killer panics)
added dump_header() call to three places. But It forgot to add
the tasklist_lock. Now, dump_header() is called without the lock.
It is obviously inadequate.

This patch fixes it.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ad85e1b..2678a04 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -600,8 +600,8 @@ retry:
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		read_unlock(&tasklist_lock);
 		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
 
@@ -633,7 +633,9 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		return;
 
 	if (sysctl_panic_on_oom == 2) {
+		read_lock(&tasklist_lock);
 		dump_header(NULL, gfp_mask, order, NULL);
+		read_unlock(&tasklist_lock);
 		panic("out of memory. Compulsory panic_on_oom is selected.\n");
 	}
 
@@ -664,6 +666,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	case CONSTRAINT_NONE:
 		if (sysctl_panic_on_oom) {
 			dump_header(NULL, gfp_mask, order, NULL);
+			read_unlock(&tasklist_lock);
 			panic("out of memory. panic_on_oom is selected\n");
 		}
 		/* Fall-through */
-- 
1.6.5.2





