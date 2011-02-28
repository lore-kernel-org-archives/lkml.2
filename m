Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1B1QhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:37:07 -0500
Received: from kroah.org ([198.145.64.141]:41214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1B1QhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.752962160@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [11/68] x86/pvclock: Zero last_value on resume
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 arch/x86/include/asm/pvclock.h |    1 +
 arch/x86/kernel/pvclock.c      |    5 +++++
 arch/x86/xen/time.c            |    2 ++
 3 files changed, 8 insertions(+)

--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -10,5 +10,6 @@ unsigned long pvclock_tsc_khz(struct pvc
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 #endif /* _ASM_X86_PVCLOCK_H */
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -111,6 +111,11 @@ unsigned long pvclock_tsc_khz(struct pvc
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -424,6 +424,8 @@ void xen_timer_resume(void)
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 


