Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1CPN6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:58:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:35905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1CPN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:58:37 -0400
Date: Wed, 16 Mar 2011 13:58:08 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110309143842.6c22845e@kryten>
References: <20110309143842.6c22845e@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, powerpc: Handle events that raise an exception without overflowing
Message-ID: <tip-0837e3242c73566fc1c0196b4ec61779c25ffc93@git.kernel.org>
Git-Commit-ID: 0837e3242c73566fc1c0196b4ec61779c25ffc93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:58:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0837e3242c73566fc1c0196b4ec61779c25ffc93
Gitweb:     http://git.kernel.org/tip/0837e3242c73566fc1c0196b4ec61779c25ffc93
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 9 Mar 2011 14:38:42 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Mar 2011 14:04:13 +0100

perf, powerpc: Handle events that raise an exception without overflowing

Events on POWER7 can roll back if a speculative event doesn't
eventually complete. Unfortunately in some rare cases they will
raise a performance monitor exception. We need to catch this to
ensure we reset the PMC. In all cases the PMC will be 256 or less
cycles from overflow.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # as far back as it applies cleanly
LKML-Reference: <20110309143842.6c22845e@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/reg.h   |    1 +
 arch/powerpc/kernel/perf_event.c |   24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 125fc1a..7626fa7 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -880,6 +880,7 @@
 #define PV_970		0x0039
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
+#define PV_POWER7	0x003F
 #define PV_970FX	0x003C
 #define PV_630		0x0040
 #define PV_630p	0x0041
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index ab6f6be..97e0ae4 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1269,6 +1269,28 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs)
 	return ip;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 /*
  * Performance monitor interrupt stuff
  */
@@ -1316,7 +1338,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
-			if ((int)val < 0)
+			if (pmc_overflow(val))
 				write_pmc(i + 1, 0);
 		}
 	}
