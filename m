Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1FMSjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:39:42 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38637 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1FMSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:39:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitz@debian.org>
Subject: [PATCH 1/8] scsi/atari: Provide a dummy NCR5380_exit()
Date: Mon, 13 Jun 2011 20:39:15 +0200
Message-Id: <1307990362-22768-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and call it from atari_scsi_release(), cfr. the other NCR5380 drivers.

This fixes:

drivers/scsi/NCR5380.h:303: warning: ‘NCR5380_exit’ declared ‘static’ but never defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
---
 drivers/scsi/atari_NCR5380.c |    5 +++++
 drivers/scsi/atari_scsi.c    |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 24652f1..2db79b4 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -892,6 +892,11 @@ static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
 	return 0;
 }
 
+static void NCR5380_exit(struct Scsi_Host *instance)
+{
+	/* Empty, as we didn't schedule any delayed work */
+}
+
 /*
  * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
  *	void (*done)(Scsi_Cmnd *))
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 3e8658e..04a154f 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -730,6 +730,7 @@ int atari_scsi_release(struct Scsi_Host *sh)
 		free_irq(IRQ_TT_MFP_SCSI, sh);
 	if (atari_dma_buffer)
 		atari_stram_free(atari_dma_buffer);
+	NCR5380_exit(sh);
 	return 1;
 }
 
-- 
1.7.0.4

