Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1JOWkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 18:40:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1JOWkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 18:40:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] Documentation/power: Update docs about suspend and CPU hotplug
Date: Sun, 16 Oct 2011 00:42:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: rdunlap@xenotime.net, len.brown@intel.com, pavel@ucw.cz,
        a.p.zijlstra@chello.nl, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111011201958.10065.78949.stgit@srivatsabhat.in.ibm.com> <201110122119.41027.rjw@sisk.pl> <4E960306.2010602@linux.vnet.ibm.com>
In-Reply-To: <4E960306.2010602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110160042.40869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 12, 2011, Srivatsa S. Bhat wrote:
> On 10/13/2011 12:49 AM, Rafael J. Wysocki wrote:
> > On Wednesday, October 12, 2011, Srivatsa S. Bhat wrote:
> >> On 10/12/2011 03:32 AM, Rafael J. Wysocki wrote:
> >>> On Tuesday, October 11, 2011, Srivatsa S. Bhat wrote:
> >>>> Update the documentation about the interaction between the suspend (S3) call
> >>>> path and the CPU hotplug infrastructure.
> >>>> This patch focusses only on the activities of the freezer, cpu hotplug and
> >>>> the notifications involved. It outlines how regular CPU hotplug differs from
> >>>> the way it is invoked during suspend and also tries to explain the locking
> >>>> involved.
> >>>>
> >>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >>>> ---
> >>>>
> >>>>  Documentation/power/00-INDEX                   |    2 
> >>>>  Documentation/power/suspend-and-cpuhotplug.txt |  113 ++++++++++++++++++++++++
> >>>>  2 files changed, 115 insertions(+), 0 deletions(-)
> >>>>  create mode 100644 Documentation/power/suspend-and-cpuhotplug.txt
> >>>>
> >>>> diff --git a/Documentation/power/00-INDEX b/Documentation/power/00-INDEX
> >>>> index 45e9d4a..a4d682f 100644
> >>>> --- a/Documentation/power/00-INDEX
> >>>> +++ b/Documentation/power/00-INDEX
> >>>> @@ -26,6 +26,8 @@ s2ram.txt
> >>>>  	- How to get suspend to ram working (and debug it when it isn't)
> >>>>  states.txt
> >>>>  	- System power management states
> >>>> +suspend-and-cpuhotplug.txt
> >>>> +	- Explains the interaction between Suspend-to-RAM (S3) and CPU hotplug
> >>>>  swsusp-and-swap-files.txt
> >>>>  	- Using swap files with software suspend (to disk)
> >>>>  swsusp-dmcrypt.txt
> >>>> diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
> >>>> new file mode 100644
> >>>> index 0000000..d0ba411
> >>>> --- /dev/null
> >>>> +++ b/Documentation/power/suspend-and-cpuhotplug.txt
> >>>> @@ -0,0 +1,113 @@
> >>>> +Interaction of Suspend code (S3) with the CPU hotplug infrastructure
> >>>> +   (C) 2011 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>, GPL
> >>>> +
> >>>> +
> >>>> +I. How does the Suspend-to-RAM code interact with CPU hotplug infrastructure?
> >>>> +
> >>>> +Well, a picture speaks more than a thousand words... So ASCII art follows :-)
> >>>> +
> >>>> +[This depicts the current design in the kernel, and focusses only on the
> >>>> +interactions between suspend call paths involving the freezer and cpu hotplug
> >>>> +and also tries to explain the locking involved. It also outlines the
> >>>> +notifications involved.]
> >>>> +
> >>>> +On a high level, the suspend-resume cycle goes like this:
> >>>> +
> >>>> +|Freeze| -> |Disable nonboot| -> |Do suspend| -> |Enable nonboot| -> |Thaw |
> >>>> +|tasks |    |     cpus      |    |          |    |     cpus     |    |tasks|
> >>>> +
> >>>> +
> >>>> +More details follow:
> >>>> +
> >>>> +Regular CPU hotplug                                   Suspend call path
> >>>> +-------------------                              ---------------------------
> >>>> +
> >>>> +Write 0 (or 1) to                                     Write 'mem' to
> >>>> +/sys/devices/system/cpu/cpu*/online                   /sys/power/state
> >>>> +     sysfs file                                          syfs file
> >>>> +         |                                                   |
> >>>> +         |                                                   v
> >>>> +         |                                         Acquire pm_mutex lock
> >>>> +         |                                                   |
> >>>> +         |                                                   v
> >>>> +         |                                Send PM_SUSPEND_PREPARE notifications
> >>>> +         |                                                   |
> >>>> +         |                                                   v
> >>>> +         |                                              Freeze tasks
> >>>
> >>> OK, so something appears to be missing here.  Namely, the task writing to
> >>> /sys/devices/system/cpu/cpu*/online should be frozen at this point or
> >>> suspend should be aborted.  I suppose neither of these happens and I wonder
> >>> why exactly.
> >>>
> >>
> >> I have a couple of clarifications to make here:
> >> * Firstly, this picture is not meant to represent what happens when regular
> >>   cpu hotplug and suspend run together. That race condition has not been
> >>   brought out here. What it does try to explain is, how the regular cpu
> >>   hotplug path is different from suspend, and where they share common code.
> >>   Please don't think about timing/race condition when reading it. Its just
> >>   meant to explain the call path and locking involved.
> > 
> > Well, I didn't understand this part.  And the question above is:
> > 
> >> I. How does the Suspend-to-RAM code interact with CPU hotplug infrastructure?
> > 
> > which kind of suggests something different from what you're saying.  Care to
> > clarify that in the document?
> > 
> 
> Ok, I get it. I'll clarify the question and post the next version.
> 
> >> * Secondly, this picture explains the *current* design, and *not* the mutual
> >>   exclusion design I have proposed between regular cpu hotplug and suspend.
> >>   The reason being, this doc was written to help everyone understand the
> >>   current locking schemes, to help evaluate my proposal for a different
> >>   scheme (mutual exclusion).
> > 
> > I understand that.
> > 
> >> Now, coming to your point, if that task writing to the sysfs file has not
> >> been frozen, then the current kernel doesn't abort suspend, which is why we are
> >> encountering problems, and which is exactly what my patchset tries to solve.
> >> Link to my patchset:
> >> http://thread.gmane.org/gmane.linux.documentation/3414/focus=3414
> > 
> > This isn't my point, actually.  My point is that the task writing to
> > /sys/devices/system/cpu/cpu*/online should be frozen by the freezer.
> > If it is not frozen, then the freezer should fail.  If that doesn't
> > happen, there's a bug that has to be fixed and it is _not_ the lack
> > of mutual exclusion.  The bug is that, apparently, suspend continues
> > even though there is an unfrozen user space process in the system.
> > 
> > Do you have any idea why that happens?
> > 
> 
> Sorry, I think I explained it wrong above. The freezer doesn't have any bugs
> in this context. If it fails to freeze the tasks, suspend does get aborted.
> 
> But the point here is, suppose the task writing to the 'online' sysfs
> file has already entered the kernel, and _now_ the freezer started
> freezing tasks, it might encounter trouble in freezing that cpu hotplug
> operation that has already begun (because the cpu hotplug online operation
> waits on the frozen userspace to get microcode). 
> 
> So, to clarify again, regular cpu hotplug and the cpu hotplug operations
> carried out during suspend are properly serialized in the current kernel.
> We have no problems there.
> 
> The problem is with freezer and regular cpu hotplug racing with each other,
> as illustrated in this scenario:
>   * the regular cpu online operation continues its journey from userspace
>     into the kernel, since the freezing has not yet begun.
>   * then freezer starts and freezes userspace.
>   * If cpu online has not yet completed the microcode update stuff by now,
>     it will now start waiting on the frozen userspace unfortunately.
>   * Now the freezer continues and tries to freeze the remaining tasks. But
>     due to this wait mentioned above, the freezer won't be able to freeze
>     the cpu online hotplug task and hence freezing of tasks fails.
>   [This race condition is where the whole problem lies.]
> 
> And if freezing of tasks fails, then suspend gets aborted. So no problems
> there again.

That pretty much is how it is supposed to be.

Do I understand correctly that you're attempting to make suspend always
succeed if CPU hotplug stress test is run in parallel with it?

Rafael
