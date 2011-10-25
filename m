Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1JYT1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:27:16 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:57248 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752934Ab1JYT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:26:25 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mingo@redhat.com, x86@kernel.org, hpa@zytor.com, mtosatti@redhat.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 2/6] Add functions to check if the host has stopped the vm
Date: Tue, 25 Oct 2011 15:26:15 -0400
Message-Id: <1319570779-8907-3-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a host stops or suspends a VM it will set a flag to show this.  The
watchdog will use these functions to determine if a softlockup is real, or the
result of a suspended VM.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 arch/x86/include/asm/pvclock.h |    2 ++
 arch/x86/kernel/kvmclock.c     |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index c59cc97..7d3ba41 100644
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
index c1a0188..8ddcfaf 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -113,6 +113,25 @@ static void kvm_get_preset_lpj(void)
 	preset_lpj = lpj;
 }
 
+bool kvm_check_and_clear_host_stopped(int cpu)
+{
+	bool ret = false;
+	struct pvclock_vcpu_time_info *src;
+
+	/*
+	 * per_cpu() is safe here because this function is only called from
+	 * timer functions where preemption is already disabled.
+	 */
+	WARN_ON(!in_atomic());
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
1.7.5.4

