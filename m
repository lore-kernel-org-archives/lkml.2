Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1G2IAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:00:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33854 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab1G2IAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:00:01 -0400
Message-ID: <4E326879.9050009@gmail.com>
Date: Fri, 29 Jul 2011 15:59:53 +0800
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
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>	<CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com> <CAJSP0QVH8RgwdtVRtowbkJ0KHiDs8np=mcfP8LWX6=NdDsAJcQ@mail.gmail.com>
In-Reply-To: <CAJSP0QVH8RgwdtVRtowbkJ0KHiDs8np=mcfP8LWX6=NdDsAJcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 07/29/2011 12:48 PM, Stefan Hajnoczi wrote:
> On Thu, Jul 28, 2011 at 4:44 PM, Stefan Hajnoczi<stefanha@gmail.com>  wrote:
>> On Thu, Jul 28, 2011 at 3:29 PM, Liu Yuan<namei.unix@gmail.com>  wrote:
>>
>> Did you investigate userspace virtio-blk performance?  If so, what
>> issues did you find?
>>
>> I have a hacked up world here that basically implements vhost-blk in userspace:
>> http://repo.or.cz/w/qemu/stefanha.git/blob/refs/heads/virtio-blk-data-plane:/hw/virtio-blk.c
>>
>>   * A dedicated virtqueue thread sleeps on ioeventfd
>>   * Guest memory is pre-mapped and accessed directly (not using QEMU's
>> usually memory access functions)
>>   * Linux AIO is used, the QEMU block layer is bypassed
>>   * Completion interrupts are injected from the virtqueue thread using ioctl
>>
>> I will try to rebase onto qemu-kvm.git/master (this work is several
>> months old).  Then we can compare to see how much of the benefit can
>> be gotten in userspace.
> Here is the rebased virtio-blk-data-plane tree:
> http://repo.or.cz/w/qemu-kvm/stefanha.git/shortlog/refs/heads/virtio-blk-data-plane
>
> When I run it on my laptop with an Intel X-25M G2 SSD I see a latency
> reduction compared to mainline userspace virtio-blk.  I'm not posting
> results because I did quick fio runs without ensuring a quiet
> benchmarking environment.
>
> There are a couple of things that could be modified:
>   * I/O request merging is done to mimic bdrv_aio_multiwrite() - but
> vhost-blk does not do this.  Try turning it off?

I noted bdrv_aio_multiwrite() do the murging job, but  I am not sure if 
this trick is really needed since we have an io scheduler down the path 
that is in a much more better position to murge requests. I think the 
duplicate *pre-mature* merging of bdrv_aio_multiwrite is the result of  
laio_submit()'s lack of submitting the requests in a batch mode. 
io_submit() in the fs/aio.c says that every time we call laio_submit(), 
it will submit the very request into the driver's request queue, which 
would be run when we blk_finish_plug(). IMHO, you can simply batch 
io_submit() requests instead of this tricks if you already bypass the 
QEMU block layer.

>   * epoll(2) is used but perhaps select(2)/poll(2) have lower latency
> for this use case.  Try another event mechanism.
>
> Let's see how it compares to vhost-blk first.  I can tweak it if we
> want to investigate further.
>
> Yuan: Do you want to try the virtio-blk-data-plane tree?  You don't
> need to change the qemu-kvm command-line options.
>
> Stefan
Yes, please, sounds interesting. BTW, I think the user space would 
achieve the same performance gain if you bypass qemu io layer all the 
way down to the system calls in a request handling cycle, compared to 
the current vhost-blk implementation that uses linux AIO. But hey, I 
would go further to optimise it with block layer and other resources in 
the mind. ;) and I don't add complexity to the current qemu io layer.

Yuan
