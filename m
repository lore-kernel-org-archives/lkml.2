Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab1ATMwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:52:02 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:43738 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1ATMv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:51:59 -0500
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 07:51:58 EST
Date: Thu, 20 Jan 2011 13:26:59 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Paris <eparis@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: flex_array related problems on selinux policy loading
Message-ID: <20110120122659.GD4639@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jan 2011 12:27:00.0305 (UTC) FILETIME=[5609CC10:01CBB89D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent changes to use flex_array_alloc on selinux policy loading made
me unable load my selinux policy. I'm not using 'common' and 'bool' in the
policy, this leads to some zero size allocations in policydb_index().
Unfortunately the behaviour on zero size allocations of flex_array_alloc()
is not the same as of kmalloc(). While zero size allocations are legal on
kmalloc(), flex_array_prealloc() fails with -ENOSPC if total_nr_elements
is zero (this happens if I try to load my policy) or it hits a division by
zero if element_size is zero.

The patch below changes the flex_array_alloc behaviour on zero size allocations
to be the same as with kmalloc. I'm able to load my policy with the patch
and everything seems to work fine. However, flex_array_get() returns now NULL
if the pointer to the struct flex_array is a ZERO_SIZE_PTR.  There is a lot
of BUG_ON() in the policy handling code if flex_array_get() returns NULL, so
somebody with a deeper knowledge on selinux policy handling should look into
this to see if furter changes are necessary.

Steffen

Subject: [PATCH] flex_array: Change behaviour on zero size allocations

flex_array_alloc allocates the basic struct flex_array regardless whether
total_nr_elements or element_size is zero. Then flex_array_prealloc
fails with -ENOSPC if total_nr_elements is zero or it hits a division by
zero if element_size is zero.

This patch changes the behaviour on zero size allocations to the same
as kmalloc, we return ZERO_SIZE_PTR in this case. All flex_array handlers
test for ZERO_SIZE_PTR and return an appropriate value to the caller.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 lib/flex_array.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/lib/flex_array.c b/lib/flex_array.c
index c0ea40b..420d11d 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -88,8 +88,13 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 					gfp_t flags)
 {
 	struct flex_array *ret;
-	int max_size = FLEX_ARRAY_NR_BASE_PTRS *
-				FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
+	int max_size;
+
+	if (unlikely(!element_size || !total))
+		return ZERO_SIZE_PTR;
+
+	max_size = FLEX_ARRAY_NR_BASE_PTRS *
+		   FLEX_ARRAY_ELEMENTS_PER_PART(element_size);
 
 	/* max_size will end up 0 if element_size > PAGE_SIZE */
 	if (total > max_size)
@@ -123,6 +128,9 @@ void flex_array_free_parts(struct flex_array *fa)
 {
 	int part_nr;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return;
+
 	if (elements_fit_in_base(fa))
 		return;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
@@ -187,6 +195,9 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 	struct flex_array_part *part;
 	void *dst;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return 0;
+
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
@@ -215,6 +226,9 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 	struct flex_array_part *part;
 	void *dst;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return 0;
+
 	if (element_nr >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
@@ -252,6 +266,9 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 	int part_nr;
 	struct flex_array_part *part;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return 0;
+
 	if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
@@ -284,6 +301,9 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return NULL;
+
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
 	if (elements_fit_in_base(fa))
@@ -343,6 +363,9 @@ int flex_array_shrink(struct flex_array *fa)
 	int part_nr;
 	int ret = 0;
 
+	if (unlikely(ZERO_OR_NULL_PTR(fa)))
+		return 0;
+
 	if (elements_fit_in_base(fa))
 		return ret;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {
-- 
1.7.0.4

