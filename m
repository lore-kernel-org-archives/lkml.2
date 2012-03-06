Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2CFQV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:21:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2610 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2CFQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:52 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=u52bHe8Tr8IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=t5Qy2eHjJ2LCHW17eE8A:9 a=xLRvxeAcmIFn2nyLePUA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161950.744002958@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 18/25][RFC 3.0.23-rt39-rc1] net: u64_stat: Protect seqcount
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0018-net-u64_stat-Protect-seqcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

On RT we must prevent that the writer gets preempted inside the write
section. Otherwise a preempting reader might spin forever.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/u64_stats_sync.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 8da8c4e..b39549f 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -70,6 +70,7 @@ struct u64_stats_sync {
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable_rt();
 	write_seqcount_begin(&syncp->seq);
 #endif
 }
@@ -78,6 +79,7 @@ static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
 	write_seqcount_end(&syncp->seq);
+	preempt_enable_rt();
 #endif
 }
 
-- 
1.7.8.3


