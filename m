Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1CBSq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:46:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:34931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1CBSq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:46:26 -0500
Date: Wed, 2 Mar 2011 18:46:03 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, ying.huang@intel.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <4D6E630E.1070107@openvz.org>
References: <4D6E630E.1070107@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, nmi: Define a name for NMI control port
Message-ID: <tip-0f5dbad5ecab0921911966e857eab408ef32163c@git.kernel.org>
Git-Commit-ID: 0f5dbad5ecab0921911966e857eab408ef32163c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 18:46:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f5dbad5ecab0921911966e857eab408ef32163c
Gitweb:     http://git.kernel.org/tip/0f5dbad5ecab0921911966e857eab408ef32163c
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 2 Mar 2011 18:32:30 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Mar 2011 16:44:44 +0100

x86, nmi: Define a name for NMI control port

Also add a comment about why we need in/out operations.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
LKML-Reference: <4D6E630E.1070107@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mach_traps.h |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
index 72a8b52..7775deb 100644
--- a/arch/x86/include/asm/mach_traps.h
+++ b/arch/x86/include/asm/mach_traps.h
@@ -8,6 +8,7 @@
 #include <asm/mc146818rtc.h>
 
 #define NMI_REASON_PORT		0x61
+#define NMI_ENABLE_PORT		0x70 /* Real-Time Clock Address Register as well */
 
 #define NMI_REASON_SERR		0x80
 #define NMI_REASON_IOCHK	0x40
@@ -30,12 +31,19 @@ static inline void reassert_nmi(void)
 		old_reg = current_lock_cmos_reg();
 	else
 		lock_cmos(0); /* register doesn't matter here */
-	outb(0x8f, 0x70);
-	inb(0x71);		/* dummy */
-	outb(0x0f, 0x70);
-	inb(0x71);		/* dummy */
+
+	/*
+	 * This will cause the NMI output to transition low
+	 * then high if there are any pending NMI sources. The
+	 * CPU's NMI input logic will then register a new NMI.
+	 */
+	outb(0x8f, NMI_ENABLE_PORT);
+	inb(0x71);	/* dummy */
+	outb(0x0f, NMI_ENABLE_PORT);
+	inb(0x71);	/* dummy */
+
 	if (old_reg >= 0)
-		outb(old_reg, 0x70);
+		outb(old_reg, NMI_ENABLE_PORT);
 	else
 		unlock_cmos();
 }
