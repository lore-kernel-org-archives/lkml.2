Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab2EUWQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:16:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16884 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2EUWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:16:28 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5IJZnVDGzjEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=8oXZ2Z5_TMdKxKkFErsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337638586.13348.7.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: Disable function tracing during suspend/resume
 and hibernation, again
From: Steven Rostedt <rostedt@goodmis.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        lenb@kernel.org, pavel@ucw.cz, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 18:16:26 -0400
In-Reply-To: <201205212355.45929.rjw@sisk.pl>
References: <20120521065651.4142.36898.stgit@srivatsabhat.in.ibm.com>
	 <201205212355.45929.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 23:55 +0200, Rafael J. Wysocki wrote:
> On Monday, May 21, 2012, Srivatsa S. Bhat wrote:
> > If function tracing is enabled for some of the low-level suspend/resume
> > functions, it leads to triple fault during resume from suspend, ultimately
> > ending up in a reboot instead of a resume (or a total refusal to come out
> > of suspended state, on some machines).
> > 
> > This issue was explained in more detail in commit f42ac38c59e0a03d (ftrace:
> > disable tracing for suspend to ram). However, the changes made by that commit
> > got reverted by commit cbe2f5a6e84eebb (tracing: allow tracing of
> > suspend/resume & hibernation code again). So, unfortunately since things are
> > not yet robust enough to allow tracing of low-level suspend/resume functions,
> > suspend/resume is still broken when ftrace is enabled.
> > 
> > So fix this by disabling function tracing during suspend/resume & hibernation.
> 
> Steve, any comments?

I was actually the one to recommend this solution ;-)

But that said, I actually do have some.

> 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Cc: stable@vger.kernel.org
> > ---
> > 
> >  kernel/power/hibernate.c |    6 ++++++
> >  kernel/power/suspend.c   |    3 +++
> >  2 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > index e09dfbf..52a1817 100644
> > --- a/kernel/power/hibernate.c
> > +++ b/kernel/power/hibernate.c
> > @@ -352,6 +352,7 @@ int hibernation_snapshot(int platform_mode)
> >  	}
> >  
> >  	suspend_console();
> > +	ftrace_stop();


Is this a point of no return?

This probably isn't a problem, but I'm being a little paranoid. As
ftrace_stop/start() is just an on off switch, anyplace that calls
ftrace_start() will enable function tracing again. Ftrace_start() is
called by tracing_start() which is called when
the /sys/kernel/debug/tracing/trace file is opened and then closed. If
the close happens while the suspend is starting, it possibly can start
function tracing again.

But this race would have to be done by the user, which should have full
control as they are in the process of suspending the machine. But they
may do it by accident.

Hmm, actually, I don't even think the ftrace_stop() is needed by
tracing_stop() anymore. I should just nuke it.

-- Steve


> >  	pm_restrict_gfp_mask();
> >  
> >  	error = dpm_suspend(PMSG_FREEZE);
> > @@ -377,6 +378,7 @@ int hibernation_snapshot(int platform_mode)
> >  	if (error || !in_suspend)
> >  		pm_restore_gfp_mask();
> >  
> > +	ftrace_start();
> >  	resume_console();
> >  	dpm_complete(msg);
> >  
> > @@ -479,6 +481,7 @@ int hibernation_restore(int platform_mode)
> >  
> >  	pm_prepare_console();
> >  	suspend_console();
> > +	ftrace_stop();
> >  	pm_restrict_gfp_mask();
> >  	error = dpm_suspend_start(PMSG_QUIESCE);
> >  	if (!error) {
> > @@ -486,6 +489,7 @@ int hibernation_restore(int platform_mode)
> >  		dpm_resume_end(PMSG_RECOVER);
> >  	}
> >  	pm_restore_gfp_mask();
> > +	ftrace_start();
> >  	resume_console();
> >  	pm_restore_console();
> >  	return error;
> > @@ -512,6 +516,7 @@ int hibernation_platform_enter(void)
> >  
> >  	entering_platform_hibernation = true;
> >  	suspend_console();
> > +	ftrace_stop();
> >  	error = dpm_suspend_start(PMSG_HIBERNATE);
> >  	if (error) {
> >  		if (hibernation_ops->recover)
> > @@ -555,6 +560,7 @@ int hibernation_platform_enter(void)
> >   Resume_devices:
> >  	entering_platform_hibernation = false;
> >  	dpm_resume_end(PMSG_RESTORE);
> > +	ftrace_start();
> >  	resume_console();
> >  
> >   Close:
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > index 396d262..c8b7446 100644
> > --- a/kernel/power/suspend.c
> > +++ b/kernel/power/suspend.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/export.h>
> >  #include <linux/suspend.h>
> >  #include <linux/syscore_ops.h>
> > +#include <linux/ftrace.h>
> >  #include <trace/events/power.h>
> >  
> >  #include "power.h"
> > @@ -212,6 +213,7 @@ int suspend_devices_and_enter(suspend_state_t state)
> >  			goto Close;
> >  	}
> >  	suspend_console();
> > +	ftrace_stop();
> >  	suspend_test_start();
> >  	error = dpm_suspend_start(PMSG_SUSPEND);
> >  	if (error) {
> > @@ -231,6 +233,7 @@ int suspend_devices_and_enter(suspend_state_t state)
> >  	suspend_test_start();
> >  	dpm_resume_end(PMSG_RESUME);
> >  	suspend_test_finish("resume devices");
> > +	ftrace_start();
> >  	resume_console();
> >   Close:
> >  	if (suspend_ops->end)
> > 
> > 
> > 


