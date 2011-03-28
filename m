Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1C1C5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:57:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51474 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab1C1C5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:57:33 -0400
Message-ID: <4D8FF993.3070207@cn.fujitsu.com>
Date: Mon, 28 Mar 2011 10:59:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC PATCH 3/5] kbuild: add kernel-offset file
References: <4D8FF8AD.5080607@cn.fujitsu.com>
In-Reply-To: <4D8FF8AD.5080607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:56:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:56:03,
	Serialize complete at 2011-03-28 10:56:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add kernel/kernel-offset.c, include/generated/kernel-offsets.h will
be generated from this file and some difines need by kernel
is generated in this file.

This generating is assigned as the last step of the kbuild generating,
it would require the other earier generated files.

__KBUILD_GENARATING__ is defined when generating, it will be
used to avoid compiling errror when generating.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Kbuild                  |   41 ++++++++++++++++++++++++++++++++---------
 kernel/kernel-offsets.c |   14 ++++++++++++++
 2 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/Kbuild b/Kbuild
index 5c2ee83..fdfde56 100644
--- a/Kbuild
+++ b/Kbuild
@@ -3,7 +3,8 @@
 # This file takes care of the following:
 # 1) Generate bounds.h
 # 2) Generate asm-offsets.h (may need bounds.h)
-# 3) Check for missing system calls
+# 3) Generate kernel-offsets.h (may need bounds.h and asm-offsets.h)
+# 4) Check for missing system calls
 
 # Default sed regexp - multiline due to syntax constraints
 define sed-y
@@ -30,6 +31,10 @@ define cmd_kbuild_gen
 	 echo "#endif" ) > $@
 endef
 
+quiet_cmd_gen_cc_s_c = CC $(quiet_modtag)  $@
+cmd_gen_cc_s_c       = $(CC) -D__KBUILD_GENARATING__		\
+                       $(c_flags) -fverbose-asm -S -o $@ $<
+
 #####
 # 1) Generate bounds.h
 
@@ -41,7 +46,7 @@ targets := $(bounds-file) kernel/bounds.s
 # We use internal kbuild rules to avoid the "is up to date" message from make
 kernel/bounds.s: kernel/bounds.c FORCE
 	$(Q)mkdir -p $(dir $@)
-	$(call if_changed_dep,cc_s_c)
+	$(call if_changed_dep,gen_cc_s_c)
 
 $(obj)/$(bounds-file): kernel/bounds.s Kbuild
 	$(Q)mkdir -p $(dir $@)
@@ -51,23 +56,41 @@ $(obj)/$(bounds-file): kernel/bounds.s Kbuild
 # 2) Generate asm-offsets.h
 #
 
-offsets-file := include/generated/asm-offsets.h
+asm-offsets-file := include/generated/asm-offsets.h
 
-always  += $(offsets-file)
-targets += $(offsets-file)
+always  += $(asm-offsets-file)
+targets += $(asm-offsets-file)
 targets += arch/$(SRCARCH)/kernel/asm-offsets.s
 
 # We use internal kbuild rules to avoid the "is up to date" message from make
 arch/$(SRCARCH)/kernel/asm-offsets.s: arch/$(SRCARCH)/kernel/asm-offsets.c \
                                       $(obj)/$(bounds-file) FORCE
 	$(Q)mkdir -p $(dir $@)
-	$(call if_changed_dep,cc_s_c)
+	$(call if_changed_dep,gen_cc_s_c)
+
+$(obj)/$(asm-offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
+	$(call cmd,kbuild_gen)
+
+#####
+# 3) Generate kernel-offsets.h
+#
+
+kernel-offsets-file := include/generated/kernel-offsets.h
+
+always  += $(kernel-offsets-file)
+targets += $(kernel-offsets-file) kernel/kernel-offsets.s
+
+# We use internal kbuild rules to avoid the "is up to date" message from make
+kernel/kernel-offsets.s: kernel/kernel-offsets.c $(obj)/$(asm-offsets-file) \
+                         $(obj)/$(bounds-file) FORCE
+	$(Q)mkdir -p $(dir $@)
+	$(call if_changed_dep,gen_cc_s_c)
 
-$(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
+$(obj)/$(kernel-offsets-file): kernel/kernel-offsets.s Kbuild
 	$(call cmd,kbuild_gen)
 
 #####
-# 3) Check for missing system calls
+# 4) Check for missing system calls
 #
 
 quiet_cmd_syscalls = CALL    $<
@@ -78,4 +101,4 @@ missing-syscalls: scripts/checksyscalls.sh FORCE
 	$(call cmd,syscalls)
 
 # Keep these two files during make clean
-no-clean-files := $(bounds-file) $(offsets-file)
+no-clean-files := $(bounds-file) $(asm-offsets-file) $(kernel-offsets-file)
diff --git a/kernel/kernel-offsets.c b/kernel/kernel-offsets.c
new file mode 100644
index 0000000..fb73ccf
--- /dev/null
+++ b/kernel/kernel-offsets.c
@@ -0,0 +1,14 @@
+/*
+ * Generate definitions needed by assembly language modules.
+ *
+ * Copyright (C) 2010 Lai Jiangshan
+ */
+
+#include <linux/kbuild.h>
+
+void foo(void);
+
+void foo(void)
+{
+}
+
-- 
1.7.4

