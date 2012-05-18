Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968022Ab2EROFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:05:41 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39779 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:05:39 -0400
Date: Fri, 18 May 2012 16:05:21 +0200
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
Message-ID: <20120518140521.GM20215@aftab.osrc.amd.com>
References: <1337287277-523-1-git-send-email-mchehab@redhat.com>
 <20120517214859.GA16777@aftab.osrc.amd.com>
 <20120518071244.GE429@gmail.com>
 <20120518095638.GA20215@aftab.osrc.amd.com>
 <4FB62BAB.90808@redhat.com>
 <20120518124338.GJ20215@aftab.osrc.amd.com>
 <4FB64D5B.1030301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB64D5B.1030301@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:23:39AM -0300, Mauro Carvalho Chehab wrote:
> Em 18-05-2012 09:43, Borislav Petkov escreveu:
> 
> (offensive/ironic comments skipped)
> 
> > you fail to see that I'm trying to make this as generic as possible and
> > not fit it into anything so that EVERYONE can use it.
> 
> Tracepoints are generic enough. Everyone can use it. If need new fields are
> needed, just add a new tracepoint.

This is exactly what I'm talking about - this is wrong on so many levels
that it ain't even funny! You can add as many tracepoints if you want
to to your pet project but in the kernel we add one tracepoint for one
thing which fits all users.

I want to see you be successful at adding a new tracepoint
to, say, prepare_task_switch() in kernel/sched/core.c because
trace_sched_switch() does not fit your needs.

> Converting it into a new printk way won't make it usable by everyone.
> It will just make the ABI unstable.

WTF? We're not even talking about converting it into a new printk!

[ … ]

> > Guess what, you can do decay very successfully in userspace.
> 
> Yes, if and only if userspace receives the errors on a proper way.

Doh, am I talking to the wall here, do you even read what I'm sayin?

> >> So, on a machine running for 30 days with, let's say, 10 corrected
> >> errors, it is not possible to tell if they were all generated on a
> >> burst (because of some temporary interference) or if they are sparse
> >> errors generated at the same DRAM, indicating a bad memory.
> > 
> > Why not, you don't have timestamps?
> 
> At the error counters? No.
> 
> There are timestamps at printk's, but printk's can't be reliably parsed, as
> formats are not consistent among drivers, and the "ABI" can break on every 
> Kernel release.

Yes, enough already! We know about the printks! The whole world knows.

> >> With this simple change, the tool can be improved to provide a more
> >> consistent memory error report, as userspace should not be worried on
> >> parsing fields that may change in future without notice.
> > 
> > Which userspace, your userspace? What happens if another userspace comes
> > with slightly different error formatting requirements? We change the
> > kernel again or we can't because this tracepoint is being used and we
> > add another tracepoint and let the bloat begin?
> 
> As said before, this is not about error formatting requirements! TP_printk() macro
> does formatting. I'm not discussing TP_printk() output.
> 
> All Userspace tools require access to the error fields.
> 
> The real issue with tracepoint is to provide access to the structured data that
> userspace needs (so, what fields should be exported), and not about what printk
> formats. With regards to the printk format there's already an agreement that
> seems to satisfy you, me and Tony.
> 
> By adding all fields there at the tracepoint, no changes will be needed inside
> Kernel to satisfy any userspace requirements, and the ABI will be reliable and
> stable.

Right, and this is why I'm asking you to have the following tracepoint proto:

+       TP_PROTO(const unsigned int err_type,
+                const unsigned int mc_index,
+                const char *error_msg,
+                const char *label,
+                const char *location,
+                const char *detail)

where detail contains all the crap one driver adds for technical people
to pinpoint where the error is.

And not have _TWO_ detail arguments!

Btw, the output looks like this here:

           <...>-2723  [001] .N..    89.107045: mc_event: Corrected error: on memory stick "unknown memory" (mc:0 csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xfc5b driver:amd64_edac)

Come to think of it, the "driver:amd64_edac" is not really needed
because on every single system there's only one EDAC driver running and
I don't think the fact that we're telling in the tracepoint who detected
the error is meaningfull information.

Which means, you can remove the EDAC_MOD_STR argument you're passing to
edac_mc_handle_error() and have one less argument.

> >> Also, doing that will avoid the extra effort of joining everything into
> >> a single string, and then breaking them back into their individual fields
> >> on userspace.
> > 
> > I'm being told this is very easy to do in userspace in your garden
> > variety language.
> 
> Well, ask the one that told you that to write a parser that will get all 
> EDAC error reports on all drivers, on several kernel versions using dmesg.

Nobody is talking about dmesg - I'm talking about the "const char
*detail" string in the tracepoint above and how I want it to be a single
char * so that userspace can read it out and fumble with it the way it
sees fit.

Having "detail" and "other_detail" is simply misleading and unneeded and
a clear sign that this ABI is not designed properly yet.

That's it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
