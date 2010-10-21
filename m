Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab0JUWe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:34:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0JUWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:34:26 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=A6yVOXcETFUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Fnu6_QAKJhjM5M7tjMoA:9 a=TUZGdpBZcEIC51OStYYA9x2XuboA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <201010220805.14454.rusty@rustcorp.com.au>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>
	 <201010220805.14454.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 18:34:23 -0400
Message-ID: <1287700463.16971.603.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 08:05 +1030, Rusty Russell wrote:
> On Fri, 22 Oct 2010 12:15:42 am Steven Rostedt wrote:
> > 
> > Ingo,
> > 
> > This is based off of my core-2 branch. I'm moved this patch after that
> > so if anyone has any objections, I can change this patch without holding
> > off the previous one.
> 
> I think disabling use in modules is lazy,

and safer.

It's not a big deal if a module does not use it. What we have is
"trace_printk()" and if the format passed to it is static, that turns
into trace_bprintk(). If the format is a variable, then you are stuck
with trace_printk() that just does the sprintf() operation in the trace.
Which this patch makes all modules do.

With trace_bprintk() the pointer to the format and arguments are put
into the ring buffer for later processing.


>  and allowing it for !MODVERSIONS
> is just weird.

that was me being weirdly paranoid ;-)

> 
> Can't you detect this on module unload and fix it up?  Or delay freeing the
> module until the trace ring is emptied?

One possibility is to magically make all string formats used in
trace_printk into its own section, and keep it allocated until the ring
buffer is empty. Or, we can just do that with the module's entire string
section, since we know whether or not that module has a trace_printk in
it or not.

-- Steve



