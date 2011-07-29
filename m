Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1G2HW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:22:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61699 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1G2HW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:22:26 -0400
Message-ID: <4E325F98.5090308@gmail.com>
Date: Fri, 29 Jul 2011 15:22:00 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>, Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
In-Reply-To: <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan
On 07/28/2011 11:44 PM, Stefan Hajnoczi wrote:
> On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan<namei.unix@gmail.com>  wrote:
>
> Did you investigate userspace virtio-blk performance?  If so, what
> issues did you find?
>

Yes, in the performance table I presented, virtio-blk in the user space 
lags behind the vhost-blk(although this prototype is very primitive 
impl.) in the kernel by about 15%.

Actually, the motivation to start vhost-blk is that, in our observation, 
KVM(virtio enabled) in RHEL 6 is worse than Xen(PV) in RHEL in disk IO 
perspective, especially for sequential read/write (around 20% gap).

We'll deploy a large number of KVM-based systems as the infrastructure 
of some service and this gap is really unpleasant.

By the design, IMHO, virtio performance is supposed to be comparable to 
the para-vulgarization solution if not better, because for KVM, guest 
and backend driver could sit in the same address space via mmaping. This 
would reduce the overhead involved in page table modification, thus 
speed up the buffer management and transfer a lot compared with Xen PV.

I am not in a qualified  position to talk about QEMU , but I think the 
surprised performance improvement by this very primitive vhost-blk 
simply manifest that, the internal structure for qemu io is the way 
bloated. I say it *surprised* because basically vhost just reduces the 
number of system calls, which is heavily tuned by chip manufacture for 
years. So, I guess the performance number vhost-blk gains mainly could 
possibly be contributed to *shorter and simpler* code path.

Anyway, IMHO, compared with user space approach, the in-kernel one would 
allow more flexibility and better integration with the kernel IO stack, 
since we don't need two IO stacks for guest OS.

> I have a hacked up world here that basically implements vhost-blk in userspace:
> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>
>   * A dedicated virtqueue thread sleeps on ioeventfd
>   * Guest memory is pre-mapped and accessed directly (not using QEMU's
> usually memory access functions)
>   * Linux AIO is used, the QEMU block layer is bypassed
>   * Completion interrupts are injected from the virtqueue thread using ioctl
>
> I will try to rebase onto qemu-kvm.git/master (this work is several
> months old).  Then we can compare to see how much of the benefit can
> be gotten in userspace.
>
I don't really get you about vhost-blk in user space since vhost 
infrastructure itself means an in-kernel accelerator that implemented in 
kernel . I guess what you meant is somewhat a re-write of virtio-blk in 
user space with a dedicated thread handling requests, and shorter code 
path similar to vhost-blk.

>> [performance]
>>
>>         Currently, the fio benchmarking number is rather promising. The seq read is imporved as much as 16% for throughput and the latency is dropped up to 14%. For seq write, 13.5% and 13% respectively.
>>
>> sequential read:
>> +-------------+-------------+---------------+---------------+
>> | iodepth     | 1           |   2           |   3           |
>> +-------------+-------------+---------------+----------------
>> | virtio-blk  | 4116(214)   |   7814(222)   |   8867(306)   |
>> +-------------+-------------+---------------+---------------+
>> | vhost-blk   | 4755(183)   |   8645(202)   |   10084(266)  |
>> +-------------+-------------+---------------+---------------+
>>
>> 4116(214) means 4116 IOPS/s, the it is completion latency is 214 us.
>>
>> seqeuential write:
>> +-------------+-------------+----------------+--------------+
>> | iodepth     |  1          |    2           |  3           |
>> +-------------+-------------+----------------+--------------+
>> | virtio-blk  | 3848(228)   |   6505(275)    |  9335(291)   |
>> +-------------+-------------+----------------+--------------+
>> | vhost-blk   | 4370(198)   |   7009(249)    |  9938(264)   |
>> +-------------+-------------+----------------+--------------+
>>
>> the fio command for sequential read:
>>
>> sudo fio -name iops -readonly -rw=read -runtime=120 -iodepth 1 -filename /dev/vda -ioengine libaio -direct=1 -bs=512
>>
>> and config file for sequential write is:
>>
>> dev@taobao:~$ cat rw.fio
>> -------------------------
>> [test]
>>
>> rw=rw
>> size=200M
>> directory=/home/dev/data
>> ioengine=libaio
>> iodepth=1
>> direct=1
>> bs=512
>> -------------------------
> 512 byte blocksize is very small, given that you can expect a file
> system to have 4 KB or so block sizes.  It would be interesting to
> measure a wider range of block sizes: 4 KB, 64 KB, and 128 KB for
> example.
>
> Stefan
Actually, I have tested 4KB, it shows the same improvement. What I care 
more is iodepth, since batched AIO would benefit it.But my laptop SATA 
doesn't behave well as it advertises: it says its NCQ queue depth is 32 
and kernel tells me it support 31 requests in one go. When increase 
iodepth in the test up to 4, both the host and guest' IOPS drops 
drastically.

Yuan
