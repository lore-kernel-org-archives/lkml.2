Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0KFKMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 06:12:21 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50313 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0KFKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 06:12:20 -0400
Date: Sat, 6 Nov 2010 03:12:09 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101106101209.GD11535@count0.beaverton.ibm.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <4CD08419.5050803@kernel.org>
 <4CD23087.30900@cs.columbia.edu>
 <4CD28033.1000700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD28033.1000700@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 10:43:15AM +0100, Tejun Heo wrote:

<snip>

> 
> I'm afraid that's not general or transparent at all.  It's extremely
> invasive to how a system is setup and used.  It basically is poor
> man's virtualization or rather partitioning without hardware support
> and at this point I find it very difficult to justify the added
> complexity.  Let's just make virtualization better.

<snip>
 
> I'm sorry to be in this position but the trade off just seems way off.
> As I wrote earlier, the transparent part of in-kernel CR basically
> boils down to implementing pseudo virtualization without hardware
> support and given the not-too-glorious history of that and the much
> higher focus on proper virtualization these days, I just don't think
> it makes much sense.  It's an extremely niche solution for niche use

If you think specialized hardware acceleration is necessary for
containers then perhaps you have a poor understanding of what a container
is. Chances are if you're running a container with namespaces configured
then you're already paying the performance costs of running in a
container. If you've compared the performance of that kernel to your
virtualization hardware then you already know how they compare.

For containers everything is native. You're not emulating instructions.
You're not running most instructions and trapping some. You're not
running whole other kernels, coordinating sharing of pages and cpu
with those kernels, etc. You're not emulating devices, busses,
interrupts, etc. And you're also not then circumventing every
virtualization mechanism you just added in order to provide decent
performance.

I rather doubt you'll see a difference between "native" hardware and...
native hardware. And I expect you'll see much better performance in one of
your containers than you'll ever see in some hand-waved
hypothetically-improved virtualization that your response implored us to
work on instead.

Our checkpoint/restart patches do *NOT* implement containers. They
sometimes work with containers to make use of checkpoint/restart simple.
In fact they are the strategy we use to enable "generic"
checkpoint/restart that you seem to think we lack. Everything else is
an optimization choice that we give userspace which virtualization
notably lacks.

Like above, I expect that your virtualization hardware will compare
unfavorably to kernel-based checkpoint/restart of containers. Imagine
checkpointing "ls" or "sleep 10" in a VM. Then imagine doing so for a
container. It takes way less time and way less disk for the container.

(It's also going to be easier to manage since you won't have to do
lots of special steps to get at the information in a container which is
shutdown or even one that's running. If "mycontainer" is running then
simply do:

lxc-attach -n mycontainer /bin/bash

Alternately, you can go through all the effort you normally do for
a VM -- set up a serial console, setup getty, setup sshd, etc. I don't
care -- it's more complicated than the above commandline.)

So please stop asserting that a purported lack of hardware support
is significant. Also please remember that we're not implementing containers
in this patch set -- they're already in.

Yes, our patches touch a wide variety of kernel code. You have just failed
to appreciate how "wide" the kernel ABI truly is. You can't really count
it by number of syscalls, number of pseudo-filesystems, etc. There's
also the intended behavior of those interfaces to consider. Each piece
of checkpoint/restart code is relatively self-contained. This can be
confirmed merely by looking at many of the patches we've already posted
enabling checkpoint/restart of that feature. Until you've tried to
implement checkpoint/restart for an interface or until you've bothered
to review a patch for one of them (my favorite on is eventfd:
http://www.mail-archive.com/devel@openvz.org/msg21565.html ) please
don't tell us it's too complex. Then compare that with your proposed
ghastly stack of userspace cards -- ptrace (really more like strace) +
LD_PRELOAD + a daemon...

Incidentally, 20k lines of code is less than many pieces of the kernel.
It's less than many:

Filesystems (I've selected ones designed for rotating media or networks usually..)
	ext4, nfs, ocfs2, xfs, reiserfs, ntfs, gfs2, jfs, cifs, ubifs, nilfs2, btrfs

Non-filesystem file-system support code:
	nfsd, nls

It's less than one of the simpler DRM graphics drivers -- i915:
	$ cd drivers/gpu/drm/i915
	$ wc -l *.[ch]
	...
	41481 total

It's less than any one of the lpfc, bfa, aic7xxx, qla2xxx, and mpt2sas
drivers I see under scsi. Perhaps a more fair comparison might be to compare
a single driver to a single checkpointable kernel interface but it's
a more-fair comparison that skews even more in our favor.

Yes, when you *add it all up* it's more than half the size of the kernel/
directory. Bear in mind that the portions we add to kernel/checkpoint though
are only 4603 lines long -- about the same size as many kernel/*.c files.
The rest is for each kernel interface that adds/manipulates state we need to
be able to checkpoint. Or arch code.. etc.

So please don't base your assessment of our code on your apparently
flawed notion of containers nor on the summary line of a diffstat you saw.

Cheers,
	-Matt Helsley
