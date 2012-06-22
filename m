Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab2FVNMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:12:13 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40656 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932659Ab2FVNML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:12:11 -0400
Date: Fri, 22 Jun 2012 08:12:12 -0500
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 1/3] x86: UV BAU destination timeout period
Message-ID: <20120622131212.GA31884@sgi.com>
References: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Si3c5-0008I6-CG@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the calculation of a destination timeout period, which is used
to distinguish between a destination timeout and the situation where all
the target software ack resources are full and a request is returned
immediately.

The problem is that integer arithmetic was overflowing, yielding a very
large result.

Without this fix destination timeouts are identified as resource 'plugged'
events and an ipi method of resource releasing is unnecessarily employed.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1811,8 +1811,8 @@ static int calculate_destination_timeout
 		index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
 		mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
 		mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
-		base = timeout_base_ns[index];
-		ts_ns = base * mult1 * mult2;
+		ts_ns = timeout_base_ns[index];
+		ts_ns *= (mult1 * mult2);
 		ret = ts_ns / 1000;
 	} else {
 		/* 4 bits  0/1 for 10/80us base, 3 bits of multiplier */
