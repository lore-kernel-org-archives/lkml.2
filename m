Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2GWCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:09:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab2GWBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:17 -0400
Message-Id: <20120723010653.646297879@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 014/108] NFSv4: Reduce the footprint of the idmapper
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

commit d073e9b541e1ac3f52d72c3a153855d9a9ee3278 upstream.

Instead of pre-allocating the storage for all the strings, we can
significantly reduce the size of that table by doing the allocation
when we do the downcall.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
[bwh: Backported to 3.2: adjust context in nfs_idmap_delete()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/idmap.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -318,7 +318,7 @@
 	unsigned long		ih_expires;
 	__u32			ih_id;
 	size_t			ih_namelen;
-	char			ih_name[IDMAP_NAMESZ];
+	const char		*ih_name;
 };
 
 struct idmap_hashtable {
@@ -382,11 +382,16 @@
 nfs_idmap_delete(struct nfs_client *clp)
 {
 	struct idmap *idmap = clp->cl_idmap;
+	int i;
 
 	if (!idmap)
 		return;
 	rpc_unlink(idmap->idmap_dentry);
 	clp->cl_idmap = NULL;
+	for (i = 0; i < ARRAY_SIZE(idmap->idmap_user_hash.h_entries); i++)
+		kfree(idmap->idmap_user_hash.h_entries[i].ih_name);
+	for (i = 0; i < ARRAY_SIZE(idmap->idmap_group_hash.h_entries); i++)
+		kfree(idmap->idmap_group_hash.h_entries[i].ih_name);
 	kfree(idmap);
 }
 
@@ -449,9 +454,14 @@
 idmap_update_entry(struct idmap_hashent *he, const char *name,
 		size_t namelen, __u32 id)
 {
+	char *str = kmalloc(namelen + 1, GFP_KERNEL);
+	if (str == NULL)
+		return;
+	kfree(he->ih_name);
 	he->ih_id = id;
-	memcpy(he->ih_name, name, namelen);
-	he->ih_name[namelen] = '\0';
+	memcpy(str, name, namelen);
+	str[namelen] = '\0';
+	he->ih_name = str;
 	he->ih_namelen = namelen;
 	he->ih_expires = jiffies + nfs_idmap_cache_timeout;
 }



