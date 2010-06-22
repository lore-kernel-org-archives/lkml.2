Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0FVHrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 03:47:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:54462 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0FVHre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 03:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,459,1272870000"; 
   d="scan'208";a="578622736"
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C2062D8.20609@redhat.com>
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
	 <4C1F50D0.70205@redhat.com>
	 <1277171344.2096.567.camel@ymzhang.sh.intel.com>
	 <4C2062D8.20609@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 15:47:53 +0800
Message-Id: <1277192873.2096.690.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 09:14 +0200, Jes Sorensen wrote:
> On 06/22/10 03:49, Zhang, Yanmin wrote:
> > On Mon, 2010-06-21 at 14:45 +0300, Avi Kivity wrote:
> >>   Since the guest can use NMI to read the 
> >> counter, it should have the highest possible priority, and thus it 
> >> shouldn't see any overflow unless it configured the threshold really low.
> >>
> >> If we drop overflow, we can use the RDPMC instruction instead of 
> >> KVM_PERF_OP_READ.  This allows the guest to allow userspace to read a 
> >> counter, or prevent userspace from reading the counter, by setting cr4.pce.
> > 1) para virt perf interface is to hide PMU hardware in host os. Guest os shouldn't
> > access PMU hardware directly. We could expose PMU hardware to guest os directly, but
> > that would be another guest os PMU support method. It shouldn't be a part of para virt
> > interface.
> > 2) Consider below scenario: PMU counter overflows and NMI causes guest os vmexit to
> > host kernel. Host kernel schedules the vcpu thread to another physical cpu before
> > vmenter the guest os again. So later on, guest os just RDPMC the counter on another
> > cpu.
> > 
> > So I think above discussion is around how to expose PMU hardware to guest os. I will
> > also check this method after the para virt interface is done.
> 
> You should be able to expose the counters as read-only to the guest. KVM
> allows you to specify whether or not a guest has read, write or
> read/write access. If you allowed read access of the counters that would
> safe a fair bit of hyper calls.
Thanks. KVM is good in register access permission configuration. But things are not so
simple like that if we consider real running environment. Host kernel might schedule
guest os vcpu thread to other cpus, or other non-kvm processes might preempt the vcpu
thread on this cpu.

To support such capability you said, we have to implement the direct exposition of PMU
hardware to guest os eventually.

> 
> Question is if it is safe to drop overflow support?
Not safe. One of PMU hardware design objectives is to use interrupt or NMI to notify
software when event counter overflows. Without overflow support, software need poll
the PMU registers looply. That is not good and consumes more cpu resources.

Besides the para virt perf interface, I'm also considering the direct exposition
of PMU hardware to guest os. But that will be another very different implementation. We
should not combine it with pv interface. Perhaps our target is to implement both, so
unmodified guest os could get support on perf statistics.

Yanmin


