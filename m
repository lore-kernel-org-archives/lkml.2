Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0HLAo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:44:26 -0400
Received: from kroah.org ([198.145.64.141]:40068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673Ab0HKX5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:37 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:56 2010
Message-Id: <20100811235456.803025585@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [013/111] ide-cd: Do not access completed requests in the irq handler
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <bp@alien8.de>

commit 110712828365ccafcc61a7f4db44c31ed4cf8793 upstream.

ide_cd_error_cmd() can complete an erroneous request with leftover
buffers. Signal this with its return value so that the request is not
accessed after its completion in the irq handler and we oops.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -506,15 +506,22 @@ int ide_cd_queue_pc(ide_drive_t *drive,
 	return (flags & REQ_FAILED) ? -EIO : 0;
 }
 
-static void ide_cd_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
+/*
+ * returns true if rq has been completed
+ */
+static bool ide_cd_error_cmd(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	unsigned int nr_bytes = cmd->nbytes - cmd->nleft;
 
 	if (cmd->tf_flags & IDE_TFLAG_WRITE)
 		nr_bytes -= cmd->last_xfer_len;
 
-	if (nr_bytes > 0)
+	if (nr_bytes > 0) {
 		ide_complete_rq(drive, 0, nr_bytes);
+		return true;
+	}
+
+	return false;
 }
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
@@ -679,7 +686,8 @@ out_end:
 		}
 
 		if (uptodate == 0 && rq->bio)
-			ide_cd_error_cmd(drive, cmd);
+			if (ide_cd_error_cmd(drive, cmd))
+				return ide_stopped;
 
 		/* make sure it's fully ended */
 		if (blk_fs_request(rq) == 0) {


