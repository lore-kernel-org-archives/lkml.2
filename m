Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1G2JGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:06:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61838 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1G2JGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <4E325F98.5090308@gmail.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
	<4E325F98.5090308@gmail.com>
Date: Fri, 29 Jul 2011 10:06:11 +0100
Message-ID: <CAJSP0QX=mXvkZyeMx28iwVNDrKEZZVAZxLLOFRv62pu7byo6gw@mail.gmail.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block device
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 8:22 AM, Liu Yuan <namei.unix@gmail.com> wrote:
> Hi Stefan
> On 07/28/2011 11:44 PM, Stefan Hajnoczi wrote:
>>
>> On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan<namei.unix@gmail.com>  wrote:
>>
>> Did you investigate userspace virtio-blk performance?  If so, what
>> issues did you find?
>>
>
> Yes, in the performance table I presented, virtio-blk in the user space lags
> behind the vhost-blk(although this prototype is very primitive impl.) in the
> kernel by about 15%.

I mean did you investigate *why* userspace virtio-blk has higher
latency?  Did you profile it and drill down on its performance?

It's important to understand what is going on before replacing it with
another mechanism.  What I'm saying is, if I have a buggy program I
can sometimes rewrite it from scratch correctly but that doesn't tell
me what the bug was.

Perhaps the inefficiencies in userspace virtio-blk can be solved by
adjusting the code (removing inefficient notification mechanisms,
introducing a dedicated thread outside of the QEMU iothread model,
etc).  Then we'd get the performance benefit for non-raw images and
perhaps non-virtio and non-Linux host platforms too.

> Actually, the motivation to start vhost-blk is that, in our observation,
> KVM(virtio enabled) in RHEL 6 is worse than Xen(PV) in RHEL in disk IO
> perspective, especially for sequential read/write (around 20% gap).
>
> We'll deploy a large number of KVM-based systems as the infrastructure of
> some service and this gap is really unpleasant.
>
> By the design, IMHO, virtio performance is supposed to be comparable to the
> para-vulgarization solution if not better, because for KVM, guest and
> backend driver could sit in the same address space via mmaping. This would
> reduce the overhead involved in page table modification, thus speed up the
> buffer management and transfer a lot compared with Xen PV.

Yes, guest memory is just a region of QEMU userspace memory.  So it's
easy to reach inside and there are no page table tricks or copying
involved.

> I am not in a qualified  position to talk about QEMU , but I think the
> surprised performance improvement by this very primitive vhost-blk simply
> manifest that, the internal structure for qemu io is the way bloated. I say
> it *surprised* because basically vhost just reduces the number of system
> calls, which is heavily tuned by chip manufacture for years. So, I guess the
> performance number vhost-blk gains mainly could possibly be contributed to
> *shorter and simpler* code path.

First we need to understand exactly what the latency overhead is.  If
we discover that it's simply not possible to do this equally well in
userspace, then it makes perfect sense to use vhost-blk.

So let's gather evidence and learn what the overheads really are.
Last year I spent time looking at virtio-blk latency:
http://www.linux-kvm.org/page/Virtio/Block/Latency

See especially this diagram:
http://www.linux-kvm.org/page/Image:Threads.png

The goal wasn't specifically to reduce synchronous sequential I/O,
instead the aim was to reduce overheads for a variety of scenarios,
especially multithreaded workloads.

In most cases it was helpful to move I/O submission out of the vcpu
thread by using the ioeventfd model just like vhost.  Ioeventfd for
userspace virtio-blk is now on by default in qemu-kvm.

Try running the userspace virtio-blk benchmark with -drive
if=none,id=drive0,file=... -device
virtio-blk-pci,drive=drive0,ioeventfd=off.  This causes QEMU to do I/O
submission in the vcpu thread, which might reduce latency at the cost
of stealing guest time.

> Anyway, IMHO, compared with user space approach, the in-kernel one would
> allow more flexibility and better integration with the kernel IO stack,
> since we don't need two IO stacks for guest OS.

