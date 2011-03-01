Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab1CAIC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:02:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62937 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1CAICY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:02:24 -0500
Message-ID: <4D6CA85B.5030107@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 16:03:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/4] slab,rcu: don't assume the size of struct rcu_head
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:01:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:01:16,
	Serialize complete at 2011-03-01 16:01:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The size of struct rcu_head may be changed. When it becomes larger,
it may pollute the data after struct slab.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slab.c b/mm/slab.c
index 37961d1..52cf0b4 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -191,22 +191,6 @@ typedef unsigned int kmem_bufctl_t;
 #define	SLAB_LIMIT	(((kmem_bufctl_t)(~0U))-3)
 
 /*
- * struct slab
- *
- * Manages the objs in a slab. Placed either at the beginning of mem allocated
- * for a slab, or allocated from an general cache.
- * Slabs are chained into three list: fully used, partial, fully free slabs.
- */
-struct slab {
-	struct list_head list;
-	unsigned long colouroff;
-	void *s_mem;		/* including colour offset */
-	unsigned int inuse;	/* num of objs active in slab */
-	kmem_bufctl_t free;
-	unsigned short nodeid;
-};
-
-/*
  * struct slab_rcu
  *
  * slab_destroy on a SLAB_DESTROY_BY_RCU cache uses this structure to
@@ -219,8 +203,6 @@ struct slab {
  *
  * rcu_read_lock before reading the address, then rcu_read_unlock after
  * taking the spinlock within the structure expected at that address.
- *
- * We assume struct slab_rcu can overlay struct slab when destroying.
  */
 struct slab_rcu {
 	struct rcu_head head;
@@ -229,6 +211,27 @@ struct slab_rcu {
 };
 
 /*
+ * struct slab
+ *
+ * Manages the objs in a slab. Placed either at the beginning of mem allocated
+ * for a slab, or allocated from an general cache.
+ * Slabs are chained into three list: fully used, partial, fully free slabs.
+ */
+struct slab {
+	union {
+		struct {
+			struct list_head list;
+			unsigned long colouroff;
+			void *s_mem;		/* including colour offset */
+			unsigned int inuse;	/* num of objs active in slab */
+			kmem_bufctl_t free;
+			unsigned short nodeid;
+		};
+		struct slab_rcu __slab_cover_slab_rcu;
+	};
+};
+
+/*
  * struct array_cache
  *
  * Purpose:
