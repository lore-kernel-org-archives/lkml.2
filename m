Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1GVJLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:11:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1GVJLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:11:53 -0400
Date: Fri, 22 Jul 2011 11:11:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable]
Message-ID: <20110722091151.GA4004@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have just come across a strange behavior of /dev/[k]mem when PAT is
configured while STRICT_DEVMEM is disabled. 
One would expect that /dev/kmem would allow to access also the
system RAM in that configuration but that is not obviously true as pat
code defines range_is_allowed to protect from accessing that memory.

AFAICS this behavior was introduced in 0124cecf (x86, PAT: disable
/dev/mem mmap RAM with PAT) which says that it disables [k]mem with PAT
because it is safer. There is no explanation why it allows to access
that memory if CONFIG_NONPROMISC_DEVMEM (CONFIG_STRICT_DEVMEM now).

The thing is even more complicated by the fact that the access is
allowed when nopat kernel parameter is specified because
range_is_allowed just does't call devmem_is_allowed in that case.

While I do agree that the feature is not safe in general we should honor
STRICT_DEVMEM setting in some way IMO.

What do you think about the following fix? I have tried to preserve
"disabled for PAT" by default behavior.
---
>From e905f034d860c52de306b410ef148d601eae9e7f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 22 Jul 2011 11:01:01 +0200
Subject: [PATCH] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disable

since 0124cecf (x86, PAT: disable /dev/mem mmap RAM with PAT) we are
disabling access to the system RAM as if STRICT_DEVMEM was enabled by
default. If we, however, disable pat by nopat kernel parameter we can
access that memory without considering CONFIG_STRICT_DEVMEM.

Let's make the code to honor STRICT_DEVMEM while we still preserve
disabled by default behavior. This means that the access to the system
memory is granted only if nopat is provided and STRICT_DEVMEM is
disabled.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/mm/pat.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f6ff57b..fbaf3fc 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -472,13 +472,6 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	return vma_prot;
 }
 
-#ifdef CONFIG_STRICT_DEVMEM
-/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
-static inline int range_is_allowed(unsigned long pfn, unsigned long size)
-{
-	return 1;
-}
-#else
 /* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
@@ -486,8 +479,10 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	u64 to = from + size;
 	u64 cursor = from;
 
+#ifndef CONFIG_STRICT_DEVMEM
 	if (!pat_enabled)
 		return 1;
+#endif
 
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
@@ -501,7 +496,6 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	}
 	return 1;
 }
-#endif /* CONFIG_STRICT_DEVMEM */
 
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t *vma_prot)
-- 
1.7.5.4

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
