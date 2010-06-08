Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0FHL7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:59:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0FHL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:59:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 06/10] oom: cleanup has_intersects_mems_allowed()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205829.768C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:59:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now has_intersects_mems_allowed() has own thread iterate logic, but
it should use while_each_thread().

It slightly improve the code readability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b88172c..8376ad1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -38,16 +38,14 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 /*
  * Is all threads of the target process nodes overlap ours?
  */
-static int has_intersects_mems_allowed(struct task_struct *tsk)
+static int has_intersects_mems_allowed(struct task_struct *p)
 {
-	struct task_struct *t;
+	struct task_struct *t = p;
 
-	t = tsk;
 	do {
 		if (cpuset_mems_allowed_intersects(current, t))
 			return 1;
-		t = next_thread(t);
-	} while (t != tsk);
+	} while_each_thread(p, t);
 
 	return 0;
 }
-- 
1.6.5.2



