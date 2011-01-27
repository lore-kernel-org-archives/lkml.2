Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1A0PAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45169 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752679Ab1A0PAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:31 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX196bwxpkD96k0eCOLkPJTubg8QJEcDjl75qGNhfuL
	jNtpkxQiIPeXMy
Subject: [PATCH v2 19/20] xtensa: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Chris Zankel <chris@zankel.net>, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 16:00:27 +0100
Message-ID: <20110127150027.23248.61798.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

set_linux_timer() does not need to be protected by a lock.

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/xtensa/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..f3e5eb4 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -96,16 +96,12 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
-
-		do_timer(1); /* Linux handler in kernel/timer.c */
+		xtime_update(1); /* Linux handler in kernel/time/timekeeping */
 
 		/* Note that writing CCOMPARE clears the interrupt. */
 
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
-
-		write_sequnlock(&xtime_lock);
 	}
 
 	/* Allow platform to do something useful (Wdog). */

