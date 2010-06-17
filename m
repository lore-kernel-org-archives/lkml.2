Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab0FQBxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:53:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34394 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab0FQBvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 6/9] oom: unify CAP_SYS_RAWIO check into other superuser check
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100617104311.FB7A.A69D9226@jp.fujitsu.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com>
Message-Id: <20100617104756.FB8F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, CAP_SYS_RAWIO check is very strange. if the user have both
CAP_SYS_ADMIN and CAP_SYS_RAWIO, points will makes 1/16.

Superuser's 1/4 bonus worthness is quite a bit dubious, but
considerable. However 1/16 is obviously insane.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b27db90..7f91151 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -199,19 +199,14 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 
 	/*
 	 * Superuser processes are usually more important, so we make it
-	 * less likely that we kill those.
+	 * less likely that we kill those. And we don't want to kill a
+	 * process with direct hardware access. Not only could that mess
+	 * up the hardware, but usually users tend to only have this
+	 * flag set on applications they think of as important.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
-	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
-		points /= 4;
-
-	/*
-	 * We don't want to kill a process with direct hardware access.
-	 * Not only could that mess up the hardware, but usually users
-	 * tend to only have this flag set on applications they think
-	 * of as important.
-	 */
-	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
+	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
+	    has_capability_noaudit(p, CAP_SYS_RAWIO))
 		points /= 4;
 
 	/*
-- 
1.6.5.2



