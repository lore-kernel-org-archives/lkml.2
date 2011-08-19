Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1HSRxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:53:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39536 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1HSRxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:53:24 -0400
Date: Fri, 19 Aug 2011 14:53:16 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Thomas Meyer <thomas@m3y3r.de>,
        Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org
Subject: [REGRESSION][BISECTED] Notebook crashes upon detecting the PCI
 subsystem with kernels >= 2.6.24-rc7
Message-ID: <20110819175316.GA999@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

My mom has a notebook that is quite quirky and I have had a hard
time trying to install any Linux distribution on it.

This is a notebook that works fine with Windows Vista, but she
wants to use Linux and wipe Windows completely.  The notebook has
an nVidia C51 chipset (nForce), a "forcedeth" network card, with
a Geforce Go 6100 video card and an AMD Sempron 3400+.

After *many* trial and error sessions, I found that kernel 2.6.24 worked
with this notebook, but *anything* more recent (in particular, even Debian
stable is "too recent" for it) just made it hang right after the io
schedulers were set up.

In other words, a regression.

>From my dmesg logs, the next thing after the io schedulers seems
to be the PCI devices. The first lines that appear right after
the io scheduler ones are:

,----
| [    0.207345] io scheduler cfq registered (default)
| [    0.207407] pci 0000:00:05.0: Boot video device
| [    0.223320] PCI: Setting latency timer of device 0000:00:02.0 to 64
| [    0.223320] assign_interrupt_mode Found MSI capability
| [    0.223320] Allocate Port Service[0000:00:02.0:pcie00]
| [    0.223320] PM: Adding info for pci_express:0000:00:02.0:pcie00
| [    0.223320] PCI: Setting latency timer of device 0000:00:03.0 to 64
| [    0.223320] assign_interrupt_mode Found MSI capability
| [    0.223320] Allocate Port Service[0000:00:03.0:pcie00]
| [    0.223320] PM: Adding info for pci_express:0000:00:03.0:pcie00
| [    0.223320] PM: Adding info for platform:vesafb.0
`----

I took the laborious task of `git bisecting` the kernel (more than 30
recompiles, and fsck'ing the disc), I found that the first bad commit
(12c22d6e), a revert by Linus:


,----[ git bisect bad ]
| 12c22d6ef299ccf0955e5756eb57d90d7577ac68 is the first bad commit
| commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
| Author: Linus Torvalds <torvalds@linux-foundation.org>
| Date:   Wed Mar 26 11:22:40 2008 -0700
| 
|     Revert "PCI: remove transparent bridge sizing"
|     
|     This reverts commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, which
|     caused various interesting problems for people, including wrong resource
|     allocations.  See for example bugzilla entry "2.6.25-rc2: ohci1394
|     problem (MMIO broken)" at
|     
|     	http://bugzilla.kernel.org/show_bug.cgi?id=10080
|     
|     And Gary Hade says:
|     
|      "The same change had also exposed an issue reported by Paul Martin that
|       has been causing an Oops while hotplugging ThinkPads to a ThinkPad
|       Dock II.  See
|     
|     	http://lkml.org/lkml/2008/2/19/405
|     	http://bugzilla.kernel.org/show_bug.cgi?id=9961
|     
|       I have a fix for the ThinkPad docking Oops but if the issue being
|       discussed here is caused by the transparent bridge sizing removal
|       change I totally agree that it should be reverted."
|     
|       The transparent bridge sizing removal change was motivated by
|       insufficient PCI memory resource for a transparent bridge window that
|       was being created as a result of expansion ROM(s) being included in
|       the transparent bridge sizing calculations.
|     
|       A later "PCI: Remove default PCI expansion ROM memory allocation"
|       change ( re: http://lkml.org/lkml/2007/12/11/361 ) removes the
|       expansion ROM(s) from the transparent bridge sizing calculations which
|       actually resolves the original issue in a different manner.  So, even
|       if the "PCI: remove transparent bridge sizing" is not problematic it
|       is no longer needed anyway."
|     
|     Identified-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
|     Tested-by: Thomas Meyer <thomas@m3y3r.de>
|     Acked-by: Gary Hade <garyhade@us.ibm.com>
|     Acked-by: Ingo Molnar <mingo@elte.hu>
|     Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
|     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
| 
| :040000 040000 e3d0046e6ce6dc4e3bb6114db61336125fab9ea7 c60b1fdbdc2bda47dbb822b0a741d8254a7d8afa M	drivers
`----

I am willing to test anything to make this notebook work with a recent
kernel version, so that I can prepare this to her use with a modern
distribution.

Please, advise if you need any dmesg, lspci outputs, acpi dumps, etc.  You
tell me, and I try my best to get whatever you want me.


Thanks in advance for any help,

Rogério Brito.

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
