Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1EVKoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:44:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1EVKou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:44:50 -0400
Date: Sun, 22 May 2011 06:44:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alex Bligh <alex@alex.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQ_FLUSH, REQ_FUA and open/close of block devices
Message-ID: <20110522104448.GA20241@infradead.org>
References: <10C5890F8F477E959B993BFA@nimrod.local>
 <20110520122010.GA25628@infradead.org>
 <60FB7C5F40961417F1605595@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60FB7C5F40961417F1605595@nimrod.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 09:42:45AM +0100, Alex Bligh wrote:
> What I am concerned about is that relatively normal actions (e.g. unmount
> a filing system) do not appear to be flushing all data, even though I
> did "sync" then "umount". I suspect the sync is generating the FLUSH here,
> and nothing is flushing the umount writes. How can I know as a block
> device that I have to write out a (long lasting) writeback cache if
> I don't receive anything beyond the last WRITE?

In your case it seems like ext3 is doing something wrong.  If you
run the same on XFS, you should not only see the last real write
having FUA and FLUSH as it's a transaction commit, but also an
explicit cache flush when devices are closed from the filesystem
to work around issues like that.  But the raw block device node
really doesn't behave different from a file and shouldn't cause
any fsync on close.

Btw, using sync_file_range is a really bad idea.  It will not actually
flush the disk cache on the server, nor make sure metadata is commited in
case of a sparse or preallocated file, and thus does not implement
the FLUSH or FUA semantics correctly.

And btw, I'd like to know what makes sync_file_range so tempting,
even after I added documentation explaining why it's almost always
wrong to use it to the man page.
