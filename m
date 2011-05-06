Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1EFAQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:16:43 -0400
Received: from kroah.org ([198.145.64.141]:32907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab1EFANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.766040412@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [patch 25/38] flex_array: flex_array_prealloc takes a number of elements, not an end
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 5d30b10bd68df007e7ae21e77d1e0ce184b53040 upstream.

Change flex_array_prealloc to take the number of elements for which space
should be allocated instead of the last (inclusive) element. Users
and documentation are updated accordingly.  flex_arrays got introduced before
they had users.  When folks started using it, they ended up needing a
different API than was coded up originally.  This swaps over to the API that
folks apparently need.

Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Tested-by: Chris Richards <gizmo@giz-works.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/flexible-arrays.txt |    4 ++--
 include/linux/flex_array.h        |    2 +-
 lib/flex_array.c                  |   13 ++++++++-----
 security/selinux/ss/policydb.c    |    6 +++---
 4 files changed, 14 insertions(+), 11 deletions(-)

--- a/Documentation/flexible-arrays.txt
+++ b/Documentation/flexible-arrays.txt
@@ -66,10 +66,10 @@ trick is to ensure that any needed memor
 entering atomic context, using:
 
     int flex_array_prealloc(struct flex_array *array, unsigned int start,
-			    unsigned int end, gfp_t flags);
+			    unsigned int nr_elements, gfp_t flags);
 
 This function will ensure that memory for the elements indexed in the range
-defined by start and end has been allocated.  Thereafter, a
+defined by start and nr_elements has been allocated.  Thereafter, a
 flex_array_put() call on an element in that range is guaranteed not to
 block.
 
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
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -497,7 +497,7 @@ static int policydb_index(struct policyd
 		goto out;
 
 	rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
-				 p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
+				 p->p_types.nprim, GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto out;
 
@@ -514,7 +514,7 @@ static int policydb_index(struct policyd
 			goto out;
 
 		rc = flex_array_prealloc(p->sym_val_to_name[i],
-					 0, p->symtab[i].nprim - 1,
+					 0, p->symtab[i].nprim,
 					 GFP_KERNEL | __GFP_ZERO);
 		if (rc)
 			goto out;
@@ -2286,7 +2286,7 @@ int policydb_read(struct policydb *p, vo
 		goto bad;
 
 	/* preallocate so we don't have to worry about the put ever failing */
-	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim - 1,
+	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim,
 				 GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto bad;


