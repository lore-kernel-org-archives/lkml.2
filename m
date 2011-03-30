Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355Ab1C3Vqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:46:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:61722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab1C3VHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237219"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jeremy.fitzhardinge@citrix.com, mingo@elte.hu, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [116/275] x86/pvclock: Zero last_value on resume
Message-Id: <20110330210555.CAAD03E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit e7a3481c0246c8e45e79c629efd63b168e91fcda upstream.

If the guest domain has been suspend/resumed or migrated, then the
system clock backing the pvclock clocksource may revert to a smaller
value (ie, can be non-monotonic across the migration/save-restore).

Make sure we zero last_value in that case so that the domain
continues to see clock updates.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/pvclock.h |    1 +
 arch/x86/kernel/pvclock.c      |    5 +++++
 arch/x86/xen/time.c            |    2 ++
 3 files changed, 8 insertions(+)

Index: linux-2.6.35.y/arch/x86/include/asm/pvclock.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/pvclock.h	2011-03-29 22:51:22.108157477 -0700
+++ linux-2.6.35.y/arch/x86/include/asm/pvclock.h	2011-03-29 23:03:00.598284861 -0700
@@ -11,5 +11,6 @@
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 #endif /* _ASM_X86_PVCLOCK_H */
Index: linux-2.6.35.y/arch/x86/kernel/pvclock.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/pvclock.c	2011-03-29 22:51:22.108157477 -0700
+++ linux-2.6.35.y/arch/x86/kernel/pvclock.c	2011-03-29 23:03:00.598284861 -0700
@@ -120,6 +120,11 @@
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
Index: linux-2.6.35.y/arch/x86/xen/time.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/xen/time.c	2011-03-29 22:51:22.109157451 -0700
+++ linux-2.6.35.y/arch/x86/xen/time.c	2011-03-29 23:03:00.629284080 -0700
@@ -425,6 +425,8 @@
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 
