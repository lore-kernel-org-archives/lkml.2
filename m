Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0FXXNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:13:41 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:50001 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0FXXNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:13:39 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=7yc1YO-cavgA:10 a=q8OS1GolVHwA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=R-pH_Scea3RLsBqJXwoA:9
 a=ogZ5tRl8enG2rw_Riw6IbnUwxWcA:4 a=CjuIK1q_8ugA:10
Subject: Re: [rfc] new stat*fs-like syscall?
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100624131455.GA10441@laptop>
Date: Thu, 24 Jun 2010 17:13:38 -0600
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca>
References: <20100624131455.GA10441@laptop>
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-24, at 07:14, Nick Piggin wrote:
> This means glibc has to provide f_flag support by parsing /proc/mounts
> and stat(2)ing mount points. This is really slow, and /proc/mounts is
> hard for the kernel to provide.

Not only that, but if a mountpoint is broken (e.g. remote NFS server) then the glibc stat of all the mountpoints can hang the statvfs() call even if there is no interest in that particular filesystem.

> It's actually the last scalability bottleneck in the core vfs for dbench (samba) after my patches.
> 
> Not only that, but it's racy.
> 
> Other than types, other differences are:
> - statvfs(2) has is f_frsize, which seems fairly useless.

Actually, we were just lamenting the fact that f_frsize is currently broken, because Lustre wants to export the IO size as 1MB for good RPC performance, but the underlying blocksize is 4kB (ext3 blocksize).  Similarly, NFS might want to export the rsize/wsize of 32kB or 64kB even if the underlying filesystem blocksize is smaller.

> - statvfs(2) has f_favail.
> - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
>  block size. The latter could be useful for disk space algorithms.
>  Both can be ill defned.

According to POSIX, "f_bsize" is the blocksize, but unfortunately this was botched in the earlier Linux implementations so currently they are both set to the same value, and using anything other than that breaks userspace programs that get them mixed up.

> - statvfs(2) lacks f_type.
> 
> Is there anything more we should add here? Samba wants a capabilities
> field, with things like sparse files, quotas, compression, encryption,
> case preserving/sensitive.

It wouldn't be a bad idea, but then you could get into issues of what exactly the above flags mean.  That said, I think it is better to have broad categories of features that may be slightly ill-defined than having nothing at all.

Cheers, Andreas





