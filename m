Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1CJHUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:20:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55194 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1CJHU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:20:26 -0500
Message-ID: <4D787C18.3070800@cn.fujitsu.com>
Date: Thu, 10 Mar 2011 15:22:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/3 V2] slub,rcu: don't assume the size of struct rcu_head
References: <4D6CA843.3090103@cn.fujitsu.com>
In-Reply-To: <4D6CA843.3090103@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 15:19:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 15:19:11,
	Serialize complete at 2011-03-10 15:19:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of struct rcu_head may be changed. When it becomes larger,
it will pollute the page array.

We reserve some some bytes for struct rcu_head when a slab
is allocated in this situation.

Changed from V1:
	use VM_BUG_ON instead BUG_ON

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/slub.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d3d1767..ebba3eb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1254,21 +1254,38 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_pages(page, order);
 }
 
+#define need_reserve_slab_rcu						\
+	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
+
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct page *page;
 
-	page = container_of((struct list_head *)h, struct page, lru);
+	if (need_reserve_slab_rcu)
+		page = virt_to_head_page(h);
+	else
+		page = container_of((struct list_head *)h, struct page, lru);
+
 	__free_slab(page->slab, page);
 }
 
 static void free_slab(struct kmem_cache *s, struct page *page)
 {
 	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
-		/*
-		 * RCU free overloads the RCU head over the LRU
-		 */
-		struct rcu_head *head = (void *)&page->lru;
+		struct rcu_head *head;
+
+		if (need_reserve_slab_rcu) {
+			int order = compound_order(page);
+			int offset = (PAGE_SIZE << order) - s->reserved;
+
+			VM_BUG_ON(s->reserved != sizeof(*head));
+			head = page_address(page) + offset;
+		} else {
+			/*
+			 * RCU free overloads the RCU head over the LRU
+			 */
+			head = (void *)&page->lru;
+		}
 
 		call_rcu(head, rcu_free_slab);
 	} else
@@ -2356,6 +2373,9 @@ static int kmem_cache_open(struct kmem_cache *s,
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 	s->reserved = 0;
 
+	if (need_reserve_slab_rcu && (s->flags & SLAB_DESTROY_BY_RCU))
+		s->reserved = sizeof(struct rcu_head);
+
 	if (!calculate_sizes(s, -1))
 		goto error;
 	if (disable_higher_order_debug) {
