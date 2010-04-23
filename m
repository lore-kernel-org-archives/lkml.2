Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0DWBo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:44:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0DWBo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:44:57 -0400
Message-ID: <4BD0FB92.4060301@redhat.com>
Date: Thu, 22 Apr 2010 15:44:50 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271675100.1674.818.camel@laptop> <4BCC3A3E.9070909@redhat.com> <20100419142158.GD14158@mothafucka.localdomain> <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org> <4BCDF85C.3000004@redhat.com> <4BCE0399.2010708@goop.org> <20100422131113.GA3364@mothafucka.localdomain>
In-Reply-To: <20100422131113.GA3364@mothafucka.localdomain>
Content-Type: multipart/mixed;
 boundary="------------080605020202000901040902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080605020202000901040902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/22/2010 03:11 AM, Glauber Costa wrote:
> On Tue, Apr 20, 2010 at 12:42:17PM -0700, Jeremy Fitzhardinge wrote:
>    
>> On 04/20/2010 11:54 AM, Avi Kivity wrote:
>>      
>>> On 04/20/2010 09:23 PM, Jeremy Fitzhardinge wrote:
>>>        
>>>> On 04/20/2010 02:31 AM, Avi Kivity wrote:
>>>>
>>>>          
>>>>> btw, do you want this code in pvclock.c, or shall we keep it kvmclock
>>>>> specific?
>>>>>
>>>>>            
>>>> I think its a pvclock-level fix.  I'd been hoping to avoid having
>>>> something like this, but I think its ultimately necessary.
>>>>
>>>>          
>>> Did you observe drift on Xen, or is this "ultimately" pointing at the
>>> future?
>>>        
>> People are reporting weirdnesses that "clocksource=jiffies" apparently
>> resolves.  Xen and KVM are faced with the same hardware constraints, and
>> it wouldn't surprise me if there were small measurable
>> non-monotonicities in the PV clock under Xen.  May as well be safe.
>>
>> Of course, it kills any possibility of being able to usefully export
>> this interface down to usermode.
>>
>> My main concern about this kind of simple fix is that if there's a long
>> term systematic drift between different CPU's tscs, then this will
>> somewhat mask the problem while giving really awful time measurement on
>> the "slow" CPU(s).  In that case it really needs to adjust the scaling
>> factor to correct for the drift (*not* update the offset).  But if we're
>> definitely only talking about fixed, relatively small time offsets then
>> it is fine.
>>      
> Can you by any chance run ingo's time warp test on those machines?
>
> You need to define TOD to 1, and leave out the TSC test.
>
> For me, warps exists on every machine out there, but the nehalems, so far
>    
Or apply this patch.

--------------080605020202000901040902
Content-Type: text/plain;
 name="time-warp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="time-warp.patch"

diff -rup a/time-warp-test.c b/time-warp-test.c
--- a/time-warp-test.c	2010-04-15 16:30:13.955981607 -1000
+++ b/time-warp-test.c	2010-04-15 16:35:37.777982377 -1000
@@ -91,7 +91,7 @@ static inline unsigned long long __rdtsc
 {
 	DECLARE_ARGS(val, low, high);
 
-	asm volatile("cpuid; rdtsc" : EAX_EDX_RET(val, low, high));
+	asm volatile("cpuid; rdtsc" : EAX_EDX_RET(val, low, high) :: "ebx", "ecx");
 
 	return EAX_EDX_VAL(val, low, high);
 }

--------------080605020202000901040902--
