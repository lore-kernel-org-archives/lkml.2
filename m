Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1A0A7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:59:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43149 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1A0A7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:59:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 09:53:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [BUGFIX] memcg: fix res_counter_read_u64 lock aware (Was Re:
 [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110127095342.3d81cf5f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
	<20110126183023.GB2401@cmpxchg.org>
	<xr9362tbl83f.fsf@gthelen.mtv.corp.google.com>
	<20110126142909.0b710a0c.akpm@linux-foundation.org>
	<20110127092434.df18c7a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 09:24:34 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote: > 
> 
> I'll review. Against the roll-over, I think we just need to take lock.
> So, res_counter_read_u64() implementation was wrong. It should take lock.
> Please give me time.
> 

As far as I can see usages of return value of res_counter_read_u64()
in memcontrol.c, all values are handle in u64 and no >> PAGE_SHIFT
to 'int' is not done. I'll see usage of u64 return value to
functions in other files from memcontrol.c

But, at least, this patch is required, I think. There are races.

==
res_counter_read_u64 reads u64 value without lock. It's dangerous
in 32bit environment. This patch adds lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/res_counter.h |   13 ++++++++++++-
 kernel/res_counter.c        |    2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

Index: mmotm-0125/include/linux/res_counter.h
===================================================================
--- mmotm-0125.orig/include/linux/res_counter.h
+++ mmotm-0125/include/linux/res_counter.h
@@ -68,7 +68,18 @@ struct res_counter {
  * @pos:     and the offset.
  */
 
-u64 res_counter_read_u64(struct res_counter *counter, int member);
+u64 res_counter_read_u64_locked(struct res_counter *counter, int member);
+
+static inline u64 res_counter_read_u64(struct res_counter *counter, int member)
+{
+	unsigned long flags;
+	u64 ret;
+
+	spin_lock_irqsave(&counter->lock, flags);
+	ret = res_counter_read_u64_locked(counter, member);
+	spin_unlock_irqrestore(&counter->lock, flags);
+	return ret;
+}
 
 ssize_t res_counter_read(struct res_counter *counter, int member,
 		const char __user *buf, size_t nbytes, loff_t *pos,
Index: mmotm-0125/kernel/res_counter.c
===================================================================
--- mmotm-0125.orig/kernel/res_counter.c
+++ mmotm-0125/kernel/res_counter.c
@@ -126,7 +126,7 @@ ssize_t res_counter_read(struct res_coun
 			pos, buf, s - buf);
 }
 
-u64 res_counter_read_u64(struct res_counter *counter, int member)
+u64 res_counter_read_u64_locked(struct res_counter *counter, int member)
 {
 	return *res_counter_member(counter, member);
 }

