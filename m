Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0HaGKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:10:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0HaGKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hC6Em8X0DlfrFptGwKHGXqxhaZSZJNYm/EaGAFWDBbYjVpNZZbviJHkQBUOG5Y1Hmh
         dfz7ZjtZFS/TU12H1cGEvzmPEVizqHmliDcA/LoN4wC9nbUNH3/N0STk3ngf5EG6GbRY
         jEQz+Cn5IBNW9cOYO9nHNh/OsU2J8cneji/yg=
Date: Tue, 31 Aug 2010 08:41:35 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] x86, cacheinfo: Fix dependency of AMD L3 CID
Message-ID: <20100831064135.GB4655@loge.amd.com>
References: <20100827075945.GA5348@loge.amd.com>
 <20100831063806.GA4655@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831063806.GA4655@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

L3 cache index disable code uses PCI accesses to AMD northbridge functions.
Currently the code is compiled #ifdef CONFIG_CPU_SUP_AMD.
But its real dependency is #if (defined(CONFIG_CPU_SUP_AMD) &&
defined(CONFIG_PCI)) which in the end is a dependency to CONFIG_K8_NB.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 898c2f4..2521cdc 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -306,7 +306,7 @@ struct _cache_attr {
 	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
 };
 
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_K8_NB
 
 /*
  * L3 cache descriptors
@@ -556,12 +556,12 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
-#else	/* CONFIG_CPU_SUP_AMD */
+#else	/* CONFIG_K8_NB */
 static void __cpuinit
 amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
-#endif /* CONFIG_CPU_SUP_AMD */
+#endif /* CONFIG_K8_NB */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
@@ -1000,7 +1000,7 @@ static struct attribute *default_attrs[] = {
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
-#ifdef CONFIG_CPU_SUP_AMD
+#ifdef CONFIG_K8_NB
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 #endif
-- 
1.6.4.4

