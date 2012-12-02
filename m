Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2LBX4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:56:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:52900 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754036Ab2LBX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:56:33 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+sa+M9mpms0357unUvnubxxFyYH9svRXUwIW1sE4
	sWd7rw2bFCsNPq
Date: Mon, 3 Dec 2012 01:56:27 +0200 (EET)
From: Dimitrios Apostolou <jimis@gmx.net>
X-X-Sender: jimis@soupermouf
To: Roland Eggner <edvx1@systemanalysen.net>
cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
In-Reply-To: <20121202225051.GA13685@mobil.systemanalysen.net>
Message-ID: <alpine.LFD.2.02.1212030120090.1646@soupermouf>
References: <1353855815.22969.20.camel@soupermouf> <1354452243.22969.48.camel@soupermouf> <20121202225051.GA13685@mobil.systemanalysen.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1655437704-1354492591=:1646"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1655437704-1354492591=:1646
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Dear Ronald,

sorry for not replying at your first message but I didn't consider 
changing kernel as a resolution to my problem.

On Sun, 2 Dec 2012, Roland Eggner wrote:
> Hello Dimitrios!
>
>
> Which part of …
>
> “0,5 … 1 G RAM is usually occupied just by kernel slab [1];  this
> memory cannot be swapped, it cannot be released by other means than rebooting,
> and there seems to be  _no_  adjustment to memory pressure.”
>
> … should I explain?

Check my initial message. If you see the /proc/meminfo attached you'll see 
that from all slab memory most is reclaimable, however it's not being 
reclaimed despite the memory pressure:

Slab:              64880 kB
SReclaimable:      60496 kB
SUnreclaim:         4384 kB

Also I mentioned that a nice'd -20 (Realtime!) process was unresponsive 
because of two nice'd + ionice'd processes. This is a bug no matter the 
memory pressure, IMHO. If not I'd rather hear it from someone more 
authoritative.

> When tar or gzip writes to ext4 filesystem on your external disk, the kernel
> keeps all inode data in slab memory  _by design_ , not by memory leaks.

ext4_inode_cache is a *cache*. So the kernel does not keep /all/ inode 
data there, but only what was needed recently. And drops it afterwards, 
which didn't happen after the backup ended.

> Several 100 M slab data cannot be stored within 128 M total RAM.
> This cannot by solved by usage of /proc/sys/vm/drop_caches.

Please take a look at [2], it's what is called in that case. Via this call 
all slabs that have registered a shrinker, get actually shrinked. 
Other fs do, but I can't find whether ext4 actually registers a shrinker 
for its slabs.

[2] http://lxr.linux.no/#linux+v3.6.8/mm/vmscan.c#L207


> This cannot by solved by oom-killer-actions.
> This cannot be solved by zram tricks.
> Unmounting the external disk would release part of slab memory, but then you
> cannot backup.

Unmounting the back'ed up fs didn't really help in my case. Of course all 
my filesystems are ext[234], mounted by ext4 code, so they use the same 
slab for caches. But anyway, the slab didn't shrink significantly as I was 
expecting.

> Reformatting the ext4 filesystem on your external disk with 128 byte inode size,
> largest possible blocksize and with extents enabled might mitigate the memory
> pressure slightly … probably not sufficient to get a working system with 3.6
> kernel.
>
>
> One advantage of Linux compared to other OS is much more support for old
> hardware, if a  _proper_  kernel version is selected.  Many years ago I used
> a notebook with 40 M total RAM, with a 2.4 kernel, Blackbox window manager and
> Opera web browser … it worked flawlessly … just rather slowly due to swapping.
> Your notebook has much more RAM than 40 M, thus there is surely a Linux solution
> for you.  Try a 2.6.27.62 kernel, it supports ext4 (“ext4dev”), probably it
> supports all devices of your notebook, and with a slim window manager e.g.
> WindowMaker or OpenBox your notebook will probably “fly”.

I appreciate your advice. I remember when we were running 2.4 much less 
memory was needed, but still I consider the kernel /fairly/ lean 
considering the time passed and the bloat in userspace applications. I 
choose to run latest kernels on old hardware, hopefully this will continue 
to be the case, and if things deteriorate much then let's hope we'll have 
enough time to help and fix them! :-)


Thanks,
Dimitris

--8323328-1655437704-1354492591=:1646--
