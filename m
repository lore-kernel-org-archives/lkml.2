Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0KSNvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:51:51 -0500
Received: from wiems06002.ceu.heidelberg.com ([193.99.214.201]:54566 "EHLO
	wiems06002.ceu.heidelberg.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0KSNvt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:51:49 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 08:51:49 EST
X-AuditID: c163d6c8-b7b3aae00000131a-89-4ce67d694465
From: "Husterer, Thomas RD-6.2.3" <Thomas.Husterer@heidelberg.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Nov 2010 14:36:33 +0100
Subject: [PATCH] tracing: missing information in trace binary format
Thread-Topic: [PATCH] tracing: missing information in trace binary format
Thread-Index: AcuH7sgOIcffZAmpSemHS8IaxIRTpA==
Message-ID: <BA096D1AF8AE9F408CA552890F7C14010ACD1A43E1@wiems02002.ceu.corp.heidelberg.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i am working with the latest patch of linux-rt (linux-2.6.33.7-rt29) and try to use
the tracer functionality with some userspace tools.
This works great when i use the ascii output of the trace file.
But parsing is not very easy due to dynamic field width and different types and length of seperators.
Additionaly this parser is not very stable over the time.


Fortunately there is a binary format (with trace_option 'bin') which can be
interpeted very fast and easy. But it is missing some data in this format.

1. There is a field value 'next_cpu' which is not written to the output.
2. There are two different event types (ctx and wake) which cannot be differentiated.
3. The Trace Output contains an ascii header and the binary body which cannot be
   separated very well.

Now I have implemented some proposals in the patch below.
1. Added the missing value 'next_cpu' (4Bytes)
2. Added one Byte which defines the event-type ctx:'>', wake:'+'
3. Insertet a uniq Sting betwen the ascii header and the binary body
   '#BinaryStart: Typ: 2 Reclen: 33\n'
   The Sting contains some info about the binary type (for future usage)
   and the length of one entry in Bytes
   and one terminating linefeed at the end.
   Behind this linefeed starts the binary data.

The patch works in linux-2.6.33.7-rt29 and linux-2.6.33.7.
Would it be possible to add this or a similar solution to the mainline kernel ?
I am not a kernel developer, and i am curently not subscribed to the kernel mailing
list but i think the solution described here could be useful for many other users.

Please CC: replies also to thomas.husterer@heidelberg.com

best regards
Thomas Husterer (thus)

diff -ur linux-2.6.33.7-rt29.orig/kernel/trace/trace.c linux-2.6.33.7-rt29/kernel/trace/trace.c
--- linux-2.6.33.7-rt29.orig/kernel/trace/trace.c       2010-11-19 11:02:34.000000000 +0100
+++ linux-2.6.33.7-rt29/kernel/trace/trace.c    2010-11-19 12:08:14.000000000 +0100
@@ -2066,6 +2066,10 @@
                        if (!(trace_flags & TRACE_ITER_VERBOSE))
                                print_func_help_header(m);
                }
+                if (trace_flags & TRACE_ITER_BIN) {
+                       seq_puts(m, "#BinaryStart: Typ: 2 Reclen: 33\n");
+                }
+
        } else if (iter->leftover) {
                /*
                 * If we filled the seq_file buffer earlier, we
diff -ur linux-2.6.33.7-rt29.orig/kernel/trace/trace_output.c linux-2.6.33.7-rt29/kernel/trace/trace_output.c
--- linux-2.6.33.7-rt29.orig/kernel/trace/trace_output.c        2010-08-02 19:27:18.000000000 +0200
+++ linux-2.6.33.7-rt29/kernel/trace/trace_output.c     2010-11-19 11:24:24.000000000 +0100
@@ -995,7 +995,7 @@
 }

 static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
-                                          int flags)
+                                          char S)
 {
        struct ctx_switch_entry *field;
        struct trace_seq *s = &iter->seq;
@@ -1008,16 +1008,30 @@
        SEQ_PUT_FIELD_RET(s, field->next_pid);
        SEQ_PUT_FIELD_RET(s, field->next_prio);
        SEQ_PUT_FIELD_RET(s, field->next_state);
+       SEQ_PUT_FIELD_RET(s, field->next_cpu);
+       SEQ_PUT_FIELD_RET(s, S);

        return TRACE_TYPE_HANDLED;
 }

+static enum print_line_t trace_ctx_bin(struct trace_iterator *iter,
+                                          int flags)
+{
+        return trace_ctxwake_bin(iter,'>');
+}
+
+static enum print_line_t trace_wake_bin(struct trace_iterator *iter,
+                                          int flags)
+{
+        return trace_ctxwake_bin(iter,'+');
+}
+
 static struct trace_event trace_ctx_event = {
        .type           = TRACE_CTX,
        .trace          = trace_ctx_print,
        .raw            = trace_ctx_raw,
        .hex            = trace_ctx_hex,
-       .binary         = trace_ctxwake_bin,
+       .binary         = trace_ctx_bin,
 };

 static struct trace_event trace_wake_event = {
@@ -1025,7 +1039,7 @@
        .trace          = trace_wake_print,
        .raw            = trace_wake_raw,
        .hex            = trace_wake_hex,
-       .binary         = trace_ctxwake_bin,
+       .binary         = trace_wake_bin,
 };

 /* TRACE_SPECIAL */

Confidentiality note:
The information in this email and any attachment may contain confidential and proprietary information of Heidelberger Druckmaschinen AG and/or its affiliates and may be privileged or otherwise protected from disclosure. If you are not the intended recipient, you are hereby notified that any review, reliance or distribution by others or forwarding without express permission is strictly prohibited and may cause liability. In case you have received this message due to an error in transmission, we kindly ask you to notify the sender immediately and to delete this email and any attachment from your system.
