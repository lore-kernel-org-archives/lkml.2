Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab0JVTSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:18:09 -0400
Received: from kroah.org ([198.145.64.141]:34046 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294Ab0JVS4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:14 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.127872831@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [031/103] ksm: fix bad user data when swapping
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 4e31635c367a9e21a43cfbfae4c9deda2e19d1f4 upstream.

Building under memory pressure, with KSM on 2.6.36-rc5, collapsed with
an internal compiler error: typically indicating an error in swapping.

Perhaps there's a timing issue which makes it now more likely, perhaps
it's just a long time since I tried for so long: this bug goes back to
KSM swapping in 2.6.33.

Notice how reuse_swap_page() allows an exclusive page to be reused, but
only does SetPageDirty if it can delete it from swap cache right then -
if it's currently under Writeback, it has to be left in cache and we
don't SetPageDirty, but the page can be reused.  Fine, the dirty bit
will get set in the pte; but notice how zap_pte_range() does not bother
to transfer pte_dirty to page_dirty when unmapping a PageAnon.

If KSM chooses to share such a page, it will look like a clean copy of
swapcache, and not be written out to swap when its memory is needed;
then stale data read back from swap when it's needed again.

We could fix this in reuse_swap_page() (or even refuse to reuse a
page under writeback), but it's more honest to fix my oversight in
KSM's write_protect_page().  Several days of testing on three machines
confirms that this fixes the issue they showed.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/ksm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -731,7 +731,7 @@ static int write_protect_page(struct vm_
 	if (!ptep)
 		goto out;
 
-	if (pte_write(*ptep)) {
+	if (pte_write(*ptep) || pte_dirty(*ptep)) {
 		pte_t entry;
 
 		swapped = PageSwapCache(page);
@@ -754,7 +754,9 @@ static int write_protect_page(struct vm_
 			set_pte_at(mm, addr, ptep, entry);
 			goto out_unlock;
 		}
-		entry = pte_wrprotect(entry);
+		if (pte_dirty(entry))
+			set_page_dirty(page);
+		entry = pte_mkclean(pte_wrprotect(entry));
 		set_pte_at_notify(mm, addr, ptep, entry);
 	}
 	*orig_pte = *ptep;


