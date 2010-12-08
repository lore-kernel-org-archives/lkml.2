Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0LHHvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:51:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58131 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab0LHHvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:51:50 -0500
Date: Wed, 8 Dec 2010 08:51:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20101208075137.GA16764@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (1):
      x86/pvclock: Zero last_value on resume


 arch/x86/include/asm/pvclock.h |    1 +
 arch/x86/kernel/pvclock.c      |    5 +++++
 arch/x86/xen/time.c            |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 7f7e577..31d84ac 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -11,6 +11,7 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
 			    struct timespec *ts);
+void pvclock_resume(void);
 
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 008b91e..42eb330 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -83,6 +83,11 @@ unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
+void pvclock_resume(void)
+{
+	atomic64_set(&last_value, 0);
+}
+
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 {
 	struct pvclock_shadow_time shadow;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index b2bb5aa..5da5e53 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -426,6 +426,8 @@ void xen_timer_resume(void)
 {
 	int cpu;
 
+	pvclock_resume();
+
 	if (xen_clockevent != &xen_vcpuop_clockevent)
 		return;
 
