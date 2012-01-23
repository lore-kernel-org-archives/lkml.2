Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2AWXul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2AWXug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:29 2012
Message-Id: <20120123234029.566986801@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Cliff Wickman <cpw@sgi.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [78/90] x86/UV2: Fix BAU destination timeout initialization
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit d059f9fa84a30e04279c6ff615e9e2cf3b260191 upstream.

Move the call to enable_timeouts() forward so that
BAU_MISC_CONTROL is initialized before using it in
calculate_destination_timeout().

Fix the calculation of a BAU destination timeout
for UV2 (in calculate_destination_timeout()).

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120116211848.GB5767@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/platform/uv/tlb_uv.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1575,14 +1575,14 @@ static int calculate_destination_timeout
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
@@ -1820,6 +1820,8 @@ static int __init uv_bau_init(void)
 			uv_base_pnode = uv_blade_to_pnode(uvhub);
 	}
 
+	enable_timeouts();
+
 	if (init_per_cpu(nuvhubs, uv_base_pnode)) {
 		nobau = 1;
 		return 0;
@@ -1830,7 +1832,6 @@ static int __init uv_bau_init(void)
 		if (uv_blade_nr_possible_cpus(uvhub))
 			init_uvhub(uvhub, vector, uv_base_pnode);
 
-	enable_timeouts();
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
 	for_each_possible_blade(uvhub) {


