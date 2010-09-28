Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0I1MSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:18:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28611 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0I1MRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:36 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729384"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stephen Tweedie <sct@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 11/12] x86/mtrr: Extend mtrr_if to include num_var_ranges
Date: Tue, 28 Sep 2010 13:16:57 +0100
Message-Id: <1285676218-26218-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:20.0479 (UTC) FILETIME=[1957DEF0:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Tweedie <sct@redhat.com>

Reorganise mtrr initialisation slightly to allow the mtrr driver to
set up num_var_ranges.  This cleans things up by making each driver
return the number of ranges rather than having a single function with
magic knowledge.

[ Impact: clean up num_var_ranges operation ]

Signed-off-by: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/cpu/mtrr/amd.c     |    6 ++++++
 arch/x86/kernel/cpu/mtrr/centaur.c |    6 ++++++
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    6 ++++++
 arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++++++
 arch/x86/kernel/cpu/mtrr/main.c    |   17 +----------------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    1 +
 6 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 92ba9cd..8556894 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,6 +108,11 @@ amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 	return 0;
 }
 
+static int __init amd_num_var_ranges(void)
+{
+	return 2;
+}
+
 static const struct mtrr_ops amd_mtrr_ops = {
 	.vendor            = X86_VENDOR_AMD,
 	.set               = amd_set_mtrr,
@@ -115,6 +120,7 @@ static const struct mtrr_ops amd_mtrr_ops = {
 	.get_free_region   = generic_get_free_region,
 	.validate_add_page = amd_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges    = amd_num_var_ranges,
 };
 
 int __init amd_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index 316fe3e..4ac35bb 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -110,6 +110,11 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	return 0;
 }
 
+static int __init centaur_num_var_ranges(void)
+{
+	return 8;
+}
+
 static const struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
 	.set               = centaur_set_mcr,
@@ -117,6 +122,7 @@ static const struct mtrr_ops centaur_mtrr_ops = {
 	.get_free_region   = centaur_get_free_region,
 	.validate_add_page = centaur_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges    = centaur_num_var_ranges,
 };
 
 int __init centaur_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 68a3343..8320306 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -265,6 +265,11 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
+static int __init cyrix_num_var_ranges(void)
+{
+	return 8;
+}
+
 static const struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
 	.set_all	   = cyrix_set_all,
@@ -273,6 +278,7 @@ static const struct mtrr_ops cyrix_mtrr_ops = {
 	.get_free_region   = cyrix_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges    = cyrix_num_var_ranges,
 };
 
 int __init cyrix_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 7d28d7d..a7d3e8f 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -747,6 +747,13 @@ int positive_have_wrcomb(void)
 	return 1;
 }
 
+static int __init generic_num_var_ranges(void)
+{
+	unsigned long config = 0, dummy;
+	rdmsr(MSR_MTRRcap, config, dummy);
+	return config & 0xff;
+}
+
 /*
  * Generic structure...
  */
@@ -758,4 +765,5 @@ const struct mtrr_ops generic_mtrr_ops = {
 	.set			= generic_set_mtrr,
 	.validate_add_page	= generic_validate_add_page,
 	.have_wrcomb		= generic_have_wrcomb,
+	.num_var_ranges    = generic_num_var_ranges,
 };
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 01c0f3e..91f8f62 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -111,21 +111,6 @@ static int have_wrcomb(void)
 	return mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0;
 }
 
-/*  This function returns the number of variable MTRRs  */
-static void __init set_num_var_ranges(void)
-{
-	unsigned long config = 0, dummy;
-
-	if (use_intel())
-		rdmsr(MSR_MTRRcap, config, dummy);
-	else if (is_cpu(AMD))
-		config = 2;
-	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
-		config = 8;
-
-	num_var_ranges = config & 0xff;
-}
-
 static void __init init_table(void)
 {
 	int i, max;
@@ -743,7 +728,7 @@ void __init mtrr_bp_init(void)
 	}
 
 	if (mtrr_if) {
-		set_num_var_ranges();
+		num_var_ranges = mtrr_if->num_var_ranges();
 		init_table();
 		if (use_intel()) {
 			get_mtrr_state();
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index df5e41f..add8abe 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -25,6 +25,7 @@ struct mtrr_ops {
 	int	(*validate_add_page)(unsigned long base, unsigned long size,
 				     unsigned int type);
 	int	(*have_wrcomb)(void);
+	int	(*num_var_ranges)(void);
 };
 
 extern int generic_get_free_region(unsigned long base, unsigned long size,
-- 
1.5.6.5

