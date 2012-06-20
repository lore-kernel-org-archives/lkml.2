Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab2FTSlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:41:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab2FTSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:28 -0400
Message-Id: <20120620173022.026692639@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 12/61] xen/setup: filter APERFMPERF cpuid feature out
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@amd.com>

commit 5e626254206a709c6e937f3dda69bf26c7344f6f upstream.

Xen PV kernels allow access to the APERF/MPERF registers to read the
effective frequency. Access to the MSRs is however redirected to the
currently scheduled physical CPU, making consecutive read and
compares unreliable. In addition each rdmsr traps into the hypervisor.
So to avoid bogus readouts and expensive traps, disable the kernel
internal feature flag for APERF/MPERF if running under Xen.
This will
a) remove the aperfmperf flag from /proc/cpuinfo
b) not mislead the power scheduler (arch/x86/kernel/cpu/sched.c) to
   use the feature to improve scheduling (by default disabled)
c) not mislead the cpufreq driver to use the MSRs

This does not cover userland programs which access the MSRs via the
device file interface, but this will be addressed separately.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -207,6 +207,9 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
+#define CPUID_THERM_POWER_LEAF 6
+#define APERFMPERF_PRESENT 0
+
 static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
 static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
 
@@ -240,6 +243,11 @@ static void xen_cpuid(unsigned int *ax,
 		*dx = cpuid_leaf5_edx_val;
 		return;
 
+	case CPUID_THERM_POWER_LEAF:
+		/* Disabling APERFMPERF for kernel usage */
+		maskecx = ~(1 << APERFMPERF_PRESENT);
+		break;
+
 	case 0xb:
 		/* Suppress extended topology stuff */
 		maskebx = 0;


