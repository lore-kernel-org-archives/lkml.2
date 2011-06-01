Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162695Ab1FAIXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:23:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:44743 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162686Ab1FAIXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:23:04 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:44 2011
Message-Id: <20110601081143.675557746@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:00 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [090/165] md/bitmap: fix saving of events_cleared and other state.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2224
Lines: 63

From: NeilBrown <neilb@suse.de>

commit 8258c53208d7a9b7207e7d4dae36d2ea384cb278 upstream.

If a bitmap is found to be 'stale' the events_cleared value
is set to match 'events'.
However if the array is degraded this does not get stored on disk.
This can subsequently lead to incorrect behaviour.

So change bitmap_update_sb to always update events_cleared in the
superblock from the known events_cleared.
For neatness also set ->state from ->flags.
This requires updating ->state whenever we update ->flags, which makes
sense anyway.

This is suitable for any active -stable release.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -493,11 +493,11 @@ void bitmap_update_sb(struct bitmap *bit
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
-	if (bitmap->mddev->events < bitmap->events_cleared) {
+	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
 		bitmap->events_cleared = bitmap->mddev->events;
-		sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
-	}
+	sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+	sb->state = cpu_to_le32(bitmap->flags);
 	/* Just in case these have been changed via sysfs: */
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
@@ -618,7 +618,7 @@ success:
 	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
 		bitmap->flags |= BITMAP_HOSTENDIAN;
 	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
-	if (sb->state & cpu_to_le32(BITMAP_STALE))
+	if (bitmap->flags & BITMAP_STALE)
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
@@ -652,9 +652,11 @@ static int bitmap_mask_state(struct bitm
 	switch (op) {
 	case MASK_SET:
 		sb->state |= cpu_to_le32(bits);
+		bitmap->flags |= bits;
 		break;
 	case MASK_UNSET:
 		sb->state &= cpu_to_le32(~bits);
+		bitmap->flags &= ~bits;
 		break;
 	default:
 		BUG();


