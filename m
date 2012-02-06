Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2BFTMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:12:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37400 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2BFTL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:11:59 -0500
Message-ID: <4F3025FB.1070802@codemonkey.ws>
Date: Mon, 06 Feb 2012 13:11:55 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Rob Earhart <earhart@google.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAB9FdM9M2DWXBxxyG-ez_5igT61x5b7ptw+fKfgaqMBU_JS5aA@mail.gmail.com>	<4F2E80A7.5040908@redhat.com> <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>
In-Reply-To: <CAB9FdM9pPJx8x4y=uvRFh-T4fKBR9xChocUVG_GfNGffTWtMNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 11:41 AM, Rob Earhart wrote:
> On Sun, Feb 5, 2012 at 5:14 AM, Avi Kivity<avi@redhat.com>  wrote:
>> On 02/03/2012 12:13 AM, Rob Earhart wrote:
>>> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com
>>> <mailto:avi@redhat.com>>  wrote:
>>>
>>>      The kvm api has been accumulating cruft for several years now.
>>>       This is
>>>      due to feature creep, fixing mistakes, experience gained by the
>>>      maintainers and developers on how to do things, ports to new
>>>      architectures, and simply as a side effect of a code base that is
>>>      developed slowly and incrementally.
>>>
>>>      While I don't think we can justify a complete revamp of the API
>>>      now, I'm
>>>      writing this as a thought experiment to see where a from-scratch
>>>      API can
>>>      take us.  Of course, if we do implement this, the new and old APIs
>>>      will
>>>      have to be supported side by side for several years.
>>>
>>>      Syscalls
>>>      --------
>>>      kvm currently uses the much-loved ioctl() system call as its entry
>>>      point.  While this made it easy to add kvm to the kernel
>>>      unintrusively,
>>>      it does have downsides:
>>>
>>>      - overhead in the entry path, for the ioctl dispatch path and vcpu
>>>      mutex
>>>      (low but measurable)
>>>      - semantic mismatch: kvm really wants a vcpu to be tied to a
>>>      thread, and
>>>      a vm to be tied to an mm_struct, but the current API ties them to file
>>>      descriptors, which can move between threads and processes.  We check
>>>      that they don't, but we don't want to.
>>>
>>>      Moving to syscalls avoids these problems, but introduces new ones:
>>>
>>>      - adding new syscalls is generally frowned upon, and kvm will need
>>>      several
>>>      - syscalls into modules are harder and rarer than into core kernel
>>>      code
>>>      - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>>>      mm_struct
>>>
>>>      Syscalls that operate on the entire guest will pick it up implicitly
>>>      from the mm_struct, and syscalls that operate on a vcpu will pick
>>>      it up
>>>      from current.
>>>
>>>
>>> <snipped>
>>>
>>> I like the ioctl() interface.  If the overhead matters in your hot path,
>>
>> I can't say that it's a pressing problem, but it's not negligible.
>>
>>> I suspect you're doing it wrong;
>>
>> What am I doing wrong?
>
> "You the vmm" not "you the KVM maintainer" :-)
>
> To be a little more precise: If a VCPU thread is going all the way out
> to host usermode in its hot path, that's probably a performance
> problem regardless of how fast you make the transitions between host
> user and host kernel.
>
> That's why ioctl() doesn't bother me.  I think it'd be more useful to
> focus on mechanisms which don't require the VCPU thread to exit at all
> in its hot paths, so the overhead of the ioctl() really becomes lost
> in the noise.  irq fds and ioevent fds are great for that, and I
> really like your MMIO-over-socketpair idea.

I'm not so sure.  ioeventfds and a future mmio-over-socketpair have to put the 
kthread to sleep while it waits for the other end to process it.  This is 
effectively equivalent to a heavy weight exit.  The difference in cost is 
dropping to userspace which is really neglible these days (< 100 cycles).

There is some fast-path trickery to avoid heavy weight exits but this presents 
the same basic problem of having to put all the device model stuff in the kernel.

ioeventfd to userspace is almost certainly worse for performance.  And Avi 
mentioned, you can emulate this behavior yourself in userspace if so inclined.

Regards,

Anthony Liguori
