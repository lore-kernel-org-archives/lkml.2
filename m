Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2CMBIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:08:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:46651 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab2CMARm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:17:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>,
        Babu Moger <babu.moger@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 013/196] ses: Avoid kernel panic when lun 0 is not mapped
Date: Mon, 12 Mar 2012 20:12:21 -0400
Message-Id: <1331597724-31358-14-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d1e12de804f9d8ad114786ca7c2ce593cba79891 upstream.

During device discovery, scsi mid layer sends INQUIRY command to LUN
0. If the LUN 0 is not mapped to host, it creates a temporary
scsi_device with LUN id 0 and sends REPORT_LUNS command to it. After
the REPORT_LUNS succeeds, it walks through the LUN table and adds each
LUN found to sysfs. At the end of REPORT_LUNS lun table scan, it will
delete the temporary scsi_device of LUN 0.

When scsi devices are added to sysfs, it calls add_dev function of all
the registered class interfaces. If ses driver has been registered,
ses_intf_add() of ses module will be called. This function calls
scsi_device_enclosure() to check the inquiry data for EncServ
bit. Since inquiry was not allocated for temporary LUN 0 scsi_device,
it will cause NULL pointer exception.

To fix the problem, sdev->inquiry is checked for NULL before reading it.

Signed-off-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
Signed-off-by: Babu Moger <babu.moger@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/scsi/scsi_device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d80b6db..558fa2f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -451,7 +451,7 @@ static inline int scsi_device_qas(struct scsi_device *sdev)
 }
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
-	return sdev->inquiry[6] & (1<<6);
+	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
 }
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
-- 
1.7.9.3

