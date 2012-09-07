Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401Ab2IGLks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:40:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48761 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab2IGLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:40:46 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: xen-devel@lists.xen.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matt Wilson <msw@amazon.com>
Subject: [PATCH/RFC] Fix xsave bug on older Xen hypervisors
Date: Fri,  7 Sep 2012 13:40:43 +0200
Message-Id: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing unsupported flags into CR4 (for some time the
xen_write_cr4 function would refuse to do anything at all)
older Xen hypervisors (and patch can potentially be improved
by finding out what older means in version numbers) would
crash the guest.

Since Amazon EC2 would at least in the past be affected by that,
Fedora and Ubuntu were carrying a hack that would filter out
X86_CR4_OSXSAVE before writing to CR4. This would affect any
PV guest, even those running on a newer HV.

And this recently caused trouble because some user-space was
only partially checking (or maybe only looking at the cpuid
bits) and then trying to use xsave even though the OS support
was not set.

So I came up with a patch that would
- limit the work-around to certain Xen versions
- prevent the write to CR4 by unsetting xsave and osxsave in
  the cpuid bits

Doing things that way may actually allow this to be acceptable
upstream, so I am sending it around, now.
It probably could be improved when knowing the exact version
to test for but otherwise should allow to work around the guest
crash while not preventing xsave on Xen 4.x and newer hosts.

-Stefan


>From dff8885934d4e1274a69c4cedd28a4d18a1255e8 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 15 Jun 2012 11:54:59 +0200
Subject: [PATCH] xen: Mask xsave cpu capability on Xen host < 4

Older Xen hypervisors (like RHEL5 versions found to be used
on Amazon's EC2) did have a bug which would crash the domain
when trying to write unsupported CR4 values.
Newer versions of the Xen hypervisor do handle this correctly.
But when a 2.6.28 or later kernel (those seem to have
xen_write_cr4 and xsave support) is booted as a PV guest on EC2,
it potentially crashes when hitting the right CPU and the wrong
hypervisor.

We were using a patch (taken from Fedora) that did always filter
the OSXSAVE off the values written to CR4 when running as Xen PV
guest. While not completely wrong this creates an inconsistency
between the cpuid bits a guest sees and the CR4 settings.
But it prevents any use of xsave even on recent Xen hypervisors.
And this did recently cause problems because user-space was not
testing all bits when deciding to use certain features.

This patch will actually mask off the cpuid bits for XSAVE and
OSXSAVE, so generic code will not even try to set CR4. It is
limited to PV guests and (since we do not actually know the
exact version) Xen hypervisors before version 4.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 arch/x86/xen/enlighten.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9642d4a..4241055 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -210,6 +210,18 @@ void xen_vcpu_restore(void)
 	}
 }
 
+/*
+ * Older (with no clear statement about what old means) Xen hypervisors
+ * will crash a PV guest that tries to store OSXSAVE into CR4.
+ * To prevent this, we force the feature bits related to this off in the
+ * xen cpuid call. This inline function serves as a centralized test
+ * on whether the quirk should be done.
+ */
+static inline needs_xsave_quirk(unsigned version)
+{
+	return (xen_pv_domain() && ((version >> 16) < 4)) ? 1 : 0;
+}
+
 static void __init xen_banner(void)
 {
 	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
@@ -221,6 +233,8 @@ static void __init xen_banner(void)
 	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion,
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
+	if (needs_xsave_quirk(version))
+		printk(KERN_INFO "Forcing xsave off due to Xen version.\n");
 }
 
 #define CPUID_THERM_POWER_LEAF 6
@@ -351,6 +365,7 @@ static bool __init xen_check_mwait(void)
 }
 static void __init xen_init_cpuid_mask(void)
 {
+	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
 	unsigned int ax, bx, cx, dx;
 	unsigned int xsave_mask;
 
@@ -371,7 +386,7 @@ static void __init xen_init_cpuid_mask(void)
 		(1 << (X86_FEATURE_OSXSAVE % 32));
 
 	/* Xen will set CR4.OSXSAVE if supported and not disabled by force */
-	if ((cx & xsave_mask) != xsave_mask)
+	if (((cx & xsave_mask) != xsave_mask) || needs_xsave_quirk(version))
 		cpuid_leaf1_ecx_mask &= ~xsave_mask; /* disable XSAVE & OSXSAVE */
 	if (xen_check_mwait())
 		cpuid_leaf1_ecx_set_mask = (1 << (X86_FEATURE_MWAIT % 32));
-- 
1.7.9.5

