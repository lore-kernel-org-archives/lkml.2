Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1EDRhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:37:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54566 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab1EDRhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:37:08 -0400
Date: Wed, 4 May 2011 10:37:04 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: [PATCH v3 0/3] data integrity: Stabilize pages during writeback
	for ext4
Message-ID: <20110504173704.GE20579@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422000226.GA22189@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is v3 of the stable-page-writes patchset for ext4.  A lot of code has been
cut out since v2 of this patch set.  For v3, the large hairy function to walk
the page tables of every process is gone since Chris Mason pointed out that
page_mkclean does what I need.  The set_memory_* hack is also gone, since (I
think) the only time the kernel maps a file data blocks for writing is in the
buffered IO case.  That leaves us with some surgery to ext4_page_mkwrite to
return locked pages and to be careful about re-checking the writeback status
after dropping and re-grabbing the page lock; and a slight modification to the
mm code to wait for page writeback when grabbing pages for buffered writes.
There are also some cleanups for wait_on_page_writeback use in ext4.

I ran my write-after-checksum ("wac") reproducer program to try to create the
DIF checksum errors by madly rewriting the same memory pages.  In fact, I tried
the following combinations:

a. 64 write() threads + sync_file_range
b. 64 mmap write threads + msync
c. 32 write() threads + sync_file_range + 32 mmap write threads + msync
d. Same as C, but with all threads in directio mode
e. Same as A, but with all threads in directio mode
f. Same as B, but with all threads in directio mode

After some 44 hours of safety testing across 4 machines, I saw zero errors.
Before the patchset, I could run any of A-F for 10 seconds or less and have a
screen full of errors.

To assess the performance impact of stable page writes, I moved to a disk that
doesn't have DIF support so that I could measure just the impact of waiting for
writeback.  I first ran wac with 64 threads madly scribbling on a 64k file and
saw about a 12% performance decrease.  I then reran the wac program with 64
threads and a 64MB file and saw about the same performance numbers.  I will of
course be testing a wider range of hardware now that I have a functioning patch
set, though as I suspected the patchset only seems to impact workloads that
rewrite the same memory page frequently.

As always, questions and comments are welcome; and thank you to all the
previous reviewers of this patchset!

--D
