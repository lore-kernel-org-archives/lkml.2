Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2FMLMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:12:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2FMLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:12:11 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bavL_TnxFR0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=-2auahfU0qTyA1z8OBEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339585929.13377.152.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 00/13 v2] kprobes/ftrace: Making ftrace usable for
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 13 Jun 2012 07:12:09 -0400
In-Reply-To: <4FD84E84.1090001@hitachi.com>
References: <20120612224327.426900129@goodmis.org>
	 <4FD84E84.1090001@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 17:25 +0900, Masami Hiramatsu wrote:
> (2012/06/13 7:43), Steven Rostedt wrote:
> > If an arch supports passing of ftrace ops, it must also pass regs.
> > But it does not need to support passing regs. By default
> > an arch can just pass NULL. If it supports  regs, then
> > it can allow tools like kprobes to ask for regs. Otherwise the
> > regs parameter should just be NULL.
> 
> Hmm, by default, will the ftrace_ops be also NULL? or NULL only if
> the arch doesn't support passing ftrace ops?
> I mean, should the generic handler always check if ftrace_ops
> isn't NULL before using it?

Nope, ftrace_ops will always be set with the ops that registered it for
the callback. As suppose to regs, ftrace_ops is created by the generic
core code and is arch agnostic. With regs, that's very arch specific and
if an arch does not support passing regs, there's nothing that the core
code can do about it but pass a NULL pointer telling the callback
"Sorry!".

Currently there's a few things that an arch needs to do in the mcount
handler to support full dynamic ftrace. One is to check the
function_trace_stop variable is not set before calling the callback. If
an arch does not support this, then ftrace will only let the callback be
a generic function that does the check on behalf of the arch and then
calls the normal routine.

Now the arch also needs to support sending in the 3rd parameter the
ftrace_ops. If it does not support this ftrace generic code will.
Luckily, it already has code to do this. If more than one ftrace_ops is
registered (even if they register to different functions), a generic
handler is called that iterates through all the registered ftrace_ops to
call their callbacks. It also checks if the ftrace_ops has registered
the current function before calling it.

Now if an arch does not pass the ftrace ops we simply call this list
function instead. The list function already has access to what
ftrace_ops is being used and passes that to the callback. Again, this is
what must be done anyway if more than one ftrace_ops is registered to
the function tracer.

As this is another indirect call that must be made, I removed the old
helper function that does the check against function_trace_stop variable
and made the arch call the list code instead. The list code now does the
check. If the arch does not support checking function_trace_stop, it
most likely doesn't support passing ftrace_ops either.

-- Steve


