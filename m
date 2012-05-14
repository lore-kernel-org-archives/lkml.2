Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774Ab2ENX6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:58:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55058 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab2ENX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:58:27 -0400
Date: Mon, 14 May 2012 16:58:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] CPU hotplug, cpusets: Fix issues with cpusets
 handling during suspend/resume
In-Reply-To: <20120513231325.3566.37740.stgit@srivatsabhat>
Message-ID: <alpine.DEB.2.00.1205141654080.25235@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Srivatsa S. Bhat wrote:

> Currently the kernel doesn't handle cpusets properly during suspend/resume.
> After a resume, all non-root cpusets end up having only 1 cpu (the boot cpu),
> causing massive performance degradation of workloads. One major user of cpusets
> is libvirt, which means that after a suspend/hibernation cycle, all VMs
> suddenly end up running terribly slow!
> 
> Also, the kernel moves the tasks from one cpuset to another during CPU hotplug
> in the suspend/resume path, leading to a task-management nightmare after
> resume.
> 

To deal with mempolicy rebinding when a cpuset changes, I made a change to 
mempolicies to store the user nodemask passed to set_mempolicy() or 
mbind() so the intention of the user could be preserved.  It seems like 
you should do the same thing for cpusets to store the "intended" set of 
cpus and respect that during cpu online?

> Patches 1 & 2 are cleanups that separate out hotplug handling so that we can
> implement different logic for different hotplug events (CPU/Mem
> online/offline). This also leads to some optimizations and more importantly
> prepares the ground for any further work dealing with cpusets during hotplug.
> 
> Patch 3 is a bug fix - it ensures that the tasks attached to the root cpuset
> see the updated cpus_allowed mask upon CPU hotplug.
> 
> Patches 4 and 5 implement the fix for cpusets handling during suspend/resume.

All of your patches are labeled to stable@vger.kernel.org, but I seriously 
doubt any of this is stable material since it has been a long-standing 
issue (and perhaps intentional in some cases) and your series includes 
cleanups and optimizations that wouldn't be stable candidates, so I'd 
suggest removing that annotation.