I agree that there may be advantages to integrating with in-kernel I/O
mechanisms.  An interesting step would be to implement the
submit_bio() approach that Christoph suggested and seeing if that
improves things further.

Push virtio-blk as far as you can and let's see what the performance is!

>> I have a hacked up world here that basically implements vhost-blk in
>> userspace:
>>
>> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>>
>>  * A dedicated virtqueue thread sleeps on ioeventfd
>>  * Guest memory is pre-mapped and accessed directly (not using QEMU's
>> usually memory access functions)
>>  * Linux AIO is used, the QEMU block layer is bypassed
>>  * Completion interrupts are injected from the virtqueue thread using
>> ioctl
>>
>> I will try to rebase onto qemu-kvm.git/master (this work is several
>> months old).  Then we can compare to see how much of the benefit can
>> be gotten in userspace.
>>
> I don't really get you about vhost-blk in user space since vhost
> infrastructure itself means an in-kernel accelerator that implemented in
> kernel . I guess what you meant is somewhat a re-write of virtio-blk in user
> space with a dedicated thread handling requests, and shorter code path
> similar to vhost-blk.

Right - it's the same model as vhost: a dedicated thread listening for
ioeventfd virtqueue kicks and processing them out-of-line with the
guest and userspace QEMU's traditional vcpu and iothread.

>>> [performance]
>>>
>>>        Currently, the fio benchmarking number is rather promising. The
>>> seq read is imporved as much as 16% for throughput and the latency is
>>> dropped up to 14%. For seq write, 13.5% and 13% respectively.
>>>
>>> sequential read:
>>> +-------------+-------------+---------------+---------------+
>>> | iodepth     | 1           |   2           |   3           |
>>> +-------------+-------------+---------------+----------------
>>> | virtio-blk  | 4116(214)   |   7814(222)   |   8867(306)   |
>>> +-------------+-------------+---------------+---------------+
>>> | vhost-blk   | 4755(183)   |   8645(202)   |   10084(266)  |
>>> +-------------+-------------+---------------+---------------+
>>>
>>> 4116(214) means 4116 IOPS/s, the it is completion latency is 214 us.
>>>
>>> seqeuential write:
>>> +-------------+-------------+----------------+--------------+
>>> | iodepth     |  1          |    2           |  3           |
>>> +-------------+-------------+----------------+--------------+
>>> | virtio-blk  | 3848(228)   |   6505(275)    |  9335(291)   |
>>> +-------------+-------------+----------------+--------------+
>>> | vhost-blk   | 4370(198)   |   7009(249)    |  9938(264)   |
>>> +-------------+-------------+----------------+--------------+
>>>
>>> the fio command for sequential read:
>>>
>>> sudo fio -name iops -readonly -rw=read -runtime=120 -iodepth 1 -filename
>>> /dev/vda -ioengine libaio -direct=1 -bs=512
>>>
>>> and config file for sequential write is:
>>>
>>> dev@taobao:~$ cat rw.fio
>>> -------------------------
>>> [test]
>>>
>>> rw=rw
>>> size=200M
>>> directory=/home/dev/data
>>> ioengine=libaio
>>> iodepth=1
>>> direct=1
>>> bs=512
>>> -------------------------
>>
>> 512 byte blocksize is very small, given that you can expect a file
>> system to have 4 KB or so block sizes.  It would be interesting to
>> measure a wider range of block sizes: 4 KB, 64 KB, and 128 KB for
>> example.
>>
>> Stefan
>
> Actually, I have tested 4KB, it shows the same improvement. What I care more
> is iodepth, since batched AIO would benefit it.But my laptop SATA doesn't
> behave well as it advertises: it says its NCQ queue depth is 32 and kernel
> tells me it support 31 requests in one go. When increase iodepth in the test
> up to 4, both the host and guest' IOPS drops drastically.

When you say "IOPS drops drastically" do you mean that it gets worse
than with queue-depth=1?

I hope that others are interested in running the benchmarks on their
systems so we can try out a range of storage devices.

Stefan
