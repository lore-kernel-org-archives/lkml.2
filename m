Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab2FADod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 23:44:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57475 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814Ab2FADob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 23:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <CALDO+SZ4L-KiS2ZONHiEP=F4aLzT6+7M83h5yG5QCE7+T-SL=w@mail.gmail.com>
References: <CALDO+SZwRt_pp-n5wx9uwhkqD1-JHpgUahxbwEVm-QWBx5cu7A@mail.gmail.com>
	<CALDO+SZC06GzKByqs2ygY521i=R4dwcMU+OhhUvvXAxuPB=OSA@mail.gmail.com>
	<CALDO+SZ4L-KiS2ZONHiEP=F4aLzT6+7M83h5yG5QCE7+T-SL=w@mail.gmail.com>
Date: Fri, 1 Jun 2012 11:44:31 +0800
Message-ID: <CALDO+Sbhz0xtXDbazQE1Ojn+-0k3es3-D8g9y9tXKa3Oz+yF+Q@mail.gmail.com>
Subject: Fwd: Low shared memory throughput at VM when using PCI mapping
From: William Tu <u9012063@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an update if you are interested in the outcome. I turns
out that my MTRR (Memory Type Range Register) configuration does not
take effect so that the shared memory region is always uncachable. My
shared memory is located at 0xf240000, and the MTRR settings are
below:

> cat /proc/mtrr
reg00: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
reg01: base=0x0f2400000 ( 3876MB), size=    4MB, count=1: write-back

The first entry actually ranges from 0xe0000000 to 0xffffffff, which
covers the 0xf24000000, even if I follow the Linux documentation
(Documentation/mtrr.txt) to create an overlapping mtrr at listed
below, the 0xf2400000 is still uncachable

// overlapping way:
reg00: base=0x0f2400000 ( 3876MB), size=    4MB, count=1: write-back
reg01: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable

In the end, I tried exclusive out the shared memory region
(0xf2400000) from the uncachable region and the 0xf2400000 finally
becomes cacheable as I wish!

//non-overlapping MTRR list:
reg00: base=0x0e0000000 ( 3584MB), size=  256MB, count=1: uncachable
reg01: base=0x0f0000000 ( 3840MB), size=   32MB, count=1: uncachable
reg02: base=0x0f2000000 ( 3872MB), size=        4MB, count=1: uncachable
reg03: base=0x0f2800000 ( 3880MB), size=        8MB, count=1: uncachable
reg04: base=0x0f3000000 ( 3888MB), size=   16MB, count=1: uncachable
reg05: base=0x0f4000000 ( 3904MB), size=   64MB, count=1: uncachable
reg06: base=0x0f8000000 ( 3968MB), size=  128MB, count=1: uncachable

I also found one wired thing that I have to setup this MTRR at the
very beginning (after bootup before I do anything to this shared
memory). Once if I touch the shared memory and its mtrr is
uncacheable, even though I modified its mtrr entry to write-back
afterwards, the kernel still takes it as uncacheable and the memory
read/write shows high latency. Does anyone run into similar cases?

Here is my updated experiment of write 400MB and read 4MB:
------------------------------------------
 op   ,  ioremap type  ,  jiffies
------------------------------------------
read, ioremap_nocache, 304
write, ioremap_nocache, 3336
read, ioremap_wc,           309
write, ioremap_wc,           23
read, ioremap_cache,      30
write, ioremap_cache,      22
------------------------------------------


Regards,
William (Cheng-Chun Tu)

On Wed, May 30, 2012 at 4:56 PM, William Tu <u9012063@gmail.com> wrote:
> Hi Folks,
>
> I'm using PCI device pass-through to pass a network device to a VM.
> Since one of my additional requirements is to share a memory between
> VM and host, I pre-allocate a memory at host (say physaddr: 0x100) and
> put this address into the BAR2 of the network device's pci
> configuration space. (similar idea as ivshmem)
>
> The KVM boots up and the device inside VM shows me a new BAR2 address
> as its guest physical address (say: addr: 0x200). I assume KVM
> automatically setups the guest physical to host physical mappings in
> its EPT for me. So that I can use ioremap(0x200, size) at VM to access
> memory at the host.
>
> However I found that this memory seems to be ** uncacheable ** as its
> read/write speed is quite slow. Frank and Cam suggest that using
> ioremap_wc can speed up things quite a bit.
> http://comments.gmane.org/gmane.comp.emulators.qemu/69172
>
> In my case, ioremap_wc indeed is fast, but write combining only
> applies to write throughput. To increase both read/write speed, I use
> ioremap_cache and ioremap_nocache, but both show the same speed.
>
> Here is my experiment of write 400MB and read 4MB:
> ------------------------------------------
> op   ,  ioremap type  ,  jiffies
> ------------------------------------------
> read, ioremap_nocache, 304
> write, ioremap_nocache, 3336
> read, ioremap_wc,           309
> write, ioremap_wc,           23
> read, ioremap_cache,      302
> write, ioremap_cache,      3284
> ------------------------------------------
>
> Since all memory read have the same speed, I guess the range of shared
> memory is marked as uncacheable in VM. Then I configure the MTRR in VM
> to set this region as write-back.
>
>> cat /proc/mtrr
> reg00: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
> reg01: base=0x0f2400000 ( 3876MB), size=    4MB, count=1: write-back
> --> my shared memory addr at BAR2
>
> Sadly this does not improve my read/write performance and using
> ioremap_cache and nocache still show the same numbers. I'm now
> checking why the MTRR does not take any effect and also making sure
> the shared memory is cacheable in both host and VM. Any comments or
> suggestions are appreciated!
>
>
> Regards,
> William (Cheng-Chun Tu)
