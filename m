Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0E2JbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:31:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51457 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0E2JbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:31:19 -0400
Date: Sat, 29 May 2010 11:31:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] powernow-k8: Fix section mismatch
Message-ID: <20100529093119.GA24169@aftab>
References: <20100525152858.GA24836@aftab>
 <20100528140908.057f2348.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528140908.057f2348.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, May 28, 2010 at 05:09:08PM -0400

Hi Andrew,

> On Tue, 25 May 2010 17:28:58 +0200
> Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > Fix the following warning:
> > 
> > "WARNING: arch/x86/kernel/built-in.o(.exit.text+0x72):
> > Section mismatch in reference from the function powernowk8_exit() to the variable .cpuinit.data:cpb_nb
> > 
> > The function __exit powernowk8_exit() references a variable
> > __cpuinitdata cpb_nb. This is often seen when error handling in the exit
> > function uses functionality in the init path. The fix is often to remove
> > the __cpuinitdata annotation of cpb_nb so it may be used outside an init
> > section."
> > 
> > Cc: <stable@kernel.org>
> > Reported-by: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > index 6f3dc8f..7ec2123 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> > @@ -1497,8 +1497,8 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
> >   * simply keep the boost-disable flag in sync with the current global
> >   * state.
> >   */
> > -static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
> > -				void *hcpu)
> > +static int cpb_notify(struct notifier_block *nb, unsigned long action,
> > +		      void *hcpu)
> >  {
> >  	unsigned cpu = (long)hcpu;
> >  	u32 lo, hi;
> > @@ -1528,7 +1528,7 @@ static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
> >  	return NOTIFY_OK;
> >  }
> >  
> > -static struct notifier_block __cpuinitdata cpb_nb = {
> > +static struct notifier_block cpb_nb = {
> >  	.notifier_call		= cpb_notify,
> >  };
> 
> I _think_ this is notabug.  If CONFIG_HOTPLUG_CPU=y, this code/data
> doesn't get discarded.  If CONFIG_HOTPLUG_CPU=n,
> [un]register_cpu_notifier() is a no-op.
> 
> But apparently the build system _did_ detect such a reference, so
> what's going on?  Maybe I'm confused again.

No, you're right. We need all that notifier code strictly for when we
take a cpu offline. The registration should too be cpu hotplug-aware for
it is the only logical thing to do. However...

> This code needs work.  It should use hotcpu_notifier() rather than
> diving down into the lower-level register_cpu_notifier().  If this is
> done then linker magic will cause all the hotplug-specific code to be
> omitted from vmlinux if CONFIG_HOTPLUG_CPU=n, and I suppose it will fix
> the above warning.

... the original warning is __exit versus __cpuinitdata section
marking which CONFIG_DEBUG_SECTION_MISMATCH complains about. Using the
[un]register_hotcpu_notifier() causes another one:

WARNING: kernel/built-in.o(.text+0x12fc5): Section mismatch in reference from the function __cpu_notify() to the variable .cpuinit.data:cpu_chain
The function __cpu_notify() references
the variable __cpuinitdata cpu_chain.
This is often because __cpu_notify lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x3ba8d): Section mismatch in reference from the function __cpu_notify() to the variable .cpuinit.data:cpu_chain
The function __cpu_notify() references
the variable __cpuinitdata cpu_chain.
This is often because __cpu_notify lacks a __cpuinitdata 
annotation or the annotation of cpu_chain is wrong.

so we're kinda like between a rock and a hard place here :).

Bottomline is: I wanna unregister the notifier at module exit time, and,
at the same time, get rid of all that code when CONFIG_HOTPLUG_CPU is
off.

But, if .cpuinit.data is being discarded at link time and the module
exit function references a .cpuinit.data symbol, we're simply dropping
all those [un]register_cpu_notifier() calls. Which means an unused
function and a notifier_block.

It could be that the above is becoming moot, though, for HOTPLUG_CPU
is almost always enabled (and being selected by a bunch of other core
stuff especially like PM_SLEEP_SMP etc) so we can save us the trouble of
section marking all those symbols. In this case of EMBEDDED you simply
disable powernow-k8.

But I don't know, I might just as well be missing something else.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
