Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab2E1So0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:44:26 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40552 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2E1Snj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:43:39 -0400
From: Vincent Sanders <vincent.sanders@collabora.co.uk>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Vincent Sanders <vince@collabora.co.uk>,
        Vincent Sanders <vincent.sanders@collabora.co.uk>
Subject: [PATCH 1/2] Allow constructor name selection by architecture.
Date: Mon, 28 May 2012 19:33:37 +0100
Message-Id: <1338230018-31052-2-git-send-email-vincent.sanders@collabora.co.uk>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
References: <1338230018-31052-1-git-send-email-vincent.sanders@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Sanders <vince@collabora.co.uk>

The constructor symbol name is different between platforms. Allow this
to be selected by configuration and set suitable default values.

Signed-off-by: Vincent Sanders <vincent.sanders@collabora.co.uk>
---
 include/asm-generic/vmlinux.lds.h |    6 +++---
 init/Kconfig                      |    6 ++++++
 kernel/module.c                   |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8aeadf6..fd34808 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -471,9 +471,9 @@
 	}
 
 #ifdef CONFIG_CONSTRUCTORS
-#define KERNEL_CTORS()	. = ALIGN(8);			   \
-			VMLINUX_SYMBOL(__ctors_start) = .; \
-			*(.ctors)			   \
+#define KERNEL_CTORS()	. = ALIGN(8);					\
+			VMLINUX_SYMBOL(__ctors_start) = .;		\
+			*(CONFIG_CONSTRUCTORS_NAME)			\
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..52181a1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,6 +20,12 @@ config CONSTRUCTORS
 	bool
 	depends on !UML
 
+config CONSTRUCTORS_NAME
+	string
+	depends on CONSTRUCTORS
+	default ".init_array" if ARM && AEABI
+	default ".ctors"
+
 config HAVE_IRQ_WORK
 	bool
 
diff --git a/kernel/module.c b/kernel/module.c
index 78ac6ec..e5fad5e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2600,7 +2600,7 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 	mod->unused_gpl_crcs = section_addr(info, "__kcrctab_unused_gpl");
 #endif
 #ifdef CONFIG_CONSTRUCTORS
-	mod->ctors = section_objs(info, ".ctors",
+	mod->ctors = section_objs(info, CONFIG_CONSTRUCTORS_NAME,
 				  sizeof(*mod->ctors), &mod->num_ctors);
 #endif
 
-- 
1.7.10

