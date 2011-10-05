Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab1JEFu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 01:50:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42683 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab1JEFuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 01:50:55 -0400
Date: Wed, 5 Oct 2011 08:50:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] aacraid: use lower snprintf() limit
Message-ID: <20111005055046.GD32077@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E8BF03D.001A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup, to silence static checker warnings.  It
doesn't change how the code works.

buf[] can either be BUF_SIZE if this is called from sysfs, or it can
be 16 if it's called from aac_get_adapter_info() via
aac_get_serial_number().  We use the smaller limit here.

sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo) is 12 so there
is actually no chance of hitting either limit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3382475..ea8d96e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -894,15 +894,20 @@ static ssize_t aac_show_serial_number(struct device *device,
 	int len = 0;
 
 	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
-		len = snprintf(buf, PAGE_SIZE, "%06X\n",
+		len = snprintf(buf, 16, "%06X\n",
 		  le32_to_cpu(dev->adapter_info.serial[0]));
 	if (len &&
 	  !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
 	    sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
 	  buf, len-1))
-		len = snprintf(buf, PAGE_SIZE, "%.*s\n",
+		len = snprintf(buf, 16, "%.*s\n",
 		  (int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo),
 		  dev->supplement_adapter_info.MfgPcbaSerialNo);
+
+
+	if (len > 16)
+		len = 16;
+
 	return len;
 }
 
