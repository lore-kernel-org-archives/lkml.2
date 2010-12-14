Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab0LNQkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:40:08 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:49485 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758230Ab0LNQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:40:06 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Michal Marek <mmarek@suse.cz>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH v2] kbuild: fix interaction of CONFIG_IKCONFIG and KCONFIG_CONFIG
Date: Tue, 14 Dec 2010 11:39:44 -0500
Message-Id: <98706bc370fe92e090b16c7ad91dce1cd2203acf.1292344590.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4D078D53.4040700@suse.cz>
References: <4D078D53.4040700@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you try to build a kernel with KCONFIG_CONFIG set (to a value
not equal to .config) and that config sets CONFIG_IKCONFIG then the
build will fail with:

make[1]: *** No rule to make target `.config', needed by \
`kernel/config_data.gz'.  Stop.

because the kernel/Makefile contains a direct reference to .config.

This issue has been present since the introduction of KCONFIG_CONFIG
in 14cdd3c402bf7c66f0bcd76e290f0770a54a4b21.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Roman Zippel <zippel@linux-m68k.org>
CC: Michal Marek <mmarek@suse.cz>
Reviewed-by: Michal Marek <mmarek@suse.cz>

---

changes since v1:
 * rebased to 6313e3c21743cc88bb5bd8aa72948ee1e83937b6 of
   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 * export KCONFIG_CONFIG from top-level Makefile (Michal Marek)

---
 Makefile        |    1 +
 kernel/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 3d94974..e0973cc 100644
--- a/Makefile
+++ b/Makefile
@@ -224,6 +224,7 @@ ifeq ($(ARCH),m68knommu)
 endif
 
 KCONFIG_CONFIG	?= .config
+export KCONFIG_CONFIG
 
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..33e0a39 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -121,7 +121,7 @@ $(obj)/configs.o: $(obj)/config_data.h
 # config_data.h contains the same information as ikconfig.h but gzipped.
 # Info from config_data can be extracted from /proc/config*
 targets += config_data.gz
-$(obj)/config_data.gz: .config FORCE
+$(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
 quiet_cmd_ikconfiggz = IKCFG   $@
-- 
1.7.0.4

