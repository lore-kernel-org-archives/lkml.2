Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1EWRj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:39:28 -0400
Received: from mail.avalus.com ([89.16.176.221]:40559 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121Ab1EWRj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:39:27 -0400
Date: Mon, 23 May 2011 18:39:23 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Jan Kara <jack@suse.cz>
cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Alex Bligh <alex@alex.org.uk>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <16968FD306209AF92D4660B9@Ximines.local>
In-Reply-To: <20110523172906.GH4716@quack.suse.cz>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
 <20110523172906.GH4716@quack.suse.cz>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

--On 23 May 2011 19:29:06 +0200 Jan Kara <jack@suse.cz> wrote:

>   I wish it was this simple ;) The trouble is that clever filesystems -
> e.g. xfs, ext4 - will send the flush when it's needed (after a transaction
> commit). So sending it after flushing the device (which happens from
> generic sync code) would result in two flushes instead of one - not good
> for performance (although these days when we do merging of flush requests
> the result need not be that bad).
>
> The fs might indicate whether it handles barriers itself or whether it
> wants VFS to handle it but that's where it's gets a bit complicated /
> controversial ;).

Well, to "fix" sync(), one could simply look at whether the file system
had ever sent a REQ_FLUSH or REQ_FUA since that FS was mounted. If there
has been one, assume the FS is taking responsibility for sending them.

I'm presuming that if just umount() were altered to do a REQ_FLUSH,
the potential presence of 2 sync()s would not be too offensive, as
unmount isn't exactly time critical, and as Christoph pointed out in
the other thread, a REQ_FLUSH when the write cache has recently been
emptied isn't going to take long.

>> Would there be any interested in these patches if I cooked them up,
>> or did they die because of opposition before rather than apathy?
>
>   I guess you might come with some proposal and post it to linux-fsdevel
> (include Al Viro and Christoph Hellwig in CC) and see what happens...

Ah, fsdevel not here. OK. Partly I'd like to understand whether
sync() not flushing write caches on barrier-less file systems
is a good thing or a bad thing. I know barriers are better, but if
writing to (e.g.) FAT32, I'm betting there is little prospect of
barrier support.

-- 
Alex Bligh
