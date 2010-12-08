Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0LHBf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:35:59 -0500
Received: from kroah.org ([198.145.64.141]:48986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab0LHBBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:21 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:34 2010
Message-Id: <20101208005734.457387195@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [131/289] md: Fix regression with raid1 arrays without persistent metadata.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit d97a41dc9c44f5829b7af7aa69fda10fd82b6b4e upstream.

A RAID1 which has no persistent metadata, whether internal or
external, will hang on the first write.
This is caused by commit  070dc6dd7103b6b3f7e4d46e754354a5c15f366e
In that case, MD_CHANGE_PENDING never gets cleared.

So during md_update_sb, is neither persistent or external,
clear MD_CHANGE_PENDING.

This is suitable for 2.6.36-stable.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2172,6 +2172,8 @@ repeat:
 	if (!mddev->persistent) {
 		clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
 		clear_bit(MD_CHANGE_DEVS, &mddev->flags);
+		if (!mddev->external)
+			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
 		wake_up(&mddev->sb_wait);
 		return;
 	}


