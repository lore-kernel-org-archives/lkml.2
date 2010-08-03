Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0HCTgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0HCTgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:36:36 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] flex_array: add helpers to get and put to make pointers easy
	to use
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dave@linux.vnet.ibm.com, akpm@linux-foundation.org, jmorris@namei.org,
        sds@tycho.nsa.gov
Date: Tue, 03 Aug 2010 15:36:23 -0400
Message-ID: <20100803193623.22126.18019.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting and putting arrays of pointers with flex arrays is a PITA.  You
have to remember to pass &ptr to the _put and you have to do weird and
wacky casting to get the ptr back from the _get.  Add two functions
flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/flex_array.h |    6 ++++++
 lib/flex_array.c           |   25 ++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
index 1d747f7..f4e4eb2 100644
--- a/include/linux/flex_array.h
+++ b/include/linux/flex_array.h
@@ -70,4 +70,10 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr);
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 int flex_array_shrink(struct flex_array *fa);
 
+#define flex_array_put_ptr(fa, nr, src, gfp)	({						\
+						 void *_src = (src);				\
+						 flex_array_put((fa), (nr), &_src, (gfp));	\
+						})
+void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr);
+
 #endif /* _FLEX_ARRAY_H */
diff --git a/lib/flex_array.c b/lib/flex_array.c
index 41b1804..77a6fea 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -171,6 +171,8 @@ __fa_get_part(struct flex_array *fa, int part_nr, gfp_t flags)
  * Note that this *copies* the contents of @src into
  * the array.  If you are trying to store an array of
  * pointers, make sure to pass in &ptr instead of ptr.
+ * You may instead wish to use the flex_array_put_ptr()
+ * helper function.
  *
  * Locking must be provided by the caller.
  */
@@ -265,7 +267,8 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
  *
  * Returns a pointer to the data at index @element_nr.  Note
  * that this is a copy of the data that was passed in.  If you
- * are using this to store pointers, you'll get back &ptr.
+ * are using this to store pointers, you'll get back &ptr.  You
+ * may instead wish to use the flex_array_get_ptr helper.
  *
  * Locking must be provided by the caller.
  */
@@ -286,6 +289,26 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
 
+/**
+ * flex_array_get_ptr - pull a ptr back out of the array
+ * @fa:		the flex array from which to extract data
+ * @element_nr:	index of the element to fetch from the array
+ *
+ * Returns the pointer placed in the flex array at element_nr using
+ * flex_array_put_ptr().  This function should not be called if the
+ * element in question was not set using the _put_ptr() helper.
+ */
+void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr)
+{
+	void **tmp;
+
+	tmp = flex_array_get(fa, element_nr);
+	if (!tmp)
+		return NULL;
+
+	return *tmp;
+}
+
 static int part_is_free(struct flex_array_part *part)
 {
 	int i;

