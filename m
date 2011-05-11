Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1EKRhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:37:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19945 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1EKRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:37:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 11 May 2011 10:37:26 -0700
Date: Wed, 11 May 2011 10:37:26 -0700
From: Robert Morell <rmorell@nvidia.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: mmap vs. ctime bug?
Message-ID: <20110511173726.GA7030@morell.nvidia.com>
References: <20110510012348.GJ3848@morell.nvidia.com>
 <20110511104358.GD5057@quack.suse.cz>
 <20110511162441.GC22847@morell.nvidia.com>
 <20110511170130.GL5057@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511170130.GL5057@quack.suse.cz>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:01:30AM -0700, Jan Kara wrote:

[...]

>   I agree with the transparency as far as data is concerned. But it simply
> cannot work for metadata - we don't know some things (like the number of
> used blocks) in advance until the file is written. 
> 
> > If we want to quote specifications, see:
> > http://pubs.opengroup.org/onlinepubs/9699919799/
> > 
> > "Section 4.8 "File Times Update"
> > [...]
> > An implementation may update timestamps that are marked for update
> > immediately, or it may update such timestamps periodically. At the point
> > in time when an update occurs, any marked timestamps shall be set to the
> > current time and the update marks shall be cleared. All timestamps that
> > are marked for update shall be updated when the file ceases to be open
> > by any process or before a fstat(), fstatat(), fsync(), futimens(),
> > lstat(), stat(), utime(), utimensat(), or utimes() is successfully
> > performed on the file."
>   But the allocation of a disk block (and thus a change to the inode) happens
> after the file is closed. So the timestamp is marked for update after the
> file is closed and we are consistent with the above paragraph. In fact we
> should not avoid updating the time stamp because then applications would
> miss that the metadata information in inode has actually changed.

Practically speaking, does anything that monitors ctimes actually care
about st_blocks changes?  Certainly tar and other similar backup or
archive-type programs shouldn't care; they only care about data that can
be restored on a new filesystem.  Maybe an acceptable change would be to
simply not trigger ctime updates based solely on disk block allocations?

I realize that this is not spec-compliant since "file status" has
changed, but this behavior could be tweaked with filesystem mount
options to turn on struct ctime behavior, similar to strictatime.

> > > So although I can see why the combination of this behavior and your
> > > libelf+tar usecase causes problems the kernel behaves according to the spec
> > > and I don't think changing the kernel is the right solution. I'd rather
> > > think that you should be able to disable the ctime check in tar.
> > 
> > This really breaks basic assumptions about process lifetime and I/O.  In
> > the basic shell flow:
> > $ ./a && ./b
> > When b is invoked, it is assumed that a has been terminated and any
> > I/O it has performed will be reflected if b tries to read it.  (I assume
> > the shell achieves this with wait(pid)?()).  Again, it is not guaranteed
> > that the output be flushed to disk, but the cache should be transparent
> > to software.
>   Again, cache is transparent for data, not for metadata. So if b is
> dependent on metadata changed by a, things get complicated. There are some
> basic things defined by POSIX but apart from that all bets are off. Basically
> the only way to get some guarantees is to use fsync/sync which is dumb but
> that's how it is. Sorry. If you wanted that perfectly metadata consistent
> behavior, kernel would have to basically fsync the file behind the scenes
> and people certainly would not like that.

fsync/sync are much heavier-weight than should be necessary, though.
None of the data has to actually hit the disk; filesystem blocks are at
the end of the day just software state; requiring disk latency here is
rather unfortunate.  An alternative fstatsync() or so that tar could
call on its files would be sufficient as well.

Thanks,
Robert
