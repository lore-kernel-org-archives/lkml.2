Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2ASIaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:30:17 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28798 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2ASIaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:30:13 -0500
Message-ID: <4F17D480.6050602@oracle.com>
Date: Thu, 19 Jan 2012 16:29:52 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Abhijeet Joglekar <abjoglek@cisco.com>,
        Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>,
        Brian Uchino <buchino@cisco.com>
CC: Sriharsha <sriharsha.devdas@oracle.com>, Joe Jin <joe.jin@oracle.com>,
        stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        andrew thomas <andrew.thomas@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] [SCSI] fnic: return zero on fnic_reset() success
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F17D494.007C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When issue LIP by sysfs found write("1") returned 8194, this caused by
fnic_reset() return SUCCESS to store_fc_private_host_issue_lip().
Return 0/-1 for fnic_reset() fix this issue.

Tested-by: Sriharsha <sriharsha.devdas@oracle.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
CC: stable@vger.kernel.org
---
 drivers/scsi/fnic/fnic_scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index c40ce52..e705e5e 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1662,7 +1662,7 @@ int fnic_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp;
 	struct fnic *fnic;
-	int ret = SUCCESS;
+	int ret = 0;
 
 	lp = shost_priv(shost);
 	fnic = lport_priv(lp);
@@ -1675,11 +1675,11 @@ int fnic_reset(struct Scsi_Host *shost)
 	 * reset remote port sessions, and if link is up, begin flogi
 	 */
 	if (lp->tt.lport_reset(lp))
-		ret = FAILED;
+		ret = -1;
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from fnic reset %s\n",
-		      (ret == SUCCESS) ?
+		      (ret == 0) ?
 		      "SUCCESS" : "FAILED");
 
 	return ret;
@@ -1706,7 +1706,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	 * scsi-ml tries to send a TUR to every device if host reset is
 	 * successful, so before returning to scsi, fabric should be up
 	 */
-	ret = fnic_reset(shost);
+	ret = (fnic_reset(shost) == 0) ? SUCCESS : FAILED;
 	if (ret == SUCCESS) {
 		wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
 		ret = FAILED;
-- 
1.7.7.5

