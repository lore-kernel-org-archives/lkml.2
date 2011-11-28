Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1K1Iqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:46:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1K1Iqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:46:48 -0500
Date: Mon, 28 Nov 2011 10:46:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Liu ping fan <kernelfans@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, aliguori@us.ibm.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, ryanh@us.ibm.com,
        jan.kiszka@web.de
Subject: Re: [Qemu-devel] [PATCH 2/2] kvm: exit to userspace with reason
 KVM_EXIT_VCPU_DEAD
Message-ID: <20111128084643.GP2557@redhat.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
 <1322361735-21428-1-git-send-email-kernelfans@gmail.com>
 <4ED212C7.1080901@redhat.com>
 <20111127105000.GL2557@redhat.com>
 <CAFgQCTscektJsC-2ThQn7FhHA7=Qf4t3t0+X+i0zT_yZZjwL0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAFgQCTscektJsC-2ThQn7FhHA7=Qf4t3t0+X+i0zT_yZZjwL0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:16:01PM +0800, Liu ping fan wrote:
> On Sun, Nov 27, 2011 at 6:50 PM, Gleb Natapov <gleb@redhat.com> wrote:
> > On Sun, Nov 27, 2011 at 12:36:55PM +0200, Avi Kivity wrote:
> >> On 11/27/2011 04:42 AM, Liu Ping Fan wrote:
> >> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >> >
> >> > The vcpu can be safely released when
> >> > --1.guest tells us that the vcpu is not needed any longer.
> >> > --2.vcpu hits the last instruction _halt_
> >> >
> >> > If both of the conditions are satisfied, kvm exits to userspace
> >> > with the reason vcpu dead. So the user thread can exit safely.
> >> >
> >> >
> >>
> >> Seems to be completely unnecessary. šIf you want to exit from the vcpu
> >> thread, send it a signal.
> >>
> Hi Avi and Gleb,
> 
> First, I wanted to make sure my assumption is right, so I can grab
> your meaning more clearly -:). Could you elaborate it for me, thanks.
> 
> I had thought that when a vcpu was being removed from guest, kvm must
> satisfy the following conditions to safely remove the vcpu:
> --1. The tasks on vcpu in GUEST  have already been migrated to other
> vcpus and ONLY idle_task left ---- The CPU_DEAD is the checkpoint.
> --2. We must wait the idle task to hit native_halt() in GUEST, till
> that time, this vcpu is no needed even by idle_task. In KVM, the vcpu
> thread will finally sit on "kvm_vcpu_block(vcpu);"
> We CAN NOT suppose the sequence of the two condition because they come
> from different threads.  Am I right?
> 
No, KVM can remove vcpu whenever it told to do so (may be not in the
middle of emulated io though). It is a guest responsibility to eject cpu
only when it is safe to do so from guest's point of view.

> And here comes my question,
> --1. I think the signal will make vcpu_run exit to user, but is it
> allow vcpu thread to finally call  "kernel/exit.c : void do_exit(long
> code)" in current code in kvm or in qemu?
Yes. Why not?

> --2. If we got CPU_DEAD event, and then send a signal to vcpu thread,
> could we ensure that we have already sit on "kvm_vcpu_block(vcpu);"
CPU_DEAD event is internal to a guest (one of them). KVM does not care
about it. And to remove vcpu it does not have to sit in kvm_vcpu_block().
And actually since signal kicks vcpu thread out from kernel into userspace
you can be sure it is not sitting in kvm_vcpu_block(). 

> 
> Thanks and regards,
> ping fan
> 
> > Also if guest "tells us that the vcpu is not needed any longer" (via
> > ACPI I presume) and vcpu actually doing something critical instead of
> > sitting in 1:hlt; jmp 1b loop then it is guest's problem if it stops
> > working after vcpu destruction.
> >
> 
> 
> > --
> > š š š š š š š š š š š šGleb.
> >

--
			Gleb.
