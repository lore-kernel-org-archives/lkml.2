Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1F1FPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:15:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55773 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab1F1FOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cRjQeGhQQo3wBqGQ60MNGFjueOyyyLhmGSkhSwoAmZvInEmLwxGlYSfkCNXGgP+1zc
         9vCULQk5ShFLhV6k84xzBbERzMVpjEGlqaJ8UI+vuWV2C+aTP9BUwKlu6P3G+MahZVED
         ZBX6SpsNzePDMB67Tv4QN5ZH7QbTJg4uRRCYA=
MIME-Version: 1.0
In-Reply-To: <87oc1q8vnj.fsf@rustcorp.com.au>
References: <20110621102605.1382.90232.sendpatchset@t400s>
	<87oc1q8vnj.fsf@rustcorp.com.au>
Date: Tue, 28 Jun 2011 14:14:36 +0900
Message-ID: <BANLkTi==EpA8s4+F5EtetWsqWVaJcKD8kA@mail.gmail.com>
Subject: Re: [PATCH 00/02][RESEND] virtio: Virtio platform driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org, linux-sh@vger.kernel.org,
        virtualization@lists.linux-foundation.org, horms@verge.net.au,
        mst@redhat.com, iws@ovro.caltech.edu,
        Christian Borntraeger <borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 11:09 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 21 Jun 2011 19:26:05 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
>> virtio: Virtio platform driver
>>
>> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
>> [PATCH 02/02] virtio: Add virtio platform driver
>>
>> These patches add a virtio platform driver to the Linux kernel. This
>> platform driver has the same role as the virtio_pci driver, but instead
>> of building on top of emulated PCI this driver is making use of the
>> platform bus together with driver specific callbacks.
>>
>> The virtio platform driver can be seen as a reusable implementation of
>> the lguest virtio driver - in fact, most code is just taken directly
>> from lguest_device.c and reworked to fit the platform device driver
>> abstraction. The first patch breaks out code that can be shared between
>> lguest and the virtio platform driver.
>>
>> This code has been used to implement a mailbox interface between the
>> two processor cores included in the sh7372 SoC. The sh7372 contains
>> one ARM Cortex-A8 and one SH4AL-DSP core, and in the prototype two
>> Linux kernels are running in parallel on the same chip. Virtio serves
>> as a communication link between the two cores.

Hi Rusty,

Thanks for your comments!

> OK, this seems pretty neat, but I have three questions before we nail this
> down (note that lguest doesn't have an ABI, so we can change it as much
> as we want).
>
> 1) The lguest bus is dumb, and I never thought about device hotplug, for
>   example.  It would be nice to handle that somehow.  Is it possible?
>   Is this something you care about?

I would most likely use device hotplug if it already existed, but my
goal with this patch and the rest of the sh7372 AMP code is to show
that virtio exists and that there is no need for people to invent
their own IPC software mechanism. So I don't care that much about
device hotplug.

I do however care about ABI and a non-GPL licensed virtio library to
allow people to tie in commercial RTOS with virtio. To prevent them
from rolling their own. It's pretty low priority though, I am quite
happy as-is staying in proof-of-concept-land running two instances of
Linux.

> 2) Have you seen the '[RFC 0/8] Introducing a generic AMP/IPC framework'
>   patches?  Seems to overlap with what you're doing after these patches.

Yes, there is clearly overlap, but surprisingly little. I believe
we're trying to solve different sides of the same problem.

Lguest system (Linux + Linux):
Host: lguest.c (user space) talks to /dev/lguest
Guest: lguest_device.c ties in virtio devices

SH Core Linux system (Linux + Linux):
Host: SoC-specific rtcpu-loader.c (user space) talks to /dev/uioX
Slave: SoC-specific code chats to virtio_platform.c that ties in virtio devices

"generic AMP/IPC framework" (Linux + DSP/RTOS):
Host: "remoteproc" and "rpmsg" run in the kernel
Slave: ?? (not covered by the patches I believe)

So while the "generic AMP/IPC framework" looks great for the host,
this patch tries to make something reusable on the slave/guest side.

> 3) The S/390 layout is identical, except their struct kvm_vqconfig is a
>   bit different.  Perhaps we should just use theirs (they use a 64-bit
>   token instead of an interrupt number).

I don't mind so much, but alignment wise I find it odd that the s390
version chose to use u64 + u64 + u16.

Thanks,

/ magnus
