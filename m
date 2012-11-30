Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2K3QQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:16:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2K3QQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:16:44 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=AsENIjYenYMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uCJ6TkGyzrcA:10 a=VwQbUJbxAAAA:8 a=qvmrgIgGuK3iWGooozEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354292203.6276.159.camel@gandalf.local.home>
Subject: [v3.0 stable version][PATCH 1/2] ring-buffer: Fix NULL pointer if
 rb_set_head_page() fails
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 30 Nov 2012 11:16:43 -0500
In-Reply-To: <20121130161333.983378567@goodmis.org>
References: <20121130161238.909829067@goodmis.org>
	 <20121130161333.983378567@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function rb_set_head_page() searches the list of ring buffer
pages for a the page that has the HEAD page flag set. If it does
not find it, it will do a WARN_ON(), disable the ring buffer and
return NULL, as this should never happen.

But if this bug happens to happen, not all callers of this function
can handle a NULL pointer being returned from it. That needs to be
fixed.

Cc: stable@vger.kernel.org # 3.0+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

Index: linux-test.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-test.git.orig/kernel/trace/ring_buffer.c
+++ linux-test.git/kernel/trace/ring_buffer.c
@@ -2926,6 +2926,8 @@ rb_get_reader_page(struct ring_buffer_pe
 	 * Splice the empty reader page into the list around the head.
 	 */
 	reader = rb_set_head_page(cpu_buffer);
+	if (!reader)
+		goto out;
 	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
 	cpu_buffer->reader_page->list.prev = reader->list.prev;
 


