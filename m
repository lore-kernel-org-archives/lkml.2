Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1LAAeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:34:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1LAAeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:34:09 -0500
Date: Thu, 1 Dec 2011 01:34:07 +0100
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111201003407.GH4541@quack.suse.cz>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz>
 <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz>
 <20111130133332.GV7595@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1111301123320.5759@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111301123320.5759@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 11:34:23, Mikulas Patocka wrote:
> On Wed, 30 Nov 2011, Alasdair G Kergon wrote:
> > On Tue, Nov 29, 2011 at 11:19:01AM +0100, Jan Kara wrote:
> > > On Mon 28-11-11 18:32:18, Mikulas Patocka wrote:
> > > > - skipping sync on frozen filesystem violates sync semantics. 
> > > > Applications, such as databases, assume that when sync finishes, data were 
> > > > written to stable storage. If we skip sync when the filesystem is frozen, 
> > > > we can cause data corruption in these applications (if the system crashes 
> > > > after we skipped a sync).
> > 
> > >   Here I don't agree. Filesystem must guarantee there are no dirty data on
> > > a frozen filesystem. Ext4 and XFS do this, ext3 would need proper
> > > page_mkwrite() implementation for this but that's the problem of ext3, not
> > > freezing code in general. If there are no dirty data, sync code (and also
> > > flusher thread) is free to return without doing anything.
> >  
> > Consider, during a 'create a snapshot' operation:
> >    I/O flow:  application -> filesystem -> LV -> disk
> > 
> > dm lockfs is issued by LVM.
> >   When this returns, the filesystem should be locked i.e. not issue any
> >   further I/O to the LV.  (But if it did happen to issue I/O, it
> >   wouldn't be a problem, as it would just get queued by dm and have no
> >   impact on the snapshot creation operation.)
> > 
> > The application is still running and might still be issuing writes to
> > the filesystem and might itself issue 'sync'.  But a 'sync' would only
> > be meaningful for already-completed writes and the lockfs process should
> > have already seen that they have hit disk.  So a sync issued while a
> > device is locked can always be skipped.  Have I missed something in this
> > reasoning, Mikulas?
> > 
> > Alasdair
> 
> You can't skip sync.
> 
> The problem is this (assume that you have non-journaled filesystem):
> 
> - A process issues a write() call. The write call goes to 
> __generic_file_aio_write, suppose that the process goes immediatelly after 
> "vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);" and then is rescheduled.
> 
> - You suspend the filesystem
> 
> - A process that issued write() is scheduled to run, note that it already 
> passed "vfs_check_frozen", so it goes on even on syspended filesystem. 
> This process creates a dirty page in the page cache.
> 
> - The process eventually returns to userspace from the write() syscall, 
> the filesystem is still suspended. write() doesn't guarantee that the data 
> hit disk, so there is no problem so far.
> 
> - The applications calls sync. Now, if you skip sync on the suspended 
> filesystem, you violate sync semantics: when a process calls write() and 
> sync(), it can assume that data are written to stable storage.
> 
> So, in order to keep sync working, you must wait for the filesystem to 
> thaw and then write the dirty data.
  So now when we have establied a difference betweeen freezing a device and
freezing a filesystem, I think the answer is that sync can skip frozen
filesystems but cannot skip unfrozen filesystems on frozen devices. Agreed?
We'd need to change the freezing code to distinguish these two cases but
that's not hard...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
