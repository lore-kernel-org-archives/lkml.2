Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2GWCIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:08:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab2GWBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:18 -0400
Message-Id: <20120723010653.829997005@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 015/108] NFSv4: Further reduce the footprint of the idmapper
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 685f50f9188ac1e8244d0340a9d6ea36b6136cec upstream.

Don't allocate the legacy idmapper tables until we actually need
them.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
[bwh: Backported to 3.2: adjust context in nfs_idmap_delete()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/idmap.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -323,7 +323,7 @@
 
 struct idmap_hashtable {
 	__u8			h_type;
-	struct idmap_hashent	h_entries[IDMAP_HASH_SZ];
+	struct idmap_hashent	*h_entries;
 };
 
 struct idmap {
@@ -378,20 +378,39 @@
 	return 0;
 }
 
+static void
+idmap_alloc_hashtable(struct idmap_hashtable *h)
+{
+	if (h->h_entries != NULL)
+		return;
+	h->h_entries = kcalloc(IDMAP_HASH_SZ,
+			sizeof(*h->h_entries),
+			GFP_KERNEL);
+}
+
+static void
+idmap_free_hashtable(struct idmap_hashtable *h)
+{
+	int i;
+
+	if (h->h_entries == NULL)
+		return;
+	for (i = 0; i < IDMAP_HASH_SZ; i++)
+		kfree(h->h_entries[i].ih_name);
+	kfree(h->h_entries);
+}
+
 void
 nfs_idmap_delete(struct nfs_client *clp)
 {
 	struct idmap *idmap = clp->cl_idmap;
-	int i;
 
 	if (!idmap)
 		return;
 	rpc_unlink(idmap->idmap_dentry);
 	clp->cl_idmap = NULL;
-	for (i = 0; i < ARRAY_SIZE(idmap->idmap_user_hash.h_entries); i++)
-		kfree(idmap->idmap_user_hash.h_entries[i].ih_name);
-	for (i = 0; i < ARRAY_SIZE(idmap->idmap_group_hash.h_entries); i++)
-		kfree(idmap->idmap_group_hash.h_entries[i].ih_name);
+	idmap_free_hashtable(&idmap->idmap_user_hash);
+	idmap_free_hashtable(&idmap->idmap_group_hash);
 	kfree(idmap);
 }
 
@@ -401,6 +420,8 @@
 static inline struct idmap_hashent *
 idmap_name_hash(struct idmap_hashtable* h, const char *name, size_t len)
 {
+	if (h->h_entries == NULL)
+		return NULL;
 	return &h->h_entries[fnvhash32(name, len) % IDMAP_HASH_SZ];
 }
 
@@ -409,6 +430,8 @@
 {
 	struct idmap_hashent *he = idmap_name_hash(h, name, len);
 
+	if (he == NULL)
+		return NULL;
 	if (he->ih_namelen != len || memcmp(he->ih_name, name, len) != 0)
 		return NULL;
 	if (time_after(jiffies, he->ih_expires))
@@ -419,6 +442,8 @@
 static inline struct idmap_hashent *
 idmap_id_hash(struct idmap_hashtable* h, __u32 id)
 {
+	if (h->h_entries == NULL)
+		return NULL;
 	return &h->h_entries[fnvhash32(&id, sizeof(id)) % IDMAP_HASH_SZ];
 }
 
@@ -426,6 +451,9 @@
 idmap_lookup_id(struct idmap_hashtable *h, __u32 id)
 {
 	struct idmap_hashent *he = idmap_id_hash(h, id);
+
+	if (he == NULL)
+		return NULL;
 	if (he->ih_id != id || he->ih_namelen == 0)
 		return NULL;
 	if (time_after(jiffies, he->ih_expires))
@@ -441,12 +469,14 @@
 static inline struct idmap_hashent *
 idmap_alloc_name(struct idmap_hashtable *h, char *name, size_t len)
 {
+	idmap_alloc_hashtable(h);
 	return idmap_name_hash(h, name, len);
 }
 
 static inline struct idmap_hashent *
 idmap_alloc_id(struct idmap_hashtable *h, __u32 id)
 {
+	idmap_alloc_hashtable(h);
 	return idmap_id_hash(h, id);
 }
 



