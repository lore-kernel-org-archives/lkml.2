Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab1CQB2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:28:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab1CQB2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:28:44 -0400
Date: Thu, 17 Mar 2011 12:28:33 +1100
From: NeilBrown <neilb@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        device-mapper development <dm-devel@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing
 device size.
Message-ID: <20110317122833.30077397@notabene.brown>
In-Reply-To: <x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
	<20110306174755.49404c8e@notabene.brown>
	<1299471771.2228.11.camel@grinch>
	<1299516418.15258.4.camel@mulgrave.site>
	<20110308094412.1c45b277@notabene.brown>
	<1299538572.15955.90.camel@mulgrave.site>
	<20110308110453.0047307d@notabene.brown>
	<x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 16:30:22 -0400 Jeff Moyer <jmoyer@redhat.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> >> Synchronous notification of errors.  If we don't try to write everything
> >> back immediately after the size change, we don't see dirty pages in
> >> zapped regions until the writeout/page cache management takes it into
> >> its head to try to clean the pages.
> >> 
> >
> > So if you just want synchronous errors, I think you want:
> >     fsync_bdev()
> >
> > which calls sync_filesystem() if it can find a filesystem, else
> > sync_blockdev();  (sync_filesystem itself calls sync_blockdev too).
> 
> ... which deadlocks md.  ;-)  writeback_inodes_sb_nr is waiting for the
> flusher thread to write back the dirty data.  The flusher thread is
> stuck in md_write_start, here:
> 
>         wait_event(mddev->sb_wait,
>                    !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> 
> This is after reverting your change, and replacing the flush_disk call
> in check_disk_size_change with a call to fsync_bdev.  I'm not familiar
> enough with md to really suggest a way forward.  Neil?

That would be quite easy to avoid.
Just call
   md_write_start()
before revalidate_disk, and
   md_write_end()
afterwards.
You wouldn't have a 'bio' to pass in - but it is rather ugly requiring
one anyway - I should fix that.
For testing, just pass in NULL, and change
	if (bio_data_dir(bi) != WRITE)
		return;
to
	if (bi && bio_data_dir(bi) != WRITE)
		return;

NeilBrown

