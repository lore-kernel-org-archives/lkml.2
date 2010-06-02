Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab0FBVV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:21:57 -0400
Received: from relay1.sgi.com ([192.48.179.29]:39576 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab0FBVVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:21:35 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 9/11] x86, UV: correct BAU regular message type
Cc: mingo@elte.hu, hpa@zytor.com, gregkh@suse.de
Message-Id: <E1OJvNy-0004ak-Dy@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 02 Jun 2010 16:22:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Broadcast Assist Unit messages have a regular or retry message type.
The regular type was not being set, but needs to be, because the lack
of a message type is sometimes used to identify an unused entry in the
message queue.
Also removing some excess comments.

Diffed against 2.6.34 -tip

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

Index: 100531.linux-tip/arch/x86/kernel/tlb_uv.c
===================================================================
--- 100531.linux-tip.orig/arch/x86/kernel/tlb_uv.c
+++ 100531.linux-tip/arch/x86/kernel/tlb_uv.c
@@ -580,23 +580,10 @@ const struct cpumask *uv_flush_send_and_
 	}
 	time1 = get_cycles();
 	do {
-		/*
-		 * Every message from any given cpu gets a unique message
-		 * sequence number. But retries use that same number.
-		 * Our message may have timed out at the destination because
-		 * all sw-ack resources are in use and there is a timeout
-		 * pending there.  In that case, our last send never got
-		 * placed into the queue and we need to persist until it
-		 * does.
-		 *
-		 * Make any retry a type MSG_RETRY so that the destination will
-		 * free any resource held by a previous message from this cpu.
-		 */
 		if (try == 0) {
-			/* use message type set by the caller the first time */
+			bau_desc->header.msg_type = MSG_REGULAR;
 			seq_number = bcp->message_number++;
 		} else {
-			/* use RETRY type on all the rest; same sequence */
 			bau_desc->header.msg_type = MSG_RETRY;
 			stat->s_retry_messages++;
 		}
