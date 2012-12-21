Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2LUBgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:36:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2LUBgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:36:17 -0500
Date: Fri, 21 Dec 2012 02:36:15 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
Message-ID: <20121221013615.GE13474@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard>
 <20121221005825.GC13474@quack.suse.cz>
 <20121221011246.GZ15182@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221011246.GZ15182@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-12-12 12:12:46, Dave Chinner wrote:
> > > > 2. The current behavior is surprising -- the timestamp resulting from
> > > >    an mmaped write will be before the write, not after.  This contradicts
> > > >    the mmap(2) manpage, which says:
> > > > 
> > > >      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
> > > >      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
> > > >      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
> > > >      occurs.
> > > 
> > > What you propose (time updates in do_writepages()) violates this.
> > > msync(MS_ASYNC) doesn't actually start any IO, therefore the
> > > timestamp wil not be updated.
> > > 
> > > Besides, what POSIX actually says is:
> > > 
> > > | The st_ctime and st_mtime fields of a file that is mapped with
> > > | MAP_SHARED and PROT_WRITE shall be marked for update at some point
> > > | in the interval between a write reference to the mapped region and
> > > | the next call to msync() with MS_ASYNC or MS_SYNC for that portion
> > > | of the file by any process.
> > > 
> > > Which means updating the timestamp during the first write is
> > > perfectly acceptible. Indeed, by definition, we are compliant with
> > > the man page because the update is after the write has occurred.
> > > That is, the write triggered the page fault, so the page fault
> > > processing where we update the timestamps is definitely after the
> > > write occurred. :)
> >   Well, but there can be more writes to the already write faulted page.
> > They can come seconds after we called ->page_mkwrite() and thus updated
> > time stamps. So Andy is correct we violate the spec AFAICT.
> 
> Depends how you read it. It can be updated at *any time* between the
> write and the msync() call, which is exactly what happens right now.
> The fact that second and subsequent writes between the first write
> and the msync call do not change it is irrelevant, as the first one
> is the one that matters... Indeed, if you read to the letter of the
> posix definition, then updating timestamps in the msync call is also
> incorrect, because that is not between the write and the msync()
> call.
> 
> What I'm saying is saying the current behaviour is wrong is
> dependent on a specific intepretation of the standard, and the same
> arguments can be made against this proposal. Hence such arguments
> are not a convincing/compelling reason to change behaviours.
  I have to say I'm not following you :) If I have the program that does:

  fd = open("file", O_RDWR);
  addr = mmap(NULL, 4096, PROT_WRITE, MAP_SHARED, fd, 0);
  addr[0] = 'a';
  sleep(1);
  addr[1] = 'b';
  close(fd);

  Then application of the spec to the second write clearly states that time
stamps should be updated sometime after the write of 'b'. I don't see any
space for other interpretation there... And currently we update time stamps
only at the moment we write 'a'.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
