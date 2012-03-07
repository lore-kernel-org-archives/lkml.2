Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031704Ab2CGAaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:30:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47078 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031679Ab2CGAau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:30:50 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>, nico@fluxnic.net,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
Date: Tue,  6 Mar 2012 17:30:37 -0700
Message-Id: <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the user to use U-Boot's mkimage's -T kernel_noload option
if their arch Kconfig allows it, and they desire.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
that some other architectures will also be able to enable it, but I'm
not familiar enough with any to know which.

 init/Kconfig         |   15 +++++++++++++++
 scripts/Makefile.lib |   15 ++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..2035562 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -203,6 +203,21 @@ config KERNEL_LZO
 
 endchoice
 
+config ALLOW_UIMAGE_KERNEL_NOLOAD
+	bool
+
+config UIMAGE_KERNEL_NOLOAD
+	bool "Use mkimage's -T kernel_noload instead of -T kernel"
+	depends on ALLOW_UIMAGE_KERNEL_NOLOAD
+	help
+	  uImage files of type "kernel" embed an absolute load and entry point
+	  address. If the uImage is loaded to a different address, then the
+	  image must be copied the uImage file to the specified load address.
+	  This copy is a waste of time if the uImage is in fact completely
+	  relocatable. If your kernel and bootloader support it, you can build
+	  a "kernel_noload" uImage rather than a "kernel" uImage, which
+	  prevents any such copying. If unsure say N.
+
 config DEFAULT_HOSTNAME
 	string "Default hostname"
 	default "(none)"
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7b0be18..d9c1c87 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -314,9 +314,18 @@ MKIMAGE := $(srctree)/scripts/mkuboot.sh
 UIMAGE_ARCH = $(SRCARCH)
 UIMAGE_COMPRESSION = $(if $(2),$(2),none)
 UIMAGE_OPTS-y =
-UIMAGE_TYPE = kernel
-UIMAGE_LOADADDR=arch_must_set_this
-UIMAGE_ENTRYADDR=$(UIMAGE_LOADADDR)
+ifeq ($(CONFIG_UIMAGE_KERNEL_NOLOAD),y)
+  UIMAGE_TYPE = kernel_noload
+  # Unused by bootloader:
+  UIMAGE_LOADADDR=0
+  # Entry point relative to actual load address:
+  UIMAGE_ENTRYADDR=0
+else
+  UIMAGE_TYPE = kernel
+  # Absolute addresses:
+  UIMAGE_LOADADDR=arch_must_set_this
+  UIMAGE_ENTRYADDR=$(UIMAGE_LOADADDR)
+endif
 UIMAGE_NAME = 'Linux-$(KERNELRELEASE)'
 UIMAGE_IN = $<
 UIMAGE_OUT = $@
-- 
1.7.0.4

