Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1EFAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:16:27 -0400
Received: from kroah.org ([198.145.64.141]:32912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab1EFANd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.859412973@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [patch 26/38] flex_arrays: allow zero length flex arrays
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit bf69d41d198138e3c601e9a6645f4f1369aff7e0 upstream.

Just like kmalloc will allow one to allocate a 0 length segment of memory
flex arrays should do the same thing.  It should bomb if you try to use
something, but it should at least allow the allocation.

This is needed because when SELinux switched to using flex_arrays in 2.6.38
the inability to allocate a 0 length array resulted in SELinux policy load
returning -ENOSPC when previously it worked.

Based-on-patch-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Tested-by: Chris Richards <gizmo@giz-works.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/flex_array.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -253,9 +253,16 @@ int flex_array_prealloc(struct flex_arra
 	unsigned int end;
 	struct flex_array_part *part;
 
+	if (!start && !nr_elements)
+		return 0;
+	if (start >= fa->total_nr_elements)
+		return -ENOSPC;
+	if (!nr_elements)
+		return 0;
+
 	end = start + nr_elements - 1;
 
-	if (start >= fa->total_nr_elements || end >= fa->total_nr_elements)
+	if (end >= fa->total_nr_elements)
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
 		return 0;
@@ -346,6 +353,8 @@ int flex_array_shrink(struct flex_array
 	int part_nr;
 	int ret = 0;
 
+	if (!fa->total_nr_elements)
+		return 0;
 	if (elements_fit_in_base(fa))
 		return ret;
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++) {


