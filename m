Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2BRHmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 02:42:03 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44170 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2BRHmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 02:42:01 -0500
Date: Sat, 18 Feb 2012 13:11:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        " Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: sched: Performance of Trade workload running inside VM
Message-ID: <20120218074127.GA9077@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
 <1329307161.2293.66.camel@twins>
 <20120215171032.GB9918@linux.vnet.ibm.com>
 <1329326651.2293.151.camel@twins>
 <20120215173817.GD9918@linux.vnet.ibm.com>
 <1329327902.2293.168.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329327902.2293.168.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021807-4790-0000-0000-00000162498D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 18:45:02]:

> I'm still waiting for a problem description that isn't a book.
> 
> What does the load-balancer do,

select_idle_sibling() tries finding a core (sched group) which is fully idle
failing which will let task wakeup on prev_cpu.

> why is it wrong,

Take this scenario. wakeup source for task is cpu0 while its prev_cpu is
cpu7 (which is in another cache domain).

		cache_dom0		cache_dom1
		(0, 1) (2, 3)		(4, 5) (6, 7)
nr_running->	 1  1   1  1     	 0, 1   1, 2

In this case we let task wakeup on cpu7, resulting in it incurring some
wait time before being scheduled. A better choice would have been cpu4 (whose
core is partially idle) or in general any other less-loaded cpu which is in same
cache domain?

> why does your patch sort it etc.

The patch does result in a hunt for "least" busy cpu when the target cpu
returned by select_idle_sibling() is not idle - thus resulting in better
scheduling latencies for the task (and in turn better benchmark scores).

Another variant of the patch could be to have select_idle_sibling() look
for any idle cpu that is in same cache domain (rather than looking for a
whole group of cpus to be idle)?

- vatsa

