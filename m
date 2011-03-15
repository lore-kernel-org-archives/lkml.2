Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1COROA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:14:00 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34255 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab1CORN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:13:59 -0400
From: Boris Ostrovsky <ostr@amd64.org>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: borislav.petkov@amd.com, andreas.herrmann3@amd.com, mark.langsdorf@amd.com,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH RESEND] x86, AMD: Set ARAT feature on AMD processors
Date: Tue, 15 Mar 2011 12:13:44 -0400
Message-Id: <1300205624-4813-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

Support for Always Running APIC timer (ARAT) was introduced in commit
db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature allows us to
avoid switching timers from LAPIC to something else (e.g. HPET) and
go into timer broadcasts when entering deep C-states.

AMD processors don't provide a CPUID bit for that feature but they also
keep APIC timers running in deep C-states (except for cases when the
processor is affected by erratum 400). Therefore we should set ARAT
feature bit on AMD CPUs.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
Tested-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..48eaa1b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -594,6 +594,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1

