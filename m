Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0DUABM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:01:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab0DUABJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:01:09 -0400
Message-ID: <4BCE403E.7050605@redhat.com>
Date: Tue, 20 Apr 2010 14:01:02 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <20100419142624.GE14158@mothafucka.localdomain> <4BCC829A.6000803@goop.org> <20100419182542.GI14158@mothafucka.localdomain> <20100420015733.GA28249@amt.cnet> <4BCD7557.9090502@redhat.com>
In-Reply-To: <4BCD7557.9090502@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 11:35 PM, Avi Kivity wrote:
> On 04/20/2010 04:57 AM, Marcelo Tosatti wrote:
>>
>>> Marcelo can probably confirm it, but he has a nehalem with an 
>>> appearently
>>> very good tsc source. Even this machine warps.
>>>
>>> It stops warping if we only write pvclock data structure once and 
>>> forget it,
>>> (which only updated tsc_timestamp once), according to him.
>> Yes. So its not as if the guest visible TSCs go out of sync (they don't
>> on this machine Glauber mentioned, or even on a multi-core Core 2 Duo),
>> but the delta calculation is very hard (if not impossible) to get right.
>>
>> The timewarps i've seen were in the 0-200ns range, and very rare (once
>> every 10 minutes or so).
>
> Might be due to NMIs or SMIs interrupting the rdtsc(); ktime_get() 
> operation which establishes the timeline.  We could limit it by having 
> a loop doing rdtsc(); ktime_get(); rdtsc(); and checking for some 
> bound, but it isn't worthwhile (and will break nested virtualization 
> for sure).  Better to have the option to calibrate kvmclock just once 
> on machines with X86_FEATURE_NONSTOP_TRULY_RELIABLE _TSC_HONESTLY.

There's a perfect way to do this and it still fails to stop timewarps.  
You can set the performance counters to overflow if more instructions 
are issued than your code path, run an assembly instruction stream and 
if the performance interrupt hits, restart the calibration.

The calibration happens not just once, but on every migration, and 
currently, I believe, on every VCPU switch.  Even if we reduce the 
number of calibrations to the bare minimum and rule out SMIs and NMIs, 
there will still be variation due to factors beyond our control because 
of the unpredictable nature of cache and instruction issue.

However, X86_FEATURE_NONSTOP_TRULY_RELIABLE_TSC_HONESTLY does imply one 
key feature which the code is missing today:  on SMP VMs, the 
calibration of kvmclock needs to be done only once, and the clock can 
then be used for all VCPUs.  That, I think, stops Glauber's bug from 
appearing on the server side.

I will spin that into my web of patches and send the cocoon out sometime 
this evening.

Zach
