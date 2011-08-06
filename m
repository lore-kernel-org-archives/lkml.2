Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1HFLnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:43:08 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:45900 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab1HFLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:43:03 -0400
X-AuditID: 1209190d-b7be0ae000000a16-7b-4e3d28237860
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 2/2] x86: Enable monitor/mwait on Intel if BIOS hasn't already
Date: Sat,  6 Aug 2011 07:42:36 -0400
Message-Id: <67feadbc353e826cf5d715d06f8ff1f92277a97d.1312630712.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312630712.git.luto@mit.edu>
References: <cover.1312630712.git.luto@mit.edu>
In-Reply-To: <cover.1312630712.git.luto@mit.edu>
References: <cover.1312630712.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsUixG6nrqusYetn8PKLpEXflaPsFm3THC12
	PnzLZrF8Xz+jxeVdc9gstlxqZrW4+nA2i8WPDY9ZHTg8brX9YfbYOesuu8fiPS+ZPDat6mTz
	WHfjK7vH501yAWxRXDYpqTmZZalF+nYJXBkvl3kVbOKp6Hizg7GB8QVnFyMnh4SAicSWPXcY
	IWwxiQv31rN1MXJxCAnsY5R49f8HM4SznlHi/fy5LCBVQgJPmSTmfwOz2QRUJDqWPmACsUUE
	DCS2rHzBCtLALHCFUeLi/BvMIAlhgUCJnu2NrCA2i4CqxPKm62A2r0CQxKXri1ghVstJHLn8
	HGwQJ9Cgz1/b2SCW6UscOTqVDZf4BEaBBYwMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3SN9HIz
	S/RSU0o3MYICmFOSdwfju4NKhxgFOBiVeHgfytj4CbEmlhVX5h5ilORgUhLlZVW39RPiS8pP
	qcxILM6ILyrNSS0+xCjBwawkwpujC1TOm5JYWZValA+TkuZgURLnVfP+7yskkJ5YkpqdmlqQ
	WgSTleHgUJLgZQJGqpBgUWp6akVaZk4JQpqJgxNkOA/QcDuQxbzFBYm5xZnpEPlTjIpS4ryS
	IM0CIImM0jy4XliCecUoDvSKMO9XkHYeYHKC634FNJgJaHDuE5Cri0sSEVJSDYxSjD8ZP+pk
	/imMv63o3Wj38cunHfFh7H8XzzNzu8PALaLHyRxqslT4b7FYg4dex/NLzE+Sci47z/sxL/pO
	SMsPDp2tjtsfqSyJKswpdJWpXG+6IOHIIQ+bc8Js/8X+KvvIxQQIrtP0EL+pb9d77WWj9NV2
	f/t9n96KH+j5HFTBOcl5/Q2dM0osxRmJhlrMRcWJAJYWSFULAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Intel DQ67SW (latest BIOS) disables monitor/mwait on the boot CPU
if TXT is enabled.  We're lucky that the system works at all, since
the feature is still enabled on other CPUs.

The obvious fix is to just re-enable it ourselves.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/cpu/intel.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index c80ab41..5a0150c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -493,6 +493,31 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
 		}
 	}
+
+	/* Enable monitor/mwait if BIOS didn't do it for us. */
+	if (!cpu_has(c, X86_FEATURE_MWAIT) && cpu_has(c, X86_FEATURE_XMM3)
+	    && c->x86 >= 6 && !(c->x86 == 6 && c->x86_model < 0x1c)
+	    && !(c->x86 == 0xf && c->x86_model < 3)) {
+		u64 misc_enable;
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
+
+		/*
+		 * Some non-SSE3 cpus will #GP.  We check for that,
+		 * but it can't hurt to be safe.
+		 */
+		wrmsr_safe(MSR_IA32_MISC_ENABLE, (u32)misc_enable,
+			   (u32)(misc_enable >> 32));
+
+		/* Re-read monitor capability. */
+		if (cpuid_ecx(1) & 0x8) {
+			set_cpu_cap(c, X86_FEATURE_MWAIT);
+
+			printk(KERN_WARNING FW_WARN "CPU #%d: "
+			       "IA32_MISC_ENABLE.ENABLE_MONITOR_FSM "
+			       "was not set\n", c->cpu_index);
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.6

