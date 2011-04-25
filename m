Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1DYUpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:45:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34315 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1DYUYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:47 -0400
Message-Id: <20110425200238.165592363@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>,
        Babu Moger <babu.moger@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 119/173] [SCSI] ses: Avoid kernel panic when lun 0 is not mapped
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Krishnasamy, Somasundaram <Somasundaram.Krishnasamy@lsi.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/scsi/scsi_device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -446,7 +446,7 @@ static inline int scsi_device_qas(struct
 }
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
-	return sdev->inquiry[6] & (1<<6);
+	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
 }
 
 static inline int scsi_device_protection(struct scsi_device *sdev)


