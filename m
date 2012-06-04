Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2FDOZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:25:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20083 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2FDOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:25:17 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=BxU6LY-SEyQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=IjpaDU1HHLEYFVsL8M8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338819915.13348.508.camel@gandalf.stny.rr.com>
Subject: Re: Re: [RFC PATCH -tip  1/9] ftrace: Add pt_regs acceptable trace
 callback
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 04 Jun 2012 10:25:15 -0400
In-Reply-To: <4FCCBEE9.8030006@hitachi.com>
References: <20120529124833.9191.23007.stgit@localhost.localdomain>
	  <20120529124857.9191.5868.stgit@localhost.localdomain>
	 <1338602877.13348.474.camel@gandalf.stny.rr.com>
	 <4FCCBEE9.8030006@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 22:58 +0900, Masami Hiramatsu wrote:

> Hmm, how about initializing in __init function ?
> Or we can make func and regs_func in different members,
> instead of using a union. (in that case, we can remove
> FTRACE_OPS_FL_SAVE_REGS.)
> I just consider passing uninitialized argument to user
> function can cause unexpected behavior...

Easy solution:

As I want all functions to pass the ftrace_ops anyway, we can implement
the ftrace_ops and the regs passing together. The arch will need to
update both at the same time.

But for archs that do not support ftrace_ops (and thus also not regs),
we can do (and I will do this):

static inline void
 __global_list_func(unsigned long ip, unsigned long parent_ip,
			struct ftrace_ops *ops, struct pt_regs *regs)
{
	[do the loop, ignoring ops anyway, but passing in regs]
}

#ifndef ARCH_SUPPORTS_FTRACE_OPS
static void
noregs_global_list_func(unsigned long ip, unsigned long parent_ip)
{
	__global_list_func(ip, parent_ip, NULL, NULL);
}
#define global_list_func (ftrace_func_t)noregs_global_list_func
#else
static void global_list_func(unsigned long ip, unsigned long parent_ip,
			struct ftrace_ops *ops, struct pt_regs *regs)
{
	__global_list_func(ip, parent_ip, ops, regs);
}
#endif



Nothing will be passed uninitialized. If an arch does not support
passing ftrace ops and regs, then it will be calling the
noregs_global_list_func() (or whatever I name it), which only expects
the ip and parent_ip as parameters. Then that will be calling the actual
loop function with NULLs in the parameters.

When an arch supports passing of ftrace_ops, then it should also support
passing in the regs (as that should be the trivial part).

Note, all funcs will get regs, but it may not get the full regs. That
requires the ftrace_ops setting the special flag. The regs are saved for
the mcount already. But only a partial set. Those will be sent to all
function callbacks. If the function call back requires a full set (like
kprobes does), then it must set the flag before registering.

Hows this sound?

-- Steve



