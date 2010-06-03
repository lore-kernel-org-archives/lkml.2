Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0FCI2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:28:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0FCI2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:28:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 3 Jun 2010 17:23:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH] memcg fix wake up in oom wait queue
Message-Id: <20100603172353.b5375879.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very sorry that my test wasn't enough and delayed.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

OOM-waitqueue should be waken up when oom_disable is canceled.
This is a fix for
 memcg-oom-kill-disable-and-oom-status.patch

How to test:
 Create a cgroup A...
 1. set memory.limit and memory.memsw.limit to be small value
 2. echo 1 > /cgroup/A/memory.oom_control, this disables oom-kill.
 3. run a program which must cause OOM.

A program executed in 3 will sleep by oom_waiqueue in memcg.
Then, how to wake it up is problem.

 1. echo 0 > /cgroup/A/memory.oom_control (enable OOM-killer)
 2. echo big mem > /cgroup/A/memory.memsw.limit_in_bytes(allow more swap)
etc..

Without the patch, a task in slept can not be waken up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: mmotm-2.6.34-May21/mm/memcontrol.c
===================================================================
--- mmotm-2.6.34-May21.orig/mm/memcontrol.c
+++ mmotm-2.6.34-May21/mm/memcontrol.c
@@ -1413,7 +1413,7 @@ static void memcg_wakeup_oom(struct mem_
 
 static void memcg_oom_recover(struct mem_cgroup *mem)
 {
-	if (mem->oom_kill_disable && atomic_read(&mem->oom_lock))
+	if (atomic_read(&mem->oom_lock))
 		memcg_wakeup_oom(mem);
 }
 
@@ -3830,6 +3830,8 @@ static int mem_cgroup_oom_control_write(
 		return -EINVAL;
 	}
 	mem->oom_kill_disable = val;
+	if (!val)
+		memcg_oom_recover(mem);
 	cgroup_unlock();
 	return 0;
 }

