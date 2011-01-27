Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1A0RaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:30:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46356 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1A0RaP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 Jan 2011 12:30:15 -0500
Date: Thu, 27 Jan 2011 12:28:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        Michael A Young <m.a.young@durham.ac.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/bug-fixes-rc2 for 2.6.38-rc3
Message-ID: <20110127172809.GA5157@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please git pull since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5
Linus Torvalds (1)
    Linux 2.6.38-rc2

patches from:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc2

The patches are fixes that were found during boot-up testing with non-page aligned
E820 memory layouts. Oh, and also a fix for the time keeping code on Intel hardware
so that we use the pvops halt insted of the cpuidle driver.

Stefan Bader (1):
      xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.

Stefano Stabellini (2):
      xen/e820: Guard against E820_RAM not having page-aligned size or start.
      xen/setup: Route halt operations to safe_halt pvop.

 arch/x86/xen/p2m.c   |   18 ++++++------------
 arch/x86/xen/setup.c |    8 +++++++-
 2 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index ddc81a0..fd12d7c 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -241,21 +241,15 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		 * As long as the mfn_list has enough entries to completely
 		 * fill a p2m page, pointing into the array is ok. But if
 		 * not the entries beyond the last pfn will be undefined.
-		 * And guessing that the 'what-ever-there-is' does not take it
-		 * too kindly when changing it to invalid markers, a new page
-		 * is allocated, initialized and filled with the valid part.
 		 */
 		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
 			unsigned long p2midx;
-			unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_init(p2m);
-
-			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
-				p2m[p2midx] = mfn_list[pfn + p2midx];
-			}
-			p2m_top[topidx][mididx] = p2m;
-		} else
-			p2m_top[topidx][mididx] = &mfn_list[pfn];
+
+			p2midx = max_pfn % P2M_PER_PAGE;
+			for ( ; p2midx < P2M_PER_PAGE; p2midx++)
+				mfn_list[pfn + p2midx] = INVALID_P2M_ENTRY;
+		}
+		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
 
 	m2p_override_init();
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b5a7f92..a8a66a5 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -179,8 +179,13 @@ char * __init xen_memory_setup(void)
 	e820.nr_map = 0;
 	xen_extra_mem_start = mem_end;
 	for (i = 0; i < memmap.nr_entries; i++) {
-		unsigned long long end = map[i].addr + map[i].size;
+		unsigned long long end;
 
+		/* Guard against non-page aligned E820 entries. */
+		if (map[i].type == E820_RAM)
+			map[i].size -= (map[i].size + map[i].addr) % PAGE_SIZE;
+
+		end = map[i].addr + map[i].size;
 		if (map[i].type == E820_RAM && end > mem_end) {
 			/* RAM off the end - may be partially included */
 			u64 delta = min(map[i].size, end - mem_end);
@@ -350,6 +355,7 @@ void __init xen_arch_setup(void)
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
 	pm_idle = default_idle;
+	boot_option_idle_override = IDLE_HALT;
 
 	fiddle_vdso();
 }
