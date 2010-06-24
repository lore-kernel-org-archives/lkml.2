Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FXIAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:00:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab0FXIAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:00:09 -0400
Message-ID: <4C231067.6080802@redhat.com>
Date: Thu, 24 Jun 2010 10:59:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
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
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>	 <4C1F5C21.7070902@redhat.com>	 <1277176333.2096.650.camel@ymzhang.sh.intel.com>	 <4C207475.9010006@redhat.com>	 <1277262774.2096.838.camel@ymzhang.sh.intel.com>	 <4C21A0FB.7030509@redhat.com> <1277350560.2096.878.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277350560.2096.878.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 06:36 AM, Zhang, Yanmin wrote:
>
>> If the perf event is bound to the vm, not a vcpu, then on guest process
>> migration you will have to disable it on one vcpu and enable it on the
>> other, no?
>>      
> I found we start from different points. This patch is to implement a para virt
> interface based on current perf implementation in kernel.
>    

The words 'current perf implementation' are scary.  I'm after a long 
term stable interface.  My goals are a simple interface (so it is easy 
to implement on both sides, easy to scale, and resists implementation 
changes in guest and host), live migration support, and good documentation.

Since most of our infrastructure is for emulating hardware, I tend 
towards hardware-like interfaces.  These tend to retain all state in 
registers so they work well with live migration.

While realistically I don't expect other OSes to implement this 
interface, I would like to design it so it would be easy to do so.  That 
will help Linux as well in case the perf implementation changes.

> Here is a diagram about perf implementation layers. Below picture is not precise,
> but it could show perf layers. Ingo and Peter could correct me if something is wrong.
>
> 		-------------------------------------------------
> 		|  Perf Generic Layer				|
> 		-------------------------------------------------
> 		|  PMU Abstraction Layer	|	
> 		|  (a couple of callbacks)	|	
> 		-------------------------------------------------
> 		|  x86_pmu				   	|
> 		|  (operate real PMU hardware)			|
> 		-------------------------------------------------
>
>
> The upper layer is perf generic layer. The 3rd layer is x86_pmu which really
> manipulate PMU hardware. Sometimes, 1st calls 3rd directly at event initialization
> and enable/disable all events.
>
> My patch implements a kvm_pmu at the 2nd layer in guest os, to call hypercall to vmexit
> to host. At host side, mostly it would go through the 3 layers till accessing real
> hardware.
>    

Ok.

> Most of your comments don't agree with the kvm_pmu design. Although you didn't say
> directly, I know that perhaps you want to implement para virt interface at 3rd layer
> in guest os. That means guest os maintains a mapping between guest event and PMU counters.
> That's why you strongly prefer per-vcpu event managements and idx reference to event.
>    

The conclusion is correct, but I arrived at it from a different 
direction.  I'm not really familiar with perf internals (do you have 
pointers I could study?).  My preference comes from the desire to retain 
all state in guest-visible registers or memory.  That simplifies live 
migration significantly.  Keeping things per-vcpu simplifies the interface.

> If we implement it at 3rd layer (or something like that although you might say I don't
> like that layer...) in guest, we need bypass 1st and 2nd layers in host kernel when
> processing guest os event. Eventually, we almost add a new layer under x86_pmu to arbitrate
> between perf PMU request and KVM guest event request.
>
> My current patch arranges the calling to go through the whole perf stack at host side.
> The upper layer arranges perf event scheduling on PMU hardware. Applications don't know
> when its event will be really scheduled to real hardware as they needn't know.
>    

No, I don't think we should bypass the perf stack on the host.  It is 
important since the perf stack arbitrates a scarce resource that needs 
to be shared with other users on the host.

The way I see it, pvpmu can easily expose an interface that is 
hardware-like: a process context host perf event corresponds to a guest 
vcpu context performance counter.  The guest already knows how to 
convert vcpu context hardware counters to process context hardware 
counters, and how to multiplex multiple software visible perf events on 
limited hardware resources.

All three layers would be involved on both guest and host.  When I 
suggest to use WRMSR and RDPMC to access pvpmu, that doesn't mean it 
accesses the real pmu; it's just a hardware-like interface to access a 
vcpu-context/per-thread counter on the host.  An advantage of an MSR 
interface is that we have infrastructure to live migrate the state 
associated with it.

Having the host see guest process context events is not useful IMO.  We 
can't allow the guest to create unlimited events, so the multiplexing 
code will still be needed.  Because of that, we may as well restrict 
ourselves to vcpu context events, which is how real hardware works.

If there is concern about a guest task migrating to a different vcpu and 
requiring the destruction and re-creation of a perf event on the host 
side, that can be addressed by a cache on the host side.  The cache 
would be invisible ("non-architectural" from the guest's point of view), 
and so we would not need to live migrate it.  However, I don't believe 
such a cache is really necessary, or that it's a good idea for large guests.

-- 
error compiling committee.c: too many arguments to function

