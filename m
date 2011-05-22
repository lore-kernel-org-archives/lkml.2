Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1EVL0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:26:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EVL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:26:30 -0400
Date: Sun, 22 May 2011 07:26:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <20110522112629.GA26586@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
 <60FB7C5F40961417F1605595@nimrod.local>
 <20110522104448.GA20241@infradead.org>
 <A0329D810FA7795CEDDA5C70@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A0329D810FA7795CEDDA5C70@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, the file in question is not mmap'd (it's an nbd disk). fsync() /
> fdatasync() is too expensive as it will sync everything. As far as I can
> tell, this is no more dangerous re metadata than fdatasync() which also
> does not sync metadata. I had read the last sentence as "this system
> call does not *necessarily* flush disk write caches" (meaning "if you
> haven't mounted e.g. ext3 with barriers=1, then you can't ensure write
> caches write through"), as opposed to "will not ever flush disk write
> caches", and given mounting ext3 without barriers=1 produces no FUA or
> FLUSH commands in normal operation anyway (as far as light debugging
> can see) that's not much of a loss.

ext3 without barriers does not gurantee any data integrity and will lose
your data in an eye blink if you have a large enough cache.

fdatasync is equivalent to fsync except that it does not flush
non-essential metadata (basically just timestamps in practice), but it
does flush metadata requried to find the data again, e.g. allocation
information and extent maps.  sync_file_range does nothing but flush
out pagecache content - it means you basically won't get your data
back in case of a crash if you either:

 a) have a volatile write cache in your disk (e.g. any normal SATA disk)
 b) are using a sparse file on a filesystem
 c) are using a fallocate-preallocated file on a filesystem
 d) use any file on a COW filesystem like btrfs

e.g. it only does anything useful for you if you do not have a volatile
write cache, and either use a raw block device node, or just overwrite
an already fully allocated (and not preallocated) file on a non-COW
filesystem.

> But rather than trying to justify myself: what is the best way to
> emulate FUA, i.e. ensure a specific portion of a file is synced before
> returning, without ensuring the whole lot is synced (which is far too
> slow)? The only other option I can see is to open the file with a second
> fd, mmap the chunk of the file (it may be larger than the available
> virtual address space), mysnc it with MS_SYNC, then fsync, then munmap
> and close, and hope the fsync doesn't spit anything else out. This
> seems a little excessive, and I don't even know whether it would work.

You can have a second FD with O_DSYNC open and write to that.  But for
NBD and Linux guest that won't make any different yet.  While REQ_FUA
is a separate flag so far it's only used in combination with REQ_FLUSH,
so the only pattern you'll see REQ_FUA used in is:

 REQ_FLUSH
 REQ_FUA

which means there's no data but the one just written in the cache.

