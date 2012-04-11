Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab2DKNvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 09:51:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42083 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2DKNvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 09:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAOtvUMdgu8zbVgGP-HxRTv=AT3Lry=Xd0P5_rFuo9VBGsdwcrw@mail.gmail.com>
References: <CAG3n4CQYZEtYfCjQ_n=iWhwFoaW4x-ovXZh3bNiwbGVtgq+jVg@mail.gmail.com>
 <CAOtvUMdgu8zbVgGP-HxRTv=AT3Lry=Xd0P5_rFuo9VBGsdwcrw@mail.gmail.com>
From: Tomer Margalit <tomermargalit@gmail.com>
Date: Wed, 11 Apr 2012 16:50:47 +0300
Message-ID: <CAG3n4CS9jDmXLA1=wEMG=HNSsMESpVJucBoO=a110pOau5DSrw@mail.gmail.com>
Subject: Re: Synchronizing userspace and kernel using mmaped memory
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, scipioenterprises@yahoo.com,
        Nezer Zaidenberg <nzaidenberg@mac.com>,
        "Zaidenberg, Nezer" <Nezer.Zaidenberg@edfenergy.com>,
        Amir Averbuch <amir@math.tau.ac.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 2:36 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Wed, Apr 11, 2012 at 1:30 PM, Tomer Margalit <tomermargalit@gmail.com> wrote:
>>
>> Hi All,
>>
>> I was wondering whether it is possible to use an mmaped byte to
>> synchronize userspace and kernel.
>
>
> Possible? yes (hint: 'git grep drivers/ mmap"). Smart? probably not :-)

Can you refer me to any specific driver that does it? I have searched
the net, but only found a simple example by someone, that is unrelated
to the kernel.
I haven't been able to find any example of such a thing in the kernel,
and I would appreciate it if you could refer me to one.
>
>>
>> To elaborate, I have a line of buffers that need to be transfered from
>> a kernel driver into a userspace daemon, so they can be sent to the
>> internet.
>> My current communication scheme is to use a series of mmaped buffers,
>> copy the data to them, and then when done, set a bit (in that same
>> memory mapped region), that indicates the page was filled and is ready
>> for transmission.
>
>
> If you copy the data to the buffers, just drop the mmap buffers and
> have the user daemon
> supply the buffers via a readv() system call and let the kernel copy
> the data to that.
>
> All synchronization work already done and debugged for a long time.

I want to do as little copying as I can. That is the reason for using
the mmaped memory. I am aware of the read/write mechanism, and have
considered it, but it will probably have me doing many useless copies.
>
>
>>
>>
>> I have implemented this scheme in two ways - one is to change the bit
>> both from kernel and userspace (set the bit when a page is filled and
>> clear it when emptied).
>> The other is to only change the bit from kernel, and only read the bit
>> from userspace (when the page is to be cleared, a custom ioctl is
>> used).
>>
>
> So you are spinning in user space waiting for the kernel to makr the bit clean?
> How wasteful.
I'm not sure what you want. A daemon is meant to wait for data from
the kernel (which in turn waits for data from the user). Daemons that
are data consumers usually "spin" until they get data. Obviously I
don't spin - more like wait (as in wait_event).

>
>>
>> The problem is that this only works 99% of time. I.e. once in every
>> million pages, there is a page that the kernel says it has filled
>> (according to logs), but userspace sees as cleared.
>> My initial instinct was that this is a bug, and I have tried debugging
>> it for a long time - with no results.
>> Figuring it was some kind of "illegal" memory access, I put guard
>> bytes around the problematic byte - but after checking, they remain
>> untouched.
>>
>> So, before I continue debugging, I thought to ask whether this is a
>> good approach?
>> Specifically, when writing/reading a memory mapped page from kernel
>> (or userspace for that matter) - is there any action that needs to be
>> taken to flush the data or protect it?
>
>
> I can think of several things that can go wrong, but since you didn't give us
> any details (architecture, kernel version, SMP, source code for your driver and
> user daemon) we can't really know:
arch is x86_64
kernel is 3.3.1 (although I tried many more 2.6.29-3.3.1).
the source code is thousands of lines. If you'd like it, I can refer
you to the sourceforge repository.

>
> 1. You might have forgotten a compiler memory barrier around reading
> the communication byte (or used a volatile pointer, although that is
> painfully inefficient)
I have ruled out this problem by only writing to the byte from the
kernel. When I do that, I lock a mutex before writing to the byte
(which implies memory barriers).
There can only be a problem if userspace changes the byte even though
it is not asked to (a thing which I am not eliminating).
In the other version, I use an smp_mb() before and after any access to
the byte (read/write).
Unfortunately in usersapce however, there is no way to do memory barriers.
> 2. You might be running an SMP system and expect the writing of the
> byte and the buffers to happen in a certain order but didn't use a
> memory barrier.
> 3. You might be running on an architecture that uses VIVT data caches,
> in which case you might be suffering from cache in coherency between
> user and kernel space since they are using different virtual addresses
> to get to the same physical page.

I'm not sure about this one. Can you clarify?

>
> Best of luck,
> Gilad
>
>>
>>
>> Thanks,
>>  Tomer
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
> gilad@benyossef.com
> Israel Cell: +972-52-8260388
> US Cell: +1-973-8260388
> http://benyossef.com
>
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru

Thanks,
  Tomer
