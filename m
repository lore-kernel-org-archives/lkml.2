Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0EGWqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:46:35 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:51378 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751003Ab0EGWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:46:33 -0400
Date: Sat, 8 May 2010 08:46:30 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sami Liedes <sliedes@cc.hut.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 is faster with LVM than without, and other filesystem
 benchmarks
Message-ID: <20100507224630.GC25419@dastard>
References: <20100507142310.GF13143@lh.kyla.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507142310.GF13143@lh.kyla.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 05:23:10PM +0300, Sami Liedes wrote:
> Basically the directory hierarchy consists of
> 
> * directory backuppc/cpool - a pool of compressed backed up files
>   - The individual files are of the form
>     backuppc/cpool/f/1/d/f1d2d2f924e986ac86fdf7b36c94bcdf32beec15
>   - There are some 456000 files in the pool, all hashed by their
>     SHA256 sum
>   - These take the first about 490 gibibytes of the archive
> 
> * directory backuppc/pc with individual backups of a few machines
>   - Essentially contains the root filesystems of quite normal desktop
>     Linux machines.
>   - All backed up files are hardlinks to the pool.
>   - Files with size 0 are not hardlinked but represented as themselves.
>   - Contains some 10.4M hard links to files in the pool, interspersed
>     with some 84300 empty files and very few regular files
> 
> The benchmarks were all I/O-bound on the speed of the target
> filesystem and partition. This was achieved by making a copy of the
> tar that has all the file contents zeroed and using a fast compressor
> (lzop) so the decompression of the .tar.lzop was still easily
> target-disk-bound.

[...]

> On XFS, extracting the archive took more than 16 hours (58548 seconds;
> only one sample), so XFS performs rather poorly in this I assume quite
> pathological case.

Not pathological, but XFS is generally slower at creating and
removing large numbers of files compared to ext and btrfs until you
get to parallel workloads and expensive storage hardware. However,
just adding the "logbsize=262144" mount option should speed it up
significantly for this workload.

FWIW, how big is the compressed tarball you are extracting? If it's
not large, can you make it available somewhere? I've current got a
set of pending modifications to XFS(*) that should help this
workload and this looks like a good load for testing...

Cheers,

Dave.

(*) http://oss.sgi.com/archives/xfs/2010-05/msg00060.html
-- 
Dave Chinner
david@fromorbit.com
