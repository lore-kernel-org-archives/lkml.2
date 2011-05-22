Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1EVMAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 08:00:49 -0400
Received: from mail.avalus.com ([89.16.176.221]:46170 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab1EVMAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 08:00:45 -0400
Date: Sun, 22 May 2011 13:00:41 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <3A79A7FE44AE1DC20A2DB90D@nimrod.local>
In-Reply-To: <20110522112629.GA26586@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
 <60FB7C5F40961417F1605595@nimrod.local>
 <20110522104448.GA20241@infradead.org>
 <A0329D810FA7795CEDDA5C70@nimrod.local>
 <20110522112629.GA26586@infradead.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

> ext3 without barriers does not gurantee any data integrity and will lose
> your data in an eye blink if you have a large enough cache.

This doesn't appear to stop people using it :-)

> fdatasync is equivalent to fsync except that it does not flush
> non-essential metadata (basically just timestamps in practice), but it
> does flush metadata requried to find the data again, e.g. allocation
> information and extent maps.  sync_file_range does nothing but flush
> out pagecache content - it means you basically won't get your data
> back in case of a crash if you either:
>
>  a) have a volatile write cache in your disk (e.g. any normal SATA disk)
>  b) are using a sparse file on a filesystem
>  c) are using a fallocate-preallocated file on a filesystem
>  d) use any file on a COW filesystem like btrfs
>
> e.g. it only does anything useful for you if you do not have a volatile
> write cache, and either use a raw block device node, or just overwrite
> an already fully allocated (and not preallocated) file on a non-COW
> filesystem.

Thanks, that's really useful.

>> But rather than trying to justify myself: what is the best way to
>> emulate FUA, i.e. ensure a specific portion of a file is synced before
>> returning, without ensuring the whole lot is synced (which is far too
>> slow)? The only other option I can see is to open the file with a second
>> fd, mmap the chunk of the file (it may be larger than the available
>> virtual address space), mysnc it with MS_SYNC, then fsync, then munmap
>> and close, and hope the fsync doesn't spit anything else out. This
>> seems a little excessive, and I don't even know whether it would work.
>
> You can have a second FD with O_DSYNC open and write to that.

Fantastic - I shall do that in the long term.

> But for
> NBD and Linux guest that won't make any different yet.

As far as I know, nbd only has linux clients. It certainly only has
linux clients that transmit flush and FUA because I only added that to
the protocol last week :-)

> While REQ_FUA
> is a separate flag so far it's only used in combination with REQ_FLUSH,
> so the only pattern you'll see REQ_FUA used in is:
>
>  REQ_FLUSH
>  REQ_FUA
>
> which means there's no data but the one just written in the cache.

I think what you are saying is that when the request with REQ_FUA arrives,
it will have been immediately preceded by a REQ_FLUSH. Therefore, I will
only have the data attached to the request with REQ_FUA to flush anyway, so
an fdatasync() does no harm performance wise. That's what I'm currently
doing if sync_file_range() is not supported. It sounds like that's what I
should be doing all the time. If you don't mind, I shall borrow your
text above and put it in the source.

-- 
Alex Bligh
