Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab1DZBqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab1DZBp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:45:56 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] flex_array: flex_array_prealloc takes a number of
	elements, not an end
To: dave@linux.vnet.ibm.com
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Date: Mon, 25 Apr 2011 21:45:31 -0400
Message-ID: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change flex_array_prealloc to take the number of elements for which space
should be allocated instead of the last (inclusive) element. Users
and documentation are updated accordingly.

Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 Documentation/flexible-arrays.txt |    4 ++--
 include/linux/flex_array.h        |    2 +-
 lib/flex_array.c                  |   13 ++++++++-----
 security/selinux/ss/policydb.c    |    6 +++---
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Documentation/flexible-arrays.txt b/Documentation/flexible-arrays.txt
index cb8a3a0..df904ae 100644
--- a/Documentation/flexible-arrays.txt
+++ b/Documentation/flexible-arrays.txt
@@ -66,10 +66,10 @@ trick is to ensure that any needed memory allocations are done before
 entering atomic context, using:
 
     int flex_array_prealloc(struct flex_array *array, unsigned int start,
-			    unsigned int end, gfp_t flags);
+			    unsigned int nr_elements, gfp_t flags);
 
 This function will ensure that memory for the elements indexed in the range
-defined by start and end has been allocated.  Thereafter, a
+defined by start and nr_elements has been allocated.  Thereafter, a
 flex_array_put() call on an element in that range is guaranteed not to
 block.
 
diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
index 70e4efa..ebeb2f3 100644
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -61,7 +61,7 @@ struct flex_array {
 struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 		gfp_t flags);
 int flex_array_prealloc(struct flex_array *fa, unsigned int start,
-		unsigned int end, gfp_t flags);
+		unsigned int nr_elements, gfp_t flags);
 void flex_array_free(struct flex_array *fa);
 void flex_array_free_parts(struct flex_array *fa);
 int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
diff --git a/lib/flex_array.c b/lib/flex_array.c
index c0ea40b..0c33b24 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -232,10 +232,10 @@ EXPORT_SYMBOL(flex_array_clear);
 
 /**
  * flex_array_prealloc - guarantee that array space exists
- * @fa:		the flex array for which to preallocate parts
- * @start:	index of first array element for which space is allocated
- * @end:	index of last (inclusive) element for which space is allocated
- * @flags:	page allocation flags
+ * @fa:			the flex array for which to preallocate parts
+ * @start:		index of first array element for which space is allocated
+ * @nr_elements:	number of elements for which space is allocated
+ * @flags:		page allocation flags
  *
  * This will guarantee that no future calls to flex_array_put()
  * will allocate memory.  It can be used if you are expecting to
@@ -245,13 +245,16 @@ EXPORT_SYMBOL(flex_array_clear);
  * Locking must be provided by the caller.
  */
 int flex_array_prealloc(struct flex_array *fa, unsigned int start,
-			unsigned int end, gfp_t flags)
+			unsigned int nr_elements, gfp_t flags)
 {
 	int start_part;
 	int end_part;
 	int part_nr;
+	unsigned int end;
 	struct flex_array_part *part;
 
+	end = start + nr_elements - 1;
+
 	if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 3258799..1b150d7 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -551,7 +551,7 @@ static int policydb_index(struct policydb *p)
 		goto out;
 
 	rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
-				 p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
+				 p->p_types.nprim, GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto out;
 
@@ -568,7 +568,7 @@ static int policydb_index(struct policydb *p)
 			goto out;
 
 		rc = flex_array_prealloc(p->sym_val_to_name[i],
-					 0, p->symtab[i].nprim - 1,
+					 0, p->symtab[i].nprim,
 					 GFP_KERNEL | __GFP_ZERO);
 		if (rc)
 			goto out;
@@ -2445,7 +2445,7 @@ int policydb_read(struct policydb *p, void *fp)
 		goto bad;
 
 	/* preallocate so we don't have to worry about the put ever failing */
-	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim - 1,
+	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim,
 				 GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto bad;

