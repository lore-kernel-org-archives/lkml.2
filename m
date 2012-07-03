Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2GCPss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:48:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39257 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2GCPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen/hvc: Fix up checks when the info is allocated.
Date: Tue,  3 Jul 2012 11:40:38 -0400
Message-Id: <1341330038-21686-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity would complain about this - even thought it looks OK.

CID 401957
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/tty/hvc/hvc_xen.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 944eaeb..fbf41be 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -209,10 +209,8 @@ static int xen_hvm_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
 		if (!info)
 			return -ENOMEM;
-	}
-
-	/* already configured */
-	if (info->intf != NULL)
+	} else if (info->intf != NULL) {
+		/* already configured */
 		return 0;
 	/*
 	 * If the toolstack (or the hypervisor) hasn't set these values, the
@@ -220,6 +218,7 @@ static int xen_hvm_console_init(void)
 	 * theoretically correct values, in practice they never are and they
 	 * mean that a legacy toolstack hasn't initialized the pv console correctly.
 	 */
+	 */
 	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
 	if (r < 0 || v == 0)
 		goto err;
@@ -259,12 +258,10 @@ static int xen_pv_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
 		if (!info)
 			return -ENOMEM;
-	}
-
-	/* already configured */
-	if (info->intf != NULL)
+	} else if (info->intf != NULL) {
+		/* already configured */
 		return 0;
-
+	}
 	info->evtchn = xen_start_info->console.domU.evtchn;
 	info->intf = mfn_to_virt(xen_start_info->console.domU.mfn);
 	info->vtermno = HVC_COOKIE;
-- 
1.7.7.6

