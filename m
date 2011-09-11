Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1IKKAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 06:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1IKKAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 06:00:17 -0400
Message-ID: <4E6C8688.6090706@redhat.com>
Date: Sun, 11 Sep 2011 12:59:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com> <4E66EF86.9070200@redhat.com> <20110907134411.GV5795@redhat.com> <4E678992.5050709@redhat.com> <20110907155657.GX5795@redhat.com> <4E679AF4.50209@redhat.com> <20110907165203.GQ6838@redhat.com> <4E67A551.4000502@redhat.com> <4E67A71A.5070903@goop.org> <4E67ACB6.40107@redhat.com> <4E67C15B.3000408@goop.org> <4E6873FE.3040603@redhat.com> <4E68FB64.9080308@goop.org>
In-Reply-To: <4E68FB64.9080308@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 08:29 PM, Jeremy Fitzhardinge wrote:
> >  I don't think it's that expensive, especially compared to the
> >  double-context-switch and vmexit of the spinner going to sleep.  On
> >  AMD we do have to take an extra vmexit (on IRET) though.
>
> Fair enough - so if the vcpu blocks itself, it ends up being rescheduled
> in the NMI handler, which then returns to the lock slowpath.  And if its
> a normal hlt, then you can also take interrupts if they're enabled while
> spinning.

Yes.  To be clear, just execute 'hlt' and inherit the interrupt enable 
flag from the environment.

> And if you get nested NMIs (since you can get multiple spurious kicks,
> or from other NMI sources), then one NMI will get latched and any others
> will get dropped?

While we're in the NMI handler, any further NMIs will be collapsed and 
queued (so one NMI can be in service and just one other queued behind 
it).  We can detect this condition by checking %rip on stack.

>
> >  Well we could have a specialized sleep/wakeup hypercall pair like Xen,
> >  but I'd like to avoid it if at all possible.
>
> Yeah, that's something that just falls out of the existing event channel
> machinery, so it isn't something that I specifically added.  But it does
> mean that you simply end up with a hypercall returning on kick, with no
> real complexities.

It also has to return on interrupt, MNI, INIT etc.  "No real 
complexities" is a meaningless phrase on x86, though it is fertile 
ground for math puns.

-- 
error compiling committee.c: too many arguments to function

