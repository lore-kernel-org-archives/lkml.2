Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1BAAfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:35:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44506 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab1BAAfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:35:06 -0500
Date: Tue, 1 Feb 2011 01:34:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] memcg: prevent endless loop when charging huge pages
 to near-limit group
Message-ID: <20110201003451.GC19534@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
 <1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
 <20110131144131.6733aa3a.akpm@linux-foundation.org>
 <20110201000455.GB19534@cmpxchg.org>
 <20110131162448.e791f0ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131162448.e791f0ae.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:24:48PM -0800, Andrew Morton wrote:
> On Tue, 1 Feb 2011 01:04:55 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> > @@ -182,6 +182,14 @@ static inline bool res_counter_check_under_limit(struct res_counter *cnt)
> >  	return ret;
> >  }
> >  
> > +/**
> > + * res_counter_check_margin - check if the counter allows charging
> > + * @cnt: the resource counter to check
> > + * @bytes: the number of bytes to check the remaining space against
> > + *
> > + * Returns a boolean value on whether the counter can be charged
> > + * @bytes or whether this would exceed the limit.
> > + */
> >  static inline bool res_counter_check_margin(struct res_counter *cnt,
> >  					    unsigned long bytes)
> >  {
> 
> mem_cgroup_check_margin() needs some lipstick too.

*oink*

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9e5de7c..6c07554 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1111,6 +1111,14 @@ static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
 	return false;
 }
 
+/**
+ * mem_cgroup_check_margin - check if the memory cgroup allows charging
+ * @mem: memory cgroup to check
+ * @bytes: the number of bytes the caller intends to charge
+ *
+ * Returns a boolean value on whether @mem can be charged @bytes or
+ * whether this would exceed the limit.
+ */
 static bool mem_cgroup_check_margin(struct mem_cgroup *mem, unsigned long bytes)
 {
 	if (!res_counter_check_margin(&mem->res, bytes))
