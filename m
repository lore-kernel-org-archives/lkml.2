Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1CREGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:06:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab1CREGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:06:45 -0400
Message-ID: <4D82DABD.7050208@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:08:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/36] perf,rcu: convert call_rcu(swevent_hlist_release_rcu)
 to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:05:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:05:22,
	Serialize complete at 2011-03-18 12:05:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback swevent_hlist_release_rcu() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(swevent_hlist_release_rcu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/perf_event.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b0581bd..43b0410 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5300,14 +5300,6 @@ swevent_hlist_deref(struct swevent_htable *swhash)
 					 lockdep_is_held(&swhash->hlist_mutex));
 }
 
-static void swevent_hlist_release_rcu(struct rcu_head *rcu_head)
-{
-	struct swevent_hlist *hlist;
-
-	hlist = container_of(rcu_head, struct swevent_hlist, rcu_head);
-	kfree(hlist);
-}
-
 static void swevent_hlist_release(struct swevent_htable *swhash)
 {
 	struct swevent_hlist *hlist = swevent_hlist_deref(swhash);
@@ -5316,7 +5308,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
 		return;
 
 	rcu_assign_pointer(swhash->swevent_hlist, NULL);
-	call_rcu(&hlist->rcu_head, swevent_hlist_release_rcu);
+	kfree_rcu(hlist, rcu_head);
 }
 
 static void swevent_hlist_put_cpu(struct perf_event *event, int cpu)
-- 
1.7.4
