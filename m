Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1EWRJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:09:23 -0400
Received: from mail.avalus.com ([89.16.176.221]:38415 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab1EWRJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:09:22 -0400
Date: Mon, 23 May 2011 18:09:17 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Alex Bligh <alex@alex.org.uk>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <EC63F9E077B362A0FDCF3527@Ximines.local>
In-Reply-To: <20110523155550.GE4716@quack.suse.cz>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

--On 23 May 2011 17:55:50 +0200 Jan Kara <jack@suse.cz> wrote:

>> But quite aside from the question of whether the FS supports barriers,
>> should the kernel itself (rather than the FS) not be sending REQ_FLUSH on
>> an unmount as the last thing that happens? IE shouldn't we see a flush
>> even on (say) ext2 which is never going to support barriers. If the
>> kernel itself generated a REQ_FLUSH for the block device, this would keep
>> filesystems that don't support barriers safe provided the unmount
>> completed successfully and would have no impact on ones that had already
>> flushed the write-behind cache.
>
>   Yes, I think that generic VFS helpers should send barriers in cases
> where it makes sense and umount is one of them. There even have been some
> attempts to do so if I recall right but they didn't go anywhere.

Indeed I think even doing sync() on ext3 with default options does not
send a flush to the write cache. I had a quick look at the code (which
has got rather more complicated since the umount syscall moved from
super.c to namespace.c) and it seemed to me the best thing to do would
be for sync() on a block device to send a REQ_FLUSH to that device at
the end (assuming the comment about sync actually completing I/O rather
than merely initiating it still holds), and to ensure umount is calling
sync.

Would there be any interested in these patches if I cooked them up,
or did they die because of opposition before rather than apathy?

-- 
Alex Bligh
