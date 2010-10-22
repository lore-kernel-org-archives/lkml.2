Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0JVEfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:35:04 -0400
Received: from ozlabs.org ([203.10.76.45]:35853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0JVEfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:35:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from using trace_bprintk()
Date: Fri, 22 Oct 2010 15:04:51 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com> <201010221413.28588.rusty@rustcorp.com.au> <1287719918.16971.615.camel@gandalf.stny.rr.com>
In-Reply-To: <1287719918.16971.615.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221504.51535.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 02:28:38 pm Steven Rostedt wrote:
> On Fri, 2010-10-22 at 14:13 +1030, Rusty Russell wrote:
> 
> > > > 
> > > > I think disabling use in modules is lazy,
> > > 
> > > and safer.
> > 
> > Well then just delete trace_bprintk altogether.  Even safer!
> 
> Reminds me of the argument against lowering the speed limit to 55. "it's
> safer"... "Then lower it to zero, even safer!"
> 
> 
> > 
> > > > Can't you detect this on module unload and fix it up?  Or delay freeing the
> > > > module until the trace ring is emptied?
> > > 
> > > One possibility is to magically make all string formats used in
> > > trace_printk into its own section, and keep it allocated until the ring
> > > buffer is empty. Or, we can just do that with the module's entire string
> > > section, since we know whether or not that module has a trace_printk in
> > > it or not.
> > 
> > Exactly.  Set a flag in the module if it resolves trace_printk, and defer freeing
> > the module in that case.  This shouldn't be that hard...
> 
> Here's my worry.
> 
> 1) Some module with tracepoints is loaded at boot up.
> 2) The user does tracing and forgets about it (ring buffer filled)
> 3) Unloads module (don't free)
> 4) loads module with trace points
> 5) unloads module (don't free)
> etc, etc
> 
> memory leak.

Sure.  Then mark the rb count or something in the module at init time,
then compare before deciding too dangerous to free.

> Thus this is not that trivial. We probably need to have a way to lock a
> module when its tracepoint is activated, and only unlock it when the
> ring buffer is emptied.

How about the intuitive and completely obvious thing?  When a tp activated,
use the module.  When deactivated, unuse it?

> Do we want to prevent the module from being unloaded while the ring
> buffer is full (after that module has been traced?), or do we let the
> module be unloaded, but just prevent this one section from being freed?

I was thinking the latter, basically defer the module_free() call.

Cheers,
Rusty.
