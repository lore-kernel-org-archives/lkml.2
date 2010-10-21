Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab0JUOBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:01:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587Ab0JUOBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:01:19 -0400
Date: Thu, 21 Oct 2010 10:00:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101021140031.GC2920@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <20101020164324.GC7348@redhat.com> <4CBFAC70.30602@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBFAC70.30602@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:58:56AM +0900, Masami Hiramatsu wrote:
> (2010/10/21 1:43), Jason Baron wrote:
> > On Wed, Oct 20, 2010 at 05:40:45PM +0200, Ingo Molnar wrote:
> >> FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
> >> seems to be tracing related. See the crashlog below - config attached.
> >>
> >> It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
> >> race of some sorts)
> >>
> >> Thanks,
> >>
> >> 	Ingo
> >>
> > 
> > strange b/c it looks like we get though enabling/disabling the
> > tracepoitns individually, but then when we go to enable all the
> > tracepoints we hit this hang - perhaps, suggesting a race. Do we always
> > fail after "Testing all events:" is printed? Does the crash have any
> > more clues. I will try and re-produce this.
> > 
> > Also, I noticed some recent changes to text_poke_smp() usage of
> > stop_machine() on Oct. 14th. That's related to the area where this appears
> > to hang, so if things were working with this .config before then, that
> > might be a place to look. Adding Masami to the 'cc list.
> 
> Recent changes of text_poke_smp() just removed unnecessary
> get/put_online_cpu(), so I think it's not related this bug.
> 
> It seems there can be a bug in stop_machine() routine under
> heavy use. usually that is called just once at a time, but jump
> label and optprobe might call it heavily (thousands times?).
> So some racy situation can be happen easily.
> 

for most tracepoints there is 1 text location that needs to be
updated...however, I know that for kmalloc, you can end up with
hundredds or even thousands. So yes, we can end up calling
stop_machine() thousands of times.

There is a patch to reduce kmalloc tracepoint text locations by moving
them out of line: http://lkml.org/lkml/2010/10/13/208

Also, text_poke_smp_batch() would allow us to update all these text
locations at once.

Nonetheless, there appears to be a underlying race condition...

thanks,

-Jason
