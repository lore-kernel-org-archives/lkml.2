Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0EKIre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:47:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:51556 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757433Ab0EKIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:47:29 -0400
Cc: akpm@osdl.org, trond.myklebust@fys.uio.no, riel@redhat.com, major@mhtx.net
Content-Type: text/plain; charset="utf-8"
Date: Tue, 11 May 2010 10:47:26 +0200
From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Message-ID: <20100511084726.88120@gmx.net>
MIME-Version: 1.0
Subject: Re: [BUG?] vfs_cache_pressure=0 does not free inode caches
To: linux-kernel@vger.kernel.org
X-Authenticated: #15156664
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/JcydklUzJA7mjQWkJ8Isi467uZu2m0sh102qRj+
 5e5nSs/JgIs0szqPlYO/b1qdxTucvdKgaYHA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: rS7belgKIydmEJ0gk2drnwNSa2FkZhXq
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> "Alexander Stohr" <Alexander.Stohr@xxxxxx> wrote:

> > i'm running an embedded system with NFS as my working area.
> > the system has only few ram leftover, any MiBi counts.
> >
> > my current best guess to resolve low memory situations
> > is a manual one (no, i could not see any smart kernel reaction
> > with that relatively old but patched 2.6.18 kernel) is this:
> >
> > echo 100000 >/proc/sys/vm/vfs_cache_pressure
> > sync
> > echo 1 >/proc/sys/vm/drop_caches
> > echo 2 >/proc/sys/vm/drop_caches

> I'm not sure what to say, really.

Thanks for your honest and helpful reply.

> If you tell the kernel not to reclaim inode/dentry caches then it will
> do what you asked. It _sounds_ like you're looking for more aggressive
> reclaim of the VFS caches when the system is getting low on memory.
> Perhaps this can be done by _increasing_ vfs_cache_pressure.

Yes, thats the method i used already. Its probably not impacting that much as caches still steadily grow as you read inodes and that value wont stop growing for the sizes i am having in my setup (<20 MB). obviously there is no timer for auto-dropping (i think i just confused it with needed timed auto-flushing of disk write data).

Doing a test drive with top, slabtop and a c coded malloc helper program that touches any byte in a heap allocated memory portion made the image clearer. (As its intended to be an embedded system there is no swap.)

step 1: fill caches by running "ls -lR /"; abort it at some 5 MB cache counter in top
step 2: run the malloc helper with increasing memory specification (10MB to 21 MB) until OOM killer hits it the first time; cache counter drops down to 1,8 MB
step 3: write "3" to drop_caches (without and with prior sync); cache counter drops again down to 1,2 MB, dentry/inode/nfs_inode/shm_inode cache values still stay at a total of some 0,5 kB - that equals to a bit more than 100 4k pages or some 1000 512byte disk sectors.

(step 4: having manually dropped the caches did _not_ result in the application being able to run using any more memory - i am puzzled.)

> But the
> kernel should wring the last drop out of the VFS caches before
> declaring OOM anyway - if it isn't doing that, we should fix it.

Its not dropping anything out of the slab based areas as these areas are just the kernels internal heap system but some of this memory represents caches and for that the slab footprint definitely shrinks down. Its just not anything in these caches that gets dropped (that far as it can diagnosed with a few loaded diagnostics applications still alive). when using memory via an application a noticeable amount still stays in. when triggering manually another chunk gets dropped but finally there is still some memory dedicated to caches. not that i worry too much about that now.

> Perhaps you could tell us exactly what behaviour you're observing, and
> how it differs from what you'd like to see.

partly done above. i would expect to see the kernels memory allocator to drain the caches to the same level as it can be done manually (and without any urgent system need) using the drop_caches interface from proc.

> > http://rackerhacker.com/2008/12/03/reducing-inode-and-dentry-caches-to-keep-oom-killer-at-bay/
> drop_caches only drops stuff which has been written back.

thanks for commenting on that.
in contrast to the opinion on this web page i assumed this to be a non-critical operation, else e.g. machines used in benchmarks would have a risky and short lifetime.

so whats left over? the cache size reported by top is not dropping below 1,2 MB and the rough sum of cache related data reported by slabtop is some 500 kB that looked pretty persistent in the test. the kernel functionality automatically invoked when peak memory amounts are requested will drop lesser caches than when cache drop is requested explicitly. dropping more cache memory does not impact on the application - thats probably the least expected result i got.
-- 
GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
