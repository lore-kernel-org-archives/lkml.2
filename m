Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2AQRYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:24:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2AQRY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:24:29 -0500
Date: Tue, 17 Jan 2012 09:24:07 -0800
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-b54bd9be35f4084edb3eb9ee054a43f722a67483@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120116212238.GF5767@sgi.com>
References: <20120116212238.GF5767@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/UV2: Add accounting for BAU strong nacks
Git-Commit-ID: b54bd9be35f4084edb3eb9ee054a43f722a67483
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 17 Jan 2012 09:24:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b54bd9be35f4084edb3eb9ee054a43f722a67483
Gitweb:     http://git.kernel.org/tip/b54bd9be35f4084edb3eb9ee054a43f722a67483
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 16 Jan 2012 15:22:38 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Jan 2012 09:09:59 +0100

x86/UV2: Add accounting for BAU strong nacks

This patch adds separate accounting of UV2 message "strong
nack's" in the BAU statistics.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120116212238.GF5767@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |    1 +
 arch/x86/platform/uv/tlb_uv.c    |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 1b82f7e..becf47b 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -483,6 +483,7 @@ struct ptc_stats {
 						   requests */
 	unsigned long	s_stimeout;		/* source side timeouts */
 	unsigned long	s_dtimeout;		/* destination side timeouts */
+	unsigned long	s_strongnacks;		/* number of strong nack's */
 	unsigned long	s_time;			/* time spent in sending side */
 	unsigned long	s_retriesok;		/* successful retries */
 	unsigned long	s_ntargcpu;		/* total number of cpu's
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 4686bf1..9be4cff 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -635,13 +635,15 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
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
@@ -1346,7 +1348,7 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 		seq_printf(file,
 			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
 		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto retries rok ");
+		    "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries rok ");
 		seq_printf(file,
 			"resetp resett giveup sto bz throt swack recv rtime ");
 		seq_printf(file,
@@ -1364,10 +1366,10 @@ static int ptc_seq_show(struct seq_file *file, void *data)
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
