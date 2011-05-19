Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab1ESSJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:04 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34259 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016Ab1ESSI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:59 -0400
X-Sasl-enc: 6ZmbVqcbQbZ57AOaS/gyxJiZE8+m5BGkSBs9Xyfqolhb 1305828538
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.795016655@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [47/71] tmpfs: fix race between swapoff and writepage
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 05bf86b4ccfd0f197da61c67bd372111d15a6620 upstream.

Shame on me!  Commit b1dea800ac39 "tmpfs: fix race between umount and
writepage" fixed the advertized race, but introduced another: as even
its comment makes clear, we cannot safely rely on a peek at list_empty()
while holding no lock - until info->swapped is set, shmem_unuse_inode()
may delete any formerly-swapped inode from the shmem_swaplist, which
in this case would leave a swap area impossible to swapoff.

Although I don't relish taking the mutex every time, I don't care much
for the alternatives either; and at least the peek at list_empty() in
shmem_evict_inode() (a hotter path since most inodes would never have
been swapped) remains safe, because we already truncated the whole file.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1037,7 +1037,6 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	struct address_space *mapping;
 	unsigned long index;
 	struct inode *inode;
-	bool unlock_mutex = false;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -1072,15 +1071,14 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	 * we've taken the spinlock, because shmem_unuse_inode() will
 	 * prune a !swapped inode from the swaplist under both locks.
 	 */
-	if (swap.val && list_empty(&info->swaplist)) {
+	if (swap.val) {
 		mutex_lock(&shmem_swaplist_mutex);
-		/* move instead of add in case we're racing */
-		list_move_tail(&info->swaplist, &shmem_swaplist);
-		unlock_mutex = true;
+		if (list_empty(&info->swaplist))
+			list_add_tail(&info->swaplist, &shmem_swaplist);
 	}
 
 	spin_lock(&info->lock);
-	if (unlock_mutex)
+	if (swap.val)
 		mutex_unlock(&shmem_swaplist_mutex);
 
 	if (index >= info->next_index) {


