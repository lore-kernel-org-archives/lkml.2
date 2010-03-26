Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0CZD2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:28:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60589 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0CZD2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=bmI/P0qAGLHDYMNFcsNDzG+UgcCetv3ps/1+NIh5XMhYZYe/SeaDM3SKC1QnX1luBW
         01qyTDZUKEN4fIkgIUV1+F1tZwdZd0Q3ICFBZxz0h4sheEFxpQRhuumvj0y7Z97EpWjM
         hFkUHd0rcVSB/+XZQtFL8Go9FhvwEBdHFt27M=
Message-ID: <4bac29d9.9d15f10a.42df.183e@mx.google.com>
Date: Thu, 25 Mar 2010 20:28:25 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Nick Piggin <npiggin@suse.de>, tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100317045350.GA2869@laptop>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317045350.GA2869@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 15:53:50 +1100, Nick Piggin <npiggin@suse.de> wrote:
> Where are the unrelated processes waiting? Can you get a sample of
> several backtraces?  (/proc/<pid>/stack should do it)
> 
I wish. One of the incredibly frustrating characteristics of this issue is the
difficulty in measuring it. By the time processes begin blocking, it's already
far too late to open a terminal and cat to a file. By the time the terminal has
opened, tens of seconds have passed and things have started to return to normal.

> 
> > Moreover, the hit on unrelated processes is so bad
> > that I would almost suspect that swap I/O is being serialized by fsync() as
> > well, despite being on a separate swap partition beyond the control of the
> > filesystem.
> 
> It shouldn't be, until it reaches the bio layer. If it is on the same
> block device, it will still fight for access. It could also be blocking
> on dirty data thresholds, or page reclaim though -- writeback and
> reclaim could easily be getting slowed down by the fsync activity.
> 
Hmm, this sounds interesting. Is there a way to monitor writeback throughput.

> Swapping tends to cause fairly nasty disk access patterns, combined with
> fsync it could be pretty unavoidable.
> 
This is definitely a possibility. However, it seems to me like swapping should
be at least mildly favored over other I/O by the I/O scheduler. That being
said, I can certainly see how it would be difficult to implement such a
heuristic in a fair way so as not to block out standard filesystem access
during a thrashing spree.

> > 
> > Xapian, however, is far from the first time I have seen this sort of
> > performance cliff. Rsync, which also uses fsync(), can also trigger this sort
> > of thrashing during system backups, as can rdiff. slocate's updatedb
> > absolutely kills interactive performance as well.
> > 
> > Issues similar to this have been widely reported[1-5] in the past, and despite
> > many attempts[5-8] within both I/O and memory managements subsystems to fix
> > it, the problem certainly remains. I have tried reducing swappiness from 60 to
> > 40, with some small improvement and it has been reported[20] that these sorts
> > of symptoms can be negated through use of memory control groups to prevent
> > interactive process pages from being evicted.
> 
> So the workload is causing quite a lot of swapping as well? How much
> pagecache do you have? It could be that you have too much pagecache and
> it is pushing out anonymous memory too easily, or you might have too
> little pagecache causing suboptimal writeout patterns (possibly writeout
> from page reclaim rather than asynchronous dirty page cleaner threads,
> which can really hurt).
> 
As far as I can tell, the workload should fit in memory without a problem. This
machine has 4 gigabytes of memory, of which currently 2.8GB is page cache.
Seems high perhaps? I've included meminfo below. I can completely see how
overly-aggressive page-cache would result in this sort of behavior.

- Ben


MemTotal:        4048068 kB
MemFree:           47232 kB
Buffers:              48 kB
Cached:          2774648 kB
SwapCached:         1148 kB
Active:          2353572 kB
Inactive:        1355980 kB
Active(anon):    1343176 kB
Inactive(anon):   342644 kB
Active(file):    1010396 kB
Inactive(file):  1013336 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4883756 kB
SwapFree:        4882532 kB
Dirty:             24736 kB
Writeback:             0 kB
AnonPages:        933820 kB
Mapped:            88840 kB
Shmem:            750948 kB
Slab:             150752 kB
SReclaimable:     121404 kB
SUnreclaim:        29348 kB
KernelStack:        2672 kB
PageTables:        31312 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     6907788 kB
Committed_AS:    2773672 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      364080 kB
VmallocChunk:   34359299100 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        8552 kB
DirectMap2M:     4175872 kB

