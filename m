Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab2FTS3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:29:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab2FTSYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:08 -0400
Message-Id: <20120620173039.740348485@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 02/20] xen/setup: filter APERFMPERF cpuid feature out
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -198,6 +198,9 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
+#define CPUID_THERM_POWER_LEAF 6
+#define APERFMPERF_PRESENT 0
+
 static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
 static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
 
@@ -218,6 +221,11 @@ static void xen_cpuid(unsigned int *ax,
 		maskedx = cpuid_leaf1_edx_mask;
 		break;
 
+	case CPUID_THERM_POWER_LEAF:
+		/* Disabling APERFMPERF for kernel usage */
+		maskecx = ~(1 << APERFMPERF_PRESENT);
+		break;
+
 	case 0xb:
 		/* Suppress extended topology stuff */
 		maskebx = 0;


