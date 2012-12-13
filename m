Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab2LMRIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:08:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28767 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2LMRIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:08:07 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_aGYK8jRc_AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SI-C17Dh1R0A:10 a=EimCnZnUSnrWQxtqR14A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355418485.17101.377.camel@gandalf.local.home>
Subject: Re: [BUG] ftrace: available_filter_functions empty after unloading
 module
From: Steven Rostedt <rostedt@goodmis.org>
To: Piotr Haber <phaber@broadcom.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 13 Dec 2012 12:08:05 -0500
In-Reply-To: <1355405698.17101.373.camel@gandalf.local.home>
References: <50C0B236.4090200@broadcom.com>
	 <1354817428.17101.10.camel@gandalf.local.home>
	 <50C1A3A3.8030107@broadcom.com>
	 <1354888679.17101.36.camel@gandalf.local.home>
	 <50C5CB74.10008@broadcom.com>
	 <1355405698.17101.373.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 08:34 -0500, Steven Rostedt wrote:
> On Mon, 2012-12-10 at 12:45 +0100, Piotr Haber wrote:
> 
> > > So you unloaded a module that you were tracing, correct? Hmm, the
> > > warning that you hit was an accounting error. The accounting of what
> > > functions are traced and what isn't. For some reason it tried to disable
> > > a function that wasn't being traced.
> > Yes, it happens when i unload a module that i traced before
> > 
> > > Can you easily reproduce this? If so, can you give my your .config and
> > > the steps you used to trigger it.
> > Not 100% but it happens often enough to be annoying
> > Attached is the config
> > As for reproduction, i load the brcmsmac module, add all it symbols to
> > set_ftrace_filter, associate with AP and unload the module
> > nothing fancy, i use 'function' tracer
> 
> Thanks, I'll see if I can reproduce it.
> 

I'm having trouble reproducing. Can you apply the below patch and try to
reproduce it. And then show me the contents
of /debug/tracing/enabled_functions.

Thanks,

-- Steve

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4451aa3..e069227 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2390,9 +2390,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	struct ftrace_ops *ops = iter->ops;
 	struct dyn_ftrace *rec = NULL;
 
-	if (unlikely(ftrace_disabled))
-		return NULL;
-
 	if (iter->flags & FTRACE_ITER_HASH)
 		return t_hash_next(m, pos);
 
@@ -2449,9 +2446,6 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 
 	mutex_lock(&ftrace_lock);
 
-	if (unlikely(ftrace_disabled))
-		return NULL;
-
 	/*
 	 * If an lseek was done, then reset and start from beginning.
 	 */
@@ -2557,9 +2551,6 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
 {
 	struct ftrace_iterator *iter;
 
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
 	iter = __seq_open_private(file, &show_ftrace_seq_ops, sizeof(*iter));
 	if (iter) {
 		iter->pg = ftrace_pages_start;


