Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0IOQXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0IOQXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:23:42 -0400
Date: Wed, 15 Sep 2010 18:23:38 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Lukas Czerner <lczerner@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu, sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] block: Make blkdev_issue_discard() interruptible
In-Reply-To: <alpine.LFD.2.00.1009151815190.3162@dhcp-lab-213.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1009151822140.3162@dhcp-lab-213.englab.brq.redhat.com>
References: <1284561161-22278-1-git-send-email-lczerner@redhat.com> <AANLkTinmJyJOqgSe6G0RiNUgT59wtxeT6y+0b3GivQem@mail.gmail.com> <alpine.LFD.2.00.1009151815190.3162@dhcp-lab-213.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the discard may take quite long time, especially with really big
extents (like the whole device for example), it would be nice to give to
users the opportunity to abort it. This is especially useful for mkfs,
when user can not know in advance how long it will take.

In conjunction with mke2fs patch "Inform user about ongoing discard"
it gives the user all the comfort of being informed about discard and
being able to abort the operation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 block/blk-lib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..f1eb78e 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -102,6 +102,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		else if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
+
+		if (fatal_signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 	}
 	return ret;
 out_free_page:
-- 
1.7.2.2

