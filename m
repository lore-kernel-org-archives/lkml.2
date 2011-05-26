Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1EZPU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:20:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55447 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1EZPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:20:58 -0400
From: Boris Ostrovsky <ostr@amd64.org>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: borislav.petkov@amd.com, Hans.Rosenfeld@amd.com, Andreas.Herrmann3@amd.com,
        cebbert@redhat.com, Boris.Ostrovsky@amd.com,
        linux-kernel@vger.kernel.org, jvpeetz@web.de, stable@kernel.org,
        x86@kernel.org
Subject: [PATCH RESEND] x86, AMD: Do not enable ARAT feature on AMD processors below family 0x12
Date: Thu, 26 May 2011 11:19:52 -0400
Message-Id: <1306423192-19774-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 added support for
ARAT (Always Running APIC timer) on AMD processors that are not
affected by erratum 400. This erratum is present on certain processor
families and prevents APIC timer from waking up the CPU when it
is in a deep C state, including C1E state.

Determining whether a processor is affected by this erratum may
have some corner cases and handling these cases is somewhat
complicated. In the interest of simplicity we won't claim ARAT
support on processor families below 0x12 and will go back to
broadcasting timer when going idle.

Signed-off-by: Boris Ostrovsky <ostr@amd64.org>
Tested-by: Boris Petkov <borislav.petkov@amd.com>
Cc: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: stable@kernel.org # 32.x, 38.x, 39.x
---
 arch/x86/kernel/cpu/amd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6f9d1f6..728b223 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -612,8 +612,11 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*
-- 
1.7.3.4

