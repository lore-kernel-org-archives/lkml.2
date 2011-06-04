Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1FDPpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 11:45:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:48493 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021Ab1FDPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 11:45:47 -0400
Date: Sat, 4 Jun 2011 17:35:47 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 1/8] powerpc/rtas-rtc: remove sideeffects of
 printk_ratelimit
Message-ID: <f9c3e5aaf1d7819e06667f2575ca9623711d03e6.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use printk_ratelimit() as an additional condition for returning
on an error. Because when the ratelimit is reached, printk_ratelimit
will return 0 and e.g. in rtas_get_boot_time won't check for an error
condition.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 arch/powerpc/kernel/rtas-rtc.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/rtas-rtc.c b/arch/powerpc/kernel/rtas-rtc.c
index 77578c0..c57c193 100644
--- a/arch/powerpc/kernel/rtas-rtc.c
+++ b/arch/powerpc/kernel/rtas-rtc.c
@@ -4,6 +4,7 @@
 #include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/delay.h>
+#include <linux/ratelimit.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/time.h>
@@ -29,9 +30,10 @@ unsigned long __init rtas_get_boot_time(void)
 		}
 	} while (wait_time && (get_tb() < max_wait_tb));
 
-	if (error != 0 && printk_ratelimit()) {
-		printk(KERN_WARNING "error: reading the clock failed (%d)\n",
-			error);
+	if (error != 0) {
+		printk_ratelimited(KERN_WARNING
+				   "error: reading the clock failed (%d)\n",
+				   error);
 		return 0;
 	}
 
@@ -55,19 +57,21 @@ void rtas_get_rtc_time(struct rtc_time *rtc_tm)
 
 		wait_time = rtas_busy_delay_time(error);
 		if (wait_time) {
-			if (in_interrupt() && printk_ratelimit()) {
+			if (in_interrupt()) {
 				memset(rtc_tm, 0, sizeof(struct rtc_time));
-				printk(KERN_WARNING "error: reading clock"
-				       " would delay interrupt\n");
+				printk_ratelimited(KERN_WARNING
+						   "error: reading clock "
+						   "would delay interrupt\n");
 				return;	/* delay not allowed */
 			}
 			msleep(wait_time);
 		}
 	} while (wait_time && (get_tb() < max_wait_tb));
 
-        if (error != 0 && printk_ratelimit()) {
-                printk(KERN_WARNING "error: reading the clock failed (%d)\n",
-		       error);
+	if (error != 0) {
+		printk_ratelimited(KERN_WARNING
+				   "error: reading the clock failed (%d)\n",
+				   error);
 		return;
         }
 
@@ -99,9 +103,10 @@ int rtas_set_rtc_time(struct rtc_time *tm)
 		}
 	} while (wait_time && (get_tb() < max_wait_tb));
 
-        if (error != 0 && printk_ratelimit())
-                printk(KERN_WARNING "error: setting the clock failed (%d)\n",
-		       error);
+	if (error != 0)
+		printk_ratelimited(KERN_WARNING
+				   "error: setting the clock failed (%d)\n",
+				   error);
 
         return 0;
 }
-- 
1.7.1

