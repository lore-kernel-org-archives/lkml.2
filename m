Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1GABBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:01:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32784 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1GABBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:01:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 1 Jul 2011 09:54:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-06-30-15-59 uploaded (mm/memcontrol.c)
Message-Id: <20110701095433.71c2aa18.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110701091525.bd8095f1.kamezawa.hiroyu@jp.fujitsu.com>
References: <201106302259.p5UMxh5i019162@imap1.linux-foundation.org>
	<20110630172054.49287627.randy.dunlap@oracle.com>
	<20110701091525.bd8095f1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 09:15:25 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 30 Jun 2011 17:20:54 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Thu, 30 Jun 2011 15:59:43 -0700 akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2011-06-30-15-59 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > >    git://zen-kernel.org/kernel/mmotm.git
> > > or
> > >    git://git.cmpxchg.org/linux-mmotm.git
> > > 
> > > It contains the following patches against 3.0-rc5:
> > 
> > I see several of these build errors:
> > 
> > mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
> > mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
> > 
> 
> Thanks...maybe !CONFIG_NUMA again. will post a fix soon.
> 

fix here. compiled and booted on !CONFIG_NUMA on my host.
I think I should do total cleanup of functions in mm/memcontrol.c 
in the next week..several functions implements similar logics....
==
>From 8773fc8b596dc56adf52fd0780c1b034291185ee Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 1 Jul 2011 09:49:54 +0900
Subject: [PATCH]memcg-fix-reclaimable-lru-check-in-memcg-fix2.patch


 memcg-fix-reclaimable-lru-check-in-memcg.patch
 causes following error with !CONFIG_NUMA.

> mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
> mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
>

This patch fixes it by moving functions out of #ifdef.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db70176..fb7338f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1134,7 +1134,6 @@ unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
-#ifdef CONFIG_NUMA
 static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
 							int nid)
 {
@@ -1146,6 +1145,17 @@ static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
 	return ret;
 }
 
+static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	unsigned long ret;
+
+	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
+		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
+	return ret;
+}
+
+#if MAX_NUMNODES > 1
 static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
 {
 	u64 total = 0;
@@ -1157,17 +1167,6 @@ static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
 	return total;
 }
 
-static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
-							int nid)
-{
-	unsigned long ret;
-
-	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
-		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
-
-	return ret;
-}
-
 static unsigned long mem_cgroup_nr_anon_lru_pages(struct mem_cgroup *memcg)
 {
 	u64 total = 0;
-- 
1.7.4.1




