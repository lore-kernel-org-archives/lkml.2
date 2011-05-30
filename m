Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1E3Ho0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:44:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49009 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab1E3HoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:44:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE34AD0.1060905@jp.fujitsu.com>
Date: Mon, 30 May 2011 16:44:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: Re: [PATCH v2 1/3] vmscan,memcg: memcg aware swap token
References: <4DD480DD.2040307@jp.fujitsu.com> <20110526133551.8c158f1c.akpm@linux-foundation.org>
In-Reply-To: <20110526133551.8c158f1c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CONFIG_CGROUPS=n:
> 
> mm/thrash.c: In function 'grab_swap_token':
> mm/thrash.c:73: error: implicit declaration of function 'css_put'
> 
> I don't think that adding a null stub for css_put() is the right fix
> here...

My bad. Following patch fixes this issue.

Thanks.



>From 6a824b46219cb2f11b125e9a33f65e0f01899d09 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 30 May 2011 15:47:32 +0900
Subject: [PATCH] swap-token: fix compilation error when CONFIG_CGROUPS=n

Andrew Morton pointed out css_put() is not defined when
CONFIG_CGROUPS=n.

: CONFIG_CGROUPS=n:
:
: mm/thrash.c: In function 'grab_swap_token':
: mm/thrash.c:73: error: implicit declaration of function 'css_put'

Thus, this patch move the whole logic into CONFIG_CGROUP_MEM_RES_CTLR
condtion.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/thrash.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/thrash.c b/mm/thrash.c
index 8832edb..cd06606 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -31,11 +31,28 @@ static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 struct mem_cgroup *swap_token_memcg;

+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = try_get_mem_cgroup_from_mm(mm);
+	if (memcg)
+		css_put(mem_cgroup_css(memcg));
+
+	return memcg;
+}
+#else
+static struct mem_cgroup* swap_token_memcg_from_mm(struct mm_struct *mm)
+{
+	return NULL;
+}
+#endif
+
 void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
 	unsigned int old_prio = mm->token_priority;
-	struct mem_cgroup *memcg;
 	static unsigned int global_faults;
 	static unsigned int last_aging;

@@ -93,12 +110,9 @@ out:

 replace_token:
 	mm->token_priority += 2;
-	memcg = try_get_mem_cgroup_from_mm(mm);
-	if (memcg)
-		css_put(mem_cgroup_css(memcg));
 	trace_replace_swap_token(swap_token_mm, mm);
 	swap_token_mm = mm;
-	swap_token_memcg = memcg;
+	swap_token_memcg = swap_token_memcg_from_mm(mm);
 	last_aging = global_faults;
 	goto out;
 }
-- 
1.7.3.1




