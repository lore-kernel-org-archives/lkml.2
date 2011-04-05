Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1DEKVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:21:51 -0400
Received: from smtp.nokia.com ([147.243.128.24]:30812 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1DEKVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:21:49 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to Makefile
Date: Tue,  5 Apr 2011 13:24:58 +0300
Message-Id: <1301999098-21412-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
References: <1301999098-21412-1-git-send-email-dedekind1@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

At the moment we have the CONFIG_KALLSYMS_EXTRA_PASS Kconfig switch,
which users can enable or disable while configuring the kernel. This
option is then used by 'make' to determine whether an extra kallsyms
pass is needed or not.

However, this approach is not nice and confusing, and this patch moves
CONFIG_KALLSYMS_EXTRA_PASS from Kconfig to Makefile instead. The
rationale is below.

1. CONFIG_KALLSYMS_EXTRA_PASS is really about the build time, not
   run-time. There is no real need for it to be in Kconfig. It is
   just an additional work-around which should be used only in rare
   cases, when someone breaks kallsyms, so Kbuild/Makefile is much
   better place for this option.
2. Grepping CONFIG_KALLSYMS_EXTRA_PASS shows that many defconfigs have
   it enabled, probably not because they try to work-around a kallsyms
   bug, but just because the Kconfig help text is confusing and does
   not really make it clear that this option should not be used unless
   except when kallsyms is broken.
3. And since many people have CONFIG_KALLSYMS_EXTRA_PASS enabled in
   their Kconfig, we do might fail to notice kallsyms bugs in time. E.g.,
   many testers use "make allyesconfig" to test builds, which will enable
   CONFIG_KALLSYMS_EXTRA_PASS and kallsyms breakage will not be noticed.

To address that, this patch:

1. Kills CONFIG_KALLSYMS_EXTRA_PASS
2. Changes Makefile so that people can use "make KALLSYMS_EXTRA_PASS=1"
   to enable the extra pass if needed. Additionally, they may define
   KALLSYMS_EXTRA_PASS as an environment variable.
3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
   "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS
4. Add "make help" entry for KALLSYMS_EXTRA_PASS

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 Makefile     |   15 ++++++++++-----
 init/Kconfig |   12 ------------
 2 files changed, 10 insertions(+), 17 deletions(-)

Changelog:
v1->v2:
	* Allow CONFIG_KALLSYMS_EXTRA_PASS to be an environment variable
	  as well, not only command line argument

diff --git a/Makefile b/Makefile
index ba7a55c..58f8ab5 100644
--- a/Makefile
+++ b/Makefile
@@ -797,15 +797,17 @@ ifdef CONFIG_KALLSYMS
 # o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
 # o Verify that the System.map from vmlinux matches the map from
 #   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
-# o If CONFIG_KALLSYMS_EXTRA_PASS is set, do an extra pass using
+# o If 'make KALLSYMS_EXTRA_PASS=1" was used, do an extra pass using
 #   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
 #   temporary bypass to allow the kernel to be built while the
 #   maintainers work out what went wrong with kallsyms.
 
-ifdef CONFIG_KALLSYMS_EXTRA_PASS
-last_kallsyms := 3
-else
 last_kallsyms := 2
+
+ifdef KALLSYMS_EXTRA_PASS
+ifneq ($(KALLSYMS_EXTRA_PASS),0)
+last_kallsyms := 3
+endif
 endif
 
 kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
@@ -816,7 +818,8 @@ define verify_kallsyms
 	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
 	$(Q)cmp -s System.map .tmp_System.map ||                             \
 		(echo Inconsistent kallsyms data;                            \
-		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;                \
+		 echo This is a bug - please report about it;                \
+		 echo Try "make KALLSYMS_EXTRA_PASS=1" as a workaround;      \
 		 rm .tmp_kallsyms* ; /bin/false )
 endef
 
@@ -1268,6 +1271,8 @@ help:
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
 	@echo  '  make W=1   [targets] Enable extra gcc checks'
+	@echo  '  make KALLSYMS_EXTRA_PASS=1 [targets] Temporary workaround for kallsyms bugs'
+	@echo  '       (KALLSYMS_EXTRA_PASS may also be an environment variable)'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/init/Kconfig b/init/Kconfig
index 563065d..0edda61 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -981,18 +981,6 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
-config KALLSYMS_EXTRA_PASS
-	bool "Do an extra kallsyms pass"
-	depends on KALLSYMS
-	help
-	   If kallsyms is not working correctly, the build will fail with
-	   inconsistent kallsyms data.  If that occurs, log a bug report and
-	   turn on KALLSYMS_EXTRA_PASS which should result in a stable build.
-	   Always say N here unless you find a bug in kallsyms, which must be
-	   reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
-	   you wait for kallsyms to be fixed.
-
-
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EXPERT
 	default y
-- 
1.7.2.3

