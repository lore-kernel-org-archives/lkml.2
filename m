Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2IJQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:49:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39516 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2IJQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:49:48 -0400
Date: Mon, 10 Sep 2012 17:49:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Ungerer <gregungerer@westnet.com.au>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches
 solicited
Message-ID: <20120910164946.GO13973@ZenIV.linux.org.uk>
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
 <504DEDBB.1090404@westnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504DEDBB.1090404@westnet.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:40:11PM +1000, Greg Ungerer wrote:
> Hi Al,
> 
> On 09/08/2012 04:20 AM, Al Viro wrote:
> >	To architecture maintainers: please, review the current
> >situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
> >and consider sending the corresponding patches for missing architectures.
> 
> I can see you have some m68k patches in there as well.
> They tested good on standard m68k (under emulator) and good on non-mmu
> ColdFire. But it is geting an exception when I run on ColdFire with MMU
> enabled:
> 
> ...
> Creating 1 MTD partitions on "RAM":
> 0x000000000000-0x0000001b8000 : "ROMfs"
> TCP: cubic registered
> NET: Registered protocol family 17
> VFS: Mounted root (romfs filesystem) readonly on device 31:0.
> *** FORMAT ERROR ***   FORMAT=4
> Current process id is 1
> BAD KERNEL TRAP: 00000000
> Modules linked in:
> PC: [<0002562a>] 0x02562a
> SR: 2704  SP: 0383dfc4  a2: 00000000
> d0: 00000000    d1: 00000000    d2: 00000000    d3: 00000000
> d4: 00000000    d5: 00000000    a0: 00000000    a1: 00000000
> Process init (pid: 1, task=0383a000)
> Frame format=4 eff addr=00000000 pc=6000169a
> Stack from 0383e000:
> Call Trace:
> Code: 6610 4cd7 073e 4fef 0020 201f 588f dfdf <4e73> 2228 0004 46fc
> 2000 0801 0007 66ff ffff c2ea 598f 4fef ffe8 48d7 78c0 486f
> Disabling lock debugging due to kernel taint
> 
> It is trapping at the return from exception (rte) in Lreturn.
> Looks like it doesn't like the "format" field of the new stack frame
> for some reason. If I get a few minutes tomorrow I'll dig into it.

Interesting...  What it should get is format 0, same as before the change.
BTW, is there any convenient way to get an emulated coldfire-MMU system?
For m68k I'm using aranym with sid/m68k from debian-ports.org and it seems
to work fine these days, but that obviously won't do for coldfire - neither
the emulator itself, nor the userland (AFAICS, gcc will happily generate
instructions that use weird addressing modes unless told not to, so I would
be extremely surprised if normal debian m68k binaries would run on coldfire,
MMU or no MMU).

BTW, the same question goes for many other embedded targets - I'm using
qemu for arm and mips and hercules for s390; alpha, parisc, ppc32 and sparc64 -
on actual hardware, amd64 and i386 - on kvm guests (all with debian userland);
ia64 kinda-sorta works with ski, but it's very much imperfect...  I think
sh (at least sh4) should be usable with qemu as well, but I hadn't set that
up yet.  sparc32 is usable on qemu, but only with very old userland.
Everything else...  In theory, quite a few ought to be usable if one
bootstraps uclinux userland with qemu, but I've no idea how well does that
work in practice.  And seeing that e.g. FRV eval boards go for several
hundred dollars even on ebay, let alone from manufacturer, I'd rather not
add the actual hardware to the pile here ;-/

What do people actually use?
