Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0DUIGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:06:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0DUIGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:06:10 -0400
Message-ID: <4BCEB1EE.9050002@redhat.com>
Date: Wed, 21 Apr 2010 11:06:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <20100419142624.GE14158@mothafucka.localdomain> <4BCC829A.6000803@goop.org> <20100419182542.GI14158@mothafucka.localdomain> <20100420015733.GA28249@amt.cnet> <4BCD7557.9090502@redhat.com> <4BCE403E.7050605@redhat.com>
In-Reply-To: <4BCE403E.7050605@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 03:01 AM, Zachary Amsden wrote:
>>> on this machine Glauber mentioned, or even on a multi-core Core 2 Duo),
>>> but the delta calculation is very hard (if not impossible) to get 
>>> right.
>>>
>>> The timewarps i've seen were in the 0-200ns range, and very rare (once
>>> every 10 minutes or so).
>>
>> Might be due to NMIs or SMIs interrupting the rdtsc(); ktime_get() 
>> operation which establishes the timeline.  We could limit it by 
>> having a loop doing rdtsc(); ktime_get(); rdtsc(); and checking for 
>> some bound, but it isn't worthwhile (and will break nested 
>> virtualization for sure).  Better to have the option to calibrate 
>> kvmclock just once on machines with 
>> X86_FEATURE_NONSTOP_TRULY_RELIABLE _TSC_HONESTLY.
> Yes. So its not as if the guest visible TSCs go out of sync (they don't
>
> There's a perfect way to do this and it still fails to stop 
> timewarps.  You can set the performance counters to overflow if more 
> instructions are issued than your code path, run an assembly 
> instruction stream and if the performance interrupt hits, restart the 
> calibration.

It's completely impractical.   The PMU is a global resource that is 
already shared among users and the host; programming and restoring it is 
expensive; and in a virtualized environment it the whole scheme may fail.

>
> The calibration happens not just once, but on every migration, and 
> currently, I believe, on every VCPU switch.  Even if we reduce the 
> number of calibrations to the bare minimum and rule out SMIs and NMIs, 
> there will still be variation due to factors beyond our control 
> because of the unpredictable nature of cache and instruction issue.

Right.

>
> However, X86_FEATURE_NONSTOP_TRULY_RELIABLE_TSC_HONESTLY does imply 
> one key feature which the code is missing today:  on SMP VMs, the 
> calibration of kvmclock needs to be done only once, and the clock can 
> then be used for all VCPUs.  That, I think, stops Glauber's bug from 
> appearing on the server side.

That's the plan.


-- 
error compiling committee.c: too many arguments to function

