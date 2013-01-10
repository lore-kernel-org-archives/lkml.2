Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3AJQnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:43:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27738 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3AJQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:43:50 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=hgKcp-RnQ0YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rC-twdHML7MA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=ePcNwm83Ps8d97yFlQ4A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357836229.5141.13.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] tracing: Fix regression of trace_options file
 setting
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 10 Jan 2013 11:43:49 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

I just hit this bug with the lastest kernel. A change that came in this
merge window broke the writing to the trace_options file. It causes
garbage to be read during the compare of option names, and breaks
setting options via the trace_options file, although options can still
be set via the options/<option> files.

Also, I'm not sure where Ingo is, but I have an old pull request with
minor fixes. Feel free to pull that if you want too:

https://lkml.org/lkml/2013/1/7/208

Please pull trace-3.8-rc2-regression-fix:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.8-rc2-regression-fix

Head SHA1: f1a67efdbc2c0acb43b2f844053320c38876776f


Steven Rostedt (1):
      tracing: Fix regression of trace_options file setting

----
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)
---------------------------
commit a8dd2176a8e988e3744e863ac39647a6f59fa900
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Jan 9 20:54:17 2013 -0500

    tracing: Fix regression of trace_options file setting
    
    The latest change to allow trace options to be set on the command
    line also broke the trace_options file.
    
    The zeroing of the last byte of the option name that is echoed into
    the trace_option file was removed with the consolidation of some
    of the code. The compare between the option and what was written to
    the trace_options file fails because the string holding the data
    written doesn't terminate with a null character.
    
    A zero needs to be added to the end of the string copied from
    user space.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e512567..1bbfa04 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2899,6 +2899,8 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 	if (copy_from_user(&buf, ubuf, cnt))
 		return -EFAULT;
 
+	buf[cnt] = 0;
+
 	trace_set_options(buf);
 
 	*ppos += cnt;


