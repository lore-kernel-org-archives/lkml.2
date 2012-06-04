Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2FDPLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:11:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4140 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2FDPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:11:31 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nKPuxUj2xSQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=lqML7umiU0S75Lk8GeQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338822687.13348.516.camel@gandalf.stny.rr.com>
Subject: Re: Re: Re: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable
 trace callback
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 04 Jun 2012 11:11:27 -0400
In-Reply-To: <4FCCCCE6.5000606@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	   <20120529124857.9191.5868.stgit@localhost.localdomain>
	  <1338602877.13348.474.camel@gandalf.stny.rr.com>
	  <4FCCBEE9.8030006@hitachi.com>
	 <1338819915.13348.508.camel@gandalf.stny.rr.com>
	 <4FCCCCE6.5000606@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 23:57 +0900, Masami Hiramatsu wrote:

> > As I want all functions to pass the ftrace_ops anyway, we can implement
> > the ftrace_ops and the regs passing together. The arch will need to
> > update both at the same time.
> 
> Hmm, is that ftrace_ops for recursion check? :)

Nope, it's to pass data to the callbacks.


> > Nothing will be passed uninitialized. If an arch does not support
> > passing ftrace ops and regs, then it will be calling the
> > noregs_global_list_func() (or whatever I name it), which only expects
> > the ip and parent_ip as parameters. Then that will be calling the actual
> > loop function with NULLs in the parameters.
> 
> Yeah, that's safe, but I think dyn_ftrace can't call handler
> directly from ftrace_call on such archs, can it?
> # It depends on performance degradation.
> 

Actually, there's already a performance degradation on most archs. They
must also implement a fast "shut off function tracing", and if it
doesn't, it calls a helper function. I'll merge the helper function into
this call so we don't have two indirections.


> > When an arch supports passing of ftrace_ops, then it should also support
> > passing in the regs (as that should be the trivial part).
> 
> Preparing pt_regs by software is hard on some archs, e.g. IA64.
> But yeah, that's an obsolete arch. We'd better focus on x86 and
> ARM variants.

It shouldn't be hard to pass a forth arg. Then if it's too hard to pass
regs, it can still pass NULL. We can just make all callbacks check for
NULL. I can add an config option that tests to make sure this is the
case. If the regs flag isn't set, I can call the call back with NULL in
the regs, and make it crash. Obviously this config will be a a debug
config and not something normal users should set. :-)

> 
> > Note, all funcs will get regs, but it may not get the full regs. That
> > requires the ftrace_ops setting the special flag. The regs are saved for
> > the mcount already. But only a partial set. Those will be sent to all
> > function callbacks. If the function call back requires a full set (like
> > kprobes does), then it must set the flag before registering.
> 
> Just out of curiously, would you mean that you will allocate full
> pt_regs frame on stack always?

Yes. The allocation is done, but the actual storage is not. This could
cause cache issues, but nothing too bad. If you are worried about stack
overflow, then the code itself is using too much stack and should be
reported. Of course, that's what the stack tracer is for ;-)

> 
> > 
> > Hows this sound?
> 
> Sounds better to me, at far as there are non-initialized parameters
> passed to user handler. :)
> 
> BTW, would you like to update ftrace part? I'd like to fix to remove
> notrace from my previous patchset and resend tomorrow.

I'll work today on getting out a new git tree that has my latest
updates.

Thanks!

-- Steve


