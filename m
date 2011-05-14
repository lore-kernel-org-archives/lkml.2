Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab1ENTGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 15:06:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab1ENTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 15:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Gt6hCkflT/jOQJ+GrqMp4QlqVqXJoi0xKhloIMD1tfB2MmGOdTCts1R3Zxol2kl/P0
         zHMjWeKWEHx3yaUXIpsw==
Date: Sat, 14 May 2011 12:06:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] tmpfs: fix race between swapoff and writepage
Message-ID: <alpine.LSU.2.00.1105141201190.1906@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---

 mm/shmem.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- 2.6.39-rc7+/mm/shmem.c	2011-05-09 21:09:49.861399310 -0700
+++ linux/mm/shmem.c	2011-05-14 03:48:02.719548428 -0700
@@ -1037,7 +1037,6 @@ static int shmem_writepage(struct page *
 	struct address_space *mapping;
 	unsigned long index;
 	struct inode *inode;
-	bool unlock_mutex = false;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -1072,15 +1071,14 @@ static int shmem_writepage(struct page *
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
