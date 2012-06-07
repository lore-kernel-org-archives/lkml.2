Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab2FGC0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2FGC0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:26:46 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=9um5mg54tOgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=X-l27-cIecZVniD6ERYA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339036003.13348.560.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][3.5] tracing: Have tracing_off() actually turn
 tracing off (and not on!)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 06 Jun 2012 22:26:43 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This was one of those "oh crap" moments. I was adding a feature request
by Arnaldo, and found that tracing_off() wasn't working. This is
something I know Thomas and Peter use often and I'm lucky that I found
it before I had to go dig another dead frozen shark out of my rafters.

It was a silly cut and paste bug from a previous change (that happened
to make it into 3.4).


Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: f2bf1f6f5f89d031245067512449fc889b2f4bb2


Steven Rostedt (1):
      tracing: Have tracing_off() actually turn tracing off

----
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit f2bf1f6f5f89d031245067512449fc889b2f4bb2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Jun 6 19:50:40 2012 -0400

    tracing: Have tracing_off() actually turn tracing off
    
    A recent update to have tracing_on/off() only affect the ftrace ring
    buffers instead of all ring buffers had a cut and paste error.
    The tracing_off() did the exact same thing as tracing_on() and
    would not actually turn off tracing. Unfortunately, tracing_off()
    is more important to be working than tracing_on() as this is a key
    development tool, as it lets the developer turn off tracing as soon
    as a problem is discovered. It is also used by panic and oops code.
    
    This bug also breaks the 'echo func:traceoff > set_ftrace_filter'
    
    Cc: <stable@vger.kernel.org> # 3.4
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 68032c6..49249c2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(tracing_on);
 void tracing_off(void)
 {
 	if (global_trace.buffer)
-		ring_buffer_record_on(global_trace.buffer);
+		ring_buffer_record_off(global_trace.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race


