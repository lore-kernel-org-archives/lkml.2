Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0EOBXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:23:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab0EOBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:23:38 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=OGvK5F8kI4IA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=9u5h_HU0C_pwQ3ea-QoA:9 a=Y6Nk1nUgXcMysZxOTeIA:7 a=hsTJvAPA456dn-v5F0FyC31pG5IA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Comment the use of event_mutex with
 trace event flags
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 14 May 2010 21:23:37 -0400
Message-ID: <1273886617.27703.3189.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is the same as the pull request for core-4, but I removed the ring
buffer patch and fixed the typo in the last patch that Mathieu found.

Please pull the latest tip/tracing/core-5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core-5


Steven Rostedt (1):
      tracing: Comment the use of event_mutex with trace event flags

----
 include/linux/ftrace_event.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)
---------------------------
commit 1eaa4787a774c4896518c81f24e8bccaa2244924
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri May 14 10:19:13 2010 -0400

    tracing: Comment the use of event_mutex with trace event flags
    
    The flags variable is protected by the event_mutex when modifying,
    but the event_mutex is not held when reading the variable.
    
    This is due to the fact that the reads occur in critical sections where
    taking a mutex (or even a spinlock) is not wanted.
    
    But the two flags that exist (enable and filter_active) have the code
    written as such to handle the reads to not need a lock.
    
    The enable flag is used just to know if the event is enabled or not
    and its use is always under the event_mutex. Whether or not the event
    is actually enabled is really determined by the tracepoint being
    registered. The flag is just a way to let the code know if the tracepoint
    is registered.
    
    The filter_active is different. It is read without the lock. If it
    is set, then the event probes jump to the filter code. There can be a
    slight mismatch between filters available and filter_active. If the flag is
    set but no filters are available, the code safely jumps to a filter nop.
    If the flag is not set and the filters are available, then the filters
    are skipped. This is acceptable since filters are usually set before
    tracing or they are set by humans, which would not notice the slight
    delay that this causes.
    
    v2: Fixed typo: "cacheing" -> "caching"
    
    Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Tom Zanussi <tzanussi@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5ac97a4..dc7fc64 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -169,7 +169,14 @@ struct ftrace_event_call {
 	 *   bit 1:		enabled
 	 *   bit 2:		filter_active
 	 *
-	 *  Must hold event_mutex to change.
+	 * Changes to flags must hold the event_mutex.
+	 *
+	 * Note: Reads of flags do not hold the event_mutex since
+	 * they occur in critical sections. But the way flags
+	 * is currently used, these changes do no affect the code
+	 * except that when a change is made, it may have a slight
+	 * delay in propagating the changes to other CPUs due to
+	 * caching and such.
 	 */
 	unsigned int		flags;
 


