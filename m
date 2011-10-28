Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1J1L7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:59:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab1J1L7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:59:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] CPU hotplug, Freezer: Synchronize CPU hotplug and Freezer
Date: Fri, 28 Oct 2011 14:02:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: a.p.zijlstra@chello.nl, stern@rowland.harvard.edu, pavel@ucw.cz,
        len.brown@intel.com, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au,
        vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <bp@amd64.org>
References: <20111027134824.20916.46845.stgit@srivatsabhat.in.ibm.com> <4EAA875D.5010203@linux.vnet.ibm.com> <201110281357.01484.rjw@sisk.pl>
In-Reply-To: <201110281357.01484.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110281402.19108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 28, 2011, Rafael J. Wysocki wrote:
> On Friday, October 28, 2011, Srivatsa S. Bhat wrote:
> > On 10/28/2011 01:43 AM, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Thursday, October 27, 2011, Srivatsa S. Bhat wrote:
> > >> Prevent CPU hotplug and the freezer from racing with each other, to ensure
> > >> that during the *entire duration* for which the callbacks for CPU hotplug
> > >> notifications such as CPU_ONLINE[_FROZEN], CPU_DEAD[_FROZEN] etc are being
> > >> executed, the state of the system (with respect to the tasks being frozen
> > >> or not) remains constant.
> > >>
> > >> This patches hooks the CPU hotplug infrastructure onto the freezer
> > >> notifications (PM_FREEZE_PREPARE and PM_POST_THAW) and thus synchronizes
> > >> with the freezer.
> > >>
> > >> Specifically,
> > >>
> > >> * Upon the PM_FREEZE_PREPARE notification, the CPU hotplug callback disables
> > >>   future (regular) CPU hotplugging and also ensures that any currently running
> > >>   CPU hotplug operation is completed before allowing the freezer to continue
> > >>   any further.
> > >>
> > >> * Upon the PM_POST_THAW notification, the CPU hotplug callback re-enables
> > >>   regular CPU hotplug.
> > >>
> > >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > >> ---
> > >>
> > >>  kernel/cpu.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >>  1 files changed, 76 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/kernel/cpu.c b/kernel/cpu.c
> > >> index 12b7458..61985ce 100644
> > >> --- a/kernel/cpu.c
> > >> +++ b/kernel/cpu.c
> > >> @@ -15,6 +15,7 @@
> > >>  #include <linux/stop_machine.h>
> > >>  #include <linux/mutex.h>
> > >>  #include <linux/gfp.h>
> > >> +#include <linux/suspend.h>
> > >>  
> > >>  #ifdef CONFIG_SMP
> > >>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> > >> @@ -478,6 +479,81 @@ static int alloc_frozen_cpus(void)
> > >>  core_initcall(alloc_frozen_cpus);
> > >>  #endif /* CONFIG_PM_SLEEP_SMP */
> > >>  
> > >> +
> > >> +#ifdef CONFIG_FREEZER
> > >> +
> > >> +/*
> > >> + * Avoid CPU hotplug racing with the freezer subsystem, by disabling CPU
> > >> + * hotplug when tasks are about to be frozen.
> > >> + *
> > >> + * Also, don't allow the freezer subsystem to continue until any currently
> > >> + * running CPU hotplug operation gets completed.
> > >> + * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
> > >> + * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
> > >> + * CPU hotplug path and released only after it is complete. Thus, we
> > >> + * (and hence the freezer) will block here until any currently running CPU
> > >> + * hotplug operation is completed.
> > >> + */
> > >> +static void cpu_hotplug_freezer_block_begin(void)
> > >> +{
> > >> +	cpu_maps_update_begin();
> > >> +	cpu_hotplug_disabled = 1;
> > >> +	cpu_maps_update_done();
> > >> +}
> > >> +
> > >> +
> > >> +/*
> > >> + * When thawing of tasks is complete, re-enable CPU hotplug (which had been
> > >> + * disabled while beginning to freeze tasks).
> > >> + */
> > >> +static void cpu_hotplug_freezer_block_done(void)
> > >> +{
> > >> +	cpu_maps_update_begin();
> > >> +	cpu_hotplug_disabled = 0;
> > >> +	cpu_maps_update_done();
> > >> +}
> > >> +
> > > 
> > > I wonder if the new PM notifier events are really necessary?
> > > 
> > > Why don't you just call cpu_hotplug_freezer_block_begin() (perhaps
> > > with a better name?) directly from freeze_processes()?  And analogously
> > > for cpu_hotplug_freezer_block_done() and thaw_processes()?
> > > 
> > 
> > Yes, we can definitely do that. 
> > 
> > But the reason why I chose to introduce new notifiers was to make this
> > more extensible (because we know that at least 2 subsystems would benefit
> > from mutually excluding themselves from the freezer, namely CPU hotplug
> > and x86 microcode).
> > http://thread.gmane.org/gmane.linux.kernel/1198291/focus=1200591
> > 
> > But now that I think of it, hooking onto the freezer notifiers wouldn't
> > solve the microcode cases since usermodehelper_disable() is called
> > _before_ freezing tasks... :(
> > 
> > So we should probably call the functions directly like you suggested.. 
> > 
> > But I really didn't want to clutter the freezer call path because of problems
> > elsewhere. So I felt freezer notifiers would be a cleaner way of dealing with
> > such things. Also, since freezer is a generic subsystem that could be used
> > for purposes other than S3/S4 as well (I have heard of attempts to use freezer
> > during tracing), wouldn't it be better to introduce new notifiers to
> > announce the begin and end of freezer activity to interested subsystems?
> > (and then use them to solve the CPU hotplug issue like this patch does...)
> > 
> > Please let me know your suggestions.
> 
> The freeze_processes() and thaw_processes() functions are only used for
> system suspend and hibernation, as far as I can tell, and I don't think there
> will be any other users in predictable future.
> 
> Also, adding the calls directly to those functions will show exactly what
> the dependecies are, while doing that through a notifier kind of obfuscates
> things.  So, please make direct calls from there.

Alternatively, which I'd even prefer in fact, you can simply use the
PM_SUSPEND_PREPARE and PM_POST_SUSPEND notifier events (and analogously
for hibernation) to run that code.  Which also might be useful for solving
the microcode case.

Thanks,
Rafael
