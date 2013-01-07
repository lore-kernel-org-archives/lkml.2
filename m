Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3AGNlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:41:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3AGNlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:41:36 -0500
X-Authority-Analysis: v=2.0 cv=IsacgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=HQJ7cb7SADkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MBbGe7VapwAA:10 a=KUD6jk83zoDi_8VGkEwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357566094.10284.83.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] arm: make return_address available for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, fweisbec@gmail.com,
        mingo@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sahara <keun-o.park@windriver.com>
Date: Mon, 07 Jan 2013 08:41:34 -0500
In-Reply-To: <CA+KhAHYbDU0Ajr5uPEjPxX2ECitvnK2ENOjmqjC=3G657GvG7w@mail.gmail.com>
References: <1357207949-3349-1-git-send-email-kpark3469@gmail.com>
	 <1357207949-3349-2-git-send-email-kpark3469@gmail.com>
	 <20130103103815.GL2631@n2100.arm.linux.org.uk>
	 <CA+KhAHbmjD7zTw+wcw84Abg3V1dD=0Ea4kUpYdGENQf1UOWphw@mail.gmail.com>
	 <1357220165.10284.30.camel@gandalf.local.home>
	 <20130103141301.GQ2631@n2100.arm.linux.org.uk>
	 <1357229038.10284.46.camel@gandalf.local.home>
	 <20130103162359.GR2631@n2100.arm.linux.org.uk>
	 <1357232337.10284.67.camel@gandalf.local.home>
	 <CA+KhAHYbDU0Ajr5uPEjPxX2ECitvnK2ENOjmqjC=3G657GvG7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 17:45 +0900, Keun-O Park wrote:

> With "CFLAGS_REMOVE_unwind.o = -pg" and with CONFIG_PROVE_LOCKING
> turned on, I confirmed that
> there's no trace output like Steve mentioned.
> However, if I turn off CONFIG_PROVE_LOCKING, "irqsoff" and
> "preemptirqsoff" ftracer prints these lines :
> 
> kernel_text_address <-unwind_frame
> core_kernel_text <-unwind_frame
> search_index <-unwind_frame
> 
> While I investigated the reason, I just found out there's two function
> with same name, trace_hardirqs_off.
> One in kernel/trace/trace_irqsoff.c and another in kernel/lockdep.c.
> And both symbols are exported.
> I am wondering whether it is intentionally maintained code to
> manipulate ftrace and lockdep or not.
> I guess it's probably not.

Both the irqsoff tracer from ftrace and lockdep came from the -rt patch.
The two were very integrated at the time. When they were ported over to
mainline, they still used the same infrastructure to hook into the
locations of interrupts being disabled or enabled.

trace_hardirqs_on/off() is the function that is called for both lockdep
and ftrace's irqsoff tracer. So this was intentional. That way we didn't
need to have two different callers at every location. But if lockdep
isn't defined and ftrace irqsoff is, then ftrace would define the
trace_hardirqs_on/off() routines, otherwise lockdep does. (These
routines are within CONFIG_PROVE_LOCKING #ifdefs in
kernel/trace/trace_irqsoff.c)

When both lockdep and irqsoff tracer are configured, then lockdep
defines the trace_hardirqs_off_caller(), and calls time_hardirqs_off()
in trace_irqsoff.c which does the same thing as the trace_hardirqs_off()
does without lockdep.

I'm not sure why one would add the annotations while adding
PROVE_LOCKING doesn't. They both seems to use CALLER_ADDR0, but maybe
there's another path that uses CALLER_ADDR1 without it.

-- Steve


