Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0HBXKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:10:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:6936 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab0HBXKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:10:38 -0400
Subject: [PATCH] Preset lpj values when on VMware.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>,
        gcosta@redhat.com
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 02 Aug 2010 16:10:37 -0700
Message-Id: <1280790637.14933.29.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider the patch below for the tip tree. Thanks !

--
When running on VMware's platform, we have seen situations where
the AP's try to calibrate the lpj values and fail to get good calibration
runs becasue of timing issues. As a result delays don't work correctly
on all cpus. 
The solutions is to set preset_lpj value based on the current tsc frequency
value. This is similar to what KVM does as well.

Signed-off-by: Alok N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/cpu/vmware.c	2010-08-02 15:43:28.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/cpu/vmware.c	2010-08-02 15:43:37.000000000 -0700
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
 


