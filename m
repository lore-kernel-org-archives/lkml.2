Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2LEQJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:09:21 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51616 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2LEQJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 04/44] trace/ring_buffer: handle 64bit aligned structs
Date: Wed, 5 Dec 2012 16:08:22 +0000
Message-ID: <1354723742-6195-5-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 32 bit architectures have 64 bit struct alignment (for example
Meta which has 64 bit read/write instructions). These require 8 byte
alignment of event data too, so use CONFIG_HAVE_64BIT_ALIGNED_STRUCT
instead of CONFIG_64BIT to decide alignment, and align
buffer_data_page::data accordingly.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/ring_buffer.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b979426..c4dc029 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -177,7 +177,8 @@ void tracing_off_permanent(void)
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 #define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
 
-#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#if !defined(CONFIG_HAVE_64BIT_ALIGNED_STRUCT) || \
+	defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 # define RB_FORCE_8BYTE_ALIGNMENT	0
 # define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
 #else
@@ -185,6 +186,8 @@ void tracing_off_permanent(void)
 # define RB_ARCH_ALIGNMENT		8U
 #endif
 
+#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
+
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
@@ -333,7 +336,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 struct buffer_data_page {
 	u64		 time_stamp;	/* page time stamp */
 	local_t		 commit;	/* write committed index */
-	unsigned char	 data[];	/* data of buffer page */
+	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
 };
 
 /*
-- 
1.7.7.6


