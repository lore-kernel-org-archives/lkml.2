Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2IFPOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:14:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2IFPOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:14:44 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pZdUz1oXxZcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7I6Cu-NdG9YA:10 a=AtSvTgsVFxPcB1ZiKxwA:9 a=PUjeQqilurYA:10 a=jFytWRkihul7h_di:21 a=1jMOe_UeGon6uLmH:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346944482.1680.28.camel@gandalf.local.home>
Subject: Re: [PATCH] x86, 32-bit: Fix invalid stack address while in softirq
From: Steven Rostedt <rostedt@goodmis.org>
To: Robert Richter <robert.richter@amd.com>
Cc: wyang1 <Wei.Yang@windriver.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net
Date: Thu, 06 Sep 2012 11:14:42 -0400
In-Reply-To: <20120906150246.GZ8285@erda.amd.com>
References: <1346031133-12756-1-git-send-email-Wei.Yang@windriver.com>
	 <20120904102439.GS8285@erda.amd.com> <5047FCBD.9000205@windriver.com>
	 <20120906100434.GX8285@erda.amd.com>
	 <1346937282.1680.15.camel@gandalf.local.home>
	 <20120906150246.GZ8285@erda.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 17:02 +0200, Robert Richter wrote:

> > > --- a/arch/x86/oprofile/backtrace.c
> > > +++ b/arch/x86/oprofile/backtrace.c
> > > @@ -113,7 +113,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
> > >  
> > >  	if (!user_mode_vm(regs)) {
> > >  		unsigned long stack = kernel_stack_pointer(regs);
> > > -		if (depth)
> > > +		if (depth & stack)
> > 
> > Can other users of kernel_stack_pointer() be nailed by a return of NULL?
> 
> It would be save here too, but dump_trace() falls back to the current
> stack in case there is no stack address given which we don't want with
> oprofile.
> 
> I was looking at all users of kernel_stack_pointer() and could not
> find any direct pointer dereference of the sp. The only potential
> problems I found could arise here:
> 
>  arch/x86/kernel/kprobes.c:resume_execution()
>  arch/x86/kernel/time.c:profile_pc()
> 
> It is not quite clear if we really need code here that checks the
> pointer. Since a NULL pointer access has the same effect as if the
> stack address would be wrong which would be the case without the
> patch, I rather tend not to change the code here.

Then a comment should be in the oprofile code too. Something to the
effect that oprofile is special and can cause kernel_stack_pointer() to
return NULL in some cases, thus we need to check for it.

-- Steve


