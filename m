Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1DMQLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:11:42 -0400
Received: from kroah.org ([198.145.64.141]:54217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab1DMPzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:44 2011
Message-Id: <20110413155143.916847355@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>,
        Babu Moger <babu.moger@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [09/74] [SCSI] ses: Avoid kernel panic when lun 0 is not mapped
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


