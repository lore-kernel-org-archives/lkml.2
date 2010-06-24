Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0FXOPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:15:48 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:52248
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0FXOPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:15:47 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 10:15:47 EDT
Message-ID: <4C2366F7.5010200@mit.edu>
Date: Thu, 24 Jun 2010 10:08:55 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
References: <20100624131455.GA10441@laptop>
In-Reply-To: <20100624131455.GA10441@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> This has come up a few times in the past, and I'd like to try to get
> an agreement on it. statvfs(2) importantly contains f_flag (mount
> flags), and is encouraged to use rather than statfs(2). The kernel
> provides a statfs syscall only.
> 
> This means glibc has to provide f_flag support by parsing /proc/mounts
> and stat(2)ing mount points. This is really slow, and /proc/mounts is
> hard for the kernel to provide. It's actually the last scalability
> bottleneck in the core vfs for dbench (samba) after my patches.
> 
> Not only that, but it's racy.
> 
> Other than types, other differences are:
> - statvfs(2) has is f_frsize, which seems fairly useless.
> - statvfs(2) has f_favail.
> - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
>   block size. The latter could be useful for disk space algorithms.
>   Both can be ill defned.
> - statvfs(2) lacks f_type.
> 
> Is there anything more we should add here? Samba wants a capabilities
> field, with things like sparse files, quotas, compression, encryption,
> case preserving/sensitive.
> 
> Any thoughts?

Something like fsid but actually specified to uniquely identify a 
superblock.  (Currently, fsid seems to be set by the filesystem, and 
nothing in particular ensures that two different filesystems couldn't 
have collisions.)  We could guarantee (or have a flag guaranteeing) that 
(fsid, st_inode) actually uniquely identifies an inode.

Similarly, something like fsid that uniquely identifies the vfsmount 
could be useful, although I don't know how easy that would be to provide 
for fstat?fs.

If we could expose the complete set of filesystem mount options so that 
mount(1) didn't have to look at /proc/self/mounts or /etc/mtab, then 
playing with chroots would be that much easier.

Should we expose superblock and vfsmount options separately?  We have 
read-only bind mounts now, but the way they work is rather inscrutable, 
and if stat?fs could say "superblock is read-write but vfsmount is 
readonly" then people might be able to make more sense of what's going on.

--Andy
