Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0CQEx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:53:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0CQExz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:53:55 -0400
Date: Wed, 17 Mar 2010 15:53:50 +1100
From: Nick Piggin <npiggin@suse.de>
To: Ben Gamari <bgamari.foss@gmail.com>, tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100317045350.GA2869@laptop>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 16, 2010 at 08:31:12AM -0700, Ben Gamari wrote:
> Hey all,
> 
> Recently I started using the Xapian-based notmuch mail client for everyday
> use.  One of the things I was quite surprised by after the switch was the
> incredible hit in interactive performance that is observed during database
> updates. Things are particularly bad during runs of 'notmuch new,' which scans
> the file system looking for new messages and adds them to the database.
> Specifically, the worst of the performance hit appears to occur when the
> database is being updated.
> 
> During these periods, even small chunks of I/O can become minute-long ordeals.
> It is common for latencytop to show 30 second long latencies for page faults
> and writing pages.  Interactive performance is absolutely abysmal, with other
> unrelated processes feeling horrible latencies, causing media players,
> editors, and even terminals to grind to a halt.
> 
> Despite the system being clearly I/O bound, iostat shows pitiful disk
> throughput (700kByte/second read, 300 kByte/second write). Certainly this poor
> performance can, at least to some degree, be attributable to the fact that
> Xapian uses fdatasync() to ensure data consistency. That being said, it seems
> like Xapian's page usage causes horrible thrashing, hence the performance hit
> on unrelated processes.

Where are the unrelated processes waiting? Can you get a sample of
several backtraces?  (/proc/<pid>/stack should do it)


> Moreover, the hit on unrelated processes is so bad
> that I would almost suspect that swap I/O is being serialized by fsync() as
> well, despite being on a separate swap partition beyond the control of the
> filesystem.

It shouldn't be, until it reaches the bio layer. If it is on the same
block device, it will still fight for access. It could also be blocking
on dirty data thresholds, or page reclaim though -- writeback and
reclaim could easily be getting slowed down by the fsync activity.

Swapping tends to cause fairly nasty disk access patterns, combined with
fsync it could be pretty unavoidable.

> 
> Xapian, however, is far from the first time I have seen this sort of
> performance cliff. Rsync, which also uses fsync(), can also trigger this sort
> of thrashing during system backups, as can rdiff. slocate's updatedb
> absolutely kills interactive performance as well.
> 
> Issues similar to this have been widely reported[1-5] in the past, and despite
> many attempts[5-8] within both I/O and memory managements subsystems to fix
> it, the problem certainly remains. I have tried reducing swappiness from 60 to
> 40, with some small improvement and it has been reported[20] that these sorts
> of symptoms can be negated through use of memory control groups to prevent
> interactive process pages from being evicted.

So the workload is causing quite a lot of swapping as well? How much
pagecache do you have? It could be that you have too much pagecache and
it is pushing out anonymous memory too easily, or you might have too
little pagecache causing suboptimal writeout patterns (possibly writeout
from page reclaim rather than asynchronous dirty page cleaner threads,
which can really hurt).

Thanks,
Nick

