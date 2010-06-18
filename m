Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0FRWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:16:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:52390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0FRWQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:16:21 -0400
Date: Fri, 18 Jun 2010 22:16:05 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <tip-*@vger.kernel.org>
References: <tip-*@vger.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, vdso: Error out if the vdso contains external references
Message-ID: <tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org>
Git-Commit-ID: 05d0b0889ca9d033a960542af7f8a13b3ad4f630
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 22:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05d0b0889ca9d033a960542af7f8a13b3ad4f630
Gitweb:     http://git.kernel.org/tip/05d0b0889ca9d033a960542af7f8a13b3ad4f630
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Jun 2010 14:36:26 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Jun 2010 14:46:21 -0700

x86, vdso: Error out if the vdso contains external references

The vdso is a piece of userspace code which is supposed to be fully
self-contained.  Any external (undefined) reference is an error, and
should be caught at compile time.  This was giving us trouble when
compiling with -Os on gcc 4.5.0, for example (failed inline).

The need to do a buildtime check was pointed out by Andi Kleen.

Reported-by: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <tip-*@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/Makefile      |    3 ++-
 arch/x86/vdso/checkundef.sh |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 6b4ffed..4a2afa1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -120,7 +120,8 @@ $(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
 quiet_cmd_vdso = VDSO    $@
       cmd_vdso = $(CC) -nostdlib -o $@ \
 		       $(VDSO_LDFLAGS) $(VDSO_LDFLAGS_$(filter %.lds,$(^F))) \
-		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
+		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
+		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
 VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
 GCOV_PROFILE := n
diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
new file mode 100755
index 0000000..490be1c
--- /dev/null
+++ b/arch/x86/vdso/checkundef.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+nm="$1"
+file="$2"
+"$nm" "$file" | grep '^ *U' > /dev/null 2>&1
+if [ $? -eq 1 ]; then
+    exit 0
+else
+    echo "$file: undefined symbols found" >&2
+    exit 1
+fi
