Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2APVS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:18:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36879 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754167Ab2APVS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:18:28 -0500
Date: Mon, 16 Jan 2012 15:18:48 -0600
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, x86@kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 2/6] x86, UV2: calc BAU destination timeout
Message-ID: <20120116211848.GB5767@sgi.com>
References: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116211617.GD5512@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move the call to enable_timeouts() forward so that BAU_MISC_CONTROL is 
initialized before using it in calculate_destination_timeout().

Fix the calculation of a BAU destination timeout for UV2 (in
calculate_destination_timeout()).

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 arch/x86/platform/uv/tlb_uv.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/platform/uv/tlb_uv.c
+++ 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
@@ -1617,14 +1617,14 @@ static int calculate_destination_timeout
 		ts_ns = base * mult1 * mult2;
 		ret = ts_ns / 1000;
 	} else {
-		/* 4 bits  0/1 for 10/80us, 3 bits of multiplier */
-		mmr_image = uv_read_local_mmr(UVH_AGING_PRESCALE_SEL);
+		/* 4 bits  0/1 for 10/80us base, 3 bits of multiplier */
+		mmr_image = uv_read_local_mmr(UVH_LB_BAU_MISC_CONTROL);
 		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
 		if (mmr_image & (1L << UV2_ACK_UNITS_SHFT))
-			mult1 = 80;
+			base = 80;
 		else
-			mult1 = 10;
-		base = mmr_image & UV2_ACK_MASK;
+			base = 10;
+		mult1 = mmr_image & UV2_ACK_MASK;
 		ret = mult1 * base;
 	}
 	return ret;
@@ -1886,6 +1886,8 @@ static int __init uv_bau_init(void)
 			uv_base_pnode = uv_blade_to_pnode(uvhub);
 	}
 
+	enable_timeouts();
+
 	if (init_per_cpu(nuvhubs, uv_base_pnode)) {
 		nobau = 1;
 		return 0;
@@ -1896,7 +1898,6 @@ static int __init uv_bau_init(void)
 		if (uv_blade_nr_possible_cpus(uvhub))
 			init_uvhub(uvhub, vector, uv_base_pnode);
 
-	enable_timeouts();
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
 	for_each_possible_blade(uvhub) {
