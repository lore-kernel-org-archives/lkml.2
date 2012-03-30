Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810Ab2C3VMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:12:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935690Ab2C3VM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:28 -0400
Message-Id: <20120330194849.785993937@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 072/149] md: fix clearing of the changed flags for the bad blocks list.
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit d0962936bff659d20522555b517582a2715fd23f upstream.

In super_1_sync (the first hunk) we need to clear 'changed' before
checking read_seqretry(), otherwise we might race with other code
adding a bad block and so won't retry later.

In md_update_sb (the second hunk), in the case where there is no
metadata (neither persistent nor external), we treat any bad blocks as
an error.  However we need to clear the 'changed' flag before calling
md_ack_all_badblocks, else it won't do anything.

This patch is suitable for -stable release 3.0 and later.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1801,13 +1801,13 @@ retry:
 						| BB_LEN(internal_bb));
 				*bbp++ = cpu_to_le64(store_bb);
 			}
+			bb->changed = 0;
 			if (read_seqretry(&bb->lock, seq))
 				goto retry;
 
 			bb->sector = (rdev->sb_start +
 				      (int)le32_to_cpu(sb->bblog_offset));
 			bb->size = le16_to_cpu(sb->bblog_size);
-			bb->changed = 0;
 		}
 	}
 
@@ -2362,6 +2362,7 @@ repeat:
 			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 			list_for_each_entry(rdev, &mddev->disks, same_set) {
 				if (rdev->badblocks.changed) {
+					rdev->badblocks.changed = 0;
 					md_ack_all_badblocks(&rdev->badblocks);
 					md_error(mddev, rdev);
 				}


