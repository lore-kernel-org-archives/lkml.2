Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1G0Vtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:49110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755Ab1G0Vt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043913"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: rjw@sisk.pl, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [88/99] PM / Hibernate: Fix free_unnecessary_pages()
Message-Id: <20110727214927.DB52E2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 4d4cf23cdde2f8f9324f5684a7f349e182039529 upstream.

There is a bug in free_unnecessary_pages() that causes it to
attempt to free too many pages in some cases, which triggers the
BUG_ON() in memory_bm_clear_bit() for copy_bm.  Namely, if
count_data_pages() is initially greater than alloc_normal, we get
to_free_normal equal to 0 and "save" greater from 0.  In that case,
if the sum of "save" and count_highmem_pages() is greater than
alloc_highmem, we subtract a positive number from to_free_normal.
Hence, since to_free_normal was 0 before the subtraction and is
an unsigned int, the result is converted to a huge positive number
that is used as the number of pages to free.

Fix this bug by checking if to_free_normal is actually greater
than or equal to the number we're going to subtract from it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-tested-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/snapshot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/power/snapshot.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/snapshot.c
+++ linux-2.6.35.y/kernel/power/snapshot.c
@@ -1199,7 +1199,11 @@ static void free_unnecessary_pages(void)
 		to_free_highmem = alloc_highmem - save;
 	} else {
 		to_free_highmem = 0;
-		to_free_normal -= save - alloc_highmem;
+		save -= alloc_highmem;
+		if (to_free_normal > save)
+			to_free_normal -= save;
+		else
+			to_free_normal = 0;
 	}
 
 	memory_bm_position_reset(&copy_bm);
