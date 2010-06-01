Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0FASNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0FASNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:13:17 -0400
Message-ID: <4C05493F.1040107@third-harmonic.com>
Date: Tue, 01 Jun 2010 13:54:07 -0400
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com,
       john cooper <john.cooper@redhat.com>
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com>
In-Reply-To: <4C053ACC.5020708@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 06/01/2010 07:38 PM, Andi Kleen wrote:
>>>> Your new code would starve again, right?
>>>>
>>>>        
>>> Yes, of course it may starve with unfair spinlock. Since vcpus are not
>>> always running there is much smaller chance then vcpu on remote memory
>>> node will starve forever. Old kernels with unfair spinlocks are running
>>> fine in VMs on NUMA machines with various loads.
>>>      
>> Try it on a NUMA system with unfair memory.
>>    
> 
> We are running everything on NUMA (since all modern machines are now
> NUMA).  At what scale do the issues become observable?
> 
>>> I understand that reason and do not propose to get back to old spinlock
>>> on physical HW! But with virtualization performance hit is unbearable.
>>>      
>> Extreme unfairness can be unbearable too.
>>    
> 
> Well, the question is what happens first.  In our experience, vcpu
> overcommit is a lot more painful.  People will never see the NUMA
> unfairness issue if they can't use kvm due to the vcpu overcommit problem.

Gleb's observed performance hit seems to be a rather mild
throughput depression compared with creating a worst case by
enforcing vcpu overcommit.  Running a single guest with 2:1
overcommit on a 4 core machine I saw over an order of magnitude
slowdown vs. 1:1 commit with the same kernel build test.
Others have reported similar results.

How close you'll get to that scenario depends on host
scheduling dynamics, and statistically the number of opened
and stalled lock held paths waiting to be contended.  So
I'd expect to see quite variable numbers for guest-guest
aggravation of this problem.

> What I'd like to see eventually is a short-term-unfair, long-term-fair
> spinlock.  Might make sense for bare metal as well.  But it won't be
> easy to write.

Collecting the contention/usage statistics on a per spinlock
basis seems complex.  I believe a practical approximation
to this are adaptive mutexes where upon hitting a spin
time threshold, punt and let the scheduler reconcile fairness.

-john

-- 
john.cooper@third-harmonic.com
