Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2BFRlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:41:08 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:42550 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2BFRlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <4F2E80A7.5040908@redhat.com>
References: <4F2AB552.2070909@redhat.com>
	<CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>
	<4F2E80A7.5040908@redhat.com>
Date: Mon, 6 Feb 2012 09:41:05 -0800
Message-ID: <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Rob Earhart <earhart@google.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 5:14 AM, Avi Kivity <avi@redhat.com> wrote:
> On 02/03/2012 12:13 AM, Rob Earhart wrote:
>> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity <avi@redhat.com
>> <mailto:avi@redhat.com>> wrote:
>>
>>     The kvm api has been accumulating cruft for several years now.
>>      This is
>>     due to feature creep, fixing mistakes, experience gained by the
>>     maintainers and developers on how to do things, ports to new
>>     architectures, and simply as a side effect of a code base that is
>>     developed slowly and incrementally.
>>
>>     While I don't think we can justify a complete revamp of the API
>>     now, I'm
>>     writing this as a thought experiment to see where a from-scratch
>>     API can
>>     take us.  Of course, if we do implement this, the new and old APIs
>>     will
>>     have to be supported side by side for several years.
>>
>>     Syscalls
>>     --------
>>     kvm currently uses the much-loved ioctl() system call as its entry
>>     point.  While this made it easy to add kvm to the kernel
>>     unintrusively,
>>     it does have downsides:
>>
>>     - overhead in the entry path, for the ioctl dispatch path and vcpu
>>     mutex
>>     (low but measurable)
>>     - semantic mismatch: kvm really wants a vcpu to be tied to a
>>     thread, and
>>     a vm to be tied to an mm_struct, but the current API ties them to file
>>     descriptors, which can move between threads and processes.  We check
>>     that they don't, but we don't want to.
>>
>>     Moving to syscalls avoids these problems, but introduces new ones:
>>
>>     - adding new syscalls is generally frowned upon, and kvm will need
>>     several
>>     - syscalls into modules are harder and rarer than into core kernel
>>     code
>>     - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>>     mm_struct
>>
>>     Syscalls that operate on the entire guest will pick it up implicitly
>>     from the mm_struct, and syscalls that operate on a vcpu will pick
>>     it up
>>     from current.
>>
>>
>> <snipped>
>>
>> I like the ioctl() interface.  If the overhead matters in your hot path,
>
> I can't say that it's a pressing problem, but it's not negligible.
>
>> I suspect you're doing it wrong;
>
> What am I doing wrong?

"You the vmm" not "you the KVM maintainer" :-)

To be a little more precise: If a VCPU thread is going all the way out
to host usermode in its hot path, that's probably a performance
problem regardless of how fast you make the transitions between host
user and host kernel.

That's why ioctl() doesn't bother me.  I think it'd be more useful to
focus on mechanisms which don't require the VCPU thread to exit at all
in its hot paths, so the overhead of the ioctl() really becomes lost
in the noise.  irq fds and ioevent fds are great for that, and I
really like your MMIO-over-socketpair idea.

>> use irq fds & ioevent fds.  You might fix the semantic mismatch by
>> having a notion of a "current process's VM" and "current thread's
>> VCPU", and just use the one /dev/kvm filedescriptor.
>>
>> Or you could go the other way, and break the connection between VMs
>> and processes / VCPUs and threads: I don't know how easy it is to do
>> it in Linux, but a VCPU might be backed by a kernel thread, operated
>> on via ioctl()s, indicating that they've exited the guest by having
>> their descriptors become readable (and either use read() or mmap() to
>> pull off the reason why the VCPU exited).
>
> That breaks the ability to renice vcpu threads (unless you want the user
> renice kernel threads).

I think it'd be fine to have an ioctl()/syscall() to do it.  But I
don't know how well that'd compose with other tools people might use
for managing priorities.

>> This would allow for a variety of different programming styles for the
>> VMM--I'm a fan of CSP model myself, but that's hard to do with the
>> current API.
>
> Just convert the synchronous API to an RPC over a pipe, in the vcpu
> thread, and you have the asynchronous model you asked for.

Yup.  But you still get multiple threads in your process.  It's not a
disaster, though.

)Rob
