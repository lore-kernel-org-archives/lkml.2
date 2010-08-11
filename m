Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0HKX7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:39 -0400
Received: from kroah.org ([198.145.64.141]:43668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289Ab0HKX7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:17 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.128853998@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [093/111] HWPOISON: abort on failed unmap
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 1668bfd5be9d8a52536c4865000fbbe065a3613b upstream.

Don't try to isolate a still mapped page. Otherwise we will hit the
BUG_ON(page_mapped(page)) in __remove_from_page_cache().

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory-failure.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -637,7 +637,7 @@ static int page_action(struct page_state
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
-static void hwpoison_user_mappings(struct page *p, unsigned long pfn,
+static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int trapno)
 {
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
@@ -647,15 +647,18 @@ static void hwpoison_user_mappings(struc
 	int i;
 	int kill = 1;
 
-	if (PageReserved(p) || PageCompound(p) || PageSlab(p) || PageKsm(p))
-		return;
+	if (PageReserved(p) || PageSlab(p))
+		return SWAP_SUCCESS;
 
 	/*
 	 * This check implies we don't kill processes if their pages
 	 * are in the swap cache early. Those are always late kills.
 	 */
 	if (!page_mapped(p))
-		return;
+		return SWAP_SUCCESS;
+
+	if (PageCompound(p) || PageKsm(p))
+		return SWAP_FAIL;
 
 	if (PageSwapCache(p)) {
 		printk(KERN_ERR
@@ -717,6 +720,8 @@ static void hwpoison_user_mappings(struc
 	 */
 	kill_procs_ao(&tokill, !!PageDirty(p), trapno,
 		      ret != SWAP_SUCCESS, pfn);
+
+	return ret;
 }
 
 int __memory_failure(unsigned long pfn, int trapno, int ref)
@@ -786,8 +791,13 @@ int __memory_failure(unsigned long pfn,
 
 	/*
 	 * Now take care of user space mappings.
+	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
 	 */
-	hwpoison_user_mappings(p, pfn, trapno);
+	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
+		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
+		res = -EBUSY;
+		goto out;
+	}
 
 	/*
 	 * Torn down by someone else?


