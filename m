Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0LFRCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:02:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0LFRCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:02:06 -0500
Message-ID: <4CFD16FC.8040905@redhat.com>
Date: Mon, 06 Dec 2010 19:01:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Jan Kiszka <jan.kiszka@web.de>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5/5] KVM: Allow host IRQ sharing for passed-through PCI
 2.3 devices
References: <cover.1291419444.git.jan.kiszka@web.de> <10b9265d513950f2574edf4e79be3b808e741a78.1291419444.git.jan.kiszka@web.de> <4CFD0D91.3050303@redhat.com> <4CFD108F.5000200@siemens.com> <4CFD1208.4070600@redhat.com> <4CFD1377.7030008@siemens.com>
In-Reply-To: <4CFD1377.7030008@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:46 PM, Jan Kiszka wrote:
> Am 06.12.2010 17:40, Avi Kivity wrote:
> >  On 12/06/2010 06:34 PM, Jan Kiszka wrote:
> >>>
> >>>   What's the protocol for doing this?  I suppose userspace has to disable
> >>>   interrupts, ioctl(SET_INTX_MASK, masked), ..., ioctl(SET_INTX_MASK,
> >>>   unmasked), enable interrupts?
> >>
> >>  Userspace just has to synchronize against itself - what it already does:
> >>  qemu_mutex, and masking/unmasking is synchronous /wrt the the executing
> >>  VCPU. Otherwise, masking/unmasking is naturally racy, also in Real Life.
> >>  The guest resolves the remaining races.
> >
> >  I meant when qemu sets INTX_MASK and the kernel clears it immediately
> >  afterwards because the two are not synchronized.  I guess that won't
> >  happen in practice because playing with INTX_MASK is very rare.
>
> Ah, there is indeed a race, and the qemu-kvm patches I did not post yet
> (to wait for the kernel interface to settle) actually suffer from it:
> userspace needs to set the kernel mask before writing the config space
> (it's the other way around ATM). This avoids that the kernel overwrites
> what userspace just wrote out. We always suffer from the race the other
> way around, see below.

Please document the protocol.  Is this always the right order?  
Shouldn't it be reversed when unmasking?  I admit I'm confused about this.

> >>
> >>  I think this is what VFIO does and is surely cleaner than this approach.
> >>  But it's not possible with the existing interface (sysfs + KVM ioctls) -
> >>  or can you restrict the sysfs access to the config space in such details?
> >
> >  I'm sure you can, not sure it's worth it.  Can the situation be
> >  exploited?  what if userspace lies?
>
> That's also the above scenario inverted: Userspace can mask or unmask at
> any time. If it unmasks a yet unhandled, thus raise interrupt, it will
> trigger another one. The kernel will catch it and mask it again. That
> can repeat forever with the frequency userspace is able to run its
> unmasking code. Not nice, but nothing to leverage for a DoS.

Ok (I think).

-- 
error compiling committee.c: too many arguments to function

