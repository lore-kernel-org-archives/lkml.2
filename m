Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0HZNWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:22:34 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752096Ab0HZNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:27 -0400
Message-Id: <20100826132125.639958322@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:54 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 17/25] GRU - no panic on gru malfunction
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_no_panic_gru_failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

If the GRU malfunctions, print a message instead of panicing the system.
This simplifies debugging since some of the debug tools can be used on
a live system. Flush the cache on instruction timeouts in case the
malfunction is related to a coherency issue (never seen this but I'm paranoid).

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/gruhandles.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.c	2010-06-09 08:11:43.724081727 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.c	2010-06-09 08:11:46.697237522 -0500
@@ -71,7 +71,7 @@ static void report_instruction_timeout(v
 	else if (TYPE_IS(TFH, goff))
 		id = "TFH";
 
-	panic(KERN_ALERT "GRU %p (%s) is malfunctioning\n", h, id);
+	printk(KERN_ALERT "GRU:%d %p (%s) is malfunctioning\n", smp_processor_id(), h, id);
 }
 
 static int wait_instruction_complete(void *h, enum mcs_op opc)
@@ -85,6 +85,7 @@ static int wait_instruction_complete(voi
 		if (status != CCHSTATUS_ACTIVE)
 			break;
 		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
+			gru_flush_cache(h);
 			report_instruction_timeout(h);
 			start_time = get_cycles();
 		}

