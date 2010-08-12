Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab0HLAHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:07:46 -0400
Received: from kroah.org ([198.145.64.141]:60423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab0HLAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:40 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:12 2010
Message-Id: <20100812000612.790256790@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alok N Kataria <akataria@vmware.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [01/67] x86, vmware: Preset lpj values when on VMware.
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
 arch/x86/kernel/cpu/vmware.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -51,7 +51,7 @@ static inline int __vmware_platform(void
 
 static unsigned long vmware_get_tsc_khz(void)
 {
-	uint64_t tsc_hz;
+	uint64_t tsc_hz, lpj;
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
@@ -62,6 +62,13 @@ static unsigned long vmware_get_tsc_khz(
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
 


