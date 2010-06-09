Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0FIJ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:28:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:1808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab0FIJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,390,1272870000"; 
   d="scan'208";a="806169794"
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C0F5804.9080406@redhat.com>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F5804.9080406@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 09 Jun 2010 17:30:23 +0800
Message-Id: <1276075823.2096.436.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 11:59 +0300, Avi Kivity wrote:
> On 06/09/2010 06:30 AM, Zhang, Yanmin wrote:
> > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> >
> > Based on Ingo's idea, I implement a para virt interface for perf to support
> > statistics collection in guest os. That means we could run tool perf in guest
> > os directly.
> >
> > Great thanks to Peter Zijlstra. He is really the architect and gave me architecture
> > design suggestions. I also want to thank Yangsheng and LinMing for their generous
> > help.
> >
> > The design is:
> >
> > 1) Add a kvm_pmu whose callbacks mostly just calls hypercall to vmexit to host kernel;
> > 2) Create a host perf_event per guest perf_event;
> > 3) Host kernel syncs perf_event count/overflows data changes to guest perf_event
> > when processing perf_event overflows after NMI arrives. Host kernel inject NMI to guest
> > kernel if a guest event overflows.
> > 4) Guest kernel goes through all enabled event on current cpu and output data when they
> > overflows.
> > 5) No change in user space.
> >    
> 
> Other issues:
> 
> - save/restore support for live migration
Well, it's a little hard to process perf_event under live migration case.
I will check it.

> - some way to limit the number of open handles (comes automatically with 
> the table approach I suggested earlier)
Current perf doesn't restrict perf_event number. Kernel does a rotation to collect
statistics of all perf_events. My patch just follows this style. 
The table method might be not good, because below scenario:
guest perf_event might be a per-task event at guest side. When the guest application task is
migrated to another cpu, the perf_event peer at host side should also be migrated to the new vcpu
thread. With table method, we need do some rearrangement on the table when event migration happens.
Here migration I mention is not guest live migration. 

I will double-check it.

Thanks,
Yanmin


