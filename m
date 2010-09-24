Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0IXM3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:29:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0IXM2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:28:34 -0400
From: Thomas Renninger <trenn@suse.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, jbaron@redhat.com,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/4] PNP: Use dev_dbg instead of dev_printk(KERN_DEBUG.. if DYNAMIC_DEBUG is compiled in
Date: Fri, 24 Sep 2010 14:28:30 +0200
Message-Id: <1285331311-21753-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100920184441.GA2915@redhat.com>
References: <20100920184441.GA2915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows usage of generic pnp.ddebug debug parameter instead of pnp.debug
PNP specific parameter.

I wonder whether CONFIG_PNP_DEBUG_MESSAGES can vanish totally with this or
at some time. Only advantage having it is:
If you are restricted and your kernel must not exceed X bytes, you cannot compile
in PNP debug messages only, but you have to compile in all debug messages.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jason Baron <jbaron@redhat.com>
CC: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
---
 drivers/pnp/base.h |    8 ++++++--
 drivers/pnp/core.c |   16 +++++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 0bab84e..1f7f9bd 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -170,12 +170,16 @@ struct pnp_resource *pnp_add_bus_resource(struct pnp_dev *dev,
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
index 88b3cde..fe834ac 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -215,9 +215,21 @@ static int __init pnp_init(void)
 
 subsys_initcall(pnp_init);
 
-int pnp_debug;
+#if defined(CONFIG_DYNAMIC_DEBUG)
+static int __init pnp_debug_setup(char *__unused)
+{
+	printk(KERN_INFO "DYNAMIC_DEBUG enabled use pnp.ddebug instead of "
+	       "pnp.debug boot param\n");
+	return 1;
+}
+__setup("pnp.debug", pnp_debug_setup);
+
+#else
 
 #if defined(CONFIG_PNP_DEBUG_MESSAGES)
+
+int pnp_debug;
+
 static int __init pnp_debug_setup(char *__unused)
 {
 	pnp_debug = 1;
@@ -225,3 +237,5 @@ static int __init pnp_debug_setup(char *__unused)
 }
 __setup("pnp.debug", pnp_debug_setup);
 #endif
+
+#endif
-- 
1.6.4.2

