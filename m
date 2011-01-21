Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1AUQkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:40:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45765 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1AUQka (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 21 Jan 2011 11:40:30 -0500
Date: Fri, 21 Jan 2011 11:38:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL] (xen) stable/bug-fixes-rc1
Message-ID: <20110121163831.GA29131@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc1

changes since git commit c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470
Linus Torvalds (1):
    Linux 2.6.38-rc1

This git pull includes a bootup fix found by Canonical during their kernel rollout,
and also a warning found by Randy during his compile shakedown.

Randy Dunlap (1):
      xen: fix non-ANSI function warning in irq.c

Stefan Bader (1):
      xen: p2m: correctly initialize partial p2m leaf

 arch/x86/xen/irq.c |    2 +-
 arch/x86/xen/p2m.c |   20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)



diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 9d30105..6a6fe89 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -126,7 +126,7 @@ static const struct pv_irq_ops xen_irq_ops __initdata = {
 #endif
 };
 
-void __init xen_init_irq_ops()
+void __init xen_init_irq_ops(void)
 {
 	pv_irq_ops = xen_irq_ops;
 	x86_init.irqs.intr_init = xen_init_IRQ;
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8f2251d..ddc81a0 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -237,7 +237,25 @@ void __init xen_build_dynamic_phys_to_machine(void)
 			p2m_top[topidx] = mid;
 		}
 
-		p2m_top[topidx][mididx] = &mfn_list[pfn];
+		/*
+		 * As long as the mfn_list has enough entries to completely
+		 * fill a p2m page, pointing into the array is ok. But if
+		 * not the entries beyond the last pfn will be undefined.
+		 * And guessing that the 'what-ever-there-is' does not take it
+		 * too kindly when changing it to invalid markers, a new page
+		 * is allocated, initialized and filled with the valid part.
+		 */
+		if (unlikely(pfn + P2M_PER_PAGE > max_pfn)) {
+			unsigned long p2midx;
+			unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			p2m_init(p2m);
+
+			for (p2midx = 0; pfn + p2midx < max_pfn; p2midx++) {
+				p2m[p2midx] = mfn_list[pfn + p2midx];
+			}
+			p2m_top[topidx][mididx] = p2m;
+		} else
+			p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
 
 	m2p_override_init();
