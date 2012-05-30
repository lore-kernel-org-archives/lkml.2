Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2E3HSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:18:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42172 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2E3HSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:18:20 -0400
MIME-Version: 1.0
Date: Wed, 30 May 2012 15:18:19 +0800
Message-ID: <CALDO+SZwRt_pp-n5wx9uwhkqD1-JHpgUahxbwEVm-QWBx5cu7A@mail.gmail.com>
Subject: Low shared memory throughput at VM when using PCI mapping
From: William Tu <u9012063@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I'm using PCI device pass-through to pass a network device to a VM.
Since one of my additional requirements is to share a memory between
VM and host, I pre-allocate a memory at host (say physaddr: 0x100) and
put this address into the BAR2 of the network device's pci
configuration space.

The KVM boots up and the device inside VM shows me a new BAR2 address
as its guest physical address (say: addr: 0x200). I assume KVM
automatically setups the guest physical to host physical mappings in
its EPT for me. So that I can use ioremap(0x200, size) at VM to access
memory at the host.

However I found that this memory seems to be uncacheable as its
read/write speed is quite slow. Frank and Cam suggest that using
ioremap_wc can speed up things quite a bit.
http://comments.gmane.org/gmane.comp.emulators.qemu/69172

In my case, ioremap_wc indeed is fast, but write combining only
applies to write throughput. To increase both read/write speed, I use
ioremap_cache and ioremap_nocache, but both show the same speed.

Here is my experiment of write 400MB and read 4MB:
------------------------------------------
op   ,  ioremap type  ,  jiffies
------------------------------------------
read, ioremap_nocache, 304
write, ioremap_nocache, 3336
read, ioremap_wc,           309
write, ioremap_wc,           23
read, ioremap_cache,      302
write, ioremap_cache,      3284
------------------------------------------

Since all memory read have the same speed, I guess the range of shared
memory is marked as uncacheable in VM. Then I configure the MTRR in VM
to set this region as write-back.

> cat /proc/mtrr
reg00: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
reg01: base=0x0f2400000 ( 3876MB), size=    4MB, count=1: write-back
--> my shared memory addr at BAR2

Sadly this does not improve my read/write performance and using
ioremap_cache and nocache still show the same numbers. I'm now
checking why the MTRR does not take any effect and also making sure
the shared memory is cacheable in host and VM. Any comments or
suggestions are appreciated!


Regards,
William (Cheng-Chun Tu)
