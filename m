Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2APVV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:21:26 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60805 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab2APVVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:21:25 -0500
Date: Mon, 16 Jan 2012 15:21:46 -0600
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, x86@kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 5/6] x86, UV2: ack BAU interrupt earlier
Message-ID: <20120116212146.GE5767@sgi.com>
References: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116211617.GD5512@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch moves the ack of the BAU interrupt to the beginning of 
the interrupt handler so that there is less possibility of a lost
interrupt and slower response to a shootdown message.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/platform/uv/tlb_uv.c
+++ 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
@@ -1218,6 +1218,7 @@ void uv_bau_message_interrupt(struct pt_
 	struct ptc_stats *stat;
 	struct msg_desc msgdesc;
 
+	ack_APIC_irq();
 	time_start = get_cycles();
 
 	bcp = &per_cpu(bau_control, smp_processor_id());
@@ -1247,8 +1248,6 @@ void uv_bau_message_interrupt(struct pt_
 		stat->d_nomsg++;
 	else if (count > 1)
 		stat->d_multmsg++;
-
-	ack_APIC_irq();
 }
 
 /*
