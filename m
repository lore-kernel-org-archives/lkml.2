Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1JHKsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:48:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64615 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1JHKs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:48:29 -0400
Date: Sat, 8 Oct 2011 13:45:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        "James E.J. Bottomley" <jbottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] [SCSI] aacraid: use lower snprintf() limit
Message-ID: <20111008104507.GP30887@longonot.mountain>
References: <20111005055046.GD32077@elgon.mountain>
 <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090209.4E902A5D.0050,ss=1,re=0.000,fgs=0
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
---
v2:  fix a whitespace issue, and use the min() macro.

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3382475..4aa76d6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -894,16 +894,17 @@ static ssize_t aac_show_serial_number(struct device *device,
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
-	return len;
+
+	return min(len, 16);
 }
 
 static ssize_t aac_show_max_channel(struct device *device,
