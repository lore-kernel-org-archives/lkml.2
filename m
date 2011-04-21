Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1DURJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:09:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58801 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1DURJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uJI1G3n1nmgFe1vjc1y6+0/zWPoMdzoHP/V8bqhvTWzgYOjz2DCogRvquhkXOvfePT
         cM5nwsu+FtZ+4gT7UL2p7LLhF073hpJ0X9PfUF/fCse3iquEIm4fTLD3CIxq0c0NnXnA
         02IZidO7oM6Qa6oDPJvn/1yXlDK4T6M1ZfNvE=
Date: Thu, 21 Apr 2011 19:09:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, kay.sievers@vrfy.org
Subject: [PATCH 2/2] ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd and
 ide-cd
Message-ID: <20110421170925.GD15988@htj.dyndns.org>
References: <20110421170826.GC15988@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421170826.GC15988@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_events() implementations in both ide-gd and ide-cd are
inadequate for in-kernel event polling.  Both generate media change
events continuously when certain conditions are met causing infinite
event loop between the driver and userland event handler.

As disk event now supports suppression of unlisted events, simply
de-listing DISK_EVENT_MEDIA_CHANGE from disk->events resolves the
problem.  Internal handling around media revalidation will behave the
same while userland will fall back to userland event polling after
detecting the device doesn't support disk events.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jens Axboe <jaxboe@fusionio.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/ide/ide-cd.c       |    1 -
 drivers/ide/ide-cd_ioctl.c |    6 ++++++
 drivers/ide/ide-gd.c       |    7 ++++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

Index: work/drivers/ide/ide-gd.c
===================================================================
--- work.orig/drivers/ide/ide-gd.c
+++ work/drivers/ide/ide-gd.c
@@ -298,6 +298,12 @@ static unsigned int ide_gd_check_events(
 		return 0;
 	}
 
+	/*
+	 * The following is used to force revalidation on the first open on
+	 * removeable devices, and never gets reported to userland as
+	 * genhd->events is 0.  This is intended as removeable ide disk
+	 * can't really detect MEDIA_CHANGE events.
+	 */
 	ret = drive->dev_flags & IDE_DFLAG_MEDIA_CHANGED;
 	drive->dev_flags &= ~IDE_DFLAG_MEDIA_CHANGED;
 
@@ -413,7 +419,6 @@ static int ide_gd_probe(ide_drive_t *dri
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
Index: work/drivers/ide/ide-cd.c
===================================================================
--- work.orig/drivers/ide/ide-cd.c
+++ work/drivers/ide/ide-cd.c
@@ -1782,7 +1782,6 @@ static int ide_cd_probe(ide_drive_t *dri
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
 	add_disk(g);
 	return 0;
 
Index: work/drivers/ide/ide-cd_ioctl.c
===================================================================
--- work.orig/drivers/ide/ide-cd_ioctl.c
+++ work/drivers/ide/ide-cd_ioctl.c
@@ -79,6 +79,12 @@ int ide_cdrom_drive_status(struct cdrom_
 	return CDS_DRIVE_NOT_READY;
 }
 
+/*
+ * ide-cd always generates media changed event if media is missing, which
+ * makes it impossible to use for proper event reporting, so disk->events
+ * is cleared to 0 and the following function is used only to trigger
+ * revalidation and never propagated to userland.
+ */
 unsigned int ide_cdrom_check_events_real(struct cdrom_device_info *cdi,
 					 unsigned int clearing, int slot_nr)
 {
