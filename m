Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121Ab1ESSPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:15:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43870 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934070Ab1ESSJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:01 -0400
X-Sasl-enc: a7HyVjuotvmjckNG8jqjTLyckW48menqyi/m1kfsPigv 1305828540
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.894710041@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>, Tim Chen <tim.c.chen@linux.intel.com>
Subject: [48/71] tmpfs: fix off-by-one in max_blocks checks
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit fc5da22ae35d4720be59af8787a8a6d5e4da9517 upstream.

If you fill up a tmpfs, df was showing

  tmpfs                   460800         -         -   -  /tmp

because of an off-by-one in the max_blocks checks.  Fix it so df shows

  tmpfs                   460800    460800         0 100% /tmp

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -422,7 +422,8 @@ static swp_entry_t *shmem_swp_alloc(stru
 		 * a waste to allocate index if we cannot allocate data.
 		 */
 		if (sbinfo->max_blocks) {
-			if (percpu_counter_compare(&sbinfo->used_blocks, (sbinfo->max_blocks - 1)) > 0)
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks - 1) >= 0)
 				return ERR_PTR(-ENOSPC);
 			percpu_counter_inc(&sbinfo->used_blocks);
 			spin_lock(&inode->i_lock);
@@ -1404,7 +1405,8 @@ repeat:
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
-			if ((percpu_counter_compare(&sbinfo->used_blocks, sbinfo->max_blocks) > 0) ||
+			if (percpu_counter_compare(&sbinfo->used_blocks,
+						sbinfo->max_blocks) >= 0 ||
 			    shmem_acct_block(info->flags)) {
 				spin_unlock(&info->lock);
 				error = -ENOSPC;


