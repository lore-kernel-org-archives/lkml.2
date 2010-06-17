Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665Ab0FQByY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:54:24 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39277 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353Ab0FQBvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:51:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 4/9] oom: oom_kill_process() need to check p is unkillable
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100617104311.FB7A.A69D9226@jp.fujitsu.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com>
Message-Id: <20100617104647.FB89.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 17 Jun 2010 10:51:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When oom_kill_allocating_task is enabled, an argument task of
oom_kill_process is not selected by select_bad_process(), It's
just out_of_memory() caller task. It mean the task can be
unkillable. check it first.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index afcbf17..541a59b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -687,7 +687,8 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	check_panic_on_oom(constraint, gfp_mask, order);
 
 	read_lock(&tasklist_lock);
-	if (sysctl_oom_kill_allocating_task) {
+	if (sysctl_oom_kill_allocating_task &&
+	    !oom_unkillable_task(current, NULL, nodemask)) {
 		/*
 		 * oom_kill_process() needs tasklist_lock held.  If it returns
 		 * non-zero, current could not be killed so we must fallback to
-- 
1.6.5.2



