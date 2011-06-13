Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1FMSjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:39:53 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:35127 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab1FMSjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:39:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sam Creasey <sammy@sammy.net>
Subject: [PATCH 5/8] scsi/sun3: Provide a dummy NCR5380_exit()
Date: Mon, 13 Jun 2011 20:39:19 +0200
Message-Id: <1307990362-22768-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and call it from sun3scsi_release(), cfr. the other NCR5380 drivers.

This fixes:

drivers/scsi/NCR5380.h:303: warning: ‘NCR5380_exit’ declared ‘static’ but never defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c  |    5 +++++
 drivers/scsi/sun3_scsi.c     |    1 +
 drivers/scsi/sun3_scsi_vme.c |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 0d04c3a..2ba1cb7 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -890,6 +890,11 @@ static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
     return 0;
 }
 
+static void NCR5380_exit(struct Scsi_Host *instance)
+{
+	/* Empty, as we didn't schedule any delayed work */
+}
+
 /* 
  * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
  *	void (*done)(struct scsi_cmnd *))
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2ad6b91..2cc83ef 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -314,6 +314,7 @@ int sun3scsi_release (struct Scsi_Host *shpnt)
 
 	iounmap((void *)sun3_scsi_regp);
 
+	NCR5380_exit(shpnt);
 	return 0;
 }
 
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index cd6d779..c0252db 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -283,6 +283,7 @@ int sun3scsi_release (struct Scsi_Host *shpnt)
 
 	iounmap((void *)sun3_scsi_regp);
 
+	NCR5380_exit(shpnt);
 	return 0;
 }
 
-- 
1.7.0.4

