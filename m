Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1BARJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:09:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1BARJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:09:53 -0500
Message-ID: <4D483E43.5060904@redhat.com>
Date: Tue, 01 Feb 2011 19:09:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>	 <1296244340-15173-3-git-send-email-glommer@redhat.com>	 <4D4563EB.3000203@redhat.com> <1296575320.5081.8.camel@mothafucka.localdomain>
In-Reply-To: <1296575320.5081.8.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 05:48 PM, Glauber Costa wrote:
> >  >  @@ -2106,6 +2120,25 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  >    			kvm_migrate_timers(vcpu);
> >  >    		vcpu->cpu = cpu;
> >  >    	}
> >  >  +
> >  >  +	if (vcpu->arch.this_time_out) {
> >  >  +		u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
> >  >  +		/*
> >  >  +		 * using nanoseconds introduces noise, which accumulates easily
> >  >  +		 * leading to big steal time values. We want, however, to keep the
> >  >  +		 * interface nanosecond-based for future-proofness.
> >  >  +		 */
> >  >  +		to /= NSEC_PER_USEC;
> >  >  +		to *= NSEC_PER_USEC;
> >
> >  Seems there is a real problem and that this is just papering it over.
> >  I'd like to understand the root cause.
> Okay, my self-explanation seemed reasonable to me, but since both you
> and Peter dislike it, I think it is important enough to get a more
> thorough investigation before a second round.

Yes please.

> But in this case,
> I keep that using nanoseconds may then not be the best approach here. We
> also have to keep in mind that the host and guest clocks may be running
> at different resolutions.

We need to choose a resolution for the clock (or negotiate one), an 
nanoseconds seems as good as any from a range and precision 
considerations, and is convenient for the host and Linux guests.  So why 
not pick it?

> >  >  +		vcpu->arch.sversion += 2;
> >
> >  Doesn't survive live migration.  You need to use the version from the
> >  guest area.
> Why not? Who said versions need to always increase? If current version
> is 102324, and we live migrate and it becomes 0, what is the problem?

Guest reads version (result: 2)
Guest starts reading data
Live migration; vcpu->arch.sversion is zeroed
Steal time update; vcpu->arch.sversion += 2; write to guest
Guest continues reading data
Guest reads version (result: 2)

So the guest is unaware that an update has occurred while it was reading 
the data.

-- 
error compiling committee.c: too many arguments to function

