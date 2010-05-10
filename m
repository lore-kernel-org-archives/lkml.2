Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab0EJXDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:03:50 -0400
Received: from kroah.org ([198.145.64.141]:45329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924Ab0EJW6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:25 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.153507257@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [75/98] [SCSI] skip sense logging for some ATA PASS-THROUGH cdbs
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Douglas Gilbert <dgilbert@interlog.com>

commit e7efe5932b1d3916c79326a4221693ea90a900e2 upstream.

Further to the lsml thread titled:
"does scsi_io_completion need to dump sense data for ata pass through (ck_cond =
1) ?"

This is a patch to skip logging when the sense data is
associated with a SENSE_KEY of "RECOVERED_ERROR" and the
additional sense code is "ATA PASS-THROUGH INFORMATION
AVAILABLE". This only occurs with the SAT ATA PASS-THROUGH
commands when CK_COND=1 (in the cdb). It indicates that
the sense data contains ATA registers.

Smartmontools uses such commands on ATA disks connected via
SAT. Periodic checks such as those done by smartd cause
nuisance entries into logs that are:
    - neither errors nor warnings
    - pointless unless the cdb that caused them are also logged

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -773,8 +773,14 @@ void scsi_io_completion(struct scsi_cmnd
 	 * we already took a copy of the original into rq->errors which
 	 * is what gets returned to the user
 	 */
-	if (sense_valid && sshdr.sense_key == RECOVERED_ERROR) {
-		if (!(req->cmd_flags & REQ_QUIET))
+	if (sense_valid && (sshdr.sense_key == RECOVERED_ERROR)) {
+		/* if ATA PASS-THROUGH INFORMATION AVAILABLE skip
+		 * print since caller wants ATA registers. Only occurs on
+		 * SCSI ATA PASS_THROUGH commands when CK_COND=1
+		 */
+		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
+			;
+		else if (!(req->cmd_flags & REQ_QUIET))
 			scsi_print_sense("", cmd);
 		result = 0;
 		/* BLOCK_PC may have set error */


