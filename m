Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1G2MBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:01:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52363 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1G2MBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:01:17 -0400
Message-ID: <4E32A105.6080509@gmail.com>
Date: Fri, 29 Jul 2011 20:01:09 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>	<4E325F98.5090308@gmail.com> <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
In-Reply-To: <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 05:06 PM, Stefan Hajnoczi wrote:
> I mean did you investigate *why* userspace virtio-blk has higher
> latency?  Did you profile it and drill down on its performance?
>
> It's important to understand what is going on before replacing it with
> another mechanism.  What I'm saying is, if I have a buggy program I
> can sometimes rewrite it from scratch correctly but that doesn't tell
> me what the bug was.
>
> Perhaps the inefficiencies in userspace virtio-blk can be solved by
> adjusting the code (removing inefficient notification mechanisms,
> introducing a dedicated thread outside of the QEMU iothread model,
> etc).  Then we'd get the performance benefit for non-raw images and
> perhaps non-virtio and non-Linux host platforms too.
>

As Christoph mentioned, the unnecessary memory allocation and too much 
cache line unfriendly
function pointers might be culprit. For example, the read quests code 
path for linux aio would be

     
qemu_iohandler_poll->virtio_pci_host_notifier_read->virtio_queue_notify_vq->virtio_blk_handle_output
->virtio_blk_handle_read->bdrv_aio_read->raw_aio_readv->bdrv_aio_readv(Yes 
again nested called!)->raw_aio_readv->laio_submit->io_submit...

Looking at this long list,most are function pointers that can not be 
inlined, and the internal data structures used by these functions are 
dozons. Leave aside code complexity, this long code path would really 
need retrofit. As Christoph simply put, this kind of mess is inherent 
all over the qemu code. So I am afraid, the 'retrofit'  would end up to 
be a re-write the entire (sub)system. I have to admit that, I am 
inclined to the MST's vhost approach, that write a new subsystem other 
than tedious profiling and fixing, that would possibly goes as far as 
actually re-writing it.

>> Actually, the motivation to start vhost-blk is that, in our observation,
>> KVM(virtio enabled) in RHEL 6 is worse than Xen(PV) in RHEL in disk IO
>> perspective, especially for sequential read/write (around 20% gap).
>>
>> We'll deploy a large number of KVM-based systems as the infrastructure of
>> some service and this gap is really unpleasant.
>>
>> By the design, IMHO, virtio performance is supposed to be comparable to the
>> para-vulgarization solution if not better, because for KVM, guest and
>> backend driver could sit in the same address space via mmaping. This would
>> reduce the overhead involved in page table modification, thus speed up the
>> buffer management and transfer a lot compared with Xen PV.
> Yes, guest memory is just a region of QEMU userspace memory.  So it's
> easy to reach inside and there are no page table tricks or copying
> involved.
>
>> I am not in a qualified  position to talk about QEMU , but I think the
>> surprised performance improvement by this very primitive vhost-blk simply
>> manifest that, the internal structure for qemu io is the way bloated. I say
>> it *surprised* because basically vhost just reduces the number of system
>> calls, which is heavily tuned by chip manufacture for years. So, I guess the
>> performance number vhost-blk gains mainly could possibly be contributed to
>> *shorter and simpler* code path.
> First we need to understand exactly what the latency overhead is.  If
> we discover that it's simply not possible to do this equally well in
> userspace, then it makes perfect sense to use vhost-blk.
>
> So let's gather evidence and learn what the overheads really are.
> Last year I spent time looking at virtio-blk latency:
> http://www.linux-kvm.org/page/Virtio/Block/Latency
>

Nice stuff.

> See especially this diagram:
> http://www.linux-kvm.org/page/Image:Threads.png
>
> The goal wasn't specifically to reduce synchronous sequential I/O,
> instead the aim was to reduce overheads for a variety of scenarios,
> especially multithreaded workloads.
>
> In most cases it was helpful to move I/O submission out of the vcpu
> thread by using the ioeventfd model just like vhost.  Ioeventfd for
> userspace virtio-blk is now on by default in qemu-kvm.
>
> Try running the userspace virtio-blk benchmark with -drive
> if=none,id=drive0,file=... -device
> virtio-blk-pci,drive=drive0,ioeventfd=off.  This causes QEMU to do I/O
> submission in the vcpu thread, which might reduce latency at the cost
> of stealing guest time.
>
>> Anyway, IMHO, compared with user space approach, the in-kernel one would
>> allow more flexibility and better integration with the kernel IO stack,
>> since we don't need two IO stacks for guest OS.
> I agree that there may be advantages to integrating with in-kernel I/O
> mechanisms.  An interesting step would be to implement the
> submit_bio() approach that Christoph suggested and seeing if that
> improves things further.
>
> Push virtio-blk as far as you can and let's see what the performance is!
>
>>> I have a hacked up world here that basically implements vhost-blk in
>>> userspace:
>>>
>>> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>>>
>>>   * A dedicated virtqueue thread sleeps on ioeventfd
>>>   * Guest memory is pre-mapped and accessed directly (not using QEMU's
>>> usually memory access functions)
>>>   * Linux AIO is used, the QEMU block layer is bypassed
>>>   * Completion interrupts are injected from the virtqueue thread using
>>> ioctl
>>>
>>> I will try to rebase onto qemu-kvm.git/master (this work is several
>>> months old).  Then we can compare to see how much of the benefit can
>>> be gotten in userspace.
>>>
>> I don't really get you about vhost-blk in user space since vhost
>> infrastructure itself means an in-kernel accelerator that implemented in
>> kernel . I guess what you meant is somewhat a re-write of virtio-blk in user
>> space with a dedicated thread handling requests, and shorter code path
>> similar to vhost-blk.
> Right - it's the same model as vhost: a dedicated thread listening for
> ioeventfd virtqueue kicks and processing them out-of-line with the
> guest and userspace QEMU's traditional vcpu and iothread.
>
> When you say "IOPS drops drastically" do you mean that it gets worse
> than with queue-depth=1?
>

Yes, on my laptop, when iodepth = 3, IOPS in my host drops to about 
3,500 from 13K! and so is iodepth = 4 in my guest during FIO seq read 
test. This should never happen.

I think SATA on my laptop has something wrong that can not be 
explainable. If not, The cause I could image is that the NCQ depth is 2 
on my disk and when the kernel submit reqs more than this number, it 
would cause severe scheduling overhead. Anyway, this is unrelated to 
vhost-blk and would not be seen
by others.

> I hope that others are interested in running the benchmarks on their
> systems so we can try out a range of storage devices.
>
> Stefan

Yuan
