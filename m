Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab0FBVWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:22:07 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37301 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932934Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/11] x86, UV: correct BAU software acknowledge
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004aP-7O@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the acknowledgment and the reset of a BAU software-acknowledged
message.

A retry message should be testing only for timed-out resources (mask << 8).
(And we delete a log message that might cause unnecessary concern)
The acknowledge MMR is  |--timed-out--|---pending--|,  each is 8 bits.

The IPI-driven reset of software acknowledge resources frees both timed out
and pending resources.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -161,15 +161,14 @@ static inline void uv_bau_process_retry_
 			slot2 = msg2 - mdp->va_queue_first;
 			mmr = uv_read_local_mmr
 				(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = ((msg2->sw_ack_vector << 8) |
-				   msg2->sw_ack_vector);
+			msg_res = msg2->sw_ack_vector;
 			/*
 			 * This is a message retry; clear the resources held
 			 * by the previous message only if they timed out.
 			 * If it has not timed out we have an unexpected
 			 * situation to report.
 			 */
-			if (mmr & (msg_res << 8)) {
+			if (mmr & (msg_res << UV_SW_ACK_NPENDING)) {
 				/*
 				 * is the resource timed out?
 				 * make everyone ignore the cancelled message.
@@ -179,9 +178,9 @@ static inline void uv_bau_process_retry_
 				cancel_count++;
 				uv_write_local_mmr(
 				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-					(msg_res << 8) | msg_res);
-			} else
-				printk(KERN_INFO "note bau retry: no effect\n");
+					(msg_res << UV_SW_ACK_NPENDING) |
+					 msg_res);
+			}
 		}
 	}
 	if (!cancel_count)
@@ -317,13 +316,13 @@ uv_do_reset(void *ptr)
 			 */
 			mmr = uv_read_local_mmr
 					(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE);
-			msg_res = ((msg->sw_ack_vector << 8) |
-						   msg->sw_ack_vector);
+			msg_res = msg->sw_ack_vector;
 			if (mmr & msg_res) {
 				stat->d_rcanceled++;
 				uv_write_local_mmr(
 				    UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS,
-							msg_res);
+					(msg_res << UV_SW_ACK_NPENDING) |
+					 msg_res);
 			}
 		}
 	}
