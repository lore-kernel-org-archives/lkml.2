Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0IHPxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:53:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0IHPxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:53:18 -0400
X-Authority-Analysis: v=1.1 cv=kSl6L8luU05z5mpL051isgeeLpAUfowbwuc/WIqEapw= c=1 sm=0 a=tW1S4gNLOmcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=xn_2uDM6AAAA:8 a=20KFwNOVAAAA:8 a=Y7L1pJxHcKivCR6NPH0A:9 a=uBE7FbITspREU3UY1SIFs4q6DkMA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=AlnqcuNMsHEA:10 a=jEp0ucaQiEUA:10 a=oUQuMaGMe1cA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.36 & stable] tracing: Do not allow llseek
 to set_ftrace_filter
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swiecki <swiecki@google.com>,
        Chris Wright <chrisw@sous-sol.org>, Tavis Ormandy <taviso@google.com>,
        Eugene Teo <eugene@redhat.com>, vendor-sec <vendor-sec@lst.de>,
        stable@kernel.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Sep 2010 11:53:15 -0400
Message-ID: <1283961195.5133.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


root (1):
      tracing: Do not allow llseek to set_ftrace_filter

----
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit 47933d55f8d3652a0319ab1e0c6854fa326f78fa
Author: root <root@ixf.(none)>
Date:   Wed Sep 8 11:20:37 2010 -0400

    tracing: Do not allow llseek to set_ftrace_filter
    
    Reading the file set_ftrace_filter does three things.
    
    1) shows whether or not filters are set for the function tracer
    2) shows what functions are set for the function tracer
    3) shows what triggers are set on any functions
    
    3 is independent from 1 and 2.
    
    The way this file currently works is that it is a state machine,
    and as you read it, it may change state. But this assumption breaks
    when you use lseek() on the file. The state machine gets out of sync
    and the t_show() may use the wrong pointer and cause a kernel oops.
    
    Luckily, this will only kill the app that does the lseek, but the app
    dies while holding a mutex. This prevents anyone else from using the
    set_ftrace_filter file (or any other function tracing file for that matter).
    
    A real fix for this is to rewrite the code, but that is too much for
    a -rc release or stable. This patch simply disables llseek on the
    set_ftrace_filter() file for now, and we can do the proper fix for the
    next major release.
    
    Reported-by: Robert Swiecki <swiecki@google.com>
    Cc: Chris Wright <chrisw@sous-sol.org>
    Cc: Tavis Ormandy <taviso@google.com>
    Cc: Eugene Teo <eugene@redhat.com>
    Cc: vendor-sec@lst.de
    Cc: <stable@kernel.org>
    Signed-off-by: root <root@ixf.(none)>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7cb1f45..83a16e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2416,7 +2416,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = no_llseek,
 	.release = ftrace_filter_release,
 };
 


