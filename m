Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1I1Wmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:42:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab1I1Wma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:42:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:36 2011
Message-Id: <20110928220136.087023333@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [102/244] [SCSI] isci: fix sata response handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 1a878284473284f9577d44babf16d87152a05c33 upstream.

A bug (likely copy/paste) that has been carried from the original
implementation.  The unsolicited frame handling structure returns the
d2h fis in the isci_request.stp.rsp buffer.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/request.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2399,22 +2399,19 @@ static void isci_task_save_for_upper_lay
 	}
 }
 
-static void isci_request_process_stp_response(struct sas_task *task,
-					      void *response_buffer)
+static void isci_process_stp_response(struct sas_task *task, struct dev_to_host_fis *fis)
 {
-	struct dev_to_host_fis *d2h_reg_fis = response_buffer;
 	struct task_status_struct *ts = &task->task_status;
 	struct ata_task_resp *resp = (void *)&ts->buf[0];
 
-	resp->frame_len = le16_to_cpu(*(__le16 *)(response_buffer + 6));
-	memcpy(&resp->ending_fis[0], response_buffer + 16, 24);
+	resp->frame_len = sizeof(*fis);
+	memcpy(resp->ending_fis, fis, sizeof(*fis));
 	ts->buf_valid_size = sizeof(*resp);
 
-	/**
-	 * If the device fault bit is set in the status register, then
+	/* If the device fault bit is set in the status register, then
 	 * set the sense data and return.
 	 */
-	if (d2h_reg_fis->status & ATA_DF)
+	if (fis->status & ATA_DF)
 		ts->stat = SAS_PROTO_RESPONSE;
 	else
 		ts->stat = SAM_STAT_GOOD;
@@ -2428,7 +2425,6 @@ static void isci_request_io_request_comp
 {
 	struct sas_task *task = isci_request_access_task(request);
 	struct ssp_response_iu *resp_iu;
-	void *resp_buf;
 	unsigned long task_flags;
 	struct isci_remote_device *idev = isci_lookup_device(task->dev);
 	enum service_response response       = SAS_TASK_UNDELIVERED;
@@ -2565,9 +2561,7 @@ static void isci_request_io_request_comp
 				task);
 
 			if (sas_protocol_ata(task->task_proto)) {
-				resp_buf = &request->stp.rsp;
-				isci_request_process_stp_response(task,
-								  resp_buf);
+				isci_process_stp_response(task, &request->stp.rsp);
 			} else if (SAS_PROTOCOL_SSP == task->task_proto) {
 
 				/* crack the iu response buffer. */


