Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab0FHU7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:59:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:39596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0FHU7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:59:00 -0400
Date: Tue, 8 Jun 2010 20:58:38 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1OJvNy-0004ak-Dy@eag09.americas.sgi.com>
References: <E1OJvNy-0004ak-Dy@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct BAU regular message type
Message-ID: <tip-7fba1bcd4844a4a8619a03bf51cabc92aea365a8@git.kernel.org>
Git-Commit-ID: 7fba1bcd4844a4a8619a03bf51cabc92aea365a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Jun 2010 20:58:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fba1bcd4844a4a8619a03bf51cabc92aea365a8
Gitweb:     http://git.kernel.org/tip/7fba1bcd4844a4a8619a03bf51cabc92aea365a8
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 2 Jun 2010 16:22:02 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Jun 2010 21:13:47 +0200

x86, UV: Correct BAU regular message type

The Broadcast Assist Unit messages have a regular or retry
message type. The regular type was not being set, but needs to
be, because the lack of a message type is sometimes used to
identify an unused entry in the message queue.
Also removing some excess comments.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: gregkh@suse.de
LKML-Reference: <E1OJvNy-0004ak-Dy@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tlb_uv.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index dc962b5..4cb14db 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -580,23 +580,10 @@ const struct cpumask *uv_flush_send_and_wait(struct bau_desc *bau_desc,
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
