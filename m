Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab1BGM3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:29:15 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:60242 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1BGM3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:29:13 -0500
Date: Mon, 7 Feb 2011 13:29:03 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v2] flex_array: Change behaviour on zero size allocations
Message-ID: <20110207122903.GO3070@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2011 12:29:04.0048 (UTC) FILETIME=[9B3AFB00:01CBC6C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flex_array_alloc allocates the basic struct flex_array regardless whether
total_nr_elements or element_size is zero. Then flex_array_prealloc
fails with -ENOSPC if total_nr_elements is zero or it hits a division by
zero if element_size is zero.

This patch changes the behaviour on zero size allocations to the same
as kmalloc, so zero size allocations are leagal now. We also change
flex_array_prealloc to take the number of elements for which space
should be allocated instead of the last (inclusive) element. Users
and documentation are updated accordingly.

This fixes a regression on selinux policy loading.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 Documentation/flexible-arrays.txt |    4 +-
 include/linux/flex_array.h        |    2 +-
 lib/flex_array.c                  |   48 ++++++++++++++++++++++++++++--------
 security/selinux/ss/policydb.c    |    6 ++--
 4 files changed, 43 insertions(+), 17 deletions(-)

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
index c0ea40b..dcd91d5 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -88,8 +88,11 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
-				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int max_size = 0;
+
+	if (element_size)
+		max_size = FLEX_ARRAY_NR_BASE_PTRS *
+			   FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -183,15 +186,18 @@ __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
 int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 			gfp_t flags)
 {
-	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	int part_nr;
 	struct flex_array_part *part;
 	void *dst;
 
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
+	if (!fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else {
+		part_nr = fa_element_to_part_nr(fa, element_nr);
 		part = __fa_get_part(fa, part_nr, flags);
 		if (!part)
 			return -ENOMEM;
@@ -211,15 +217,18 @@ EXPORT_SYMBOL(flex_array_put);
  */
 int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 {
-	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	int part_nr;
 	struct flex_array_part *part;
 	void *dst;
 
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
+	if (!fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else {
+		part_nr = fa_element_to_part_nr(fa, element_nr);
 		part = fa->parts[part_nr];
 		if (!part)
 			return -EINVAL;
@@ -232,10 +241,10 @@ EXPORT_SYMBOL(flex_array_clear);
 
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
@@ -245,15 +254,27 @@ EXPORT_SYMBOL(flex_array_clear);
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
 
-	if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
+	if (!fa->total_nr_elements && !start)
+		return 0;
+	if (start >= fa->total_nr_elements)
+		return -ENOSPC;
+	if (!nr_elements)
+		return 0;
+
+	end = start + nr_elements - 1;
+
+	if (end >= fa->total_nr_elements)
 		return -ENOSPC;
+	if (!fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return 0;
 	start_part = fa_element_to_part_nr(fa, start);
@@ -281,14 +302,17 @@ EXPORT_SYMBOL(flex_array_prealloc);
  */
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 {
-	int part_nr = fa_element_to_part_nr(fa, element_nr);
+	int part_nr;
 	struct flex_array_part *part;
 
+	if (!fa->element_size)
+		return NULL;
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else {
+		part_nr = fa_element_to_part_nr(fa, element_nr);
 		part = fa->parts[part_nr];
 		if (!part)
 			return NULL;
@@ -343,6 +367,8 @@ int flex_array_shrink(struct flex_array *fa)
 	int part_nr;
 	int ret = 0;
 
+	if (!fa->total_nr_elements || !fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return ret;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 5736356..f96f09c 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -497,7 +497,7 @@ static int policydb_index(struct policydb *p)
 		goto out;
 
 	rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
-				 p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
+				 p->p_types.nprim, GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto out;
 
@@ -514,7 +514,7 @@ static int policydb_index(struct policydb *p)
 			goto out;
 
 		rc = flex_array_prealloc(p->sym_val_to_name[i],
-					 0, p->symtab[i].nprim - 1,
+					 0, p->symtab[i].nprim,
 					 GFP_KERNEL | __GFP_ZERO);
 		if (rc)
 			goto out;
@@ -2286,7 +2286,7 @@ int policydb_read(struct policydb *p, void *fp)
 		goto bad;
 
 	/* preallocate so we don't have to worry about the put ever failing */
-	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim - 1,
+	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim,
 				 GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto bad;
-- 
1.7.0.4

