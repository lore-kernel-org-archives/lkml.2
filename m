Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0IXApj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:45:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58640 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0IXApi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:45:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Sep 2010 09:40:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: + memcg-use-for_each_mem_cgroup.patch added to -mm tree
Message-Id: <20100924094006.a4c63cf8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201009211936.o8LJaaRO030096@imap1.linux-foundation.org>
References: <201009211936.o8LJaaRO030096@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 12:36:35 -0700
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      memcg: use for_each_mem_cgroup
> has been added to the -mm tree.  Its filename is
>      memcg-use-for_each_mem_cgroup.patch
> 

This is a bug fix for this patch. Wrote onto mmotm-0922.
I'm sorry that test was not enough.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memcg-use-for_each_mem_cgroup.patch's function mem_cgroup_start_loop() is
wrong because it always scan IDs larger than ROOT of sub-tree.
(This works well in small test..)

css_get_next() scans IDs larger than given number. Then...

Assume a tree like this.

	Root(id=1)--A(id=2)
		  |
		  --B(id=3)--C(id=4)
			   |
			   --D(id=5)

In above case, searching all cgroup under "B" works well because
all IDs larger than B will be visited. (3->4->5)

Here, rmdir "A" and mkdir "E" under "B".

       Root(id=1)--B(id=3)--C(id=4)
			  |
			  --D(id=5)
			  |
			  --E(id=2) /* reuse freed ID */

E's ID is smaller than B's. But, the function just visits (3->4->5)

All scan should be started from 1. Fixed routine will visit (2->3->4->5).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

Index: mmotm-0922/mm/memcontrol.c
===================================================================
--- mmotm-0922.orig/mm/memcontrol.c
+++ mmotm-0922/mm/memcontrol.c
@@ -697,12 +697,28 @@ static struct mem_cgroup *try_get_mem_cg
 /* The caller has to guarantee "mem" exists before calling this */
 static struct mem_cgroup *mem_cgroup_start_loop(struct mem_cgroup *mem)
 {
-	if (mem && css_tryget(&mem->css))
-		return mem;
-	if (!mem)
-		return root_mem_cgroup; /*css_put/get against root is ignored*/
+	struct cgroup_subsys_state *css;
+	int found;
 
-	return NULL;
+	if (!mem) /* ROOT cgroup has the smallest ID */
+		return root_mem_cgroup; /*css_put/get against root is ignored*/
+	if (!mem->use_hierarchy) {
+		if (css_tryget(&mem->css))
+			return mem;
+		return NULL;
+	}
+	rcu_read_lock();
+	/*
+	 * searching a memory cgroup which has the smallest ID under given
+	 * ROOT cgroup. (ID >= 1)
+	 */
+	css = css_get_next(&mem_cgroup_subsys, 1, mem, &found);
+	if (css && css_tryget(&css))
+		mem = container_of(css, struct mem_cgroup, css);
+	else
+		mem = NULL;
+	rcu_read_unlock();
+	return mem;
 }
 
 static struct mem_cgroup *mem_cgroup_get_next(struct mem_cgroup *iter,

