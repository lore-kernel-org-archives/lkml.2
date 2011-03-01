Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1CAICd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:02:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61504 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab1CAIC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:02:29 -0500
Message-ID: <4D6CA860.3020409@cn.fujitsu.com>
Date: Tue, 01 Mar 2011 16:03:44 +0800
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
Subject: [PATCH 4/4] net,rcu: don't assume the size of struct rcu_head
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:01:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-01 16:01:21,
	Serialize complete at 2011-03-01 16:01:21
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct dst_entry assumes the size of struct rcu_head as 2 * sizeof(long)
and manually adds pads for aligning for "__refcnt".

When the size of struct rcu_head is changed, these manual padding
is wrong. Use __attribute__((aligned (64))) instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/net/dst.h b/include/net/dst.h
index 93b0310..4ef6c4a 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -62,8 +62,6 @@ struct dst_entry {
 	struct hh_cache		*hh;
 #ifdef CONFIG_XFRM
 	struct xfrm_state	*xfrm;
-#else
-	void			*__pad1;
 #endif
 	int			(*input)(struct sk_buff*);
 	int			(*output)(struct sk_buff*);
@@ -74,23 +72,18 @@ struct dst_entry {
 
 #ifdef CONFIG_NET_CLS_ROUTE
 	__u32			tclassid;
-#else
-	__u32			__pad2;
 #endif
 
 
 	/*
 	 * Align __refcnt to a 64 bytes alignment
 	 * (L1_CACHE_SIZE would be too much)
-	 */
-#ifdef CONFIG_64BIT
-	long			__pad_to_align_refcnt[1];
-#endif
-	/*
+	 *
 	 * __refcnt wants to be on a different cache line from
 	 * input/output/ops or performance tanks badly
 	 */
-	atomic_t		__refcnt;	/* client references	*/
+	atomic_t		__refcnt	/* client references	*/
+				__attribute__((aligned (64)));
 	int			__use;
 	unsigned long		lastuse;
 	union {
