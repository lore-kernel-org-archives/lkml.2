Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825Ab0FYECG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 00:02:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:35314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab0FYECD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 00:02:03 -0400
Date: Fri, 25 Jun 2010 14:01:56 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100625040156.GQ10441@laptop>
References: <20100624131455.GA10441@laptop>
 <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 05:13:38PM -0600, Andreas Dilger wrote:
> On 2010-06-24, at 07:14, Nick Piggin wrote:
> > This means glibc has to provide f_flag support by parsing /proc/mounts
> > and stat(2)ing mount points. This is really slow, and /proc/mounts is
> > hard for the kernel to provide.
> 
> Not only that, but if a mountpoint is broken (e.g. remote NFS server) then the glibc stat of all the mountpoints can hang the statvfs() call even if there is no interest in that particular filesystem.

Good point.

 
> > It's actually the last scalability bottleneck in the core vfs for dbench (samba) after my patches.
> > 
> > Not only that, but it's racy.
> > 
> > Other than types, other differences are:
> > - statvfs(2) has is f_frsize, which seems fairly useless.
> 
> Actually, we were just lamenting the fact that f_frsize is currently broken, because Lustre wants to export the IO size as 1MB for good RPC performance, but the underlying blocksize is 4kB (ext3 blocksize).  Similarly, NFS might want to export the rsize/wsize of 32kB or 64kB even if the underlying filesystem blocksize is smaller.
> 
> > - statvfs(2) has f_favail.
> > - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
> >  block size. The latter could be useful for disk space algorithms.
> >  Both can be ill defned.
> 
> According to POSIX, "f_bsize" is the blocksize, but unfortunately this was botched in the earlier Linux implementations so currently they are both set to the same value, and using anything other than that breaks userspace programs that get them mixed up.

So is "frsize" supposed to be the optimal block size, or what?
f_bsize AFAIKS should be filesystem allocation block size because 
apparently some programs require it to calculate size of file on
disk.

If we can't change existing suboptimal legacy things, then let's
introduce new APIs that do the right thing. Apps that care will
eventually start using eg. a new syscall.

> 
> > - statvfs(2) lacks f_type.
> > 
> > Is there anything more we should add here? Samba wants a capabilities
> > field, with things like sparse files, quotas, compression, encryption,
> > case preserving/sensitive.
> 
> It wouldn't be a bad idea, but then you could get into issues of what exactly the above flags mean.  That said, I think it is better to have broad categories of features that may be slightly ill-defined than having nothing at all.

Yes it would be tricky. I don't want to add features that will just
be useless or go unused, but I don't want to change the syscall API
just to add f_flags, without looking at other possibilities.

Thanks,
Nick

