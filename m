Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2I2EXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 00:23:51 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53105 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2I2EXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 00:23:49 -0400
Message-ID: <1348892617.6455.4.camel@ThinkPad-T420>
Subject: [PATCH v2 scsi] Short the path length of scsi_cmd_to_driver()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 29 Sep 2012 12:23:37 +0800
In-Reply-To: <1348818498.2411.8.camel@dabdike.int.hansenpartnership.com>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
	 <1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	 <1348721055.2509.0.camel@dabdike> <yq1bogr8itb.fsf@sermon.lab.mkp.net>
	 <1348818498.2411.8.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092904-5816-0000-0000-000004AB784C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by James: this patch tries to short the path length of
scsi_cmd_to_driver(). As only REQ_TYPE_BLOCK_PC commands can be
submitted without a driver, so we could avoid the related NULL
checking, as long as we make sure we don't use it for REQ_TYPE_BLOCK_PC
type commands. Plus, this fixes a bug where you get different behaviors
from REQ_TYPE_BLOCK_PC commands when a driver is and isn't attached.

v2: mirror code != REQ_TYPE_BLOCK_PC in scsi.c, rather than == REQ_TYPE_FS

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_error.c |    8 +++++---
 include/scsi/scsi_cmnd.h  |   12 ++----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index de2337f..c1b05a8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -789,7 +789,6 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 			     int cmnd_size, int timeout, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
-	struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
 	struct Scsi_Host *shost = sdev->host;
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft;
@@ -845,8 +844,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-	if (sdrv && sdrv->eh_action)
-		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
+	if (scmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
+		if (sdrv->eh_action)
+			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
+	}
 
 	return rtn;
 }
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ac06cc5..de5f5d8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -132,18 +132,10 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
+/* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
-	struct scsi_driver **sdp;
-
-	if (!cmd->request->rq_disk)
-		return NULL;
-
-	sdp = (struct scsi_driver **)cmd->request->rq_disk->private_data;
-	if (!sdp)
-		return NULL;
-
-	return *sdp;
+	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
 }
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-- 
1.7.7.6



