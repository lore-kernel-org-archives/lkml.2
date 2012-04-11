Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2DKLge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:36:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52983 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2DKLgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:36:33 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <CAG3n4CQYZEtYfCjQ_n=iWhwFoaW4x-ovXZh3bNiwbGVtgq+jVg@mail.gmail.com>
References: <CAG3n4CQYZEtYfCjQ_n=iWhwFoaW4x-ovXZh3bNiwbGVtgq+jVg@mail.gmail.com>
Date: Wed, 11 Apr 2012 14:36:32 +0300
Message-ID: <CAOtvUMdgu8zbVgGP-HxRTv=AT3Lry=Xd0P5_rFuo9VBGsdwcrw@mail.gmail.com>
Subject: Re: Synchronizing userspace and kernel using mmaped memory
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Tomer Margalit <tomermargalit@gmail.com>
Cc: linux-kernel@vger.kernel.org, scipioenterprises@yahoo.com,
        Nezer Zaidenberg <nzaidenberg@mac.com>,
        "Zaidenberg, Nezer" <Nezer.Zaidenberg@edfenergy.com>,
        Amir Averbuch <amir@math.tau.ac.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 1:30 PM, Tomer Margalit <tomermargalit@gmail.com> wrote:
>
> Hi All,
>
> I was wondering whether it is possible to use an mmaped byte to
> synchronize userspace and kernel.


Possible? yes (hint: 'git grep drivers/ mmap"). Smart? probably not :-)

>
> To elaborate, I have a line of buffers that need to be transfered from
> a kernel driver into a userspace daemon, so they can be sent to the
> internet.
> My current communication scheme is to use a series of mmaped buffers,
> copy the data to them, and then when done, set a bit (in that same
> memory mapped region), that indicates the page was filled and is ready
> for transmission.


If you copy the data to the buffers, just drop the mmap buffers and
have the user daemon
supply the buffers via a readv() system call and let the kernel copy
the data to that.

All synchronization work already done and debugged for a long time.


>
>
> I have implemented this scheme in two ways - one is to change the bit
> both from kernel and userspace (set the bit when a page is filled and
> clear it when emptied).
> The other is to only change the bit from kernel, and only read the bit
> from userspace (when the page is to be cleared, a custom ioctl is
> used).
>

So you are spinning in user space waiting for the kernel to makr the bit clean?
How wasteful.

>
> The problem is that this only works 99% of time. I.e. once in every
> million pages, there is a page that the kernel says it has filled
> (according to logs), but userspace sees as cleared.
> My initial instinct was that this is a bug, and I have tried debugging
> it for a long time - with no results.
> Figuring it was some kind of "illegal" memory access, I put guard
> bytes around the problematic byte - but after checking, they remain
> untouched.
>
> So, before I continue debugging, I thought to ask whether this is a
> good approach?
> Specifically, when writing/reading a memory mapped page from kernel
> (or userspace for that matter) - is there any action that needs to be
> taken to flush the data or protect it?


I can think of several things that can go wrong, but since you didn't give us
any details (architecture, kernel version, SMP, source code for your driver and
user daemon) we can't really know:

1. You might have forgotten a compiler memory barrier around reading
the communication byte (or used a volatile pointer, although that is
painfully inefficient)
2. You might be running an SMP system and expect the writing of the
byte and the buffers to happen in a certain order but didn't use a
memory barrier.
3. You might be running on an architecture that uses VIVT data caches,
in which case you might be suffering from cache in coherency between
user and kernel space since they are using different virtual addresses
to get to the same physical page.

Best of luck,
Gilad

>
>
> Thanks,
>  Tomer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/




--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
