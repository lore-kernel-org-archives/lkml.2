Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2JJQ56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:57:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab2JJQ5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:57:54 -0400
Date: Wed, 10 Oct 2012 18:57:50 +0200
From: Jan Kara <jack@suse.cz>
To: Viktor Nagy <viktor.nagy@thx4games.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Darrick J. Wong" <djwong@us.ibm.com>, chris.mason@fusionio.com
Subject: Re: Linux 3.0+ Disk performance problem - wrong pdflush behaviour
Message-ID: <20121010165750.GD32581@quack.suse.cz>
References: <5073F13C.5050807@thx4games.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5073F13C.5050807@thx4games.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 09-10-12 11:41:16, Viktor Nagy wrote:
> Since Kernel version 3.0 pdflush blocks writes even the dirty bytes
> are well below /proc/sys/vm/dirty_bytes or /proc/sys/vm/dirty_ratio.
> The kernel 2.6.39 works nice.
> 
> How this hurt us in the real life: We have a very high performance
> game server where the MySQL have to do many writes along the reads.
> All writes and reads are very simple and have to be very quick. If
> we run the system with Linux 3.2 we get unacceptable performance.
> Now we are stuck with 2.6.32 kernel here because this problem.
> 
> I attach the test program wrote by me which shows the problem. The
> program just writes blocks continously to random position to a given
> big file. The write rate limited to 100 MByte/s. In a well-working
> kernel it have to run with constant 100 MBit/s speed for indefinite
> long. The test have to be run on a simple HDD.
> 
> Test steps:
> 1. You have to use an XFS, EXT2 or ReiserFS partition for the test,
> Ext4 forces flushes periodically. I recommend to use XFS.
> 2. create a big file on the test partiton. For 8 GByte RAM you can
> create a 2 GByte file. For 2 GB RAM I recommend to create 500MByte
> file. File creation can be done with this command:  dd if=/dev/zero
> of=bigfile2048M.bin bs=1M count=2048
> 3. compile pdflushtest.c: (gcc -o pdflushtest pdflushtest.c)
> 4. run pdflushtest: ./pdflushtest --file=/where/is/the/bigfile2048M.bin
> 
> In the beginning there can be some slowness even on well-working
> kernels. If you create the bigfile in the same run then it runs
> usually smootly from the beginning.
> 
> I don't know a setting of /proc/sys/vm variables which runs this
> test smootly on a 3.2.29 (3.0+) kernel. I think this is a kernel
> bug, because if I have much more "/proc/sys/vm/dirty_bytes" than the
> testfile size the test program should never be blocked.
  I've run your program and I can confirm your results. As a side note,
your test program as a bug as it uses 'int' for offset arithmetics so when
the file is larger than 2 GB, you can hit some problems but for our case
that's not really important.

The regression you observe is caused by commit 3d08bcc8 "mm: Wait for
writeback when grabbing pages to begin a write". At the first sight I was
somewhat surprised when I saw that code path in the traces but later when I
did some math it's clear. What the commit does is that when a page is just
being written out to disk, we don't allow it's contents to be changed and
wait for IO to finish before letting next write to proceed. Now if you have
1 GB file, that's 256000 pages. By the observation from my test machine,
writeback code keeps around 10000 pages in flight to disk at any moment
(this number fluctuates a lot but average is around that number). Your
program dirties about 25600 pages per second. So the probability one of
dirtied pages is a page under writeback is equal to 1 for all practical
purposes (precisely it is 1-(1-10000/256000)^25600). Actually, on average
you are going to hit about 1000 pages under writeback per second which
clearly has a noticeable impact (even single page can have). Pity I didn't
do the math when we were considering those patches.

There were plans to avoid waiting if underlying storage doesn't need it but
I'm not sure how far that plans got (added a couple of relevant CCs).
Anyway you are about second or third real workload that sees regression due
to "stable pages" so we have to fix that sooner rather than later... Thanks
for your detailed report!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
