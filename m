Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab2AQRVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:21:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2AQRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:21:20 -0500
Date: Tue, 17 Jan 2012 09:20:59 -0800
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-d059f9fa84a30e04279c6ff615e9e2cf3b260191@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120116211848.GB5767@sgi.com>
References: <20120116211848.GB5767@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/UV2:
  Fix BAU destination timeout initialization
Git-Commit-ID: d059f9fa84a30e04279c6ff615e9e2cf3b260191
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 09:21:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d059f9fa84a30e04279c6ff615e9e2cf3b260191
Gitweb:     http://git.kernel.org/tip/d059f9fa84a30e04279c6ff615e9e2cf3b260191
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 16 Jan 2012 15:18:48 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Jan 2012 09:09:53 +0100

x86/UV2: Fix BAU destination timeout initialization

Move the call to enable_timeouts() forward so that
BAU_MISC_CONTROL is initialized before using it in
calculate_destination_timeout().

Fix the calculation of a BAU destination timeout
for UV2 (in calculate_destination_timeout()).

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120116211848.GB5767@sgi.com
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 1341a2e..c425ff1 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1617,14 +1617,14 @@ static int calculate_destination_timeout(void)
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
