Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1EVTLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:11:18 -0400
Received: from mail.avalus.com ([89.16.176.221]:58688 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab1EVTLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:11:12 -0400
Date: Sun, 22 May 2011 20:11:08 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>
cc: Alex Bligh <alex@alex.org.uk>
Subject: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS in
 general
Message-ID: <959E4E25EAEC544D31199E6F@nimrod.local>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been doing some testing to see what file systems successfully send
REQ_FLUSH after all writes to the file system in the case of an unmount.

Results so far:
 1. ext2, ext3 (with default options), never send REQ_FLUSH
 2. ext3 (with barrier=1) and ext4 do send REQ_FLUSH but then
    send further writes afterwards.
 3. btrfs and xfs do things right (i.e. either end with a REQ_FLUSH in
    xfs's case, or a REQ_FLUSH and a REQ_FUA in btrfs's case)

So the first bug is that ext3 and ext4 appear to send writes (without a
subsequent flush/fia) before an unmount, and thus will never fully
flush a write-behind cache. They look like this:

But quite aside from the question of whether the FS supports barriers,
should the kernel itself (rather than the FS) not be sending REQ_FLUSH on
an unmount as the last thing that happens? IE shouldn't we see a flush
even on (say) ext2 which is never going to support barriers. If the kernel
itself generated a REQ_FLUSH for the block device, this would keep
filesystems that don't support barriers safe provided the unmount
completed successfully and would have no impact on ones that had already
flushed the write-behind cache.

I have been using an instrumented version of nbd to test this (see
git.alex.org.uk). nbd in this instance is patched to support REQ_FLUSH
and REQ_FUA.

Trace from ext3 below (ext4 is similar)

-- 
Alex Bligh

> H=10ee1e1b0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=0000000002529000 
L=00000400
> H=00d00b1f0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=0000000002531000 
L=00000400
> H=082714110088ffff C=0x00000003 (NBD_CMD_FLUSH+NONE) O=0000000000000000 
L=00000000
> H=68d10b1f0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=0000000002544400 
L=00000400
> H=d0d20b1f0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=0000000002564400 
L=00000400
> H=082714110088ffff C=0x00010001 (NBD_CMD_WRITE+ FUA) O=000000000112cc00 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=000000000103a000 
L=00000400
> H=d052c31a0088ffff C=0x00000001 (NBD_CMD_WRITE+NONE) O=0000000000000400 
L=00000400
> H=88dcdd1b0088ffff C=0x00000002 ( NBD_CMD_DISC+NONE) O=fffffffffffffe00 
L=00000000

