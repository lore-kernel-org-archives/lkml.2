Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1EDC54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 22:57:56 -0400
Received: from tundra.namei.org ([65.99.196.166]:58497 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1EDC5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 22:57:55 -0400
Date: Wed, 4 May 2011 12:57:47 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: [GIT] SELinux / flex_array bugfixes
Message-ID: <alpine.LRH.2.00.1105041252210.29669@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these fixes for SELinux, and for flex_array (which fixes a 
regression in SELinux).


The following changes since commit 609cfda586c7fe3e5d1a02c51edb587506294167:
  Linus Torvalds (1):
        Merge branch 'stable/bug-fixes-for-rc5' of git://git.kernel.org/.../konrad/xen

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric Paris (3):
      SELinux: pass last path component in may_create
      flex_array: flex_array_prealloc takes a number of elements, not an end
      flex_arrays: allow zero length flex arrays

James Morris (1):
      Merge branch 'for-linus' of git://git.infradead.org/users/eparis/selinux into for-linus


 Documentation/flexible-arrays.txt |    4 ++--
 include/linux/flex_array.h        |    2 +-
 lib/flex_array.c                  |   24 ++++++++++++++++++------
 security/selinux/hooks.c          |    3 ++-
 security/selinux/ss/policydb.c    |    6 +++---
 5 files changed, 26 insertions(+), 13 deletions(-)

---

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
index c0ea40b..854b57b 100644
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
@@ -245,14 +245,24 @@ EXPORT_SYMBOL(flex_array_clear);
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
+	if (!start && !nr_elements)
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
 	if (elements_fit_in_base(fa))
 		return 0;
@@ -343,6 +353,8 @@ int flex_array_shrink(struct flex_array *fa)
 	int part_nr;
 	int ret = 0;
 
+	if (!fa->total_nr_elements)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return ret;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f7cf0ea..8fb2488 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1578,7 +1578,8 @@ static int may_create(struct inode *dir,
 		return rc;
 
 	if (!newsid || !(sbsec->flags & SE_SBLABELSUPP)) {
-		rc = security_transition_sid(sid, dsec->sid, tclass, NULL, &newsid);
+		rc = security_transition_sid(sid, dsec->sid, tclass,
+					     &dentry->d_name, &newsid);
 		if (rc)
 			return rc;
 	}
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index e7b850a..e6e7ce0 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -502,7 +502,7 @@ static int policydb_index(struct policydb *p)
 		goto out;
 
 	rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
-				 p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
+				 p->p_types.nprim, GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto out;
 
@@ -519,7 +519,7 @@ static int policydb_index(struct policydb *p)
 			goto out;
 
 		rc = flex_array_prealloc(p->sym_val_to_name[i],
-					 0, p->symtab[i].nprim - 1,
+					 0, p->symtab[i].nprim,
 					 GFP_KERNEL | __GFP_ZERO);
 		if (rc)
 			goto out;
@@ -2375,7 +2375,7 @@ int policydb_read(struct policydb *p, void *fp)
 		goto bad;
 
 	/* preallocate so we don't have to worry about the put ever failing */
-	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim - 1,
+	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim,
 				 GFP_KERNEL | __GFP_ZERO);
 	if (rc)
 		goto bad;
