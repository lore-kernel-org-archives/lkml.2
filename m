Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1JJHho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 03:37:44 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:46400 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1JJHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 03:37:43 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjUQEYRerA==
X-RZG-CLASS-ID: mo00
Date: Mon, 10 Oct 2011 09:37:39 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH] staging: hv: storvsc: ignore SET_WINDOW scsi command
Message-ID: <20111010073739.GA19807@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some commands sent by smartd will offline the device.
With this change applied, smartd sill not monitor the device anymore.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/storvsc_drv.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1122,6 +1122,22 @@ static void storvsc_command_completion(s
 	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
 
+static bool storvsc_check_scsi_cmd(struct scsi_cmnd *scmnd)
+{
+	bool allowed = true;
+	u8 scsi_op = scmnd->cmnd[0];
+
+	switch (scsi_op) {
+		/* smartd sends this command, which will offline the device */
+		case SET_WINDOW:
+			scmnd->result = DID_ERROR << 16;
+			allowed = false;
+			break;
+		default:
+			break;
+	}
+	return allowed;
+}
 
 /*
  * storvsc_queuecommand - Initiate command processing
@@ -1141,6 +1157,10 @@ static int storvsc_queuecommand_lck(stru
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
 
+	if (storvsc_check_scsi_cmd(scmnd) == false) {
+		done(scmnd);
+		return 0;
+	}
 
 	/* If retrying, no need to prep the cmd */
 	if (scmnd->host_scribble) {
