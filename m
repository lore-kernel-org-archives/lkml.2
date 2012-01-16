Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2APVWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:22:19 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756621Ab2APVWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:22:17 -0500
Date: Mon, 16 Jan 2012 15:22:38 -0600
From: Cliff Wickman <cpw@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, x86@kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [PATCH 6/6] x86, UV2: accounting for BAU strong nacks
Message-ID: <20120116212238.GF5767@sgi.com>
References: <20120116211617.GD5512@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116211617.GD5512@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds separate accounting of UV2 message "strong nack's" in
the BAU statistics.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/platform/uv/tlb_uv.c    |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

Index: 120113.linux-3.2.1/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/include/asm/uv/uv_bau.h
+++ 120113.linux-3.2.1/arch/x86/include/asm/uv/uv_bau.h
@@ -483,6 +483,7 @@ struct ptc_stats {
 						   requests */
 	unsigned long	s_stimeout;		/* source side timeouts */
 	unsigned long	s_dtimeout;		/* destination side timeouts */
+	unsigned long	s_strongnacks;		/* number of strong nack's */
 	unsigned long	s_time;			/* time spent in sending side */
 	unsigned long	s_retriesok;		/* successful retries */
 	unsigned long	s_ntargcpu;		/* total number of cpu's
Index: 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/platform/uv/tlb_uv.c
+++ 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
@@ -635,13 +635,15 @@ static int uv2_wait_completion(struct ba
 		 * our message and its state will stay IDLE.
 		 */
 		if ((descriptor_stat == UV2H_DESC_SOURCE_TIMEOUT) ||
-		    (descriptor_stat == UV2H_DESC_DEST_STRONG_NACK) ||
 		    (descriptor_stat == UV2H_DESC_DEST_PUT_ERR)) {
 			stat->s_stimeout++;
 			return FLUSH_GIVEUP;
+		} else if (descriptor_stat == UV2H_DESC_DEST_STRONG_NACK) {
+			stat->s_strongnacks++;
+			bcp->conseccompletes = 0;
+			return FLUSH_GIVEUP;
 		} else if (descriptor_stat == UV2H_DESC_DEST_TIMEOUT) {
 			stat->s_dtimeout++;
-			ttm = get_cycles();
 			bcp->conseccompletes = 0;
 			return FLUSH_RETRY_TIMEOUT;
 		} else {
@@ -1346,7 +1348,7 @@ static int ptc_seq_show(struct seq_file
 		seq_printf(file,
 			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto retries rok ");
+		    "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries rok ");
 		seq_printf(file,
 			"resetp resett giveup sto bz throt swack recv rtime ");
 		seq_printf(file,
@@ -1364,10 +1366,10 @@ static int ptc_seq_show(struct seq_file
 			   stat->s_ntargremotes, stat->s_ntargcpu,
 			   stat->s_ntarglocaluvhub, stat->s_ntargremoteuvhub,
 			   stat->s_ntarguvhub, stat->s_ntarguvhub16);
-		seq_printf(file, "%ld %ld %ld %ld %ld ",
+		seq_printf(file, "%ld %ld %ld %ld %ld %ld ",
 			   stat->s_ntarguvhub8, stat->s_ntarguvhub4,
 			   stat->s_ntarguvhub2, stat->s_ntarguvhub1,
-			   stat->s_dtimeout);
+			   stat->s_dtimeout, stat->s_strongnacks);
 		seq_printf(file, "%ld %ld %ld %ld %ld %ld %ld %ld ",
 			   stat->s_retry_messages, stat->s_retriesok,
 			   stat->s_resets_plug, stat->s_resets_timeout,
