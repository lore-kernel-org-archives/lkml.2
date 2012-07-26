Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2GZP4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:56:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47903 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2GZP4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:56:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="203311643"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 22/24] ARM: enable earlyprintk=xen
Date: Thu, 26 Jul 2012 16:34:04 +0100
Message-ID: <1343316846-25860-22-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Currently ARM setup_early_printk does not support alternative early
consoles and it always registers early_console only.

This patch adds support for xenboot_console.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/kernel/early_printk.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/early_printk.c b/arch/arm/kernel/early_printk.c
index 85aa2b2..eecfa21 100644
--- a/arch/arm/kernel/early_printk.c
+++ b/arch/arm/kernel/early_printk.c
@@ -11,6 +11,8 @@
 #include <linux/kernel.h>
 #include <linux/console.h>
 #include <linux/init.h>
+#include <linux/string.h>
+#include <xen/hvc-console.h>
 
 extern void printch(int);
 
@@ -50,7 +52,14 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static int __init setup_early_printk(char *buf)
 {
-	register_console(&early_console);
+	if (!buf || !strncmp(buf, "serial", 6))
+		register_console(&early_console);
+
+#ifdef CONFIG_HVC_XEN
+	if (!strncmp(buf, "xen", 3))
+		register_console(&xenboot_console);
+#endif
+
 	return 0;
 }
 
-- 
1.7.2.5

