Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2BGMBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:01:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab2BGMBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:01:51 -0500
Message-ID: <4F3112A4.3090407@redhat.com>
Date: Tue, 07 Feb 2012 14:01:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Rob Earhart <earhart@google.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com> <4F2E80A7.5040908@redhat.com> <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>
In-Reply-To: <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 07:41 PM, Rob Earhart wrote:
> >>
> >>  I like the ioctl() interface.  If the overhead matters in your hot path,
> >
> >  I can't say that it's a pressing problem, but it's not negligible.
> >
> >>  I suspect you're doing it wrong;
> >
> >  What am I doing wrong?
>
> "You the vmm" not "you the KVM maintainer" :-)
>
> To be a little more precise: If a VCPU thread is going all the way out
> to host usermode in its hot path, that's probably a performance
> problem regardless of how fast you make the transitions between host
> user and host kernel.

Why?

> That's why ioctl() doesn't bother me.  I think it'd be more useful to
> focus on mechanisms which don't require the VCPU thread to exit at all
> in its hot paths, so the overhead of the ioctl() really becomes lost
> in the noise.  irq fds and ioevent fds are great for that, and I
> really like your MMIO-over-socketpair idea.

I like them too, but they're not suitable for all cases.

An ioeventfd, or unordered write-over-mmio-socketpair can take one of 
two paths:

  - waking up an idle mmio service thread on a different core, involving 
a double context switch on that remote core
  - scheduling the idle mmio service thread on the current core, 
involving both a double context switch and a heavyweight exit

An ordered write-over-mmio-socketpair, or a read-over-mmio-socketpair 
can also take one of two paths
  - waking up an idle mmio service thread on a different core, involving 
a double context switch on that remote core, and also  invoking two 
context switches on the current core (while we wait for a reply); if the 
current core schedules a user task we might also have a heavyweight exit
  - scheduling the idle mmio service thread on the current core, 
involving both a double context switch and a heavyweight exit

As you can see the actual work is greater for threaded io handlers than 
the synchronous ones.  The real advantage is that you can perform more 
work in parallel if you have the spare cores (not a given in 
consolidation environments) and if you actually have a lot of work to do 
(like virtio-net in a throughput load).  It doesn't quite fit a "read 
hpet register" load.



>
> >>  This would allow for a variety of different programming styles for the
> >>  VMM--I'm a fan of CSP model myself, but that's hard to do with the
> >>  current API.
> >
> >  Just convert the synchronous API to an RPC over a pipe, in the vcpu
> >  thread, and you have the asynchronous model you asked for.
>
> Yup.  But you still get multiple threads in your process.  It's not a
> disaster, though.
>

You have multiple threads anyway, even if it's the kernel that creates them.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

