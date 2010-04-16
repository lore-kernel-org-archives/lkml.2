Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab0DPVFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0DPVF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:05:28 -0400
Message-ID: <4BC8D115.2010900@redhat.com>
Date: Fri, 16 Apr 2010 11:05:25 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org>
In-Reply-To: <4BC8CA52.4090703@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2010 10:36 AM, Jeremy Fitzhardinge wrote:
> On 04/15/2010 11:37 AM, Glauber Costa wrote:
>    
>> In recent stress tests, it was found that pvclock-based systems
>> could seriously warp in smp systems. Using ingo's time-warp-test.c,
>> I could trigger a scenario as bad as 1.5mi warps a minute in some systems.
>>
>>      
> Is that "1.5 million"?
>
>    
>> (to be fair, it wasn't that bad in most of them). Investigating further, I
>> found out that such warps were caused by the very offset-based calculation
>> pvclock is based on.
>>
>>      
> Is the problem that the tscs are starting out of sync, or that they're
> drifting relative to each other over time?  Do the problems become worse
> the longer the uptime?  How large are the offsets we're talking about here?
>    

This is one source of the problem, but the same thing happens at many 
levels... tsc may start out of sync, drift between sockets, be badly 
re-calibrated by the BIOS, etc... the issue persists even if the TSCs 
are perfectly in sync - the measurement of them is not.

So reading TSC == 100,000 units at time A and then waiting 10 units, one 
may read TSC == 100,010 +/- 5 units because the code stream is not 
perfectly serialized - nor can it be.  There will always be some amount 
of error unless running in perfect lock-step, which only happens in a 
simulator.

This inherent measurement error can cause apparent time to go backwards 
when measured simultaneously across multiple CPUs, or when 
re-calibrating against an external clocksource.  Combined with other 
factors as above, it can be of sufficient magnitude to be noticed.  KVM 
clock is particularly exposed to the problem because the TSC is measured 
and recalibrated for each virtual CPU whenever there is a physical CPU 
switch, so micro-adjustments forwards and backwards may occur during the 
recalibration - and appear as a real backwards time warp to the guest.  
I have some patches to fix that issue, but the SMP problem remains to be 
fixed - and is addressed quite thoroughly by this patch.

Zach
