Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0FYRrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 13:47:33 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30119 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0FYRrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 13:47:31 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=7yc1YO-cavgA:10 a=q8OS1GolVHwA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=Cy-jdzZCuv9ZuY1-C0MA:9
 a=Tavm47Z-m3wxyFaGV6cA:7 a=zNx2ncQUkawGfqg1UrHN7_FQK3IA:4 a=CjuIK1q_8ugA:10
Subject: Re: [rfc] new stat*fs-like syscall?
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20100625040156.GQ10441@laptop>
Date: Fri, 25 Jun 2010 11:47:29 -0600
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1A529206-98C4-4A88-A2CA-18522D4D631D@dilger.ca>
References: <20100624131455.GA10441@laptop> <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca> <20100625040156.GQ10441@laptop>
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-24, at 22:01, Nick Piggin wrote:
> On Thu, Jun 24, 2010 at 05:13:38PM -0600, Andreas Dilger wrote:
>>> Other than types, other differences are:
>>> - statvfs(2) has is f_frsize, which seems fairly useless.
>> 
>> Actually, we were just lamenting the fact that f_frsize is currently broken, because Lustre wants to export the IO size as 1MB for good RPC performance, but the underlying blocksize is 4kB (ext3 blocksize).  Similarly, NFS might want to export the rsize/wsize of 32kB or 64kB even if the underlying filesystem blocksize is smaller.
>> 
>> 
>>> - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
>>> block size. The latter could be useful for disk space algorithms.
>>> Both can be ill defned.
>> 
>> According to POSIX, "f_bsize" is the blocksize, but unfortunately this was 

Doh, typo.  "f_frsize" is the "blocksize" (i.e. the units of f_blocks), and "f_bsize" is the "optimal IO size".

The SUSv2 includes the following field definitions (not showing all of them):
> unsigned long f_bsize    file system block size
> unsigned long f_frsize   fundamental filesystem block size
> fsblkcnt_t    f_blocks   total number of blocks on file system
>                          in units of f_frsize

>> botched in the earlier Linux implementations so currently they are both set to the same value, and using anything other than that breaks userspace programs that get them mixed up.
> 
> So is "frsize" supposed to be the optimal block size, or what?

No, "frsize" is the minimum allocation unit - it is "fragment size".

> f_bsize AFAIKS should be filesystem allocation block size because 
> apparently some programs require it to calculate size of file on
> disk.

Using statvfs()/struct statvfs clearly documents that f_blocks is in units of f_frsize, but since this is a relatively new API on Linux, and statfs() used f_bsize for years to mean the same thing some applications are broken.

> If we can't change existing suboptimal legacy things, then let's
> introduce new APIs that do the right thing. Apps that care will
> eventually start using eg. a new syscall.

I'd rather NOT start a proliferation of redundant syscalls, since there is no expectation that they will be used correctly either, and it just makes applications less portable.  I think it less effort to fix the few current applications using sys_statvfs() incorrectly to use f_frsize than to use some new linux-only syscall.

>> It wouldn't be a bad idea, but then you could get into issues of what exactly the above flags mean.  That said, I think it is better to have broad categories of features that may be slightly ill-defined than having nothing at all.
> 
> Yes it would be tricky. I don't want to add features that will just
> be useless or go unused, but I don't want to change the syscall API
> just to add f_flags, without looking at other possibilities.

SUSv2 only defines the flags ST_RDONLY and ST_NOSUID, and this is also what is documented in the Linux/BSD/OSX statvfs(3) man page.  According to the Solaris statvfs(3) man page I found it additionally defines:

ST_NOTRUNC   0x04    /* does not truncate file names longer than
                        NAME_MAX */

Cheers, Andreas





