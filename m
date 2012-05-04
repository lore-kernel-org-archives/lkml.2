Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288Ab2EDV6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:58:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34310 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab2EDV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:58:30 -0400
Date: Fri, 4 May 2012 14:57:47 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120504215747.GE3054@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
 <1336163281.6509.69.camel@twins>
 <20120504204908.GC18177@linux.vnet.ibm.com>
 <1336165294.6509.76.camel@twins>
 <20120504212758.GC3054@linux.vnet.ibm.com>
 <1336167265.6509.83.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336167265.6509.83.camel@twins>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050421-3270-0000-0000-000006156E1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2012 [23:34:25 +0200], Peter Zijlstra wrote:
> On Fri, 2012-05-04 at 14:27 -0700, Nishanth Aravamudan wrote:
> > >  - if you retain it for cpuset but not others that's confusing (too);
> > 
> > That's a good point.
> > 
> > Related, possibly counter-example, and perhaps I'm wrong about it.  When
> > we hot-unplug a CPU, and a task's scheduler affinity (via
> > sched_setaffinity) refers to that CPU only, do we kill that task? Can
> > you sched_setaffinity a task to a CPU that is offline (alone or in a
> > group of possible CPUs)? Or is it allowed to run anywhere? Do we destroy
> > its affinity policy when that situation is run across?
> 
> See a few emails back, we destroy the affinity. Current cpuset behaviour
> can be said to match that.

Ah you're right, sorry for glossing over that case. Does that also
happen if you affinitize it to a group of CPUs?

Seems not, we "remember" the original mask in that case:

# taskset -p f $$
pid 1424's current affinity mask: ff
pid 1424's new affinity mask: f
# grep Cpus_allowed /proc/self/status
Cpus_allowed:   0000000f
Cpus_allowed_list:      0-3
# echo 0 > /sys/devices/system/cpu/cpu2/online
# grep Cpus_allowed /proc/self/status
Cpus_allowed:   0000000f
Cpus_allowed_list:      0-3

So ... it seems like we come to a crossroads of sorts? I would think
cpusets and sched_setaffinity should behave the same in terms of
hotplug. 

*Maybe* a compromise is that we remember cpuset information up to the
empty cpuset, once you empty a cpuset, you forget everything? That
roughly corresponds to your and my test-case results?

Maybe that's more work than it's worth. It seems like, though, they
should have some similarity in functionality.

> >  Or do we restore the task to the CPU again when we re-plug it?
> 
> Nope that information is lost forever from the kernels pov.
> 
> Keeping this information around for the off-chance of needing it is
> rather expensive (512 bytes per task for your regular distro kernel that
> has NR_CPUS=4096).

Yep, that's another good point.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

