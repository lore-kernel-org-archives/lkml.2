Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab0GDVJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 17:09:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab0GDVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 17:09:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Sun, 4 Jul 2010 23:09:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-3-git-send-email-arnd@arndb.de> <20100704080146.GA31828@merkur.ravnborg.org>
In-Reply-To: <20100704080146.GA31828@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007042309.09727.arnd@arndb.de>
X-Provags-ID: V02:K0:CO+NI5sFShK/H4xgOnnC4LMlAazrEDs4kQmxTf9kEou
 sYg/lawG38M8biEdEdeK2cpyA20lRoBGzFzGIZYRHtNmX8Wrki
 y4gsvLz5kNWV925cvP/m+jU0YVHXNAXKoI0196lo/j1i7TFKvv
 qGxWjgHzAkfBsLbHt8B7Jf2dFhbOXoUntDQ+uQDtsmfUerDfYz
 svEC0SVzETOwCNRDkYCvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 July 2010 10:01:46 Sam Ravnborg wrote:
> > --- a/drivers/block/amiflop.c
> > +++ b/drivers/block/amiflop.c
> > @@ -1555,10 +1555,13 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
> >  	int old_dev;
> >  	unsigned long flags;
> >  
> > +	lock_kernel();
> >  	old_dev = fd_device[drive];
> >  
> > -	if (fd_ref[drive] && old_dev != system)
> > +	if (fd_ref[drive] && old_dev != system) {
> > +		unlock_kernel();
> >  		return -EBUSY;
> > +	}
> >  
> >  	if (mode & (FMODE_READ|FMODE_WRITE)) {
> >  		check_disk_change(bdev);
> > @@ -1571,8 +1574,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
> >  			fd_deselect (drive);
> >  			rel_fdc();
> >  
> > -			if (wrprot)
> > +			if (wrprot) {
> > +				unlock_kernel();
> >  				return -EROFS;
> > +			}
> >  		}
> >  	}
> >  
> > @@ -1589,6 +1594,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
> >  	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
> >  	       unit[drive].type->name, data_types[system].name);
> >  
> > +	unlock_kernel();
> >  	return 0;
> >  }
> 
> Using goto for errorhandling here would have been nicer.

I tried to minimize the chance for breaking stuff in code I cannot easily
test build. As shown by the bug you found in my pktcdvd patch, changing the
control flow of a function has a higher potential of introducing bugs,
so I didn't do it for drivers that people don't care much about any more.

> Also did you forget to include smp_locks.h?

No, that was already there from the first patch.

> Lot's of other places could benefit from improved goto error handling.
> The driver maintainers should do this (if there is a maintainer).

If that makes Jens accept my patches, I'd gladly change them this way.
I agree that it's cleaner and I always write my own code like that,
but when modifying (mostly) unmaintained code, my preference is on
trying to ensure the patch is correct.


> I did not find anything else going through this patch.

Ok, thanks a lot for looking through this!

	Arnd
