Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2BMPqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:46:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab2BMPqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:46:36 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, jacob.jun.pan@linux.intel.com, alan@linux.intel.com,
        feng.tang@intel.com, konrad.wilk@oracle.com, avi@redhat.com,
        glommer@redhat.com, johnstul@us.ibm.com, riel@redhat.com,
        tj@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, amit.shah@redhat.com
Subject: [PATCH RFC] pvclock: Make pv_clock more robust and fixup it if overflow happens
Date: Mon, 13 Feb 2012 16:45:59 +0100
Message-Id: <1329147959-22472-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <20120213130727.GA8052@amt.cnet>
References: <20120213130727.GA8052@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hunting misterious stalls/hungs all over the kernel when
overflow occurs at pvclock.c:pvclock_get_nsec_offset

    u64 delta = native_read_tsc() - shadow->tsc_timestamp;

and introducing hooks when places of unexpected access found, pv_clock
should be initialized for the calling cpu if overflow condition is detected.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/pvclock.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 42eb330..b486756 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -41,9 +41,14 @@ void pvclock_set_flags(u8 flags)
 	valid_flags = flags;
 }
 
-static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
+static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow,
+				   bool *overflow)
 {
-	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
+	u64 delta;
+	u64 tsc = native_read_tsc();
+	u64 shadow_timestamp = shadow->tsc_timestamp;
+	*overflow = tsc < shadow_timestamp;
+	delta = tsc - shadow_timestamp;
 	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
 				   shadow->tsc_shift);
 }
@@ -94,12 +99,19 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	unsigned version;
 	cycle_t ret, offset;
 	u64 last;
+	bool overflow;
 
 	do {
 		version = pvclock_get_time_values(&shadow, src);
 		barrier();
-		offset = pvclock_get_nsec_offset(&shadow);
+		offset = pvclock_get_nsec_offset(&shadow, &overflow);
 		ret = shadow.system_timestamp + offset;
+		if (unlikely(overflow)) {
+			memset(src, 0, sizeof(*src));
+			barrier();
+			x86_cpuinit.early_percpu_clock_init();
+			continue;
+		}
 		barrier();
 	} while (version != src->version);
 
-- 
1.7.7.6

