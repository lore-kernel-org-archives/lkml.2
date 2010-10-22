Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0JVD6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:58:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58026 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0JVD6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:58:42 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=A6yVOXcETFUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QPNwdh67xy5aMDjlxJIA:9 a=2xgu3lP9YHmzrGFJlG1RX2o1WVsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <201010221413.28588.rusty@rustcorp.com.au>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>
	 <201010220805.14454.rusty@rustcorp.com.au>
	 <1287700463.16971.603.camel@gandalf.stny.rr.com>
	 <201010221413.28588.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 23:58:38 -0400
Message-ID: <1287719918.16971.615.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 14:13 +1030, Rusty Russell wrote:

> > > 
> > > I think disabling use in modules is lazy,
> > 
> > and safer.
> 
> Well then just delete trace_bprintk altogether.  Even safer!

Reminds me of the argument against lowering the speed limit to 55. "it's
safer"... "Then lower it to zero, even safer!"


> 
> > > Can't you detect this on module unload and fix it up?  Or delay freeing the
> > > module until the trace ring is emptied?
> > 
> > One possibility is to magically make all string formats used in
> > trace_printk into its own section, and keep it allocated until the ring
> > buffer is empty. Or, we can just do that with the module's entire string
> > section, since we know whether or not that module has a trace_printk in
> > it or not.
> 
> Exactly.  Set a flag in the module if it resolves trace_printk, and defer freeing
> the module in that case.  This shouldn't be that hard...

Here's my worry.

1) Some module with tracepoints is loaded at boot up.
2) The user does tracing and forgets about it (ring buffer filled)
3) Unloads module (don't free)
4) loads module with trace points
5) unloads module (don't free)
etc, etc

memory leak.

Thus this is not that trivial. We probably need to have a way to lock a
module when its tracepoint is activated, and only unlock it when the
ring buffer is emptied.

Do we want to prevent the module from being unloaded while the ring
buffer is full (after that module has been traced?), or do we let the
module be unloaded, but just prevent this one section from being freed?

-- Steve


