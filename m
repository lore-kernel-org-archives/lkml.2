Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1JLT2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:28:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1JLT2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:28:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
Date: Wed, 12 Oct 2011 21:31:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <201110112356.31502.rjw@sisk.pl> <4E95102A.3050503@linux.vnet.ibm.com>
In-Reply-To: <4E95102A.3050503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110122131.08811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 12, 2011, Srivatsa S. Bhat wrote:
> On 10/12/2011 03:26 AM, Rafael J. Wysocki wrote:
> > On Tuesday, October 11, 2011, Srivatsa S. Bhat wrote:
> >> On 10/10/2011 08:46 PM, Srivatsa S. Bhat wrote:
> >>> On 10/10/2011 07:56 PM, Peter Zijlstra wrote:
> >>>> On Mon, 2011-10-10 at 18:15 +0530, Srivatsa S. Bhat wrote:
> >>>>>> +     /*
> >>>>>> +      * Prevent cpu online and suspend/hibernate (including freezer)
> >>>>>> +      * operations from running in parallel. Fail cpu online if suspend or
> >>>>>> +      * hibernate has already started.
> >>>>>> +      */
> >>>>>> +     if (!trylock_pm_sleep())
> >>>>>
> >>>>> Would it be better to hook into the suspend/hibernate notifiers and
> >>>>> use them to exclude cpu hotplug from suspend/hibernate, instead of
> >>>>> trying to take pm_mutex lock like this?
> >>>>> Peter, I remember you pointing out in another patch's review
> >>>>> (http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087)
> >>>>> that introducing more locks in cpu hotplug would be a bad idea. Does that
> >>>>> comment hold here as well, or is this fine? 
> >>>>
> >>>> Arguably pm_mutex is already involved in the whole hotplug dance due to
> >>>> suspend using it, that said, I'm not at all familiar with the whole
> >>>> suspend/hibernate side of things.
> >>>>
> >>>> I tried having a quick look this morning but failed to find the actual
> >>>> code.
> >>>>
> >>>> I think it would be good to have an overview of the various locks and a
> >>>> small description of how they interact/nest.
> >>>>
> >>>
> >>> Sure. I'll put together whatever I have understood, in the form of a patch
> >>> to Documentation/power directory and post it tomorrow, for the benefit of
> >>> all.
> >>>
> >>
> >> Here it is, just as promised :-)
> >> http://lkml.org/lkml/2011/10/11/393
> > 
> > Well, I have an idea.
> > 
> > Why don't we make drivers/base/cpu.c:store_online() take pm_mutex
> > in addition to calling cpu_hotplug_driver_lock()?  This at least
> > will make the interface mutually exclusive with suspend/hibernation.
> > 
> 
> Oh, no no.. We shouldn't be doing that even though it seems very
> innocuous, because of a subtle reason: the memory hotplug code called
> in cpu_up() tries to acquire pm_mutex! So we will end up deadlocking
> ourselves, due to recursive locking!

So, you're referring to mem_online_node().  Is it actually used
from any place other than cpu_up()?  Perhaps we can remove the
lock_system_sleep() from lock_memory_hotplug() if store_online()
acquires pm_mutex?  And if we can't, then why exactly?

> See kernel/cpu.c: cpu_up() calls mem_online_node() [defined in
> mm/memory_hotplug.c/mem_online_node() which calls lock_memory_hotplug()
> which internally calls lock_system_sleep(), which is where it tries
> to get pm_mutex].
> 
> So this patchset implements the mutual exclusion in the cpu_up() function
> (i.e., a little bit deeper down the road than store_online() ) and solves
> the problem.

Which is not exactly the right place to do that as Peter has already
indicated.  What you want is really the CPU hotplug interface to be
mutually exclusive with the suspend/hibernation interface, not the
CPU hotplug itself to be mutually exclusive with suspend/hibernation.

Thanks,
Rafael
