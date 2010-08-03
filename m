Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0HCAWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:22:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:54844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0HCAWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:22:04 -0400
Date: Tue, 3 Aug 2010 00:21:47 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akataria@vmware.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, akataria@vmware.com, hpa@linux.intel.com
In-Reply-To: <1280790637.14933.29.camel@ank32.eng.vmware.com>
References: <1280790637.14933.29.camel@ank32.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vmware] x86, vmware: Preset lpj values when on VMware.
Message-ID: <tip-9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d@git.kernel.org>
Git-Commit-ID: 9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 00:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d
Gitweb:     http://git.kernel.org/tip/9f242dc10e0c3c1eb32d8c83c18650a35fd7f80d
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Mon, 2 Aug 2010 16:10:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 2 Aug 2010 17:16:30 -0700

x86, vmware: Preset lpj values when on VMware.

When running on VMware's platform, we have seen situations where
the AP's try to calibrate the lpj values and fail to get good calibration
runs becasue of timing issues. As a result delays don't work correctly
on all cpus.

The solutions is to set preset_lpj value based on the current tsc frequency
value. This is similar to what KVM does as well.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1280790637.14933.29.camel@ank32.eng.vmware.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/vmware.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index b9d1ff5..227b044 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -51,7 +51,7 @@ static inline int __vmware_platform(void)
 
 static unsigned long vmware_get_tsc_khz(void)
 {
-	uint64_t tsc_hz;
+	uint64_t tsc_hz, lpj;
 	uint32_t eax, ebx, ecx, edx;
 
 	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
@@ -62,6 +62,13 @@ static unsigned long vmware_get_tsc_khz(void)
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
 
