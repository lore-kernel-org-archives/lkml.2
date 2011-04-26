Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab1DZBpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab1DZBpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:45:51 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] flex_array: allow 0 length elements
To: dave@linux.vnet.ibm.com
Cc: steffen.klassert@secunet.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov
Date: Mon, 25 Apr 2011 21:45:43 -0400
Message-ID: <20110426014543.1740.89115.stgit@paris.rdu.redhat.com>
In-Reply-To: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
References: <20110426014531.1740.24077.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow elements of 0 length.  We already allow flex_arrays with 0 elements, but
this patch allow us to have elements that are 0 bytes long.

Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 lib/flex_array.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
index 2554a5f..dcd91d5 100644
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
@@ -264,6 +273,8 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 
 	if (end >= fa->total_nr_elements)
 		return -ENOSPC;
+	if (!fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return 0;
 	start_part = fa_element_to_part_nr(fa, start);
@@ -291,14 +302,17 @@ EXPORT_SYMBOL(flex_array_prealloc);
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
@@ -353,7 +367,7 @@ int flex_array_shrink(struct flex_array *fa)
 	int part_nr;
 	int ret = 0;
 
-	if (!fa->total_nr_elements)
+	if (!fa->total_nr_elements || !fa->element_size)
 		return 0;
 	if (elements_fit_in_base(fa))
 		return ret;

