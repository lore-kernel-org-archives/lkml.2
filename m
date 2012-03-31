Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2CaVhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:37:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7102 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2CaVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:37:42 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wMWVvwg0qUAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=M0bg4YLm8plviE2vedUA:9 a=dut7F_H8wIDa2kTazrcA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1333229859.23924.200.camel@gandalf.stny.rr.com>
Subject: Re: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 31 Mar 2012 17:37:39 -0400
In-Reply-To: <20120331204501.GA18572@redhat.com>
References: <20120330183104.GA12927@redhat.com>
	 <1333134131.23924.191.camel@gandalf.stny.rr.com>
	 <20120330201550.GA16628@redhat.com>
	 <1333152806.23924.196.camel@gandalf.stny.rr.com>
	 <20120331204501.GA18572@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 22:45 +0200, Oleg Nesterov wrote:
> On 03/30, Steven Rostedt wrote:
> >
> > On Fri, 2012-03-30 at 22:15 +0200, Oleg Nesterov wrote:
> >
> > > But I don't really understand why do you think that "clear" is more
> > > important.
> >
> > They are both important. But as I tend to consider performance when
> > tracing is off as critical, I'm more concerned about that. But both must
> > be fixed, because not reporting traces can confuse a developer.
> 
> Ah, got it, thanks.
> 
> I was going to send the simple patch we discussed, but suddenly I
> realized that I have another question.
> 
> Why do we want to filter out the kernel threads in syscall_regfunc?
> 
> >From cc3b13c1 "tracing: Don't trace kernel thread syscalls"
> 
> 	 then it has no effect to trace the kernel thread calls
> 	 to syscalls in that path.
> 	 Setting the TIF_SYSCALL_TRACEPOINT flag is then useless for these.
> 
> OK, but then it doesn't hurt? Or is there another reason why
> TIF_SYSCALL_TRACEPOINT is not desirable on kthread?

Right, it doesn't hurt. I was about to say that in a previous email.

> 
> The problem is ____call_usermodehelper() which execs the user-space
> task. This clears PF_KTHREAD (sets ->mm), but obviously if
> sys_tracepoint_refcount != 0 this is too late.
> 
> So what do you think we should do,
> 
> 	- keep this check
> 
> 	- remove it
> 
> 	- remove it in a separate patch

I say this one (remove it in a separate patch). That way if something
breaks we know exactly what did it ;-)

> 
> 	- add the "sync with sys_tracepoint_refcount" hook
> 	  before kernel_execve()
> 
> ?

-- Steve


