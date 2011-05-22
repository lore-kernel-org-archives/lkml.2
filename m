Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab1EVLR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:17:26 -0400
Received: from mail.avalus.com ([89.16.176.221]:53384 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab1EVLRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:17:23 -0400
Date: Sun, 22 May 2011 12:17:15 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <A0329D810FA7795CEDDA5C70@nimrod.local>
In-Reply-To: <20110522104448.GA20241@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
 <60FB7C5F40961417F1605595@nimrod.local>
 <20110522104448.GA20241@infradead.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

--On 22 May 2011 06:44:49 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, May 21, 2011 at 09:42:45AM +0100, Alex Bligh wrote:
>> What I am concerned about is that relatively normal actions (e.g. unmount
>> a filing system) do not appear to be flushing all data, even though I
>> did "sync" then "umount". I suspect the sync is generating the FLUSH
>> here, and nothing is flushing the umount writes. How can I know as a
>> block device that I have to write out a (long lasting) writeback cache if
>> I don't receive anything beyond the last WRITE?
>
> In your case it seems like ext3 is doing something wrong.  If you
> run the same on XFS, you should not only see the last real write
> having FUA and FLUSH as it's a transaction commit, but also an
> explicit cache flush when devices are closed from the filesystem
> to work around issues like that.

OK. Sounds like an ext3 bug then. I will test with xfs, ext4 and btrfs
and see if they exhibit the same symptoms, and come back with a more
appropriate subject line.

> But the raw block device node
> really doesn't behave different from a file and shouldn't cause
> any fsync on close.

Fair enough. I will check whether the hypervisor concerned is doing
an fsync() or equivalent in the right place.

> Btw, using sync_file_range is a really bad idea.  It will not actually
> flush the disk cache on the server, nor make sure metadata is commited in
> case of a sparse or preallocated file, and thus does not implement
> the FLUSH or FUA semantics correctly.
>
> And btw, I'd like to know what makes sync_file_range so tempting,
> even after I added documentation explaining why it's almost always
> wrong to use it to the man page.

I think you are referring to this (which in my defence wasn't in my
local copy of the manpage).

> This  system  call is extremely dangerous and should not be used in
> portable programs.  None of these operations writes out the file's
> metadata.  Therefore, unless the application is strictly performing
> overwrites of already- instantiated  disk  blocks,  there are no
> guarantees that the data will be available after a crash.  There is no
> user interface to know if a write is purely an overwrite.  On file
> systems using copy-on-write semantics  (e.g., btrfs) an overwrite of
> existing allocated blocks is impossible.  When writing into preallocated
> space, many file systems also require calls into the block allocator,
> which this system call does not sync  out  to  disk.   This system  call
> does  not  flush  disk write  caches and thus does not provide any data
> integrity on systems with volatile disk write caches.

So, the file in question is not mmap'd (it's an nbd disk). fsync() /
fdatasync() is too expensive as it will sync everything. As far as I can
tell, this is no more dangerous re metadata than fdatasync() which also
does not sync metadata. I had read the last sentence as "this system
call does not *necessarily* flush disk write caches" (meaning "if you
haven't mounted e.g. ext3 with barriers=1, then you can't ensure write
caches write through"), as opposed to "will not ever flush disk write
caches", and given mounting ext3 without barriers=1 produces no FUA or
FLUSH commands in normal operation anyway (as far as light debugging
can see) that's not much of a loss.

But rather than trying to justify myself: what is the best way to
emulate FUA, i.e. ensure a specific portion of a file is synced before
returning, without ensuring the whole lot is synced (which is far too
slow)? The only other option I can see is to open the file with a second
fd, mmap the chunk of the file (it may be larger than the available
virtual address space), mysnc it with MS_SYNC, then fsync, then munmap
and close, and hope the fsync doesn't spit anything else out. This
seems a little excessive, and I don't even know whether it would work.

I guess given NBD currently does nothing at all to support barriers,
I thought this was an improvement!

-- 
Alex Bligh
