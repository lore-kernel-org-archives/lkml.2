Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0EJVTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:19:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410Ab0EJVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:19:22 -0400
Date: Mon, 10 May 2010 14:18:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no, riel@redhat.com,
       major@mhtx.net
Subject: Re: [BUG?] vfs_cache_pressure=0 does not free inode caches
Message-Id: <20100510141844.3a3c74df.akpm@linux-foundation.org>
In-Reply-To: <20100510172621.284310@gmx.net>
References: <20100510172621.284310@gmx.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 19:26:21 +0200
"Alexander Stohr" <Alexander.Stohr@gmx.de> wrote:

> this is a follow up to:
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/03026.html
> 
> > The server is going to die a slow death,
> > all user space memory is swapped out,
> > then all processes are OOM killed 
> > until it dies from complete memory exhaustion."
> 
> > a cache is supposed to be a cache and not a memory hog
> 
> i'm running an embedded system with NFS as my working area.
> the system has only few ram leftover, any MiBi counts.
> 
> my current best guess to resolve low memory situations
> is a manual one (no, i could not see any smart kernel reaction
> with that relatively old but patched 2.6.18 kernel) is this:
> 
> echo 100000 >/proc/sys/vm/vfs_cache_pressure
> sync
> echo 1 >/proc/sys/vm/drop_caches
> echo 2 >/proc/sys/vm/drop_caches
> 
> any hints on that?
> is this still an issue in current kernels
> or is this already addressed in some way?
> 

I'm not sure what to say, really.

If you tell the kernel not to reclaim inode/dentry caches then it will
do what you asked.  It _sounds_ like you're looking for more aggressive
reclaim of the VFS caches when the system is getting low on memory. 
Perhaps this can be done by _increasing_ vfs_cache_pressure.  But the
kernel should wring the last drop out of the VFS caches before
declaring OOM anyway - if it isn't doing that, we should fix it.

Perhaps you could tell us exactly what behaviour you're observing, and
how it differs from what you'd like to see.

> 
> 
> here is the link to the initial patch set applied to 2.6.8:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=95afb3658a8217ff2c262e202601340323ef2803
> 
> some other people spotting similar effects:
> http://rackerhacker.com/2008/12/03/reducing-inode-and-dentry-caches-to-keep-oom-killer-at-bay/

That page says "If you are writing data at the time you run these
commands, you'll actually be dumping the data out of the filesystem
cache before it reaches the disk, which could lead to very bad things".
That had better not be true!  That would be a bad bug.  drop_caches
only drops stuff which has been written back.
