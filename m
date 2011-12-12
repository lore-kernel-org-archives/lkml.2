Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1LLXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:13:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1LLXNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:13:42 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>, Thomas Renninger <trenn@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.dyndbg instead of pnp.debug
Date: Mon, 12 Dec 2011 16:12:45 -0700
Message-Id: <1323731569-20644-19-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

based upon https://lkml.org/lkml/2010/9/15/398

This patch splits control of pnp debug messages for 2 configs:

CONFIG_DYNAMIC_DEBUG:
  use pnp.dyndbg, using pnp.debug will warn
!CONFIG_DYNAMIC_DEBUG:
  use pnp.debug, using pnp.dyndbg will warn

2 separate boot options is perhaps suboptimal, but dyndbg is a 'fake'
parameter, and is special enough that adapting one to another is both
more suboptimal and harder to explain succinctly.

Thomas' original comments, still pertinent:

I wonder whether CONFIG_PNP_DEBUG_MESSAGES can vanish totally with
this or at some time. Only advantage having it is: If you are
restricted and your kernel must not exceed X bytes, you cannot compile
in PNP debug messages only, but you have to compile in all debug
messages.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
CC: Bjorn Helgaas <bhelgaas@google.com>
---
 Documentation/kernel-parameters.txt |   14 ++++++++------
 drivers/pnp/base.h                  |    8 ++++++--
 drivers/pnp/core.c                  |   12 ++++++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..81c27b1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2123,12 +2123,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Override pmtimer IOPort with a hex value.
 			e.g. pmtmr=0x508
 
-	pnp.debug=1	[PNP]
-			Enable PNP debug messages (depends on the
-			CONFIG_PNP_DEBUG_MESSAGES option).  Change at run-time
-			via /sys/module/pnp/parameters/debug.  We always show
-			current resource usage; turning this on also shows
-			possible settings and some assignment information.
+	pnp.debug=1	[PNP] Enable PNP debug messages
+		        (depends on CONFIG_PNP_DEBUG_MESSAGES and
+			!CONFIG_DYNAMIC_DEBUG options.  If latter, use
+			pnp.dyndbg instead).  Change at run-time via
+			/sys/module/pnp/parameters/debug.  We always
+			show current resource usage; turning this on
+			also shows possible settings and some
+			assignment information.
 
 	pnpacpi=	[ACPI]
 			{ off }
diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index fa4e0a5..28e98aa 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -173,12 +173,16 @@ struct pnp_resource *pnp_add_bus_resource(struct pnp_dev *dev,
 					  resource_size_t start,
 					  resource_size_t end);
 
-extern int pnp_debug;
-
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define pnp_dbg(dev, format, arg...)					\
+	({ dev_dbg(dev, format, ## arg); 0; })
+#else
 #if defined(CONFIG_PNP_DEBUG_MESSAGES)
+extern int pnp_debug;
 #define pnp_dbg(dev, format, arg...)					\
 	({ if (pnp_debug) dev_printk(KERN_DEBUG, dev, format, ## arg); 0; })
 #else
 #define pnp_dbg(dev, format, arg...)					\
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ## arg); 0; })
 #endif
+#endif
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index cb6ce42..838d82c 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -219,6 +219,18 @@ subsys_initcall(pnp_init);
 
 int pnp_debug;
 
+#if defined(CONFIG_DYNAMIC_DEBUG)
+static int __init pnp_debug_setup(char *__unused)
+{
+	pr_info("DYNAMIC_DEBUG enabled, use pnp.dyndbg instead\n");
+	return 1;
+}
+__setup("pnp.debug", pnp_debug_setup);
+
+#else
+
 #if defined(CONFIG_PNP_DEBUG_MESSAGES)
 module_param_named(debug, pnp_debug, int, 0644);
 #endif
+
+#endif
-- 
1.7.7.3

