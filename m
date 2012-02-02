Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2BBWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:16:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52662 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2BBWQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>
References: <4F2AB552.2070909@redhat.com>
	<CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>
Date: Thu, 2 Feb 2012 14:16:27 -0800
Message-ID: <CAB9FdM-oniPUOAPUJQ0Rr1uVK-MkzYQYU9c0G24sCHm8CpOdzg@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Rob Earhart <earhart@google.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending as plain text to appease vger.kernel.org :-)

On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity <avi@redhat.com> wrote:
>
> The kvm api has been accumulating cruft for several years now.  This is
> due to feature creep, fixing mistakes, experience gained by the
> maintainers and developers on how to do things, ports to new
> architectures, and simply as a side effect of a code base that is
> developed slowly and incrementally.
>
> While I don't think we can justify a complete revamp of the API now, I'm
> writing this as a thought experiment to see where a from-scratch API can
> take us.  Of course, if we do implement this, the new and old APIs will
> have to be supported side by side for several years.
>
> Syscalls
> --------
> kvm currently uses the much-loved ioctl() system call as its entry
> point.  While this made it easy to add kvm to the kernel unintrusively,
> it does have downsides:
>
> - overhead in the entry path, for the ioctl dispatch path and vcpu mutex
> (low but measurable)
> - semantic mismatch: kvm really wants a vcpu to be tied to a thread, and
> a vm to be tied to an mm_struct, but the current API ties them to file
> descriptors, which can move between threads and processes.  We check
> that they don't, but we don't want to.
>
> Moving to syscalls avoids these problems, but introduces new ones:
>
> - adding new syscalls is generally frowned upon, and kvm will need several
> - syscalls into modules are harder and rarer than into core kernel code
> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
> mm_struct
>
> Syscalls that operate on the entire guest will pick it up implicitly
> from the mm_struct, and syscalls that operate on a vcpu will pick it up
> from current.
>

<snipped>

I like the ioctl() interface.  If the overhead matters in your hot
path, I suspect you're doing it wrong; use irq fds & ioevent fds.  You
might fix the semantic mismatch by having a notion of a "current
process's VM" and "current thread's VCPU", and just use the one
/dev/kvm filedescriptor.

Or you could go the other way, and break the connection between VMs
and processes / VCPUs and threads: I don't know how easy it is to do
it in Linux, but a VCPU might be backed by a kernel thread, operated
on via ioctl()s, indicating that they've exited the guest by having
their descriptors become readable (and either use read() or mmap() to
pull off the reason why the VCPU exited).  This would allow for a
variety of different programming styles for the VMM--I'm a fan of CSP
model myself, but that's hard to do with the current API.

It'd be nice to be able to kick a VCPU out of the guest without
messing around with signals.  One possibility would be to tie it to an
eventfd; another might be to add a pseudo-register to indicate whether
the VCPU is explicitly suspended.  (Combined with the decoupling idea,
you'd want another pseudo-register to indicate whether the VMM is
implicitly suspended due to an intercept; a single "runnable" bit is
racy if both the VMM and VCPU are setting it.)

ioevent fds are definitely useful.  It might be cute if they could
synchronously set the VIRTIO_USED_F_NOTIFY bit - the guest could do
this itself, but that'd require giving the guest write access to the
used side of the virtio queue, and I kind of like the idea that it
doesn't need write access there.  Then again, I don't have any perf
data to back up the need for this.

The rest of it sounds great.

)Rob
