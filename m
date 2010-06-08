Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0FHU6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:58:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:39552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0FHU6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:58:07 -0400
Date: Tue, 8 Jun 2010 20:57:43 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004aP-7O@eag09.americas.sgi.com>
References: <E1OJvNy-0004aP-7O@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct BAU software acknowledge
Message-ID: <tip-39847e7f3c8198b14102fe7ba4b3a6a1d84bbcfe@git.kernel.org>
Git-Commit-ID: 39847e7f3c8198b14102fe7ba4b3a6a1d84bbcfe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39847e7f3c8198b14102fe7ba4b3a6a1d84bbcfe
Gitweb:     http://git.kernel.org/tip/39847e7f3c8198b14102fe7ba4b3a6a1d84bbcfe
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:46 +0200

x86, UV: Correct BAU software acknowledge

Correct the acknowledgment and the reset of a BAU
software-acknowledged message.

A retry message should be testing only for timed-out resources
(mask << 8). (And we delete a log message that might cause
unnecessary concern) The acknowledge MMR is
|--timed-out--|---pending--|,  each is 8 bits.

The IPI-driven reset of software acknowledge resources frees
both timed out and pending resources.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004aP-7O@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index d759290..295a411 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -161,15 +161,14 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
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
@@ -179,9 +178,9 @@ static inline void uv_bau_process_retry_msg(struct msg_desc *mdp,
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
