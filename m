Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682Ab0HEUir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:38:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:48059 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab0HEUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:38:43 -0400
Date: Thu, 5 Aug 2010 20:38:00 GMT
Message-Id: <201008052038.o75Kc07G022013@hera.kernel.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/build for 2.6.36
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 05 Aug 2010 20:38:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cdd854bc42b5e6c79bbbc40c6600d995ffe6e747:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-08-05 09:03:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-build-for-linus

H. Peter Anvin (2):
      x86, vdso: Error out if the vdso contains external references
      x86, vdso: Don't quote $nm in the script for checking vdso references

 arch/x86/vdso/Makefile      |    3 ++-
 arch/x86/vdso/checkundef.sh |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)
 create mode 100755 arch/x86/vdso/checkundef.sh

Merge made by recursive.
 arch/x86/vdso/Makefile      |    3 ++-
 arch/x86/vdso/checkundef.sh |   10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)
 create mode 100755 arch/x86/vdso/checkundef.sh
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
index 0000000..7ee90a9
--- /dev/null
+++ b/arch/x86/vdso/checkundef.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+nm="$1"
+file="$2"
+$nm "$file" | grep '^ *U' > /dev/null 2>&1
+if [ $? -eq 1 ]; then
+    exit 0
+else
+    echo "$file: undefined symbols found" >&2
+    exit 1
+fi
