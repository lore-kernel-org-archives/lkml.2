Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AFLat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:30:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1AFLar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:30:47 -0500
Message-ID: <4D25A7E3.4090101@redhat.com>
Date: Thu, 06 Jan 2011 01:30:43 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and
 VMX
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com> <9EEA19E7-668A-4CD0-B006-6B494D9FD242@suse.de>
In-Reply-To: <9EEA19E7-668A-4CD0-B006-6B494D9FD242@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:41 AM, Alexander Graf wrote:
> Am 06.01.2011 um 11:10 schrieb Zachary Amsden<zamsden@redhat.com>:
>
>    
>> Reasons to trap the TSC are numerous, but we want to avoid it as much
>> as possible for performance reasons.
>>
>> We provide two conservative modes via modules parameters and userspace
>> hinting.  First, the module can be loaded with "tsc_auto=1" as a module
>> parameter, which turns on conservative TSC trapping only when it is
>> required (when unstable TSC or faster KHZ CPU is detected).
>>
>> For userspace hinting, we enable trapping only if necessary.  Userspace
>> can hint that a VM needs a fixed frequency TSC, and also that SMP
>> stability will be required.  In that case, we conservatively turn on
>> trapping when it is needed.  In addition, users may now specify the
>> desired TSC rate at which to run.  If this rate differs significantly
>> from the host rate, trapping will be enabled.
>>
>> There is also an override control to allow TSC trapping to be turned on
>> or off unconditionally for testing.
>>
>> We indicate to pvclock users that the TSC is being trapped, to allow
>> avoiding overhead and directly using RDTSCP (only for SVM).  This
>> optimization is not yet implemented.
>>      
> When migrating, the implementation could switch from non-trapped to trapped, making it less attractive. The guest however does not get notified about this change. Same for the other way around.
>    

That's a policy decision to be made by the userspace agent.  It's better 
than the current situation, where there is no control at all of TSC 
rate.  Here, we're flexible either way.

Also note, moving to a faster processor, trapping kicks in... but the 
processor is faster, so no actual loss is noticed, and the problem 
corrects when the VM is power cycled.

> Would it make sense to add a kvmclock interrupt to notify the guest of such a change?

kvmclock is immune to frequency changes, so it needs no interrupt, it 
just has a version controlled shared area, which is reset.
