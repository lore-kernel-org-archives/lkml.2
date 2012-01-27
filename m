Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2A0Aig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:38:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52576 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2A0Aie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:38:34 -0500
From: Kees Cook <kees@ubuntu.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Johansen <john.johansen@canonical.com>
Subject: [PATCH 4/4] AppArmor: export known rlimit names/value mappings in securityfs
Date: Thu, 26 Jan 2012 16:29:23 -0800
Message-Id: <1327624163-21576-5-git-send-email-kees@ubuntu.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the parser needs to know which rlimits are known to the kernel,
export the list via a mask file in the "rlimit" subdirectory in the
securityfs "features" directory.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/Makefile           |   24 ++++++++++++++++++------
 security/apparmor/apparmorfs.c       |    2 ++
 security/apparmor/include/resource.h |    4 ++++
 security/apparmor/resource.c         |    5 +++++
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index 2dafe50..86103ce 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -28,25 +28,37 @@ cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ;\
 #    [RLIMIT_STACK] = "stack",
 #
 # and build a second integer table (with the second sed cmd), that maps
-# RLIMIT defines to the order defined in asm-generic/resource.h  Thi is
+# RLIMIT defines to the order defined in asm-generic/resource.h  This is
 # required by policy load to map policy ordering of RLIMITs to internal
 # ordering for architectures that redefine an RLIMIT.
 # Transforms lines from
 #    #define RLIMIT_STACK		3	/* max stack size */
 # to
 # RLIMIT_STACK, 
+#
+# and build the securityfs entries for the mapping.
+# Transforms lines from
+#    #define RLIMIT_FSIZE        1   /* Maximum filesize */
+#    #define RLIMIT_STACK		3	/* max stack size */
+# to
+# #define AA_FS_RLIMIT_MASK "fsize stack"
 quiet_cmd_make-rlim = GEN     $@
-cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ;\
+cmd_make-rlim = echo "static const char *rlim_names[RLIM_NLIMITS] = {" > $@ ;\
 	sed $< >> $@ -r -n \
 	    -e 's/^\# ?define[ \t]+(RLIMIT_([A-Z0-9_]+)).*/[\1] = "\L\2",/p';\
 	echo "};" >> $@ ;\
-	echo "static const int rlim_map[] = {" >> $@ ;\
+	echo "static const int rlim_map[RLIM_NLIMITS] = {" >> $@ ;\
 	sed -r -n "s/^\# ?define[ \t]+(RLIMIT_[A-Z0-9_]+).*/\1,/p" $< >> $@ ;\
-	echo "};" >> $@
+	echo "};" >> $@ ; \
+	echo -n '\#define AA_FS_RLIMIT_MASK "' >> $@ ;\
+	sed -r -n 's/^\# ?define[ \t]+RLIMIT_([A-Z0-9_]+).*/\L\1/p' $< | \
+	    tr '\n' ' ' | sed -e 's/ $$/"\n/' >> $@
 
 $(obj)/capability.o : $(obj)/capability_names.h
 $(obj)/resource.o : $(obj)/rlim_names.h
-$(obj)/capability_names.h : $(srctree)/include/linux/capability.h
+$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
+			    $(src)/Makefile
 	$(call cmd,make-caps)
-$(obj)/rlim_names.h : $(srctree)/include/asm-generic/resource.h
+$(obj)/rlim_names.h : $(srctree)/include/asm-generic/resource.h \
+		      $(src)/Makefile
 	$(call cmd,make-rlim)
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 68ce771..38d6262 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -25,6 +25,7 @@
 #include "include/audit.h"
 #include "include/context.h"
 #include "include/policy.h"
+#include "include/resource.h"
 
 /**
  * aa_simple_write_to_buffer - common routine for getting policy from user
@@ -202,6 +203,7 @@ static struct aa_fs_entry aa_fs_entry_features[] = {
 	AA_FS_DIR("file",			aa_fs_entry_file),
 	AA_FS_FILE_BOOLEAN("namespaces",	1),
 	AA_FS_FILE_U64("capability",		VFS_CAP_FLAGS_MASK),
+	AA_FS_DIR("rlimit",			aa_fs_entry_rlimit),
 	{ }
 };
 
diff --git a/security/apparmor/include/resource.h b/security/apparmor/include/resource.h
index 02baec7..d3f4cf0 100644
--- a/security/apparmor/include/resource.h
+++ b/security/apparmor/include/resource.h
@@ -18,6 +18,8 @@
 #include <linux/resource.h>
 #include <linux/sched.h>
 
+#include "apparmorfs.h"
+
 struct aa_profile;
 
 /* struct aa_rlimit - rlimit settings for the profile
@@ -32,6 +34,8 @@ struct aa_rlimit {
 	struct rlimit limits[RLIM_NLIMITS];
 };
 
+extern struct aa_fs_entry aa_fs_entry_rlimit[];
+
 int aa_map_resource(int resource);
 int aa_task_setrlimit(struct aa_profile *profile, struct task_struct *,
 		      unsigned int resource, struct rlimit *new_rlim);
diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
index a4136c1..72c25a4 100644
--- a/security/apparmor/resource.c
+++ b/security/apparmor/resource.c
@@ -23,6 +23,11 @@
  */
 #include "rlim_names.h"
 
+struct aa_fs_entry aa_fs_entry_rlimit[] = {
+	AA_FS_FILE_STRING("mask", AA_FS_RLIMIT_MASK),
+	{ }
+};
+
 /* audit callback for resource specific fields */
 static void audit_cb(struct audit_buffer *ab, void *va)
 {
-- 
1.7.0.4

