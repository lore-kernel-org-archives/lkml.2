Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965311Ab1C3VKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:38344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965229Ab1C3VKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279169"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: Somasundaram.Krishnasamy@lsi.com, babu.moger@lsi.com,
        James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [251/275] ses: Avoid kernel panic when lun 0 is not mapped
Message-Id: <20110330210817.EE2043E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/scsi/scsi_device.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.35.y.orig/include/scsi/scsi_device.h	2011-03-29 22:50:10.926978825 -0700
+++ linux-2.6.35.y/include/scsi/scsi_device.h	2011-03-29 23:03:03.501210582 -0700
@@ -451,7 +451,7 @@
 }
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
-	return sdev->inquiry[6] & (1<<6);
+	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
 }
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
