Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1IAU2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 16:28:01 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:42900 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757892Ab1IAU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 16:27:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Sep 2011 14:27:49 -0600
From: emunson@mgebm.net
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, <avi@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <arnd@arndb.de>, <riel@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <aliguori@us.ibm.com>,
        <raharper@us.ibm.com>, <kvm-ia64@vger.kernel.org>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
In-Reply-To: <4E5FDBDC.2030302@codemonkey.ws>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet> <4E5FDBDC.2030302@codemonkey.ws>
Message-ID: <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, 01 Sep 2011 14:24:12 -0500, Anthony Liguori wrote:
> On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
>> On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
>>> Currently, when qemu stops a guest kernel that guest will issue a 
>>> soft lockup
>>> message when it resumes.  This set provides the ability for qemu to 
>>> comminucate
>>> to the guest that it has been stopped.  When the guest hits the 
>>> watchdog on
>>> resume it will check if it was suspended before issuing the 
>>> warning.
>>>
>>> Eric B Munson (4):
>>>    Add flag to indicate that a vm was stopped by the host
>>>    Add functions to check if the host has stopped the vm
>>>    Add generic stubs for kvm stop check functions
>>>    Add check for suspended vm in softlockup detector
>>>
>>>   arch/x86/include/asm/pvclock-abi.h |    1 +
>>>   arch/x86/include/asm/pvclock.h     |    2 ++
>>>   arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
>>>   include/asm-generic/pvclock.h      |   14 ++++++++++++++
>>>   kernel/watchdog.c                  |   12 ++++++++++++
>>>   5 files changed, 43 insertions(+), 0 deletions(-)
>>>   create mode 100644 include/asm-generic/pvclock.h
>>>
>>> --
>>> 1.7.4.1
>>
>> How is the host supposed to set this flag?
>>
>> As mentioned previously, if you save save/restore the offset added 
>> to
>> kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
>> paravirt infrastructure is required. Which means the issue is also 
>> fixed
>> for older guests.
>
> IIRC, the steal time patches have some logic that basically say:
>
> if there was steal time:
>    kick soft lockup detector
>
> I wonder if that serves this purpose provided that time spent in stop
> is accounted as steal time.  If it isn't, perhaps it should be?
>
> Regards,
>
> Anthony Liguori
>

 I could be missing it, but I don't see anywhere in the steal time 
 patches that kicks the watchdog.

 Accounting stopped time as stolen time opens a possible problem when 
 the accounting (CPU power modification) part is turned on.  As a process 
 accumulates steal time its CPU power is increased.  If we account 
 stopped time as stolen, it will do strange things with CPU power for 
 that process.  I believe that it is for this reason that patch 4 of 
 Glauber's series explicitly states that halted time is not stolen time.  
 Stolen time is only accumulated when a vCPU actually has work to do.

 Eric
