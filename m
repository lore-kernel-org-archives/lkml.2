Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab2BJWfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:35:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2BJWfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:35:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/4] CPU hotplug, cpusets: Fix CPU online handling related to cpusets
Date: Fri, 10 Feb 2012 23:39:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paul@paulmenage.org, tj@kernel.org, frank.rowand@am.sony.com,
        pjt@google.com, tglx@linutronix.de, lizf@cn.fujitsu.com,
        prashanth@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202101647440.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202102339.02702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 10, 2012, Alan Stern wrote:
> On Fri, 10 Feb 2012, Peter Zijlstra wrote:
> 
> > Now the whole problem here seems to be that suspend uses cpu-hotplug to
> > reduce the machine to UP -- I've no clue why it does that but I can
> > imagine its because the BIOS calls only work on CPU0 and/or the resume
> > only wakes CPU0 so you have to bootstrap the SMP thing again..

Yes, that's the main problem.

> > Some suspend person wanna clarify? Rafael?
> 
> If I understand correctly, ACPI requires that only CPU0 be running when
> the system is suspended (i.e., your guess is right).  Of course, this
> doesn't apply to non-ACPI systems, but it's easiest to do the same
> thing everywhere.

That's correct.  Plus we have some code in the kernel (syscore_ops in
general) that assumes to be executed on one CPU with interrupts off.
Plus I'm not sure how the ACPI low-level suspend is going to behave if it's
not executed on the boot CPU.

> > Anyway, the whole suspend case is magic anyway since all tasks will have
> > been frozen, so we could simply leave all of cpuset alone and ignore the
> > hotplug notifier on CPU_TASKS_FROZEN callbacks, hmm?
> 
> I don't see why not.  Presumably no CPUs will be added or removed while 
> the system is asleep.

ACPI explicitly forbids that level of hardware reconfiguration in a sleep
state (even in S4), AFAICS.  Still, people may try to do that ...

Thanks,
Rafael
