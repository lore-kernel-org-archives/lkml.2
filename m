Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab1KJDe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:34:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935608Ab1KJDey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:34:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:25 2011
Message-Id: <20111109212725.455018425@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Kim Phillips <kim.phillips@freescale.com>
Subject: [247/262] net: Handle different key sizes between address families in flow cache
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: dpward <david.ward@ll.mit.edu>

commit aa1c366e4febc7f5c2b84958a2dd7cd70e28f9d0 upstream.

With the conversion of struct flowi to a union of AF-specific structs, some
operations on the flow cache need to account for the exact size of the key.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/flow.h |   19 +++++++++++++++++++
 net/core/flow.c    |   31 +++++++++++++++++--------------
 2 files changed, 36 insertions(+), 14 deletions(-)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -7,6 +7,7 @@
 #ifndef _NET_FLOW_H
 #define _NET_FLOW_H
 
+#include <linux/socket.h>
 #include <linux/in6.h>
 #include <asm/atomic.h>
 
@@ -161,6 +162,24 @@ static inline struct flowi *flowidn_to_f
 	return container_of(fldn, struct flowi, u.dn);
 }
 
+typedef unsigned long flow_compare_t;
+
+static inline size_t flow_key_size(u16 family)
+{
+	switch (family) {
+	case AF_INET:
+		BUILD_BUG_ON(sizeof(struct flowi4) % sizeof(flow_compare_t));
+		return sizeof(struct flowi4) / sizeof(flow_compare_t);
+	case AF_INET6:
+		BUILD_BUG_ON(sizeof(struct flowi6) % sizeof(flow_compare_t));
+		return sizeof(struct flowi6) / sizeof(flow_compare_t);
+	case AF_DECnet:
+		BUILD_BUG_ON(sizeof(struct flowidn) % sizeof(flow_compare_t));
+		return sizeof(struct flowidn) / sizeof(flow_compare_t);
+	}
+	return 0;
+}
+
 #define FLOW_DIR_IN	0
 #define FLOW_DIR_OUT	1
 #define FLOW_DIR_FWD	2
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -172,29 +172,26 @@ static void flow_new_hash_rnd(struct flo
 
 static u32 flow_hash_code(struct flow_cache *fc,
 			  struct flow_cache_percpu *fcp,
-			  const struct flowi *key)
+			  const struct flowi *key,
+			  size_t keysize)
 {
 	const u32 *k = (const u32 *) key;
+	const u32 length = keysize * sizeof(flow_compare_t) / sizeof(u32);
 
-	return jhash2(k, (sizeof(*key) / sizeof(u32)), fcp->hash_rnd)
+	return jhash2(k, length, fcp->hash_rnd)
 		& (flow_cache_hash_size(fc) - 1);
 }
 
-typedef unsigned long flow_compare_t;
-
 /* I hear what you're saying, use memcmp.  But memcmp cannot make
- * important assumptions that we can here, such as alignment and
- * constant size.
+ * important assumptions that we can here, such as alignment.
  */
-static int flow_key_compare(const struct flowi *key1, const struct flowi *key2)
+static int flow_key_compare(const struct flowi *key1, const struct flowi *key2,
+			    size_t keysize)
 {
 	const flow_compare_t *k1, *k1_lim, *k2;
-	const int n_elem = sizeof(struct flowi) / sizeof(flow_compare_t);
-
-	BUILD_BUG_ON(sizeof(struct flowi) % sizeof(flow_compare_t));
 
 	k1 = (const flow_compare_t *) key1;
-	k1_lim = k1 + n_elem;
+	k1_lim = k1 + keysize;
 
 	k2 = (const flow_compare_t *) key2;
 
@@ -215,6 +212,7 @@ flow_cache_lookup(struct net *net, const
 	struct flow_cache_entry *fle, *tfle;
 	struct hlist_node *entry;
 	struct flow_cache_object *flo;
+	size_t keysize;
 	unsigned int hash;
 
 	local_bh_disable();
@@ -222,6 +220,11 @@ flow_cache_lookup(struct net *net, const
 
 	fle = NULL;
 	flo = NULL;
+
+	keysize = flow_key_size(family);
+	if (!keysize)
+		goto nocache;
+
 	/* Packet really early in init?  Making flow_cache_init a
 	 * pre-smp initcall would solve this.  --RR */
 	if (!fcp->hash_table)
@@ -230,11 +233,11 @@ flow_cache_lookup(struct net *net, const
 	if (fcp->hash_rnd_recalc)
 		flow_new_hash_rnd(fc, fcp);
 
-	hash = flow_hash_code(fc, fcp, key);
+	hash = flow_hash_code(fc, fcp, key, keysize);
 	hlist_for_each_entry(tfle, entry, &fcp->hash_table[hash], u.hlist) {
 		if (tfle->family == family &&
 		    tfle->dir == dir &&
-		    flow_key_compare(key, &tfle->key) == 0) {
+		    flow_key_compare(key, &tfle->key, keysize) == 0) {
 			fle = tfle;
 			break;
 		}
@@ -248,7 +251,7 @@ flow_cache_lookup(struct net *net, const
 		if (fle) {
 			fle->family = family;
 			fle->dir = dir;
-			memcpy(&fle->key, key, sizeof(*key));
+			memcpy(&fle->key, key, keysize * sizeof(flow_compare_t));
 			fle->object = NULL;
 			hlist_add_head(&fle->u.hlist, &fcp->hash_table[hash]);
 			fcp->hash_count++;


