Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1EKQh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:37:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1EKQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:37:22 -0400
Date: Wed, 11 May 2011 12:43:58 +0200
From: Jan Kara <jack@suse.cz>
To: rmorell@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmap vs. ctime bug?
Message-ID: <20110511104358.GD5057@quack.suse.cz>
References: <20110510012348.GJ3848@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510012348.GJ3848@morell.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Mon 09-05-11 18:23:48, rmorell@nvidia.com wrote:
> I tracked an intermittent failure in one of our build systems down to
> questionable kernel behavior.
> 
> The makefile for the build seems completely reasonable.  It essentially does
> this (greatly simplified):
> output: $(OBJECTS)
>         ld -o output $(OBJECTS)
>         $(POSTPROCESS) output
> 
> tarball.tgz: output
>         tar zcf tarball.tgz output
> 
> $(POSTPROCESS) in this case is just a program that modifies some ELF headers.
> This program does so through libelf, but the important part is that libelf
> operates on the file using mmap().
> 
> The problem is that the "tar" step sometimes fails with the error:
> /bin/tar: output: file changed as we read it
> 
> As tar is adding a file to a tarball, it first stats the file, reads the entire
> file, then stats it again.  It reports the above error if the ctime does not
> match between the two stat calls.  In the case of the intermittent failure, the
> ctime does not match for the file as reported by stat(1).
> 
> Adding a sync between the postprocess program's termination and the tar
> invocation "fixes" the problem, but adds a significant delay to the overall
> build time, so I'd prefer to not do that.
> 
> I was able to reproduce the behavior with a simple test case (attached) with
> the latest git kernel built from 26822eebb25.  To run the test, simply
> put test.c and the Makefile in a new directory and run "make runtest".
> Note that the filesystem blocks and ctime change between the two stat
> invocations, although the mtime remains the same:
> 
> # make runtest
> gcc test.c -o test
> rm -f out
> ./test out
> stat out
>   File: `out'
>   Size: 268435456 	Blocks: 377096     IO Block: 4096   regular file
> Device: 304h/772d	Inode: 655367      Links: 1
> Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2011-05-09 18:06:24.000000000 -0700
> Modify: 2011-05-09 18:06:27.000000000 -0700
> Change: 2011-05-09 18:06:27.000000000 -0700
> sync
> stat out
>   File: `out'
>   Size: 268435456 	Blocks: 524808     IO Block: 4096   regular file
> Device: 304h/772d	Inode: 655367      Links: 1
> Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2011-05-09 18:06:24.000000000 -0700
> Modify: 2011-05-09 18:06:27.000000000 -0700
> Change: 2011-05-09 18:06:28.000000000 -0700
> 
> (note: depending on your system, you may need to tweak the "SIZE" constant in
> test.c up to see ctime actually change at a resolution of 1s)
> 
> 
> Does this seem like a bug to anyone else?  For the normal "make" flow to work
> properly, files really need to be done changing by the time a process exits and
> wait(3) returns to the parent.  The heavy-hammer workaround of adding a
> sync(1) throws away a ton of potential benefit from the filesystem cache.
> Adding an msync(MS_SYNC) in the toy test app also "fixes" the problem, but
> that's not feasible in the production environment since libelf is doing the
> modification internally and besides, it seems like it shouldn't be necessary.
> 
> If it matters, the filesystem is a dead simple ext3 with no special mount
> flags, but I suspect this is not specific to FS:
  OK, so let me explain what happens: When a sparse file is created and
written to via mmap, we just store the data in memory. Later, we decide
it's time to store the data on disk and thus we allocate blocks for the
data. At this point we also update ctime and mtime - naturally since the
amount of space occupied by the file has changed. I've looked at the
specification and it says:
The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
MAP_SHARED  will  be  updated  after  a write to the mapped region, and
before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if one
occurs.

So although I can see why the combination of this behavior and your
libelf+tar usecase causes problems the kernel behaves according to the spec
and I don't think changing the kernel is the right solution. I'd rather
think that you should be able to disable the ctime check in tar.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
