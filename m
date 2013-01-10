Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3AJPpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:45:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52711 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3AJPcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:32 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v3 05/44] trace/ring_buffer: handle 64bit aligned structs
Date: Thu, 10 Jan 2013 15:30:33 +0000
Message-ID: <1357831872-29451-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 32 bit architectures require 64 bit values to be aligned (for
example Meta which has 64 bit read/write instructions). These require 8
byte alignment of event data too, so use
!CONFIG_HAVE_64BIT_ALIGNED_ACCESS instead of !CONFIG_64BIT ||
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to decide alignment, and align
buffer_data_page::data accordingly.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org> (previous version subtly different)
---
 kernel/trace/ring_buffer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ce8514f..cb4524f 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -177,7 +177,7 @@ void tracing_off_permanent(void)
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 #define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
 
-#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#ifndef CONFIG_HAVE_64BIT_ALIGNED_ACCESS
 # define RB_FORCE_8BYTE_ALIGNMENT	0
 # define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
 #else
@@ -185,6 +185,8 @@ void tracing_off_permanent(void)
 # define RB_ARCH_ALIGNMENT		8U
 #endif
 
+#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
+
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
@@ -333,7 +335,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
-	unsigned char	 data[];	/* data of buffer page */
+	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
 };
 
 /*
-- 
1.7.7.6


