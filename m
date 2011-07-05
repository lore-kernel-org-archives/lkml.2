Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1GEXoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 19:44:21 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:47767 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1GEXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 19:44:20 -0400
Date: Tue, 05 Jul 2011 19:42:18 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rdunlap@xenotime.net
Subject: [PATCH] kernel: prevent unnecessary rebuilding due to config_data.gz
Message-id: <alpine.LNX.2.00.1107051741390.20637@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When IKCONFIG is built-in make oldconfig will cause the kernel to be 
relinked even if .config didn't change. This happens because of a 
config_data.gz dependency on .config. This patch changes the if_changed to 
a filechk so that config_data.h is only rebuilt when the contents 
have actually changed.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 kernel/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 2d64cfc..d06467f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -125,11 +125,10 @@ targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
-quiet_cmd_ikconfiggz = IKCFG   $@
-      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
+      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
-	$(call if_changed,ikconfiggz)
+	$(call filechk,ikconfiggz)
 
 $(obj)/time.o: $(obj)/timeconst.h
 
-- 
1.7.5.3

