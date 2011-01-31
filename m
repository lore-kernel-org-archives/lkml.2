Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1AaIwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:52:18 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:35808 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1AaIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:52:16 -0500
Date: Mon, 31 Jan 2011 09:52:13 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] flex_array: Change behaviour on zero size allocations
Message-ID: <20110131085213.GK3070@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 31 Jan 2011 08:52:13.0986 (UTC) FILETIME=[27BCD020:01CBC124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flex_array_alloc allocates the basic struct flex_array regardless whether
total_nr_elements or element_size is zero. Then flex_array_prealloc
fails with -ENOSPC if total_nr_elements is zero or it hits a division by
zero if element_size is zero.

This patch changes the behaviour on zero size allocations to the same
as kmalloc, so zero size allocations are leagal now. This fixes a
regression on selinux policy loading.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 lib/flex_array.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
index c0ea40b..8eb437b 100644
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
 
+	if (!fa->element_size)
+		return 0;
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
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
 
+	if (!fa->element_size)
+		return 0;
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
 	else {
+		part_nr = fa_element_to_part_nr(fa, element_nr);
 		part = fa->parts[part_nr];
 		if (!part)
 			return -EINVAL;
@@ -252,8 +261,12 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 	int part_nr;
 	struct flex_array_part *part;
 
+	if (!fa->total_nr_elements)
+		return 0;
 	if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
 		return -ENOSPC;
+	if (!fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return 0;
 	start_part = fa_element_to_part_nr(fa, start);
@@ -284,6 +297,8 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
 
+	if (!fa->total_nr_elements || !fa->element_size)
+		return NULL;
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
 	if (elements_fit_in_base(fa))
@@ -343,6 +358,8 @@ int flex_array_shrink(struct flex_array *fa)
 	int part_nr;
 	int ret = 0;
 
+	if (!fa->total_nr_elements || !fa->element_size)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return ret;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
-- 
1.7.0.4

