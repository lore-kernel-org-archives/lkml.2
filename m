Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab0LFRMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:12:19 -0500
Received: from thoth.sbs.de ([192.35.17.2]:24824 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0LFRMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:12:17 -0500
Message-ID: <4CFD195E.5060208@siemens.com>
Date: Mon, 06 Dec 2010 18:11:58 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] KVM: Allow host IRQ sharing for passed-through PCI
 2.3 devices
References: <cover.1291419444.git.jan.kiszka@web.de> <10b9265d513950f2574edf4e79be3b808e741a78.1291419444.git.jan.kiszka@web.de> <4CFD0D91.3050303@redhat.com> <4CFD108F.5000200@siemens.com> <4CFD1208.4070600@redhat.com> <4CFD1377.7030008@siemens.com> <4CFD16FC.8040905@redhat.com>
In-Reply-To: <4CFD16FC.8040905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.12.2010 18:01, Avi Kivity wrote:
> On 12/06/2010 06:46 PM, Jan Kiszka wrote:
>> Am 06.12.2010 17:40, Avi Kivity wrote:
>>>  On 12/06/2010 06:34 PM, Jan Kiszka wrote:
>>>>>
>>>>>   What's the protocol for doing this?  I suppose userspace has to disable
>>>>>   interrupts, ioctl(SET_INTX_MASK, masked), ..., ioctl(SET_INTX_MASK,
>>>>>   unmasked), enable interrupts?
>>>>
>>>>  Userspace just has to synchronize against itself - what it already does:
>>>>  qemu_mutex, and masking/unmasking is synchronous /wrt the the executing
>>>>  VCPU. Otherwise, masking/unmasking is naturally racy, also in Real Life.
>>>>  The guest resolves the remaining races.
>>>
>>>  I meant when qemu sets INTX_MASK and the kernel clears it immediately
>>>  afterwards because the two are not synchronized.  I guess that won't
>>>  happen in practice because playing with INTX_MASK is very rare.
>>
>> Ah, there is indeed a race, and the qemu-kvm patches I did not post yet
>> (to wait for the kernel interface to settle) actually suffer from it:
>> userspace needs to set the kernel mask before writing the config space
>> (it's the other way around ATM). This avoids that the kernel overwrites
>> what userspace just wrote out. We always suffer from the race the other
>> way around, see below.
> 
> Please document the protocol.

Yes, will do.

>  Is this always the right order?  
> Shouldn't it be reversed when unmasking?  I admit I'm confused about this.

The kernel only notes down userspace's view on the mask, it doesn't
modify the hardware (unless it is in line-disabling mode, but then there
is no conflict anyway). Therefore, if userspace first unmasks and an
interrupts arrives before this was reported to the kernel, the device
interrupt will remain masked and no event is delivered to userspace.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
