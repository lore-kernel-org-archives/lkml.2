Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1A0Bto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:49:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56036 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab1A0Btm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:49:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 10:43:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [BUGFIX v2] memcg: fix res_counter_read_u64 lock aware (Was Re:
 [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110127104339.0f580bac.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
	<20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for advices. This version doesn't use inlined function
and adds no overhead in 64bit.

Info:
res_counter_read_u64 is not frequently called in memcontrol.c now.
It's called at user-interface and interaction with other components.
This addition of lock will not add any performance troubles.

==
res_counter_read_u64 reads u64 value without lock. It's dangerous
in 32bit environment. This patch adds lock.

Changelog:
 - handle 32/64 bit in other funciton
 - avoid unnecessary inlining.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 kernel/res_counter.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: mmotm-0125/kernel/res_counter.c
===================================================================
--- mmotm-0125.orig/kernel/res_counter.c
+++ mmotm-0125/kernel/res_counter.c
@@ -126,10 +126,24 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
+#if BITS_PER_LONG == 32
+u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	unsigned long flags;
+	u64 ret;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = *res_counter_member(counter, member);
+	spin_unlock_irqrestore(&counter->lock, flags);
+
+	return ret;
+}
+#else
 u64 res_counter_read_u64(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }
+#endif
 
 int res_counter_memparse_write_strategy(const char *buf,
 					unsigned long long *res)

