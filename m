Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2FODRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:17:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9524 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2FODRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:17:37 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=BPWRnCgUoscA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=t2tB0Df2KYFp4hYxdrUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339730255.13377.307.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 03/13 v2] ftrace: Return pt_regs to function trace
 callback
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 14 Jun 2012 23:17:35 -0400
In-Reply-To: <4FDAA5E2.1040608@hitachi.com>
References: <20120612224327.426900129@goodmis.org>
	 <20120612225424.709165437@goodmis.org> <4FDAA5E2.1040608@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 12:02 +0900, Masami Hiramatsu wrote:
> (2012/06/13 7:43), Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Return as the 4th paramater to the function tracer callback the pt_regs.
> > 
> > Currently x86_64 just passes NULL as the regs arguement. Later patches
> > that implement regs passing will require having the ftrace_ops set the
> > SAVE_REGS flag, which will tell the arch to take the time to pass a
> > full set of pt_regs to the ftrace_ops callback function. If the arch
> > does not support it then it should pass NULL.
> 
> Hmm, I think the x86-64 part of this patch would be better to be separated
> with x86-64 part of [5/13], so that I can easily review the change...
> Another reason is that this patch doesn't define ARCH_SUPPORTS_FTRACE_SAVE_REGS
> on x86_64 too...

I agree. This was more left over from the 'PARTIAL_REGS' saving, which I
scrapped. I'll just fold the x86 bits of this patch into patch 5 as you
suggested, and then just keep this patch as the 'added API' change.


> 
> 
> > A ftrace_ops call back can either check if the macro ARCH_SUPPORTS_FTRACE_SAVE_REGS
> > is defined, or it can check if regs is NULL. As it will be NULL if
> > it is not supported by the arch even if the SAVE_REGS flag is set.
> > 
> > If an arch can pass full regs, then it should define:
> >  ARCH_SUPPORTS_FTRACE_SAVE_REGS to 1
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> [...]
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 2b4f94c..83d8ae0 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -80,7 +80,11 @@ ENTRY(ftrace_caller)
> >  	MCOUNT_SAVE_FRAME
> >  
> >  	leaq function_trace_op, %rdx
> > -	movq 0x38(%rsp), %rdi
> > +
> > +	/* regs go into 4th parameter (but make it NULL) */
> > +	movq $0, %rcx
> 
> There is no ARCH_SUPPORTS_FTRACE_SAVE_REGS, so I think you
> don't need to clear rcx at least this time.

Agreed, I'll fold this in then.

> 
> Another generic ftrace part of this patch is good to me :)
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks for the review, but I'll modify 3 and 5 and hopefully, you can
review it again. I'll do this tomorrow as it's bed time for me now ;-)

-- Steve


