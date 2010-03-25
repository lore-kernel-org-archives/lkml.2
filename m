Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0CYTlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:41:04 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36182 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0CYTk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mDKNwGv79hc1JENfO4TAxToaL57JSy5A99lj50/nYJpYbSka8pvuOqogT3f+kwhZGU
         Nlewr7kZifkl7ampvFtv6b4MQ8lvjwpobpLnkVM4vU1xF/y4/mghf0kFGRjMM3TkXaik
         c/gUoSZA12YUAd8Ts4pHDY1bgx8yPMbX8FFp8=
Date: Fri, 26 Mar 2010 01:11:00 +0530
From: Rabin Vincent <rabin@rab.in>
To: lkml <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, hpa@zytor.com, penberg@cs.helsinki.fi,
       cl@linux-foundation.org
Subject: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100325194100.GA2364@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On latest git, I'm seeing "start_kernel(): bug: interrupts were enabled
early" messages on ARM (sample log below).

This appears to be caused by:

  start_kernel -> radix_tree_init -> kmem_cache_create (slub) ->
   down_write -> __down_write (lib/rwsem-spinlock.c) -> spin_unlock_irq

radix_tree_init was moved earlier by:

  commit 773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
  Author: Yinghai Lu <yinghai@kernel.org>
  Date:   Wed Feb 10 01:20:33 2010 -0800

      init: Move radix_tree_init() early

      Prepare for using radix trees in early_irq_init().

      Signed-off-by: Yinghai Lu <yinghai@kernel.org>
      LKML-Reference: <1265793639-15071-30-git-send-email-yinghai@kernel.org>
      Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Rabin

---
Uncompressing Linux... done, booting the kernel.
Linux version 2.6.34-rc2-00184-g01e7770 (rabin@debian) (gcc version 4.4.1 (Sourcery G++ Lite 2009q3-67) ) #5 Fri Mar 26 00:56:33 IST 2010
CPU: ARMv7 Processor [410fc080] revision 0 (ARMv7), cr=10c03c7f
CPU: VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
Machine: ARM-RealView PB-A8
Ignoring unrecognised tag 0x00000000
bootconsole [earlycon0] enabled
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: earlyprintk mem=128M console=ttyAMA0 root=/dev/ram0 init=/linuxrc
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 128MB = 128MB total
Memory: 123916k/123916k available, 7156k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc8800000 - 0xf8000000   ( 760 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .init : 0xc0008000 - 0xc0331000   (3236 kB)
      .text : 0xc0331000 - 0xc040b000   ( 872 kB)
      .data : 0xc040c000 - 0xc0418180   (  49 kB)
SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:96
start_kernel(): bug: interrupts were enabled early
Calibrating delay loop... 419.43 BogoMIPS (lpj=2097152)
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
devtmpfs: initialized
Serial: AMBA PL011 UART driver
dev:uart0: ttyAMA0 at MMIO 0x10009000 (irq = 44) is a AMBA/PL011
console [ttyAMA0] enabled, bootconsole disabled
console [ttyAMA0] enabled, bootconsole disabled
dev:uart1: ttyAMA1 at MMIO 0x1000a000 (irq = 45) is a AMBA/PL011
dev:uart2: ttyAMA2 at MMIO 0x1000b000 (irq = 46) is a AMBA/PL011
fpga:uart3: ttyAMA3 at MMIO 0x1000c000 (irq = 47) is a AMBA/PL011
Switching to clocksource timer3
Unpacking initramfs...
Freeing initrd memory: 1680K
VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 0
Freeing init memory: 3236K
