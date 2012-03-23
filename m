Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2CWGiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 02:38:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42959 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750895Ab2CWGiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 02:38:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jX1cEMRbjByqrF23MM66xzIfeFt7pRbCYBqZkD0
	B2N/l2XpWFP+Dz
Message-ID: <1332484680.5721.42.camel@marge.simpson.net>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Fri, 23 Mar 2012 07:38:00 +0100
In-Reply-To: <20120322153205.GA28570@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
	 <20120305152443.GE26559@linux.vnet.ibm.com>
	 <20120306091410.GD27238@elte.hu>
	 <20120322153205.GA28570@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 21:02 +0530, Srivatsa Vaddagiri wrote: 
> * Ingo Molnar <mingo@elte.hu> [2012-03-06 10:14:11]:
> 
> > > I did some experiments with volanomark and it does turn out to 
> > > be sensitive to SD_BALANCE_WAKE, while the other wake-heavy 
> > > benchmark that I am dealing with (Trade) benefits from it.
> > 
> > Does volanomark still do yield(), thereby invoking a random 
> > shuffle of thread scheduling and pretty much voluntarily 
> > ejecting itself from most scheduler performance considerations?
> > 
> > If it uses a real locking primitive such as futexes then its 
> > performance matters more.
> 
> Some more interesting results on more recent tip kernel.

Yeah, interesting.  I find myself ever returning to this message, as
gears grind away trying to imagine what's going on in those vcpus.

> Machine : 2 Quad-core Intel X5570 CPU w/ H/T enabled (16 cpus)
> Kernel  : tip (HEAD at ee415e2)
> guest VM : 2.6.18 linux kernel based enterprise guest
> 
> Benchmarks are run in two scenarios:
> 
> 1. BM -> Bare Metal. Benchmark is run on bare metal in root cgroup
> 2. VM -> Benchmark is run inside a guest VM. Several cpu hogs (in
>  	 various cgroups) are run on host. Cgroup setup is as below:
> 
> 	/sys (cpu.shares = 1024, hosts all system tasks)
> 	/libvirt (cpu.shares = 20000)
>  	/libvirt/qemu/VM (cpu.shares = 8192. guest VM w/ 8 vcpus)
> 	/libvirt/qemu/hoga (cpu.shares = 1024. hosts 4 cpu hogs)
> 	/libvirt/qemu/hogb (cpu.shares = 1024. hosts 4 cpu hogs)
> 	/libvirt/qemu/hogc (cpu.shares = 1024. hosts 4 cpu hogs)
> 	/libvirt/qemu/hogd (cpu.shares = 1024. hosts 4 cpu hogs)
> 
> First BM (bare metal) scenario:
> 
> 		tip	tip + patch
> 
> volano 		1	0.955   (4.5% degradation)
> sysbench [n1] 	1	0.9984  (0.16% degradation)
> tbench 1 [n2]	1	0.9096  (9% degradation)

Those make sense, fast path cycles added.

> Now the more interesting VM scenario:
> 
> 		tip	tip + patch
> 
> volano		1	1.29   (29% improvement)
> sysbench [n3]	1	2      (100% improvement)
> tbench 1 [n4] 	1       1.07   (7% improvement)
> tbench 8 [n5] 	1       1.26   (26% improvement)
> httperf  [n6]	1 	1.05   (5% improvement)
> Trade		1	1.31   (31% improvement)
> 
> Notes:
>  
> n1. sysbench was run with 16 threads.
> n2. tbench was run on localhost with 1 client 
> n3. sysbench was run with 8 threads
> n4. tbench was run on localhost with 1 client
> n5. tbench was run over network with 8 clients
> n6. httperf was run as with burst-length of 100 and wsess of 100,500,0
> 
> So the patch seems to be a wholesome win when VCPU threads are waking
> up (in a highly contended environment). One reason could be that any assumption 
> of better cache hits by running (vcpu) threads on its prev_cpu may not
> be fully correct as vcpu threads could represent many different threads
> internally?
> 
> Anyway, there are degradations as well, considering which I see several 
> possibilities:
> 
> 1. Do balance-on-wake for vcpu threads only.

That's what your numbers say to me with this patch.  I'm not getting the
why, but your patch appears to reduce vcpu internal latencies hugely.

> 2. Document tuning possibility to improve performance in virtualized
>    environment:
> 	- Either via sched_domain flags (disable SD_WAKE_AFFINE 
>  	  at all levels and enable SD_BALANCE_WAKE at SMT/MC levels)
> 	- Or via a new sched_feat(BALANCE_WAKE) tunable
> 
> Any other thoughts or suggestions for more experiments?

Other than nuke select_idle_sibling() entirely instead, none here.

-Mike

