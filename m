Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0EKQV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0EKQVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:22 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, zamsden@redhat.com,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 1/9] Enable pvclock flags in vcpu_time_info structure
Date: Tue, 11 May 2010 12:17:39 -0400
Message-Id: <1273594667-17175-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-1-git-send-email-glommer@redhat.com>
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes one padding byte and transform it into a flags
field. New versions of guests using pvclock will query these flags
upon each read.

Flags, however, will only be interpreted when the guest decides to.
It uses the pvclock_valid_flags function to signal that a specific
set of flags should be taken into consideration. Which flags are valid
are usually devised via HV negotiation.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/pvclock-abi.h |    3 ++-
 arch/x86/include/asm/pvclock.h     |    1 +
 arch/x86/kernel/pvclock.c          |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
index 6d93508..ec5c41a 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -29,7 +29,8 @@ struct pvclock_vcpu_time_info {
 	u64   system_time;
 	u32   tsc_to_system_mul;
 	s8    tsc_shift;
-	u8    pad[3];
+	u8    flags;
+	u8    pad[2];
 } __attribute__((__packed__)); /* 32 bytes */
 
 struct pvclock_wall_clock {
diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
index 53235fd..cd02f32 100644
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -6,6 +6,7 @@
 
 /* some helper functions for xen and kvm pv clock sources */
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
+void pvclock_set_flags(u8 flags);
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall,
 			    struct pvclock_vcpu_time_info *vcpu,
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 03801f2..f7fdd56 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -31,8 +31,16 @@ struct pvclock_shadow_time {
 	u32 tsc_to_nsec_mul;
 	int tsc_shift;
 	u32 version;
+	u8  flags;
 };
 
+static u8 valid_flags __read_mostly = 0;
+
+void pvclock_set_flags(u8 flags)
+{
+	valid_flags = flags;
+}
+
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.
@@ -91,6 +99,7 @@ static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
 		dst->system_timestamp  = src->system_time;
 		dst->tsc_to_nsec_mul   = src->tsc_to_system_mul;
 		dst->tsc_shift         = src->tsc_shift;
+		dst->flags             = src->flags;
 		rmb();		/* test version after fetching data */
 	} while ((src->version & 1) || (dst->version != src->version));
 
-- 
1.6.2.2

