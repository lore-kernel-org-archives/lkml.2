Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1G2M3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:29:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36575 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1G2M3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <4E32A105.6080509@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	<4E325F98.5090308@gmail.com>
	<CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
	<4E32A105.6080509@gmail.com>
Date: Fri, 29 Jul 2011 13:29:44 +0100
Message-ID: <CAJSP0QUV1C3O6SuXzFKMi5t61T+Qa-Yy2yWEevuuAvyQarJ47g@mail.gmail.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block device
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 1:01 PM, Liu Yuan <namei.unix@gmail.com> wrote:
> On 07/29/2011 05:06 PM, Stefan Hajnoczi wrote:
>>
>> I mean did you investigate *why* userspace virtio-blk has higher
>> latency?  Did you profile it and drill down on its performance?
>>
>> It's important to understand what is going on before replacing it with
>> another mechanism.  What I'm saying is, if I have a buggy program I
>> can sometimes rewrite it from scratch correctly but that doesn't tell
>> me what the bug was.
>>
>> Perhaps the inefficiencies in userspace virtio-blk can be solved by
>> adjusting the code (removing inefficient notification mechanisms,
>> introducing a dedicated thread outside of the QEMU iothread model,
>> etc).  Then we'd get the performance benefit for non-raw images and
>> perhaps non-virtio and non-Linux host platforms too.
>>
>
> As Christoph mentioned, the unnecessary memory allocation and too much cache
> line unfriendly
> function pointers might be culprit. For example, the read quests code path
> for linux aio would be
>
>
>  qemu_iohandler_poll->virtio_pci_host_notifier_read->virtio_queue_notify_vq->virtio_blk_handle_output
> ->virtio_blk_handle_read->bdrv_aio_read->raw_aio_readv->bdrv_aio_readv(Yes
> again nested called!)->raw_aio_readv->laio_submit->io_submit...
>
> Looking at this long list,most are function pointers that can not be
> inlined, and the internal data structures used by these functions are
> dozons. Leave aside code complexity, this long code path would really need
> retrofit. As Christoph simply put, this kind of mess is inherent all over
> the qemu code. So I am afraid, the 'retrofit'  would end up to be a re-write
> the entire (sub)system. I have to admit that, I am inclined to the MST's
> vhost approach, that write a new subsystem other than tedious profiling and
> fixing, that would possibly goes as far as actually re-writing it.

I'm totally for vhost-blk if there are unique benefits that make it
worth maintaining.  But better benchmark results are not a cause, they
are an effect.  So the thing to do is to drill down on both vhost-blk
and userspace virtio-blk to understand what causes overheads.
Evidence showing that userspace can never compete is needed to justify
vhost-blk IMO.

>>> Actually, the motivation to start vhost-blk is that, in our observation,
>>> KVM(virtio enabled) in RHEL 6 is worse than Xen(PV) in RHEL in disk IO
>>> perspective, especially for sequential read/write (around 20% gap).
>>>
>>> We'll deploy a large number of KVM-based systems as the infrastructure of
>>> some service and this gap is really unpleasant.
>>>
>>> By the design, IMHO, virtio performance is supposed to be comparable to
>>> the
>>> para-vulgarization solution if not better, because for KVM, guest and
>>> backend driver could sit in the same address space via mmaping. This
>>> would
>>> reduce the overhead involved in page table modification, thus speed up
>>> the
>>> buffer management and transfer a lot compared with Xen PV.
>>
>> Yes, guest memory is just a region of QEMU userspace memory.  So it's
>> easy to reach inside and there are no page table tricks or copying
>> involved.
>>
>>> I am not in a qualified  position to talk about QEMU , but I think the
>>> surprised performance improvement by this very primitive vhost-blk simply
>>> manifest that, the internal structure for qemu io is the way bloated. I
>>> say
>>> it *surprised* because basically vhost just reduces the number of system
>>> calls, which is heavily tuned by chip manufacture for years. So, I guess
>>> the
>>> performance number vhost-blk gains mainly could possibly be contributed
>>> to
>>> *shorter and simpler* code path.
>>
>> First we need to understand exactly what the latency overhead is.  If
>> we discover that it's simply not possible to do this equally well in
>> userspace, then it makes perfect sense to use vhost-blk.
>>
>> So let's gather evidence and learn what the overheads really are.
>> Last year I spent time looking at virtio-blk latency:
>> http://www.linux-kvm.org/page/Virtio/Block/Latency
>>
>
> Nice stuff.
>
>> See especially this diagram:
>> http://www.linux-kvm.org/page/Image:Threads.png
>>
>> The goal wasn't specifically to reduce synchronous sequential I/O,
>> instead the aim was to reduce overheads for a variety of scenarios,
>> especially multithreaded workloads.
>>
>> In most cases it was helpful to move I/O submission out of the vcpu
>> thread by using the ioeventfd model just like vhost.  Ioeventfd for
>> userspace virtio-blk is now on by default in qemu-kvm.
>>
>> Try running the userspace virtio-blk benchmark with -drive
>> if=none,id=drive0,file=... -device
>> virtio-blk-pci,drive=drive0,ioeventfd=off.  This causes QEMU to do I/O
>> submission in the vcpu thread, which might reduce latency at the cost
>> of stealing guest time.
>>
>>> Anyway, IMHO, compared with user space approach, the in-kernel one would
>>> allow more flexibility and better integration with the kernel IO stack,
>>> since we don't need two IO stacks for guest OS.
>>
>> I agree that there may be advantages to integrating with in-kernel I/O
>> mechanisms.  An interesting step would be to implement the
>> submit_bio() approach that Christoph suggested and seeing if that
>> improves things further.
>>
>> Push virtio-blk as far as you can and let's see what the performance is!
>>
>>>> I have a hacked up world here that basically implements vhost-blk in
>>>> userspace:
>>>>
>>>>
>>>> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>>>>
>>>>  * A dedicated virtqueue thread sleeps on ioeventfd
>>>>  * Guest memory is pre-mapped and accessed directly (not using QEMU's
>>>> usually memory access functions)
>>>>  * Linux AIO is used, the QEMU block layer is bypassed
>>>>  * Completion interrupts are injected from the virtqueue thread using
>>>> ioctl
>>>>
>>>> I will try to rebase onto qemu-kvm.git/master (this work is several
>>>> months old).  Then we can compare to see how much of the benefit can
>>>> be gotten in userspace.
>>>>
>>> I don't really get you about vhost-blk in user space since vhost
>>> infrastructure itself means an in-kernel accelerator that implemented in
>>> kernel . I guess what you meant is somewhat a re-write of virtio-blk in
>>> user
>>> space with a dedicated thread handling requests, and shorter code path
>>> similar to vhost-blk.
>>
>> Right - it's the same model as vhost: a dedicated thread listening for
>> ioeventfd virtqueue kicks and processing them out-of-line with the
>> guest and userspace QEMU's traditional vcpu and iothread.
>>
>> When you say "IOPS drops drastically" do you mean that it gets worse
>> than with queue-depth=1?
>>
>
> Yes, on my laptop, when iodepth = 3, IOPS in my host drops to about 3,500
> from 13K! and so is iodepth = 4 in my guest during FIO seq read test. This
> should never happen.

Yes, that doesn't make sense to me unless the I/O scheduler is doing
something weird.  Have you tried switching between cfq, deadline, and
noop?

Stefan
