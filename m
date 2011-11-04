Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1KDNod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:44:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1KDNoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:44:32 -0400
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=d1TCUqu53CkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=56LjntBiG02QEpgdNhoA:9 a=RxrUlhDnI-AKOlWVrFsA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320414269.19219.12.camel@gandalf.stny.rr.com>
Subject: Re: function_graph selftest fails with !DYNAMIC
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 04 Nov 2011 09:44:29 -0400
In-Reply-To: <20111102150255.GA6973@debian>
References: <20111102150255.GA6973@debian>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 20:32 +0530, Rabin Vincent wrote:
> The function_graph selftest fails when CONFIG_DYNAMIC_FTRACE is not set
> (tested on x86-64) on current kernels:
> 
> [    0.300124] Testing tracer function: PASSED
> [    0.446092] Testing tracer function_graph: .. no entries found ..FAILED!
> 
> Bisecting goes back to this commit:
> 
> 2b499381bc50ede01b3d8eab164ca2fad00655f0 is the first bad commit

Your bisect is wrong. I ran it though ktest.pl and it gave me this
bisect commit:

commit 6331c28c962561aee59e5a493b7556a4bb585957
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Jul 13 15:11:02 2011 -0400

    ftrace: Fix dynamic selftest failure on some archs


I used the following test config options:

TEST_START IF ${RUN_TYPE} == bisect
TEST_TYPE = bisect
BISECT_GOOD = 2b499381bc50ede01b3d8eab164ca2fad00655f0
BISECT_BAD = b4beb4bf9934d151bf4581a54ae028927374cb2a
BISECT_TYPE = test
TEST = ssh root@bxf /work/bin/test-fgraph
BISECT_CHECK = good
MIN_CONFIG = ${THIS_DIR}/config-bisect
BUILD_NOCLEAN = 1


Where test-fgraph was a simple script:

if dmesg | grep function_graph | grep PASSED; then
	exit 0
else
	exit 1
fi


Looking at this commit I found the bug, and yes I'm quite embarrassed by
it. It happened because I left in a change to test the
!CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST case.


+#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST


The fact that function graph tracing failed when this was unset was not
a bug in the logic in this case, but because the mcount code in the x86
asm assumes that this is set and will do different things because of the
way the code changes.

The simple fix is:

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -151,7 +151,6 @@ void clear_ftrace_function(void)
        ftrace_pid_function = ftrace_stub;
 }
 
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their


I'll write a formal patch and send it up.

Thanks for reporting!

-- Steve



