Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1ADG1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:27:32 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53303 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab1ADG1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:27:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFBMIk15Ldpx/2dsb2JhbACkNXS7SIVKBJAq
Date: Tue, 4 Jan 2011 17:27:25 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104062725.GD3402@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229151246.GA22033@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 10:12:46AM -0500, Christoph Hellwig wrote:
>  - the sync_inodes_sb export removal looks fine to, but should be a
>    separate patch with a good changelog

OK


>  - why is the sync_inode_metadata wait parameter removed?  Especially
>    as we would need it for some callers that need to be converted to it.
>    E.g. in this patch converts writeback_inode from non-blocking to
>    blocking behaviour.

Basically the blocking or non blocking behaviour of ->write_inode is
irrelevant and will go away. Specific behaviour cannot be relied upon from
generic code, only filesystems. But even filesystems should not
differentiate between blocking and non-blocking (where they do, they
have been buggy). That is the *other* big bug in the code (the first one
being syncing code not waiting for writeback).

So after my series, we guarantee ->write_inode is called after the inode
has been dirtied. We make no guarantees about what mode it is called in
(blocking or non blocking). So the filesystem should either have _all_
write_inode calls do sync writeout, or have them all do part of the op
(eg. clean struct inode by dirtying pagecache) and then syncing in fsync
and sync_fs. In the latter scheme, it doesn't make sense to do anything
more in the case of a "sync" call.

Basically you can spot the bugs by looking for where the .write_inode
functions differentiate the writeback mode.

So, that's all very confusing with the current set of APIs that are
called sync_inode, sync_inode_metadata, etc. So I'm trying to reduce and
remove these gradually.


>  - except for that the sync_inode() removal is fine, I had planned for
>    that already.  But again, please a separate and well-documented
>    patch.

Yes ok.

 
> As for the actualy sync_inode operation:  I don't think it's helpful.
> The *_sync_inode helpers in ext2 and fat are fine, but there's little
> point in going through an iops vector for it.  Also adding the file
> syncing really complicates the API for now reason, epecially with
> the range interface.

It does have a reason, which is the nfsd syncing callback -- using
sync_inode_metadata there is actually wrong and should really be
replaced with a warning that the fs cannot support such syncing.

See the problem I explained above -- it really needs to do a full
fsync call. But it doesn't have a file descriptor, and most filesystems
don't need one, so I think a sync_inode operation is nice.

Also giving filesystems the flexibility to do the data writeout can
be more optimal by doing all writeout at once or ordering to suit their
writeback patterns. Having range data could give some performance
advantages writing back mappings or commit operations over network. I
don't see it as a big complexity. It gives a chance to do range fsyncs
and sync_file_range and such properly too.


