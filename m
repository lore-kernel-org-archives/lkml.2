Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2BPOq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:46:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46156 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2BPOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:46:25 -0500
Message-ID: <4F3D16BB.5060804@codemonkey.ws>
Date: Thu, 16 Feb 2012 08:46:19 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@ozlabs.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com>	<4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com>	<87vcnih5qt.fsf@rustcorp.com.au> <4F3BB59D.2020505@redhat.com>	<4F3C2AC5.80400@codemonkey.ws> <20120216085741.GB19771@redhat.com>
In-Reply-To: <20120216085741.GB19771@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 02:57 AM, Gleb Natapov wrote:
> On Wed, Feb 15, 2012 at 03:59:33PM -0600, Anthony Liguori wrote:
>> On 02/15/2012 07:39 AM, Avi Kivity wrote:
>>> On 02/07/2012 08:12 PM, Rusty Russell wrote:
>>>>> I would really love to have this, but the problem is that we'd need a
>>>>> general purpose bytecode VM with binding to some kernel APIs.  The
>>>>> bytecode VM, if made general enough to host more complicated devices,
>>>>> would likely be much larger than the actual code we have in the kernel now.
>>>>
>>>> We have the ability to upload bytecode into the kernel already.  It's in
>>>> a great bytecode interpreted by the CPU itself.
>>>
>>> Unfortunately it's inflexible (has to come with the kernel) and open to
>>> security vulnerabilities.
>>
>> I wonder if there's any reasonable way to run device emulation
>> within the context of the guest.  Could we effectively do something
>> like SMM?
>>
>> For a given set of traps, reflect back into the guest quickly
>> changing the visibility of the VGA region. It may require installing
>> a new CR3 but maybe that wouldn't be so bad with VPIDs.
>>
> What will it buy us? Surely not speed. Entering a guest is not much
> (if at all) faster than exiting to userspace and any non trivial
> operation will require exit to userspace anyway,

You can emulate the PIT/RTC entirely within the guest using kvmclock which 
doesn't require an additional exit to get the current time base.

So instead of:

1) guest -> host kernel
2) host kernel -> userspace
3) implement logic using rdtscp via VDSO
4) userspace -> host kernel
5) host kernel -> guest

You go:

1) guest -> host kernel
2) host kernel -> guest (with special CR3)
3) implement logic using rdtscp + kvmclock page
4) change CR3 within guest and RETI to VMEXIT source RIP

Same basic concept as PS/2 emulation with SMM.

Regards,

Anthony Liguori
