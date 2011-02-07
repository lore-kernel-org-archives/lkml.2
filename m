Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1BGKLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:11:47 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:40835 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1BGKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:11:45 -0500
Date: Mon, 7 Feb 2011 15:40:41 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Daniel Tiron <dtiron@debian.armed.us>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Does the scheduler know about the cache topology?
Message-ID: <20110207101041.GA3196@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110207095141.GA26132@andariel.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110207095141.GA26132@andariel.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Tiron <dtiron@debian.armed.us> [2011-02-07 10:51:42]:

> Hi all.
> 
> I did some performance tests on a Core 2 Quad machine [1] with QEMU.
> A QEMU instance creates one main thread and one thread for each virtual
> CPU. There were two vms with one CPU each, which make four threads.
> 
> I tried different combinations where I pinned one tgread to one physical
> core with taskset and measured the network performance between the vms
> with iperf [2]. The best result was achieved with each vm (main and CPU
> thread) assigned to one cache group (core 0 & 1 and 2 & 3).
> 
> But it also turns out that letting the scheduler handle the assignment
> works well, too: The results where no pinning was done were just
> slightly below the best. So I was wondering, is the Linux scheduler
> aware of the CPU's cache topology?

Yes, the sched domains are created based on the socket or L2 cache
boundaries.  Scheduler will try to keep the task on same CPU or move
it close enough if it does have to migrate the task.

The CPU topology and cache domains in an SMP system is captured in the
form of sched domain tree with the scheduler, and this structure is
referred during task scheduling and migration.

When running VMs, there is an interesting side effect, the host
scheduler knows the cache domains but not the guest scheduler.  If the
guest scheduler keeps moving tasks between the vcps, then the cache
affinity and benefits could be lost.

> I'm curious to hear your opinion.
> 
> Thanks,
> Daniel
> 
> [1] Core 0 and 1 share one L2 cache and so do 2 and 3
> [2] The topic of my research is networking performance. My interest in
>     cache awareness is only a side effect.

Interrupt delivery and routing may also affect network performance.

--Vaidy

