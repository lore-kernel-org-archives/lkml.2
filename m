Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab0HLAqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:46:08 -0400
Received: from kroah.org ([198.145.64.141]:40025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758680Ab0HKX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:27 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:56 2010
Message-Id: <20100811235456.065172812@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alok N Kataria <akataria@vmware.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [005/111] x86, vmware: Preset lpj values when on VMware.
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d upstream.

When running on VMware's platform, we have seen situations where
the AP's try to calibrate the lpj values and fail to get good calibration
runs becasue of timing issues. As a result delays don't work correctly
on all cpus.

The solutions is to set preset_lpj value based on the current tsc frequency
value. This is similar to what KVM does as well.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1280790637.14933.29.camel@ank32.eng.vmware.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/vmware.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/dmi.h>
+#include <linux/jiffies.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
 #include <asm/x86_init.h>
@@ -50,7 +51,7 @@ static inline int __vmware_platform(void
 
 static unsigned long vmware_get_tsc_khz(void)
 {
-	uint64_t tsc_hz;
+	uint64_t tsc_hz, lpj;
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
@@ -61,6 +62,13 @@ static unsigned long vmware_get_tsc_khz(
 	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
 			 (unsigned long) tsc_hz / 1000,
 			 (unsigned long) tsc_hz % 1000);
+
+	if (!preset_lpj) {
+		lpj = ((u64)tsc_hz * 1000);
+		do_div(lpj, HZ);
+		preset_lpj = lpj;
+	}
+
 	return tsc_hz;
 }
 


