Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2HSCHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:07:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57975 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2HSCHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:07:11 -0400
Date: Sun, 19 Aug 2012 04:07:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/31] Disable const sections for PA-RISC
Message-ID: <20120819020710.GO11413@one.firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-2-git-send-email-andi@firstfloor.org> <20120818211549.GA12298@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120818211549.GA12298@merkur.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +config BROKEN_RODATA
> > +	bool
> > +	default y
> 
> Could you please change this so we have a commonly defined HAVE_BROKEN_RODATA
> symbol. Then arch's that have broken RO data can select this symbol.
> If we experience tomorrow that sparc have the same issue then with
> this patch sparc has to create a local definition of this symbol.

Here's an updated patch with the config placed in init/Kconfig.
I'm not going to repost the whole series.

-Andi

---

Disable const sections for PA-RISC v2

The PA-RISC tool chain seems to have some problem with correct read/write
attributes on sections. This causes problems when the const sections
are fixed up for other architecture to only contain truly read-only
data.

Disable const sections for PA-RISC

This can cause a bit of noise with modpost.

v2: Move config to init/Kconfig
Cc: James.Bottomley@HansenPartnership.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/parisc/Kconfig  |    1 +
 include/linux/init.h |   27 +++++++++++++++++++--------
 init/Kconfig         |    6 ++++++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 3ff21b5..77f9c81 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -19,6 +19,7 @@ config PARISC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
+	select BROKEN_RODATA
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/include/linux/init.h b/include/linux/init.h
index 5e664f6..c2f06b3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -43,10 +43,21 @@
    discard it in modules) */
 #define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
-#define __initconst	__section(.init.rodata)
+#define __initconst	__constsection(.init.rodata)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 
+/* 
+ * Some architecture have tool chains which do not handle rodata attributes
+ * correctly. For those disable special sections for const, so that other
+ * architectures can annotate correctly.
+ */
+#ifdef CONFIG_BROKEN_RODATA
+#define __constsection(x)
+#else
+#define __constsection(x) __section(x)
+#endif
+
 /*
  * modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -66,7 +77,7 @@
  */
 #define __ref            __section(.ref.text) noinline
 #define __refdata        __section(.ref.data)
-#define __refconst       __section(.ref.rodata)
+#define __refconst       __constsection(.ref.rodata)
 
 /* compatibility defines */
 #define __init_refok     __ref
@@ -85,26 +96,26 @@
 /* Used for HOTPLUG */
 #define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
-#define __devinitconst   __section(.devinit.rodata)
+#define __devinitconst   __constsection(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold notrace
 #define __devexitdata    __section(.devexit.data)
-#define __devexitconst   __section(.devexit.rodata)
+#define __devexitconst   __constsection(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
 #define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
-#define __cpuinitconst   __section(.cpuinit.rodata)
+#define __cpuinitconst   __constsection(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold notrace
 #define __cpuexitdata    __section(.cpuexit.data)
-#define __cpuexitconst   __section(.cpuexit.rodata)
+#define __cpuexitconst   __constsection(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
-#define __meminitconst   __section(.meminit.rodata)
+#define __meminitconst   __constsection(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold notrace
 #define __memexitdata    __section(.memexit.data)
-#define __memexitconst   __section(.memexit.rodata)
+#define __memexitconst   __constsection(.memexit.rodata)
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
diff --git a/init/Kconfig b/init/Kconfig
index af6c7f8..a8785db 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1612,4 +1612,10 @@ config PADATA
 	depends on SMP
 	bool
 
+# Can be selected by architectures with broken toolchains
+# that get confused by correct const<->read_only section
+# mappings
+config BROKEN_RODATA
+	bool
+
 source "kernel/Kconfig.locks"
-- 
1.7.10.4

