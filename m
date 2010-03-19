Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0CSCoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:44:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CSCoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:44:19 -0400
X-Authority-Analysis: v=1.0 c=1 a=qZ4rcf0kavUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=-eGxAq5vGyx-T57c5gMA:9 a=6Iz1nZuTp5IZqeb4b9kA:7 a=8uMsRL5d07qWVaObvcJoFW1APlEA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=GbQXIhYNWpNwKYfg:21 a=hIADOTQmEVP8H7k9:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.34] ring-buffer: Do 8 byte alignment for 64
 bit that can not handle 4 byte align
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Sparc <sparclinux@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 18 Mar 2010 22:44:17 -0400
Message-ID: <1268966657.758.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch fixes a bug in the ring buffer that breaks 64bit boxes that
can not write a long on a 4byte alignment.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align

----
 kernel/trace/ring_buffer.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)
---------------------------
commit fb6b926d6be02e0767c92cbde4c8574f6a9eca27
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Mar 18 17:54:19 2010 -0400

    ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align
    
    The ring buffer uses 4 byte alignment while recording events into the
    buffer, even on 64bit machines. This saves space when there are lots
    of events being recorded at 4 byte boundaries.
    
    The ring buffer has a zero copy method to write into the buffer, with
    the reserving of space and then committing it. This may cause problems
    when writing an 8 byte word into a 4 byte alignment (not 8). For x86 and
    PPC this is not an issue, but on some architectures this would cause an
    out-of-alignment exception.
    
    This patch uses CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
    if it is OK to use 4 byte alignments on 64 bit machines. If it is not,
    it forces the ring buffer event header to be 8 bytes and not 4,
    and will align the length of the data to be 8 byte aligned.
    This keeps the data payload at 8 byte alignments and will allow these
    machines to run without issue.
    
    The trick to this is that the header can be either 4 bytes or 8 bytes
    depending on the length of the data payload. The 4 byte header
    has a length field that supports up to 112 bytes. If the length of
    the data is more than 112, the length field is set to zero, and the actual
    length is stored in the next 4 bytes after the header.
    
    When CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is not set, the code forces
    zero in the 4 byte header forcing the length to be stored in the 4 byte
    array, even with a small data load. It also forces the length of the
    data load to be 8 byte aligned. The combination of these two guarantee
    that the data is always at 8 byte alignment.
    
    Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
               (on sparc64)
    Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 05a9f83..d1187ef 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -207,6 +207,14 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
 #define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
 
+#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+# define RB_FORCE_8BYTE_ALIGNMENT	0
+# define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
+#else
+# define RB_FORCE_8BYTE_ALIGNMENT	1
+# define RB_ARCH_ALIGNMENT		8U
+#endif
+
 /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
 #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
 
@@ -1547,7 +1555,7 @@ rb_update_event(struct ring_buffer_event *event,
 
 	case 0:
 		length -= RB_EVNT_HDR_SIZE;
-		if (length > RB_MAX_SMALL_DATA)
+		if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT)
 			event->array[0] = length;
 		else
 			event->type_len = DIV_ROUND_UP(length, RB_ALIGNMENT);
@@ -1722,11 +1730,11 @@ static unsigned rb_calculate_event_length(unsigned length)
 	if (!length)
 		length = 1;
 
-	if (length > RB_MAX_SMALL_DATA)
+	if (length > RB_MAX_SMALL_DATA || RB_FORCE_8BYTE_ALIGNMENT)
 		length += sizeof(event.array[0]);
 
 	length += RB_EVNT_HDR_SIZE;
-	length = ALIGN(length, RB_ALIGNMENT);
+	length = ALIGN(length, RB_ARCH_ALIGNMENT);
 
 	return length;
 }


