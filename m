Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1LYMh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 07:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab1LYMh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 07:37:57 -0500
Message-ID: <4EF71919.40201@redhat.com>
Date: Sun, 25 Dec 2011 14:37:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: Prevent exposing TSC deadline timer feature
 in the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com> <4EF1B081.3010109@siemens.com> <4EF1B423.8050707@siemens.com> <4EF1B67D.7010603@redhat.com> <DE8DF0795D48FD4CA783C40EC82923358DEA@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923358DEA@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 05:41 PM, Liu, Jinsong wrote:
> Avi Kivity wrote:
> > On 12/21/2011 12:25 PM, Jan Kiszka wrote:
> >> We must not report the TSC deadline timer feature on our own when
> >> user space provides the APIC as we have no clue about its features.
> > 
> > We must not report the TSC deadline timer feature on our own, period.
> > We should just update the timer mode mask there.  Don't know how this
> > slipped through review.
> > 
> > I think your original idea was correct.  Add a new KVM_CAP for the tsc
> > deadline timer.  Userspace can add the bit to cpuid if either it
> > implements the feature in a userspace apic, or if it finds the new
> > capability and uses the kernel apic.
>
> Is it necessary to use KVM_CAP? If I didn't misunderstand, the KVM_CAP sulotion would be:
> 1. qemu get kvm tsc deadline timer capability by KVM_CAP_...;
> 2. qemu add cpuid bit
>         if ((guest use qemu apic && qemu emualte tsc deadline timer) || 
>            (guest use kvm apic && kvm emulate tsc deadline timer (KVM_CAP)))
> 3. qemu ioctl KVM_SET_CPUID2
> 4. kvm expose the feature to guest by saving it at vcpu->arch.cpuid_entries, 

Correct.

> seems it's logically redundant.

What's logically redundant?

> Jan's patch v2 is a straight forward and simple fix. in the patch
>     if (apic) { ... }
> means apic (and then its sub-logic tsc deadline timer) emulated by kvm, that's enough:
> if quest use kvm apic, it's OK to add cpuid bit and expose to guest;
> if guest don't use kvm apic, it will not touch cpuid bit;
>

It breaks live migration: if you start a guest on a TSC-deadline capable
host kernel, and migrate it to a TSC-deadline incapable host kernel, you
end up with a broken guest.

More broadly, kvm never exposes features transparently to the guest, it
always passes them to userspace first, so userspace controls the ABI
exposed to the guest.  This prevents the following scenario:

- a guest is started on some hardware, which doesn't support some cpuid
feature (say AVX for example)
- the guest or one of its applications are broken wrt AVX, but because
the feature is not exposed, it works correctly
- the host hardware is upgraded to one which supports AVX
- the guest is now broken

(the downside is that guests run slower than they would with automatic
feature exposure, but that's better than breaking them)

-- 
error compiling committee.c: too many arguments to function

