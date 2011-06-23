Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab1FWSgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:36:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777Ab1FWSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:36:52 -0400
From: Sergiu Iordache <sergiu@chromium.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] char drivers: Ram oops kernel configuration parameters
Date: Thu, 23 Jun 2011 11:36:00 -0700
Message-Id: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramoops currently has module parameters for setting the configuration
variables (ram start, ram size and dump oopses). This makes it difficult to
configure when the module is compiled as a builtin.

This patch adds the following 3 configuration options which set the same
variables as the module parameters:
 1. RAMOOPS_RAM_START
 2. RAMOOPS_RAM_SIZE
 3. RAMOOPS_RAM_DUMP_OOPS

Module parameters take precedence over configuration parameters.

Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
---
 drivers/char/Kconfig   |   36 ++++++++++++++++++++++++++++++++++++
 drivers/char/ramoops.c |    6 +++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 49502bc..0284f9f 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -608,6 +608,42 @@ config RAMOOPS
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in RAM where it can be read back at some later point.
 
+config RAMOOPS_RAM_START
+	hex "Ramoops physical start address"
+	depends on RAMOOPS
+	default "0"
+	---help---
+	  Start address of the memory area that is used by Ramoops.
+
+	  For this feature to be useful, the selected memory area must be
+ 	  preserved across reboot, so not used by the boot loader, for example.
+
+	  Module parameter takes precedence over this.
+
+config RAMOOPS_RAM_SIZE
+	hex "Ramoops used RAM size"
+	depends on RAMOOPS
+	default "0"
+	---help---
+	  Size of the memory area that is used by Ramoops.
+
+	  For this feature to be useful, the selected memory area must be
+ 	  preserved across reboot, so not used by the boot loader, for example.
+
+	  Module parameter takes precedence over this.
+
+config RAMOOPS_DUMP_OOPS
+	int "Dump oopses or only panics"
+	depends on RAMOOPS
+	default "1"
+	help
+	  Flag to determine what gets dumped to RAM.
+
+	  If set to 1 then both oopses and panics are dumped to RAM.
+	  If set to 0 only kernel panics get dumped to RAM.
+
+	  Module parameter takes precedence over this.
+
 config MSM_SMD_PKT
 	bool "Enable device interface for some SMD packet ports"
 	default n
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 1a9f5f6..31b2c30 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -32,17 +32,17 @@
 
 #define RECORD_SIZE 4096UL
 
-static ulong mem_address;
+static ulong mem_address = CONFIG_RAMOOPS_RAM_START;
 module_param(mem_address, ulong, 0400);
 MODULE_PARM_DESC(mem_address,
 		"start of reserved RAM used to store oops/panic logs");
 
-static ulong mem_size;
+static ulong mem_size = CONFIG_RAMOOPS_RAM_SIZE;
 module_param(mem_size, ulong, 0400);
 MODULE_PARM_DESC(mem_size,
 		"size of reserved RAM used to store oops/panic logs");
 
-static int dump_oops = 1;
+static int dump_oops = CONFIG_RAMOOPS_DUMP_OOPS;
 module_param(dump_oops, int, 0600);
 MODULE_PARM_DESC(dump_oops,
 		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
-- 
1.7.2.3

