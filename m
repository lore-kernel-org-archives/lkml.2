Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0DVTdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:33:10 -0400
Received: from kroah.org ([198.145.64.141]:41586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab0DVT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:24 2010
Message-Id: <20100422190924.012622772@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       maximilian attems <max@stro.at>
Subject: [185/197] [SCSI] mptspi: Fix for incorrect data underrun errata
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 9b53b39243cf23a0b68eaa16c37ce16eada69a46 upstream.

Errata:
Certain conditions on the scsi bus may casue the 53C1030 to incorrectly signal
a SCSI_DATA_UNDERRUN to the host.

Workaround 1:
For an Errata on LSI53C1030 When the length of request data
and transfer data are different with result of command (READ or VERIFY),
DID_SOFT_ERROR is set.

Workaround 2:
For potential trouble on LSI53C1030. It is checked whether the length of
request data is equal to the length of transfer and residual.
MEDIUM_ERROR is set by incorrect data.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptscsih.c |   86 +++++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 5 deletions(-)

--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -792,11 +792,36 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			 *  precedence!
 			 */
 			sc->result = (DID_OK << 16) | scsi_status;
-			if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
-				/* Have already saved the status and sense data
+			if (!(scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID)) {
+
+				/*
+				 * For an Errata on LSI53C1030
+				 * When the length of request data
+				 * and transfer data are different
+				 * with result of command (READ or VERIFY),
+				 * DID_SOFT_ERROR is set.
 				 */
-				;
-			} else {
+				if (ioc->bus_type == SPI) {
+					if (pScsiReq->CDB[0] == READ_6  ||
+					    pScsiReq->CDB[0] == READ_10 ||
+					    pScsiReq->CDB[0] == READ_12 ||
+					    pScsiReq->CDB[0] == READ_16 ||
+					    pScsiReq->CDB[0] == VERIFY  ||
+					    pScsiReq->CDB[0] == VERIFY_16) {
+						if (scsi_bufflen(sc) !=
+							xfer_cnt) {
+							sc->result =
+							DID_SOFT_ERROR << 16;
+						    printk(KERN_WARNING "Errata"
+						    "on LSI53C1030 occurred."
+						    "sc->req_bufflen=0x%02x,"
+						    "xfer_cnt=0x%02x\n",
+						    scsi_bufflen(sc),
+						    xfer_cnt);
+						}
+					}
+				}
+
 				if (xfer_cnt < sc->underflow) {
 					if (scsi_status == SAM_STAT_BUSY)
 						sc->result = SAM_STAT_BUSY;
@@ -835,7 +860,58 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			sc->result = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
 				;
-			} else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
+			} else if (scsi_state &
+			    MPI_SCSI_STATE_AUTOSENSE_VALID) {
+
+				/*
+				 * For potential trouble on LSI53C1030.
+				 * (date:2007.xx.)
+				 * It is checked whether the length of
+				 * request data is equal to
+				 * the length of transfer and residual.
+				 * MEDIUM_ERROR is set by incorrect data.
+				 */
+				if ((ioc->bus_type == SPI) &&
+					(sc->sense_buffer[2] & 0x20)) {
+					u32	 difftransfer;
+					difftransfer =
+					sc->sense_buffer[3] << 24 |
+					sc->sense_buffer[4] << 16 |
+					sc->sense_buffer[5] << 8 |
+					sc->sense_buffer[6];
+					if (((sc->sense_buffer[3] & 0x80) ==
+						0x80) && (scsi_bufflen(sc)
+						!= xfer_cnt)) {
+						sc->sense_buffer[2] =
+						    MEDIUM_ERROR;
+						sc->sense_buffer[12] = 0xff;
+						sc->sense_buffer[13] = 0xff;
+						printk(KERN_WARNING"Errata"
+						"on LSI53C1030 occurred."
+						"sc->req_bufflen=0x%02x,"
+						"xfer_cnt=0x%02x\n" ,
+						scsi_bufflen(sc),
+						xfer_cnt);
+					}
+					if (((sc->sense_buffer[3] & 0x80)
+						!= 0x80) &&
+						(scsi_bufflen(sc) !=
+						xfer_cnt + difftransfer)) {
+						sc->sense_buffer[2] =
+							MEDIUM_ERROR;
+						sc->sense_buffer[12] = 0xff;
+						sc->sense_buffer[13] = 0xff;
+						printk(KERN_WARNING
+						"Errata on LSI53C1030 occurred"
+						"sc->req_bufflen=0x%02x,"
+						" xfer_cnt=0x%02x,"
+						"difftransfer=0x%02x\n",
+						scsi_bufflen(sc),
+						xfer_cnt,
+						difftransfer);
+					}
+				}
+
 				/*
 				 * If running against circa 200003dd 909 MPT f/w,
 				 * may get this (AUTOSENSE_VALID) for actual TASK_SET_FULL


