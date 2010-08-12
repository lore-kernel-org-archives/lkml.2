Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab0HLARv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:17:51 -0400
Received: from kroah.org ([198.145.64.141]:60519 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082Ab0HLAIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:14 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:14 2010
Message-Id: <20100812000614.598946449@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>
Subject: [21/67] mm: fix corruption of hibernation caused by reusing swap during image saving
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 966cca029f739716fbcc8068b8c6dfe381f86fc3 upstream.

Since 2.6.31, swap_map[]'s refcounting was changed to show that a used
swap entry is just for swap-cache, can be reused.  Then, while scanning
free entry in swap_map[], a swap entry may be able to be reclaimed and
reused.  It was caused by commit c9e444103b5e7a5 ("mm: reuse unused swap
entry if necessary").

But this caused deta corruption at resume. The scenario is

- Assume a clean-swap cache, but mapped.

- at hibernation_snapshot[], clean-swap-cache is saved as
  clean-swap-cache and swap_map[] is marked as SWAP_HAS_CACHE.

- then, save_image() is called.  And reuse SWAP_HAS_CACHE entry to save
  image, and break the contents.

After resume:

- the memory reclaim runs and finds clean-not-referenced-swap-cache and
  discards it because it's marked as clean.  But here, the contents on
  disk and swap-cache is inconsistent.

Hance memory is corrupted.

This patch avoids the bug by not reclaiming swap-entry during hibernation.
This is a quick fix for backporting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ondreg Zary <linux@rainbow-software.org>
Tested-by: Ondreg Zary <linux@rainbow-software.org>
Tested-by: Andrea Gelmini <andrea.gelmini@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swapfile.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -318,8 +318,10 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not busy. */
-	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/* reuse swap entry of cache-only swap if not hibernation. */
+	if (vm_swap_full()
+		&& usage == SWAP_HAS_CACHE
+		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);


