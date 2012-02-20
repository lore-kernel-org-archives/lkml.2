Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2BTQBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:01:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2BTQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:01:38 -0500
Date: Mon, 20 Feb 2012 17:01:35 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Josh Boyer <jwboyer@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: udf deadlock (was Re: hugetlbfs lockdep spew revisited.)
Message-ID: <20120220160135.GH6799@quack.suse.cz>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
 <20120217003848.GB20071@boyd>
 <20120217004922.GN23916@ZenIV.linux.org.uk>
 <20120217174818.GP23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217174818.GP23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-02-12 17:48:18, Al Viro wrote:
> On Fri, Feb 17, 2012 at 12:49:22AM +0000, Al Viro wrote:
> > Folks, this is not a false positive and it has nothing to do with misannotation
> > for directories.  Deadlock is real; I have no idea WTF do we what ->i_mutex
> > held over that area in hugetlbfs ->mmap(), but doing that is really, really
> > wrong, whatever the reason.
> 
> Arrrrgh...  Some grepping around has uncovered another deadlock on
> i_mutex/mmap_sem and this one is not hard to hit at all.
> 
> Thread A:
> 	opens file on UDF (O_RDWR open)
> 	does big, fat write() to it
> Thread B:
> 	opens the same file (also O_RDWR)
> 	mmaps it
> 	closes
> 	does munmap()
> 
> and there we are - munmap() will end up closing the second struct file,
> call udf_release_file() and we are hitting ->i_mutex while under
> ->mmap_sem.  Blocking on it, actually, since generic_file_aio_write()
> in the first thread is holding ->i_mutex.  And as soon as thread A gets
> around to faulting the next piece of data in, well...  To widen the
> window a lot, mmap something large sitting on NFS and do write() from
> that mmapped area.  Race window as wide as one could ask for...
  Right, I didn't realize ->release() may be called with mmap_sem held.
Thanks for spotting this.  BTW: Documentation/filesystems/Locking might
need an update since it states:
locking rules:
        All may block except for ->setlease.
        No VFS locks held on entry except for ->setlease.

> What happens there is prealloc discard on close; do we even want ->i_mutex
> there these days?  Note that there's also
> 	down_write(&UDF_I(inode)->i_data_sem);
> in udf_release_file()...
  I've looked around and it seems we don't need i_mutex for anything.
i_data_sem should be enough. So I'll just remove i_mutex.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
