Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0DMNHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 09:07:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0DMNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:07:07 -0400
Message-ID: <4BC46C6C.4010203@vlnb.net>
Date: Tue, 13 Apr 2010 17:06:52 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vu Pham <vuhuong@mellanox.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>,
       Andy Yan <ayan@marvell.com>, linux-driver@qlogic.com
Subject: Re: [PATCH][RFC 10/12/1/5] SCST external modules support
References: <4BC44A49.7070307@vlnb.net> <4BC44D08.4060907@vlnb.net>
In-Reply-To: <4BC44D08.4060907@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18BR0nYbWOygAVdsyTr2/vautonS63Fpg+PXCD
 Fa1K3OlNP2e0dm4aIjLmtHJytCooVb3IoNMjpGenLqdvQ1gNhx
 OKLz2BaoHNk0xPxg/Ch6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains SCST external modules support routines.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 scst_module.c |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff -uprN orig/linux-2.6.33/drivers/scst/scst_module.c linux-2.6.33/drivers/scst/scst_module.c
--- orig/linux-2.6.33/drivers/scst/scst_module.c
+++ linux-2.6.33/drivers/scst/scst_module.c
@@ -0,0 +1,63 @@
+/*
+ *  scst_module.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  Support for loading target modules. The usage is similar to scsi_module.c
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include <scst.h>
+
+static int __init init_this_scst_driver(void)
+{
+	int res;
+
+	res = scst_register_target_template(&driver_target_template);
+	TRACE_DBG("scst_register_target_template() returned %d", res);
+	if (res < 0)
+		goto out;
+
+#ifdef SCST_REGISTER_INITIATOR_DRIVER
+	driver_template.module = THIS_MODULE;
+	scsi_register_module(MODULE_SCSI_HA, &driver_template);
+	TRACE_DBG("driver_template.present=%d",
+	      driver_template.present);
+	if (driver_template.present == 0) {
+		res = -ENODEV;
+		MOD_DEC_USE_COUNT;
+		goto out;
+	}
+#endif
+
+out:
+	return res;
+}
+
+static void __exit exit_this_scst_driver(void)
+{
+
+#ifdef SCST_REGISTER_INITIATOR_DRIVER
+	scsi_unregister_module(MODULE_SCSI_HA, &driver_template);
+#endif
+
+	scst_unregister_target_template(&driver_target_template);
+	return;
+}
+
+module_init(init_this_scst_driver);
+module_exit(exit_this_scst_driver);
