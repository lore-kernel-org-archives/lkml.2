Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2ERQkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:40:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40952 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2ERQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:40:32 -0400
Date: Fri, 18 May 2012 18:40:14 +0200
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
Message-ID: <20120518164014.GX20215@aftab.osrc.amd.com>
References: <1337287277-523-1-git-send-email-mchehab@redhat.com>
 <20120517214859.GA16777@aftab.osrc.amd.com>
 <20120518071244.GE429@gmail.com>
 <20120518095638.GA20215@aftab.osrc.amd.com>
 <4FB62BAB.90808@redhat.com>
 <20120518124338.GJ20215@aftab.osrc.amd.com>
 <4FB64D5B.1030301@redhat.com>
 <20120518140521.GM20215@aftab.osrc.amd.com>
 <4FB65D52.9060108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB65D52.9060108@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:31:46AM -0300, Mauro Carvalho Chehab wrote:
> Ok, but you won't use trace_sched_switch() as a memory tracepoint, as
> they represent different things.
> 
> Memory errors are different than CPU errors. So, their tracepoints
> will be different.

WTF? A tracepoint is a tracepoint.

> > Right, and this is why I'm asking you to have the following tracepoint proto:
> > 
> > +       TP_PROTO(const unsigned int err_type,
> > +                const unsigned int mc_index,
> > +                const char *error_msg,
> > +                const char *label,
> > +                const char *location,
> > +                const char *detail)
> > 
> > where detail contains all the crap one driver adds for technical people
> > to pinpoint where the error is.
> > 
> > And not have _TWO_ detail arguments!
> 
> And what I'm saying is that this should be, instead:
> 
> + TP_PROTO(const unsigned int err_type,
> +          const unsigned int mc_index,
> +          const char *error_msg,
> +          const char *label,
> +          int layer0,
> +          int layer1,
> +          int layer2,
> +          unsigned long pfn,
> +          unsigned long offset,
> +          unsigned long grain,
> +          unsigned long syndrome,
> +          const char *driver_detail),
> 
> So, having just one detail argument, filled by the driver, and not
> folding "location" and core "details" into strings, but keeping as they
> are.

And this way you're enforcing an interface that all drivers will have
to adhere to. What if "grain" doesn't mean a thing for a driver, or
"syndrome" or whatever? What if some other entity wants to use that
tracepoint?

See what I'm sayin?

Having

       TP_PROTO(const unsigned int err_type,
                const unsigned int mc_index,
                const char *error_msg,
                const char *label,
                const char *location,
                const char *detail)

is a bit more generic and userspace can parse it however it likes.

Actually, I'd slim this up even more:

       TP_PROTO(const unsigned int mc_index,
                const char *error_msg,
                const char *label,
                const char *location,
                const char *detail)

and have error_msg contain the "Corrected/Uncorrected/Fatal" things
and this way you can drop all the ternary operators in the tracepoint
definition.

> > Btw, the output looks like this here:
> > 
> >            <...>-2723  [001] .N..    89.107045: mc_event: Corrected error: on memory stick "unknown memory" (mc:0 csrow:3 channel:1 page:0x5bac7 offset:0x388 grain:0 syndrome:0xfc5b driver:amd64_edac)
> > 
> > Come to think of it, the "driver:amd64_edac" is not really needed
> > because on every single system there's only one EDAC driver running and
> > I don't think the fact that we're telling in the tracepoint who detected
> > the error is meaningfull information.
> > 
> > Which means, you can remove the EDAC_MOD_STR argument you're passing to
> > edac_mc_handle_error() and have one less argument.
> 
> That's what I said you, but you didn't seem to agree, as I understood that
> you've required to keep "amd64_edac"  at the trace, due to:
> 	http://markmail.org/message/nr3ooep7gc7mhgdl.
> 
> If you're ok, I'll remove EDAC_MOD_STR argument from the amd64_edac calls
> on a separate patch (with can be merged latter with the patch that converted
> amd64_edac to the new function calls).

Ok.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
