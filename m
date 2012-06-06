Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2FFPFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:05:31 -0400
Received: from www84.your-server.de ([213.133.104.84]:57876 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2FFPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:05:30 -0400
Message-ID: <1338995150.9281.7.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Wed, 06 Jun 2012 17:05:50 +0200
In-Reply-To: <CACVXFVPX-F820rgusEiC9F9XQNqYybi29Cd_hSyiN95c2OAWHg@mail.gmail.com>
References: <1338988998-9061-1-git-send-email-stefani@seibold.net>
	 <CACVXFVPX-F820rgusEiC9F9XQNqYybi29Cd_hSyiN95c2OAWHg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 22:28 +0800 schrieb Ming Lei:
> On Wed, Jun 6, 2012 at 9:23 PM,  <stefani@seibold.net> wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> >
> > This is a fix for the USB skeleton driver to bring it in shape.
> >
> > - The usb_interface structure pointer will be no longer stored
> > - Every access to the USB will be handled trought the usb_interface pointer
> > - Add a new bool 'connected' for signaling a disconnect (== false)
> > - Handle a non blocking read without blocking
> > - Code cleanup
> > - Synchronize disconnect() handler with open() and release(), to fix races
> > - Introduced fsync
> > - Single user mode
> > - More code cleanup :-)
> > - Save some bytes in the dev structure
> 
> So many purposes, you need to split your patches for review easily, :-)
> 

This is the next step :-)

> >  static void skel_delete(struct kref *kref)
> >  {
> > @@ -86,15 +90,13 @@ static int skel_open(struct inode *inode, struct file *file)
> >  {
> >        struct usb_skel *dev;
> >        struct usb_interface *interface;
> > -       int subminor;
> > -       int retval = 0;
> > +       int retval;
> >
> > -       subminor = iminor(inode);
> > +       /* lock against skel_disconnect() */
> > +       mutex_lock(&sync_mutex);
> 
> This one is not needed since we have minor_rwsem(drivers/usb/core/file.c)
> to avoid the race.
> 

The mutex is not for the minor handling, it is for the disconnect(). As
mentioned in the previous posting, there is a race betwenn open() and
connect().

Oliver told me that a interface pointer can be already used by an other
driver when the disconnect() was called. 

So the interface will be used to determinate the dev pointer, which can
at this time also owned by an other driver.

And at last the dev pointer could be point to an already released
memory.

So it is IMHO needed.

> >
> >  static int skel_release(struct inode *inode, struct file *file)
> >  {
> > -       struct usb_skel *dev;
> > -
> > -       dev = file->private_data;
> > -       if (dev == NULL)
> > -               return -ENODEV;
> > +       struct usb_skel *dev = file->private_data;
> >
> > +       /* lock against skel_disconnect() */
> > +       mutex_lock(&sync_mutex);
> 
> Since the reference count is held now, so is there any race between
> release and disconnect?
> 

Same as above, the interface could be owned by an other driver.

Thanks,
Stefani


