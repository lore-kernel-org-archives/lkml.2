Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0F3J15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:27:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59778 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0F3J1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:27:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 02/11] oom: oom_kill_process() doesn't select kthread child
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630182715.AA4B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:27:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
doesn't. It mean oom_kill_process() may choose wrong task, especially,
when the child are using use_mm().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0aeacb2..dc8589e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -467,6 +467,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (child->mm == p->mm)
 				continue;
+			if (child->flags & PF_KTHREAD)
+				continue;
 			if (mem && !task_in_mem_cgroup(child, mem))
 				continue;
 			if (!has_intersects_mems_allowed(child, nodemask))
-- 
1.6.5.2



