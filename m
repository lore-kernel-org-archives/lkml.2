Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0EJW4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:56:21 -0400
Received: from kroah.org ([198.145.64.141]:33454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab0EJWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:08 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.845875867@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [116/117] SCSI: Retry commands with UNIT_ATTENTION sense codes to fix ext3/ext4 I/O error
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 77a4229719e511a0d38d9c355317ae1469adeb54 upstream.

There's nastyness in the way we currently handle barriers (and
discards): They're effectively filesystem commands, but they get
processed as BLOCK_PC commands.  Unfortunately BLOCK_PC commands are
taken by SCSI to be SG_IO commands and the issuer expects to see and
handle any returned errors, however trivial.  This leads to a huge
problem, because the block layer doesn't expect this to happen and any
trivially retryable error on a barrier causes an immediate I/O error
to the filesystem.

The only real way to hack around this is to take the usual class of
offending errors (unit attentions) and make them all retryable in the
case of a REQ_HARDBARRIER.  A correct fix would involve a rework of
the entire block and SCSI submit system, and so is out of scope for a
quick fix.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_error.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -301,7 +301,20 @@ static int scsi_check_sense(struct scsi_
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
-		return SUCCESS;
+
+		if (blk_barrier_rq(scmd->request))
+			/*
+			 * barrier requests should always retry on UA
+			 * otherwise block will get a spurious error
+			 */
+			return NEEDS_RETRY;
+		else
+			/*
+			 * for normal (non barrier) commands, pass the
+			 * UA upwards for a determination in the
+			 * completion functions
+			 */
+			return SUCCESS;
 
 		/* these three are not supported */
 	case COPY_ABORTED:


