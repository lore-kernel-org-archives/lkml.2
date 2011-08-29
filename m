Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1H2X1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:27:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43948 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab1H2X1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:27:43 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        mtosatti@redhat.com, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm-ppc@vger.kernel.org, aliguori@us.ibm.com, raharper@us.ibm.com,
        kvm-ia64@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 2/4] Add functions to check if the host has stopped the vm
Date: Mon, 29 Aug 2011 17:27:13 -0600
Message-Id: <1314660435-23293-3-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a host stops or suspends a VM it will set a flag to show this.  The
watchdog will use these functions to determine if a softlockup is real, or the
result of a suspended VM.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/pvclock.h |    2 ++
 arch/x86/kernel/kvmclock.c     |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index a518c0a..dd59ad0 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -13,6 +13,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct timespec *ts);
 void pvclock_resume(void);
 
+bool kvm_check_and_clear_host_stopped(int cpu);
+
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index c1a0188..5f60d2b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -113,6 +113,20 @@ static void kvm_get_preset_lpj(void)
 	preset_lpj = lpj;
 }
 
+bool kvm_check_and_clear_host_stopped(int cpu)
+{
+	bool ret = false;
+	struct pvclock_vcpu_time_info *src;
+
+	src = &per_cpu(hv_clock, cpu);
+	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
+		src->flags = src->flags & (~PVCLOCK_GUEST_STOPPED);
+		ret = true;
+	}
+
+	return ret;
+}
+
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
 	.read = kvm_clock_get_cycles,
-- 
1.7.4.1

