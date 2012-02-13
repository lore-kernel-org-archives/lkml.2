Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2BMSVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:21:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456Ab2BMSVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:21:01 -0500
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        riel@redhat.com, amit.shah@redhat.com, mtosatti@redhat.com
Subject: [PATCH] BUG in pv_clock when overflow condition is detected
Date: Mon, 13 Feb 2012 19:20:56 +0100
Message-Id: <1329157256-19926-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG when overflow occurs at pvclock.c:pvclock_get_nsec_offset

    u64 delta = native_read_tsc() - shadow->tsc_timestamp;

this might happen at an attempt to read an uninitialized yet clock.
It won't prevent stalls and hangs but at least it won't do it silently.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/pvclock.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 42eb330..35a6190 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -43,7 +43,10 @@ void pvclock_set_flags(u8 flags)
 
 static u64 pvclock_get_nsec_offset(struct pvclock_shadow_time *shadow)
 {
-	u64 delta = native_read_tsc() - shadow->tsc_timestamp;
+	u64 delta;
+	u64 tsc = native_read_tsc();
+	BUG_ON(tsc < shadow->tsc_timestamp);
+	delta = tsc - shadow->tsc_timestamp;
 	return pvclock_scale_delta(delta, shadow->tsc_to_nsec_mul,
 				   shadow->tsc_shift);
 }
-- 
1.7.7.6

