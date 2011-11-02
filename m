Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934618Ab1KCBvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:51:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672Ab1KCBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.817084435@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kiran Patil <kiran.patil@intel.com>,
        Robert Love <robert.w.love@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [034/101] [SCSI] fcoe: Unable to select the exchangeID from offload pool for storage targets
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kiran Patil <kiran.patil@intel.com>

commit 1ff9918b625457ce20d450d00f9ed0a12ba191b7 upstream.

Problem: When initiator sends write command to target, target tries to
assign new sequence. It allocates new exchangeID (RX_ID)
always from non-offloaded pool (Non-offload EMA)

Fix: Enhanced fcoe_oem_match routine to look at F_CTL flags and if it
is exchange responder and command type is WRITEDATA, then function
returns TRUE instead of FALSE. This function is used to determine
which pool to use (offload pool of exchange is used only if this
function returns TRUE).

Technical Notes: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -704,12 +704,27 @@ static int fcoe_shost_config(struct fc_l
  * The offload EM that this routine is associated with will handle any
  * packets that are for SCSI read requests.
  *
+ * This has been enhanced to work when FCoE stack is operating in target
+ * mode.
+ *
  * Returns: True for read types I/O, otherwise returns false.
  */
 bool fcoe_oem_match(struct fc_frame *fp)
 {
-	return fc_fcp_is_read(fr_fsp(fp)) &&
-		(fr_fsp(fp)->data_len > fcoe_ddp_min);
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	struct fcp_cmnd *fcp;
+
+	if (fc_fcp_is_read(fr_fsp(fp)) &&
+	    (fr_fsp(fp)->data_len > fcoe_ddp_min))
+		return true;
+	else if (!(ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)) {
+		fcp = fc_frame_payload_get(fp, sizeof(*fcp));
+		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN &&
+		    fcp && (ntohl(fcp->fc_dl) > fcoe_ddp_min) &&
+		    (fcp->fc_flags & FCP_CFL_WRDATA))
+			return true;
+	}
+	return false;
 }
 
 /**


