Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab0CSBhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:37:02 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58095 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752587Ab0CSBhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:37:00 -0400
Date: Thu, 18 Mar 2010 21:36:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
	lock
Message-ID: <20100319013658.GB28456@Krystal>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere> <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp> <20100318211633.GG5103@nowhere> <20100319010857.GC23020@Krystal> <20100319012337.GA22095@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319012337.GA22095@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:30:30 up 55 days,  4:07,  4 users,  load average: 0.26, 0.26,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Thu, Mar 18, 2010 at 09:08:57PM -0400, Mathieu Desnoyers wrote:
> > > I sometimes wonder which trick between jmp optimization and hot patching
> > > would be the best to optimize the tracepoints off-cases.
> > > 
> > > I should look more closely at the jmp optimization. I don't know if
> > > it avoids to push the tracepoints parameters in the off case, in
> > > which case it could be perhaps more efficient than hot patching,
> > 
> > yep, tracepoints with jump patching will branch over the whole stack setup in
> > the off case, which is one of the good reasons for using this solution over
> > patching only a call (leaving the stack setup in place).
> 
> 
> 
> Ok that's good to know. It's a pretty good argument against hot
> patching in this particular case.
> 
> 
>  
> > Note that if the parameters include side-effects (such as a function call),
> > these will be executed even when the tracepoint is disabled. This is why people
> > should implement these calls with side-effects in the appropriate TRACE_EVENT
> > fields.
> 
> 
> Good to know too.
> But this makes me curious. So it guarantees stack setup won't happen but
> can't sort it out with functions as parameters or so?
> 
> I have no idea how this thing works. Please Cc me for the next batch,
> this looks like a cool thing :)
> 

Well, the now deceased "Linux Kernel Markers" (which were based on a single
macro rather than static inline functions) were able to use the preprocessor to
put function calls passed as argument within the conditional branch. But with
tracepoints, we rely on static inlines to have flexible parameter declaration,
so this is not possible.

All the arguments passed to the static inline (eventually used for the stack
setup of the actual function call within the tracepoint) can be moved into the
conditional branch by the compiler optimizations, because they are not needed
otherwise. However, this cannot be done for function calls passed as parameter
to the tracepoint, because the compiler do not know whether or not the function
side-effects are needed outside of the "tracing active" branch.

Mathieu

> 
> 
> > > although perhaps most of the time the given arguments are already in
> > > registers because the traced function uses them for its own needs.
> > > 
> > > Also, adopting hot patching means the tracepoint calls would be
> > > in a non-inlined separated function. The result would be probably
> > > less i-cache footprint from the caller, and better for the off-case,
> > > worse for the on-case. But tracing off-case is most important.
> > > 
> > > (Adding more people in Cc)
> > > 
> > 
> > The idea has been discussed to add support in gcc to emit the code for an
> > unlikely branch into a separate section, which does have the smaller cache-line
> > footprint benefit your are talking about, but without the overhead of the extra
> > out-of-line function call in the enabled case. I don't know how this work is
> > advanced though. We had determined that the "asm goto" was an higher priority
> > item.
> 
> 
> Ok.
> 
> Thanks!
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
