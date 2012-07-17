Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2GQI1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2GQI1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:27:50 -0400
Message-ID: <50052276.2080906@redhat.com>
Date: Tue, 17 Jul 2012 16:29:42 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
In-Reply-To: <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 07:58 PM, Stefan Hajnoczi wrote:
> On Thu, Jul 12, 2012 at 4:35 PM, Asias He <asias@redhat.com> wrote:
>> This patchset adds vhost-blk support. vhost-blk is a in kernel virito-blk
>> device accelerator. Compared to userspace virtio-blk implementation, vhost-blk
>> gives about 5% to 15% performance improvement.
>
> Why is it 5-15% faster?  vhost-blk and the userspace virtio-blk you
> benchmarked should be doing basically the same thing:
>
> 1. An eventfd file descriptor is signalled when the vring has new
> requests available from the guest.
> 2. A thread wakes up and processes the virtqueue.
> 3. Linux AIO is used to issue host I/O.
> 4. An interrupt is injected into the guest.

Yes. This is how both of them work. Though, there are some differences 
in details. e.g.

In vhost-blk, we use the vhost's work infrastructure to handle the 
requests. In kvm tool, we use a dedicated thread.
In vhost-blk, we use irqfd to inject interrupts. In kvm tool, we use 
ioctl to inject interrupts.


> Does the vhost-blk implementation do anything fundamentally different
> from userspace?  Where is the overhead that userspace virtio-blk has?


Currently, no. But we could play with bio directly in vhost-blk as 
Christoph suggested which could make the IO path from guest to host's 
real storage even shorter in vhost-blk.

I've been trying my best to reduce the overhead of virtio-blk at kvm 
tool side. I do not see any significant overhead out there. Compared to 
vhost-blk, the overhead we have in userspace virito-blk is syscalls. In 
each IO request, we have

    epoll_wait() & read(): wait for the eventfd which guest notifies us
    io_submit(): submit the aio
    read(): read the aio complete eventfd
    io_getevents(): reap the aio complete result
    ioctl(): trigger the interrupt

So, vhost-blk at least saves ~6 syscalls for us in each request.

> I'm asking because it would be beneficial to fix the overhead
> (especially it that could speed up all userspace applications) instead
> of adding a special-purpose kernel module to work around the overhead.

I guess you mean qemu here. Yes, in theory, qemu's block layer can be 
improved to achieve similar performance as vhost-blk or kvm tool's 
userspace virito-blk has. But I think it makes no sense to prevent one 
solution becase there is another in theory solution called: we can do 
similar in qemu.

What do you mean by specail-purpose here, we need general-purpose kernel
module? Is vhost-net a special purpose kernel module?  Is xen-blkback a 
special-purpose kernel module? And I think vhost-blk is beneficial to 
qemu too, as well as any other kvm host side implementation.

-- 
Asias


