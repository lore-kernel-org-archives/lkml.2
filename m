Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab2EWRxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:53:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46176 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2EWRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:53:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH 1/4] xen/hvc: Collapse error logic.
Date: Wed, 23 May 2012 13:46:59 -0400
Message-Id: <1337795222-29946-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the error paths are doing the same logic. In which
case we might as well collapse them in one path.

CC: stable@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index d3d91da..afc7fc2 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -216,22 +216,16 @@ static int xen_hvm_console_init(void)
 		return 0;
 
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
-	if (r < 0) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (r < 0)
+		goto err;
 	info->evtchn = v;
 	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
-	if (r < 0) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (r < 0)
+		goto err;
 	mfn = v;
 	info->intf = ioremap(mfn << PAGE_SHIFT, PAGE_SIZE);
-	if (info->intf == NULL) {
-		kfree(info);
-		return -ENODEV;
-	}
+	if (info->intf == NULL)
+		goto err;
 	info->vtermno = HVC_COOKIE;
 
 	spin_lock(&xencons_lock);
@@ -239,6 +233,9 @@ static int xen_hvm_console_init(void)
 	spin_unlock(&xencons_lock);
 
 	return 0;
+err:
+	kfree(info);
+	return -ENODEV;
 }
 
 static int xen_pv_console_init(void)
-- 
1.7.7.5

