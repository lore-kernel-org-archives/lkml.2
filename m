Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1K3T6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:58:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46897 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1K3T6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:58:08 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.ddebug instead of pnp.debug
Date: Wed, 30 Nov 2011 12:56:48 -0700
Message-Id: <1322683014-13285-20-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

resubmit of https://lkml.org/lkml/2010/9/15/398

This allows usage of generic pnp.ddebug debug parameter instead of
pnp.debug PNP specific parameter.

I wonder whether CONFIG_PNP_DEBUG_MESSAGES can vanish totally with
this or at some time. Only advantage having it is: If you are
restricted and your kernel must not exceed X bytes, you cannot compile
in PNP debug messages only, but you have to compile in all debug
messages.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
CC: Thomas Renninger <trenn@suse.de>
---
 drivers/pnp/base.h |    8 ++++++--
 drivers/pnp/core.c |   13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

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
index cb6ce42..332010a 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -219,6 +219,19 @@ subsys_initcall(pnp_init);
 
 int pnp_debug;
 
+#if defined(CONFIG_DYNAMIC_DEBUG)
+static int __init pnp_debug_setup(char *__unused)
+{
+	printk(KERN_INFO "DYNAMIC_DEBUG enabled use pnp.ddebug instead of "
+		"pnp.debug boot param\n");
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

