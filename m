Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1CUXQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:16:30 -0400
Received: from kroah.org ([198.145.64.141]:49594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab1CUXQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:16 2011
Message-Id: <20110321230716.632588913@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [72/87] perf, powerpc: Handle events that raise an exception without overflowing
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 upstream.

Events on POWER7 can roll back if a speculative event doesn't
eventually complete. Unfortunately in some rare cases they will
raise a performance monitor exception. We need to catch this to
ensure we reset the PMC. In all cases the PMC will be 256 or less
cycles from overflow.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110309143842.6c22845e@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/reg.h   |    1 +
 arch/powerpc/kernel/perf_event.c |   24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -878,6 +878,7 @@
 #define PV_970		0x0039
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
+#define PV_POWER7	0x003F
 #define PV_970FX	0x003C
 #define PV_630		0x0040
 #define PV_630p	0x0041
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1268,6 +1268,28 @@ unsigned long perf_instruction_pointer(s
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
@@ -1315,7 +1337,7 @@ static void perf_event_interrupt(struct
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
-			if ((int)val < 0)
+			if (pmc_overflow(val))
 				write_pmc(i + 1, 0);
 		}
 	}


