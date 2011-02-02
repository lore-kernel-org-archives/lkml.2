Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1BBBGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:06:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:46559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BBAnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028345"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [38/139] sparc: Kill prom devops_{32,64}.c
Message-Id: <20110202004353.8F18F3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit b148246912bea92bde2a0cba125ca94f1f776b12 ]

Completely unused.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_32.h |   19 --------
 arch/sparc/include/asm/oplib_64.h |   21 ---------
 arch/sparc/prom/Makefile          |    1 
 arch/sparc/prom/devops_32.c       |   87 --------------------------------------
 arch/sparc/prom/devops_64.c       |   67 -----------------------------
 5 files changed, 195 deletions(-)
 delete mode 100644 arch/sparc/prom/devops_32.c
 delete mode 100644 arch/sparc/prom/devops_64.c

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_32.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_32.h
@@ -60,25 +60,6 @@ extern char *prom_getbootargs(void);
 extern char *prom_mapio(char *virt_hint, int io_space, unsigned int phys_addr, unsigned int num_bytes);
 extern void prom_unmapio(char *virt_addr, unsigned int num_bytes);
 
-/* Device operations. */
-
-/* Open the device described by the passed string.  Note, that the format
- * of the string is different on V0 vs. V2->higher proms.  The caller must
- * know what he/she is doing!  Returns the device descriptor, an int.
- */
-extern int prom_devopen(char *device_string);
-
-/* Close a previously opened device described by the passed integer
- * descriptor.
- */
-extern int prom_devclose(int device_handle);
-
-/* Do a seek operation on the device described by the passed integer
- * descriptor.
- */
-extern void prom_seek(int device_handle, unsigned int seek_hival,
-		      unsigned int seek_lowval);
-
 /* Miscellaneous routines, don't really fit in any category per se. */
 
 /* Reboot the machine with the command line passed. */
Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -67,27 +67,6 @@ extern void prom_init(void *cif_handler,
 /* Boot argument acquisition, returns the boot command line string. */
 extern char *prom_getbootargs(void);
 
-/* Device utilities. */
-
-/* Device operations. */
-
-/* Open the device described by the passed string.  Note, that the format
- * of the string is different on V0 vs. V2->higher proms.  The caller must
- * know what he/she is doing!  Returns the device descriptor, an int.
- */
-extern int prom_devopen(const char *device_string);
-
-/* Close a previously opened device described by the passed integer
- * descriptor.
- */
-extern int prom_devclose(int device_handle);
-
-/* Do a seek operation on the device described by the passed integer
- * descriptor.
- */
-extern void prom_seek(int device_handle, unsigned int seek_hival,
-		      unsigned int seek_lowval);
-
 /* Miscellaneous routines, don't really fit in any category per se. */
 
 /* Reboot the machine with the command line passed. */
Index: linux-2.6.35.y/arch/sparc/prom/Makefile
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/Makefile
+++ linux-2.6.35.y/arch/sparc/prom/Makefile
@@ -6,7 +6,6 @@ ccflags := -Werror
 
 lib-y                 := bootstr_$(BITS).o
 lib-$(CONFIG_SPARC32) += devmap.o
-lib-y                 += devops_$(BITS).o
 lib-y                 += init_$(BITS).o
 lib-$(CONFIG_SPARC32) += memory.o
 lib-y                 += misc_$(BITS).o
Index: linux-2.6.35.y/arch/sparc/prom/devops_32.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/devops_32.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * devops.c:  Device operations using the PROM.
- *
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-
-#include <asm/openprom.h>
-#include <asm/oplib.h>
-
-extern void restore_current(void);
-
-/* Open the device described by the string 'dstr'.  Returns the handle
- * to that device used for subsequent operations on that device.
- * Returns -1 on failure.
- */
-int
-prom_devopen(char *dstr)
-{
-	int handle;
-	unsigned long flags;
-	spin_lock_irqsave(&prom_lock, flags);
-	switch(prom_vers) {
-	case PROM_V0:
-		handle = (*(romvec->pv_v0devops.v0_devopen))(dstr);
-		if(handle == 0) handle = -1;
-		break;
-	case PROM_V2:
-	case PROM_V3:
-		handle = (*(romvec->pv_v2devops.v2_dev_open))(dstr);
-		break;
-	default:
-		handle = -1;
-		break;
-	};
-	restore_current();
-	spin_unlock_irqrestore(&prom_lock, flags);
-
-	return handle;
-}
-
-/* Close the device described by device handle 'dhandle'. */
-int
-prom_devclose(int dhandle)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&prom_lock, flags);
-	switch(prom_vers) {
-	case PROM_V0:
-		(*(romvec->pv_v0devops.v0_devclose))(dhandle);
-		break;
-	case PROM_V2:
-	case PROM_V3:
-		(*(romvec->pv_v2devops.v2_dev_close))(dhandle);
-		break;
-	default:
-		break;
-	};
-	restore_current();
-	spin_unlock_irqrestore(&prom_lock, flags);
-	return 0;
-}
-
-/* Seek to specified location described by 'seekhi' and 'seeklo'
- * for device 'dhandle'.
- */
-void
-prom_seek(int dhandle, unsigned int seekhi, unsigned int seeklo)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&prom_lock, flags);
-	switch(prom_vers) {
-	case PROM_V0:
-		(*(romvec->pv_v0devops.v0_seekdev))(dhandle, seekhi, seeklo);
-		break;
-	case PROM_V2:
-	case PROM_V3:
-		(*(romvec->pv_v2devops.v2_dev_seek))(dhandle, seekhi, seeklo);
-		break;
-	default:
-		break;
-	};
-	restore_current();
-	spin_unlock_irqrestore(&prom_lock, flags);
-}
Index: linux-2.6.35.y/arch/sparc/prom/devops_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/devops_64.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * devops.c:  Device operations using the PROM.
- *
- * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
- * Copyright (C) 1996,1997 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-
-#include <asm/openprom.h>
-#include <asm/oplib.h>
-
-/* Open the device described by the string 'dstr'.  Returns the handle
- * to that device used for subsequent operations on that device.
- * Returns 0 on failure.
- */
-int
-prom_devopen(const char *dstr)
-{
-	unsigned long args[5];
-
-	args[0] = (unsigned long) "open";
-	args[1] = 1;
-	args[2] = 1;
-	args[3] = (unsigned long) dstr;
-	args[4] = (unsigned long) -1;
-
-	p1275_cmd_direct(args);
-
-	return (int) args[4];
-}
-
-/* Close the device described by device handle 'dhandle'. */
-int
-prom_devclose(int dhandle)
-{
-	unsigned long args[4];
-
-	args[0] = (unsigned long) "close";
-	args[1] = 1;
-	args[2] = 0;
-	args[3] = (unsigned int) dhandle;
-
-	p1275_cmd_direct(args);
-
-	return 0;
-}
-
-/* Seek to specified location described by 'seekhi' and 'seeklo'
- * for device 'dhandle'.
- */
-void
-prom_seek(int dhandle, unsigned int seekhi, unsigned int seeklo)
-{
-	unsigned long args[7];
-
-	args[0] = (unsigned long) "seek";
-	args[1] = 3;
-	args[2] = 1;
-	args[3] = (unsigned int) dhandle;
-	args[4] = seekhi;
-	args[5] = seeklo;
-	args[6] = (unsigned long) -1;
-
-	p1275_cmd_direct(args);
-}
