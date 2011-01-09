Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab1AIIGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 03:06:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1AIIGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 03:06:03 -0500
Message-ID: <4D296C67.4020309@redhat.com>
Date: Sat, 08 Jan 2011 22:05:59 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and
 VMX
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com> <20110107112334.GB12056@amt.cnet>
In-Reply-To: <20110107112334.GB12056@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 01:23 AM, Marcelo Tosatti wrote:
> On Thu, Jan 06, 2011 at 12:10:44AM -1000, Zachary Amsden wrote:
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
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h    |    6 +-
>>   arch/x86/include/asm/pvclock-abi.h |    1 +
>>   arch/x86/kvm/svm.c                 |   20 ++++++
>>   arch/x86/kvm/vmx.c                 |   21 +++++++
>>   arch/x86/kvm/x86.c                 |  113 +++++++++++++++++++++++++++++++++---
>>   arch/x86/kvm/x86.h                 |    2 +
>>   include/linux/kvm.h                |   15 +++++
>>   7 files changed, 168 insertions(+), 10 deletions(-)
>>      
> - Docs / test case please.
>    

Yes, will do.

> - KVM_TSC_CONTROL ioctl ignores flags field.
>    

Oops.

> - What is the purpose of PVCLOCK_TSC_TRAPPED_BIT?
>    

To allow RDTSCP optimizations for KVM clock when TSC is trapped (because 
a userspace application requires strict TSC).

> - Fail to see purpose of module parameters. Configuration from qemu
>    should be enough?
>    

For users with older versions of qemu who wish to take advantage of the 
feature, or performance / bug testing.  And oops here, the tsc_trap 
should not default to on.
