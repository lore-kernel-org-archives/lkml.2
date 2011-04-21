Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1DUAqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:46:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab1DUApz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=axbJ8327+3VWY5ZutzosqAZjQgVftpdqWDCNyR0+Bfzn3NCE/W+JjS4MKceBSxKbPn
         a2jKfsXW+uxolO9TU04w==
Date: Wed, 20 Apr 2011 17:45:50 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
In-Reply-To: <20110420153907.GA9000@alberich.amd.com>
Message-ID: <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com> <20110420153907.GA9000@alberich.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Andreas Herrmann wrote:

> Following patch breaks real NUMA on multi-node CPUs like AMD
> Magny-Cours and should be reverted (or changed to just take effect in
> case of numa=fake):
> 
>   commit 7d6b46707f2491a94f4bd3b4329d2d7f809e9368
>   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>   Date:   Fri Apr 15 20:39:01 2011 +0900
> 
>     x86, NUMA: Fix fakenuma boot failure
> 
>     ...
> 
>     Thus, this patch implements a reassignment of node-ids if buggy firmware
>     or numa emulation makes wrong cpu node map. Tt enforce all logical cpus
>     in the same physical cpu share the same node.
> 
>     ...
> 
>   +static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
>   +{
>   +       int node1 = early_cpu_to_node(cpu1);
>   +       int node2 = early_cpu_to_node(cpu2);
>   +
>   +       /*
>   +        * Our CPU scheduler assumes all logical cpus in the same physical cpu
>   +        * share the same node. But, buggy ACPI or NUMA emulation might assign
>   +        * them to different node. Fix it.
>   +        */
> 
>    ...
> 
> This is a false assumption. Magny-Cours has two nodes in the same
> physical package. The scheduler was (kind of) fixed to work around
> this boot problem for multi-node CPUs (with 2.6.32). If this is also
> an issue with wrong cpu node maps in case of NUMA emulation this might
> be fixed similar or this quirk should only be applied in case of NUMA
> emulation.
> 

Right, this yields cpuless nodes that the scheduler can't handle.  Prior 
to the unification and cleanup, NUMA emulation would bind cpus to all 
nodes that are allocated on the physical node that it has affinity with on 
the board.  This causes all nodes to have bound cpus such that 
node_to_cpumask() correctly reveals the proximity that cpus have to its 
nodes, either emulated or otherwise.

We usually don't touch NUMA code for real architectures to fix a problem 
that can only happen with NUMA emulation, so 7d6b46707f24 should probably 
be reverted.

With that patch reverted, NUMA emulation works fine for me; for example, 
with numa=fake=8:

	/sys/devices/system/node/node0/cpulist:0-3
	/sys/devices/system/node/node1/cpulist:4-7
	/sys/devices/system/node/node2/cpulist:8-11
	/sys/devices/system/node/node3/cpulist:12-15
	/sys/devices/system/node/node4/cpulist:0-3
	/sys/devices/system/node/node5/cpulist:4-7
	/sys/devices/system/node/node6/cpulist:8-11
	/sys/devices/system/node/node7/cpulist:12-15

I'm not sure what it's trying to address (yes, there is a problem with the 
binding for CONFIG_NUMA_EMU && CONFIG_DEBUG_PER_CPU_MAPS, but not 
otherwise).

KOSAKI-san?
