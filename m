Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966499Ab2ERSxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:53:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42023 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2ERSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:53:16 -0400
Date: Fri, 18 May 2012 20:52:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120518185258.GE20215@aftab.osrc.amd.com>
References: <20120517214859.GA16777@aftab.osrc.amd.com>
 <20120518071244.GE429@gmail.com>
 <20120518095638.GA20215@aftab.osrc.amd.com>
 <4FB62BAB.90808@redhat.com>
 <20120518124338.GJ20215@aftab.osrc.amd.com>
 <4FB64D5B.1030301@redhat.com>
 <20120518140521.GM20215@aftab.osrc.amd.com>
 <4FB65D52.9060108@redhat.com>
 <20120518164014.GX20215@aftab.osrc.amd.com>
 <4FB6866E.7090503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB6866E.7090503@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 02:27:10PM -0300, Mauro Carvalho Chehab wrote:
> Em 18-05-2012 13:40, Borislav Petkov escreveu:
> > On Fri, May 18, 2012 at 11:31:46AM -0300, Mauro Carvalho Chehab wrote:
> >> Ok, but you won't use trace_sched_switch() as a memory tracepoint, as
> >> they represent different things.
> >>
> >> Memory errors are different than CPU errors. So, their tracepoints
> >> will be different.
> > 
> > WTF? A tracepoint is a tracepoint.
> 
> This is the event you've mentioned:
> 
> TRACE_EVENT(sched_switch,
> 
> 	TP_PROTO(struct task_struct *prev,
> 		 struct task_struct *next),
> 
> It doesn't have the same arguments of a memory tracepoint, like:
> 
> TRACE_EVENT(mm_vmscan_wakeup_kswapd,
> 
> 	TP_PROTO(int nid, int zid, int order),
> 
> trace events for different things will have different arguments.

It seems you and I speak two different english languages. Here's what I meant:

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0533a688ce22..96947fb50328 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1918,6 +1918,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
        prepare_lock_switch(rq, next);
        prepare_arch_switch(next);
        trace_sched_switch(prev, next);
+       trace_sched_switch_rq(prev, next, rq);
 }

because for some reason we want to dump something from the runqueue
pointer now. We can't change the current tracepoint because userspace
scripts use it.

Now imagine the bloat levels when people start adding
tracepoints left and right...

> > 
> >>> Right, and this is why I'm asking you to have the following tracepoint proto:
> >>>
> >>> +       TP_PROTO(const unsigned int err_type,
> >>> +                const unsigned int mc_index,
> >>> +                const char *error_msg,
> >>> +                const char *label,
> >>> +                const char *location,
> >>> +                const char *detail)
> >>>
> >>> where detail contains all the crap one driver adds for technical people
> >>> to pinpoint where the error is.
> >>>
> >>> And not have _TWO_ detail arguments!
> >>
> >> And what I'm saying is that this should be, instead:
> >>
> >> + TP_PROTO(const unsigned int err_type,
> >> +          const unsigned int mc_index,
> >> +          const char *error_msg,
> >> +          const char *label,
> >> +          int layer0,
> >> +          int layer1,
> >> +          int layer2,
> >> +          unsigned long pfn,
> >> +          unsigned long offset,
> >> +          unsigned long grain,
> >> +          unsigned long syndrome,
> >> +          const char *driver_detail),
> >>
> >> So, having just one detail argument, filled by the driver, and not
> >> folding "location" and core "details" into strings, but keeping as they
> >> are.
> > 
> > And this way you're enforcing an interface that all drivers will have
> > to adhere to. What if "grain" doesn't mean a thing for a driver,  or
> > "syndrome" or whatever? What if some other entity wants to use that
> > tracepoint?
> 
> This enforcement is already there at the EDAC API/ABI. This patch series
> won't change that.
> 
> Memory controllers that can't get the error address (page/offset/grain)
> or the syndrome fills those information with 0.

Setting something to 0 because it is N/A is the first sign that
something is wrong with your ABI. Having an arbitrary string which each
driver parses as it sees fit is perfectly fine.

> > See what I'm sayin?
> > 
> > Having
> > 
> >        TP_PROTO(const unsigned int err_type,
> >                 const unsigned int mc_index,
> >                 const char *error_msg,
> >                 const char *label,
> >                 const char *location,
> >                 const char *detail)
> > 
> > is a bit more generic and userspace can parse it however it likes.
> > 
> > Actually, I'd slim this up even more:
> > 
> >        TP_PROTO(const unsigned int mc_index,
> >                 const char *error_msg,
> >                 const char *label,
> >                 const char *location,
> >                 const char *detail)
> 
> Well, this even more generic:
> 	TP_PROTO(const char *msg)
> 
> but the more we convert other fields into strings, the harder is for
> userspace to handle it,

For the millionth time, it is not hard for userspace to parse anything!

> as fields may be on different order, string conversion patches might
> change or break the parsing behavior, different drivers will require
> different parsing expressions, etc.

That's why _each_ _driver_ will have its format and the userspace tools
parsing it will know about it!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
