Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1CHTD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:03:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34684 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1CHTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:03:24 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 1/3] AppArmor: Cleanup make file to remove cruft and make it easier to read
Date: Tue,  8 Mar 2011 11:03:07 -0800
Message-Id: <1299610989-3917-2-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
References: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanups based on comments from Sam Ravnborg,

* remove references to the currently unused af_names.h
* add rlim_names.h to clean-files:
* rework cmd_make-XXX to make them more readable by adding comments,
  reworking the expressions to put logical components on individual lines,
  and keep lines < 80 characters.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 security/apparmor/Makefile |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index f204869..81e5b16 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -6,19 +6,47 @@ apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
               path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
               resource.o sid.o file.o
 
-clean-files: capability_names.h af_names.h
+clean-files: capability_names.h rlim_names.h
 
+
+# Build a lower case string table of capability names
+# Transforms lines from
+#    #define CAP_DAC_OVERRIDE     1
+# to
+#    [1] = "dac_override",
 quiet_cmd_make-caps = GEN     $@
-cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
+cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ;\
+	sed $< >>$@ -r -n -e '/CAP_FS_MASK/d' \
+	-e 's/^\#define[ \t]+CAP_([A-Z0-9_]+)[ \t]+([0-9]+)/[\2] = "\L\1",/p';\
+	echo "};" >> $@
+
 
+# Build a lower case string table of rlimit names.
+# Transforms lines from
+#    #define RLIMIT_STACK		3	/* max stack size */
+# to
+#    [RLIMIT_STACK] = "stack",
+#
+# and build a second integer table (with the second sed cmd), that maps
+# RLIMIT defines to the order defined in asm-generic/resource.h  Thi is
+# required by policy load to map policy ordering of RLIMITs to internal
+# ordering for architectures that redefine an RLIMIT.
+# Transforms lines from
+#    #define RLIMIT_STACK		3	/* max stack size */
+# to
+# RLIMIT_STACK, 
 quiet_cmd_make-rlim = GEN     $@
-cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ; sed -n --e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+RLIMIT_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@ ; echo "static const int rlim_map[] = {" >> $@ ; sed -n -e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+\\(RLIMIT_[A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/\\1,/p" $< >> $@ ; echo "};" >> $@
+cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ;\
+	sed $< >> $@ -r -n \
+	    -e 's/^\# ?define[ \t]+(RLIMIT_([A-Z0-9_]+)).*/[\1] = "\L\2",/p';\
+	echo "};" >> $@ ;\
+	echo "static const int rlim_map[] = {" >> $@ ;\
+	sed -r -n "s/^\# ?define[ \t]+(RLIMIT_[A-Z0-9_]+).*/\1,/p" $< >> $@ ;\
+	echo "};" >> $@
 
 $(obj)/capability.o : $(obj)/capability_names.h
 $(obj)/resource.o : $(obj)/rlim_names.h
 $(obj)/capability_names.h : $(srctree)/include/linux/capability.h
 	$(call cmd,make-caps)
-$(obj)/af_names.h : $(srctree)/include/linux/socket.h
-	$(call cmd,make-af)
 $(obj)/rlim_names.h : $(srctree)/include/asm-generic/resource.h
 	$(call cmd,make-rlim)
-- 
1.7.1

