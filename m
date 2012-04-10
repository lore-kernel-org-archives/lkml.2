Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab2DJNhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:37:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2DJNhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:37:11 -0400
Date: Tue, 10 Apr 2012 09:37:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
Message-ID: <20120410133708.GE21801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if CFQ as default scheduler is still the right choice. CFQ
generally works well on slow rotational media (SATA?). But often
underperforms on faster storage (storage arrays, PCIE SSDs, virtualized
disk in linux guests etc). People often put logic in user space to tune their
systems and change IO scheduler to deadline to get better performance on
faster storage.

Though there is not one good answer for all kind of storage and for all
kind of workloads, I am wondering if we can provide a better default and
that is change default IO scheduler to "deadline" except SATA.

One can argue that some SAS disks can be slow too and benefit from CFQ. Yes,
but default IO scheduler choice is not perfect anyway. It just tries to
cater to a wide variety of use cases out of the box.

So I am throwing this patch out see if it flies. Personally, I think it
might turn out to be a more reasonable default.

Thanks
Vivek


Change default IO scheduler to deadline except SATA disks.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/Kconfig.iosched     |    2 +-
 block/elevator.c          |    2 +-
 drivers/ata/libata-scsi.c |    4 ++++
 include/linux/elevator.h  |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/block/Kconfig.iosched
===================================================================
--- linux-2.6.orig/block/Kconfig.iosched	2012-04-09 22:18:30.941885325 -0400
+++ linux-2.6/block/Kconfig.iosched	2012-04-09 22:18:51.982885971 -0400
@@ -45,7 +45,7 @@ config CFQ_GROUP_IOSCHED
 
 choice
 	prompt "Default I/O scheduler"
-	default DEFAULT_CFQ
+	default DEFAULT_DEADLINE
 	help
 	  Select the I/O scheduler which will be used by default for all
 	  block devices.
Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c	2012-04-09 22:18:30.946885325 -0400
+++ linux-2.6/drivers/ata/libata-scsi.c	2012-04-10 01:09:10.529292695 -0400
@@ -1146,6 +1146,10 @@ static int ata_scsi_dev_config(struct sc
 
 	blk_queue_flush_queueable(q, false);
 
+	/* Change IO scheduler to CFQ */
+	if (!(*chosen_elevator))
+		elevator_change(q, "cfq");
+
 	dev->sdev = sdev;
 	return 0;
 }
Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c	2012-04-09 22:18:30.000000000 -0400
+++ linux-2.6/block/elevator.c	2012-04-10 20:11:10.296866631 -0400
@@ -130,7 +130,7 @@ static int elevator_init_queue(struct re
 	return -ENOMEM;
 }
 
-static char chosen_elevator[ELV_NAME_MAX];
+char chosen_elevator[ELV_NAME_MAX];
 
 static int __init elevator_setup(char *str)
 {
Index: linux-2.6/include/linux/elevator.h
===================================================================
--- linux-2.6.orig/include/linux/elevator.h	2012-03-13 01:07:29.000000000 -0400
+++ linux-2.6/include/linux/elevator.h	2012-04-10 01:07:44.303289797 -0400
@@ -204,5 +204,7 @@ enum {
 	INIT_LIST_HEAD(&(rq)->csd.list);	\
 	} while (0)
 
+extern char chosen_elevator[];
+
 #endif /* CONFIG_BLOCK */
 #endif
