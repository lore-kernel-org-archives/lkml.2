Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1GBQYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:24:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1GBQY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikO+cUbCFPAuNSE01xSmOzhwWP0mQ@mail.gmail.com>
References: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
 <BANLkTimF0AsS3=-S=gmbcjBC5JuKr=6Prw@mail.gmail.com> <BANLkTimp2cafUrALLdqeSBWeMsA+ybiUpQ@mail.gmail.com>
 <BANLkTikO+cUbCFPAuNSE01xSmOzhwWP0mQ@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 2 Jul 2011 12:24:08 -0400
Message-ID: <BANLkTimAHc6+ZPd7gUpr0-eHGpyLSwJFEA@mail.gmail.com>
Subject: Re: [PCI Driver]Physical address being returned as 0 in mmap
To: newton mailinglist <newtonmailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please reply inline, top-posting is unwelcome on LKML.

On Sat, Jul 2, 2011 at 11:27, newton mailinglist
<newtonmailinglist@gmail.com> wrote:
> ok thanks Kyle, I will try the DMA API now.
>
>  I was wondering, when my driver gets the mmap() call then has the
>  kernel already allocated memory and put its details in the vma
>  parameter or do I need to allocate memory myself ?

Hmm, I'm not exactly clear what you are asking here... I would need
to see your driver code to be able to give you better advice, but let
me give it a shot anyways:

The "vma" is a vm_area_struct which describes the user side of the
memory-map, and in your "mmap()" call you essentially populate that
"vma" with information about the physical CPU memory addresses.
Typically that means memory allocated with dma_alloc_coherent(),
and I think the DMA API docs have some example code for this.


> I am already using the driver read and write functions to read/write
> some other parameters to the FPGA, so I will setup the DMA in mmap()

The reason I suggest read()/write() is because you are talking about
using mmap() and then doing memcpy(), whereas if you implement
your read()/write() handlers properly then you might not need to do
a memcpy() at all.

If you're just using read()/write() for parameter data, I would switch
those to an ioctl() call and use read()/write() for your bulk data transfer.
Even if you elect to use mmap() the way you have described, you
will still need to implement some ioctl() calls to allow your userspace
program to trigger the appropriate dma_sync_*() API calls on the
memory when communicating with the hardware.

Ideally, for streaming large amounts of data out of a device, you
would call read() from the device onto a large multiple-page buffer
in your userspace program.  The userspace addresses get passed
down into your kernel driver, and you use the appropriate APIs to
get the page structs for those addresses and directly DMA-map
those pages.

That means that in the best case your device will read directly into
user memory.  If the user memory is not accessible to your device
then the kernel will use the "swiotlb" driver to bounce-buffer it for
you.

Cheers,
Kyle Moffett
