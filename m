Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1LKMl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 07:41:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1LKMlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 07:41:23 -0500
Message-ID: <4EE4A4DA.90100@redhat.com>
Date: Sun, 11 Dec 2011 14:40:58 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <4EDF7B0D.4060001@redhat.com>
In-Reply-To: <4EDF7B0D.4060001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 04:41 PM, Avi Kivity wrote:
> On 12/05/2011 10:18 PM, Eric B Munson wrote:
>> Changes from V4:
>> Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
>> Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt
>>
>> Changes from V3:
>> Include CC's on patch 3
>> Drop clear flag ioctl and have the watchdog clear the flag when it is reset
>>
>> Changes from V2:
>> A new kvm functions defined in kvm_para.h, the only change to pvclock is the
>> initial flag definition
>>
>> Changes from V1:
>> (Thanks Marcelo)
>> Host code has all been moved to arch/x86/kvm/x86.c
>> KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED
>>
>> When a guest kernel is stopped by the host hypervisor it can look like a soft
>> lockup to the guest kernel.  This false warning can mask later soft lockup
>> warnings which may be real.  This patch series adds a method for a host
>> hypervisor to communicate to a guest kernel that it is being stopped.  The
>> final patch in the series has the watchdog check this flag when it goes to
>> issue a soft lockup warning and skip the warning if the guest knows it was
>> stopped.
>>
>> It was attempted to solve this in Qemu, but the side effects of saving and
>> restoring the clock and tsc for each vcpu put the wall clock of the guest behind
>> by the amount of time of the pause.  This forces a guest to have ntp running
>> in order to keep the wall clock accurate.

Guests need to run NTP regardless, not only the virtualization layer add 
some skew, the physical world is not that perfect.
btw: traditional NTP client won't sync the time automatically if the 
diff is > 0.5%.

>
> Having this controlled from userspace means it doesn't work for SIGSTOP
> or for long scheduling delays.  What about doing this automatically
> based on preempt notifiers?
>
>

Isn't it solved by steal time?
