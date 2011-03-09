Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1CIJOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1CIJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wlx5bE0XvoPRzuuRRM+FeYaSyGOhXY/YxnU3HrUUynIPjeVHu4Cbi+djbJVL+nfSdr
         RY+fF/ixKyPSYZN08KySf3P1WLKhPtEvYDaFGjWfiAu7ZvwxQAoSX7KGZQXuYNqWAC64
         AaNvhPpAaUeP2Z3FMPuhExsRrNzyl3KZCit9c=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/16] xsysace: Convert to bdops->check_events()
Date: Wed,  9 Mar 2011 10:13:31 +0100
Message-Id: <1299662016-7721-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert from ->media_changed() to ->check_events().

xsysace buffers media changed state and clears it on revalidation.  It
will behave correctly with kernel event polling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/xsysace.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 829161e..16a2fa9 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -867,12 +867,12 @@ static void ace_request(struct request_queue * q)
 	}
 }
 
-static int ace_media_changed(struct gendisk *gd)
+static unsigned int ace_check_events(struct gendisk *gd, unsigned int clearing)
 {
 	struct ace_device *ace = gd->private_data;
-	dev_dbg(ace->dev, "ace_media_changed(): %i\n", ace->media_change);
+	dev_dbg(ace->dev, "ace_check_events(): %i\n", ace->media_change);
 
-	return ace->media_change;
+	return ace->media_change ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
 static int ace_revalidate_disk(struct gendisk *gd)
@@ -953,7 +953,7 @@ static const struct block_device_operations ace_fops = {
 	.owner = THIS_MODULE,
 	.open = ace_open,
 	.release = ace_release,
-	.media_changed = ace_media_changed,
+	.check_events = ace_check_events,
 	.revalidate_disk = ace_revalidate_disk,
 	.getgeo = ace_getgeo,
 };
@@ -1005,6 +1005,7 @@ static int __devinit ace_setup(struct ace_device *ace)
 	ace->gd->major = ace_major;
 	ace->gd->first_minor = ace->id * ACE_NUM_MINORS;
 	ace->gd->fops = &ace_fops;
+	ace->gd->events = DISK_EVENT_MEDIA_CHANGE;
 	ace->gd->queue = ace->queue;
 	ace->gd->private_data = ace;
 	snprintf(ace->gd->disk_name, 32, "xs%c", ace->id + 'a');
-- 
1.7.1

