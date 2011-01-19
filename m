Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1ASSx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:53:58 -0500
Received: from claw.goop.org ([74.207.240.146]:45577 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab1ASSx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:53:56 -0500
Message-ID: <4D373340.60608@goop.org>
Date: Wed, 19 Jan 2011 10:53:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: vatsa@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        kvm@vger.kernel.org, suzuki@in.ibm.com
Subject: Re: [PATCH 2/3] kvm hypervisor : Add hypercalls to support pv-ticketlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>	 <20110119164432.GA30669@linux.vnet.ibm.com>	 <20110119171239.GB726@linux.vnet.ibm.com> <1295457672.28776.144.camel@laptop>
In-Reply-To: <1295457672.28776.144.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 09:21 AM, Peter Zijlstra wrote:
> On Wed, 2011-01-19 at 22:42 +0530, Srivatsa Vaddagiri wrote:
>> Add two hypercalls to KVM hypervisor to support pv-ticketlocks.
>>
>> KVM_HC_WAIT_FOR_KICK blocks the calling vcpu until another vcpu kicks it or it
>> is woken up because of an event like interrupt.
>>
>> KVM_HC_KICK_CPU allows the calling vcpu to kick another vcpu.
>>
>> The presence of these hypercalls is indicated to guest via
>> KVM_FEATURE_WAIT_FOR_KICK/KVM_CAP_WAIT_FOR_KICK. Qemu needs a corresponding
>> patch to pass up the presence of this feature to guest via cpuid. Patch to qemu
>> will be sent separately.
>
> I didn't really read the patch, and I totally forgot everything from
> when I looked at the Xen series, but does the Xen/KVM hypercall
> interface for this include the vcpu to await the kick from?
>
> My guess is not, since the ticket locks used don't know who the owner
> is, which is of course, sad. There are FIFO spinlock implementations
> that can do this though.. although I think they all have a bigger memory
> footprint.

At least in the Xen code, a current owner isn't very useful, because we
need the current owner to kick the *next* owner to life at release time,
which we can't do without some structure recording which ticket belongs
to which cpu.

(A reminder: the big problem with ticket locks is not with the current
owner getting preempted, but making sure the next VCPU gets scheduled
quickly when the current one releases; without that all the waiting
VCPUs burn the timeslices until the VCPU scheduler gets around to
scheduling the actual next in line.)

At present, the code needs to scan an array of percpu "I am waiting on
lock X with ticket Y" structures to work out who's next.  The search is
somewhat optimised by keeping a cpuset of which CPUs are actually
blocked on spinlocks, but its still going to scale badly with lots of CPUs.

I haven't thought of a good way to improve on this; an obvious approach
is to just add a pointer to the spinlock and hang an explicit linked
list off it, but that's incompatible with wanting to avoid expanding the
lock.

You could have a table of auxiliary per-lock data hashed on the lock
address, but its not clear to me that its an improvement on the array
approach, especially given the synchronization issues of keeping that
structure up to date (do we have a generic lockless hashtable
implementation?).  But perhaps its one of those things that makes sense
at larger scales.

> The reason for wanting this should be clear I guess, it allows PI.

Well, if we can expand the spinlock to include an owner, then all this
becomes moot...

    J


