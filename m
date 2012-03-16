Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2CPT3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:29:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54058 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab2CPT3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120316173610.GA26601@kroah.com>
References: <1326405431-988-1-git-send-email-taysom@chromium.org>
	<20120316173610.GA26601@kroah.com>
Date: Fri, 16 Mar 2012 12:29:15 -0700
Message-ID: <CAKwO_5FCn5Z07ZLBUq6Zu=E0Oki-yL6ytwA7gKjzsO8=fJrCHA@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Paul Taysom <taysom@google.com>
To: Greg KH <greg@kroah.com>
Cc: Paul Taysom <taysom@chromium.org>, Mandeep Baines <msb@chromium.org>,
        Jens Axboe <axboe@kernel.dk>, Theodore Tso <tytso@google.com>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:36 AM, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jan 12, 2012 at 01:57:11PM -0800, Paul Taysom wrote:
> > A USB stick with a ext file system on it, would occasionally crash
> > when the stick was pulled.
> >
> > The problem was a timer was being set on the Backing Device Interface,
> > bdi, after the USB device had been removed and the bdi had been
> > unregistered. The bdi would then be later reinitialized by zeroing
> > the timer without removing from the timer from the timer queue.
> > This would eventually result in a kernel crash (NULL ptr dereference).
> >
> > When the bdi is unregistered, the dev field is set to NULL. This
> > indication is used by bdi_unregister to only unregister the device
> > once.
> >
> > Fix: When the backing device is invalidated, the mapping
> > backing_dev_info
> > should be redirected to the default_backing_dev_info.
> >
> > Created 3 USB sticks with ext2, ext4 and one with both apple and DOS
> > file systems on it. Inserted and removed USB sticks many times in random
> > order. With out the bug fix, the kernel would soon crash. With the fix,
> > it did not. Ran on both stumpy and amd64-generic.
> >
> > Signed-off-by: Paul Taysom <taysom@chromium.org>
> > Cc: Mandeep Baines <msb@chromium.org>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Theodore Tso <tytso@google.com>
> > Cc: Andrew Morton <akpm@google.com>
> > Cc: <linux-usb@vger.kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: <linux-fsdevel@vger.kernel.org>
> > Cc: <stable@kernel.org>
> > ---
> >  fs/block_dev.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index afe74dd..322cd05 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -110,6 +110,7 @@ void invalidate_bdev(struct block_device *bdev)
> >        * But, for the strange corners, lets be cautious
> >        */
> >       cleancache_flush_inode(mapping);
> > +     mapping->backing_dev_info = &default_backing_dev_info;
> >  }
> >  EXPORT_SYMBOL(invalidate_bdev);
>
> What ever happened to this patch?  Is it still needed?  Can you still
> reproduce the problem on Linus's tree and older kernels?
>


Never heard anything back.  Ted supplied a partial fix in 3.2.6 (I
believe) for just the ext4 file system. Who should I follow up with?
Thanks,
Paul
