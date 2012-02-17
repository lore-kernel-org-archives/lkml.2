Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2BQRsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:48:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35542 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2BQRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:48:20 -0500
Date: Fri, 17 Feb 2012 17:48:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Josh Boyer <jwboyer@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: udf deadlock (was Re: hugetlbfs lockdep spew revisited.)
Message-ID: <20120217174818.GP23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
 <20120217003848.GB20071@boyd>
 <20120217004922.GN23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217004922.GN23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 12:49:22AM +0000, Al Viro wrote:
> Folks, this is not a false positive and it has nothing to do with misannotation
> for directories.  Deadlock is real; I have no idea WTF do we what ->i_mutex
> held over that area in hugetlbfs ->mmap(), but doing that is really, really
> wrong, whatever the reason.

Arrrrgh...  Some grepping around has uncovered another deadlock on
i_mutex/mmap_sem and this one is not hard to hit at all.

Thread A:
	opens file on UDF (O_RDWR open)
	does big, fat write() to it
Thread B:
	opens the same file (also O_RDWR)
	mmaps it
	closes
	does munmap()

and there we are - munmap() will end up closing the second struct file,
call udf_release_file() and we are hitting ->i_mutex while under
->mmap_sem.  Blocking on it, actually, since generic_file_aio_write()
in the first thread is holding ->i_mutex.  And as soon as thread A gets
around to faulting the next piece of data in, well...  To widen the
window a lot, mmap something large sitting on NFS and do write() from
that mmapped area.  Race window as wide as one could ask for...

What happens there is prealloc discard on close; do we even want ->i_mutex
there these days?  Note that there's also
	down_write(&UDF_I(inode)->i_data_sem);
in udf_release_file()...
