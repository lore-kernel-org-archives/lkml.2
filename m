Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FXDfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:35:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:30430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0FXDfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="529716383"
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
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
       tim.c.chen@intel.com, Alexander Graf <agraf@suse.de>,
       Carsten Otte <carsteno@de.ibm.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C21A0FB.7030509@redhat.com>
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
	 <4C1F5C21.7070902@redhat.com>
	 <1277176333.2096.650.camel@ymzhang.sh.intel.com>
	 <4C207475.9010006@redhat.com>
	 <1277262774.2096.838.camel@ymzhang.sh.intel.com>
	 <4C21A0FB.7030509@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 24 Jun 2010 11:36:00 +0800
Message-Id: <1277350560.2096.878.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 08:51 +0300, Avi Kivity wrote:
> On 06/23/2010 06:12 AM, Zhang, Yanmin wrote:
> >>>
> >>> This design is to deal with a task context perf collection in guest os.
> >>> Scenario 1:
> >>> 1) guest os starts to collect statistics of process A on vcpu 0;
> >>> 2) process A is scheduled to vcpu 1. Then, the perf_event at host side need
> >>> to be moved to VCPU 1 's thread. With the per KVM instance design, we needn't
> >>> move host_perf_shadow among vcpus.
> >>>
> >>>        
> >> First, the guest already knows how to deal with per-cpu performance
> >> monitors, since that's how most (all) hardware works.  So we aren't
> >> making the guest more complex, and on the other hand we simplify the host.
> >>      
> > I agree that we need keep things simple.
> >
> >    
> >> Second, if process A is migrated, and the guest uses per-process
> >> counters, the guest will need to stop/start the counter during the
> >> migration.  This will cause the host to migrate the counter,
> >>      
> > Agree. My patches do so.
> >
> > Question: Where does host migrate the counter?
> > The perf event at host side is bound to specific vcpu thread.
> >    
> 
> If the perf event is bound to the vm, not a vcpu, then on guest process 
> migration you will have to disable it on one vcpu and enable it on the 
> other, no?
I found we start from different points. This patch is to implement a para virt
interface based on current perf implementation in kernel.

Here is a diagram about perf implementation layers. Below picture is not precise,
but it could show perf layers. Ingo and Peter could correct me if something is wrong.

		-------------------------------------------------
		|  Perf Generic Layer				|
		-------------------------------------------------
		|  PMU Abstraction Layer	|	  
		|  (a couple of callbacks)	|	  
		-------------------------------------------------
		|  x86_pmu				   	|
		|  (operate real PMU hardware)			|
		-------------------------------------------------


The upper layer is perf generic layer. The 3rd layer is x86_pmu which really
manipulate PMU hardware. Sometimes, 1st calls 3rd directly at event initialization
and enable/disable all events.

My patch implements a kvm_pmu at the 2nd layer in guest os, to call hypercall to vmexit
to host. At host side, mostly it would go through the 3 layers till accessing real
hardware.

Most of your comments don't agree with the kvm_pmu design. Although you didn't say
directly, I know that perhaps you want to implement para virt interface at 3rd layer
in guest os. That means guest os maintains a mapping between guest event and PMU counters.
That's why you strongly prefer per-vcpu event managements and idx reference to event.
If we implement it at 3rd layer (or something like that although you might say I don't
like that layer...) in guest, we need bypass 1st and 2nd layers in host kernel when
processing guest os event. Eventually, we almost add a new layer under x86_pmu to arbitrate
between perf PMU request and KVM guest event request.

My current patch arranges the calling to go through the whole perf stack at host side.
The upper layer arranges perf event scheduling on PMU hardware. Applications don't know
when its event will be really scheduled to real hardware as they needn't know.


> 
> >>   so while we
> >> didn't move the counter to a different vcpu,
> >>      
> > Disagree here. If process A on vcpu 0 in guest os is migrated to vcpu 1,
> > host has to move process A's perf_event to vcpu 1 thread.
> >    
> 
> Sorry, I'm confused now (lost track of our example).  But whatever we 
> do, if a guest process is migrated, the host will have to migrate the 
> perf event, yes?
> 


