Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0KRUCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:02:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0KRUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:02:38 -0500
Date: Thu, 18 Nov 2010 12:02:30 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118200230.GA25715@suse.de>
References: <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118163321.GA2723@suse.de>
 <4CE5562B.8080604@freescale.com>
 <20101118165136.GA3103@suse.de>
 <4CE55ACB.80207@freescale.com>
 <20101118171856.GA4283@suse.de>
 <4CE5647F.5000203@freescale.com>
 <20101118175832.GA4931@suse.de>
 <4CE58005.7040308@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE58005.7040308@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 01:35:33PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> >> I just booted a Linux kernel with the driver I just emailed you, and there's no
> >> > /dev/serial/ directory.  The only directories under /dev/ are 'shm' and 'pts',
> >> > both of which are empty.
> 
> > Then plug in a serial port device and see what happens.  You didn't hook
> > everything up in your driver correctly it seems, do your devices show up
> > under /sys/class/tty?
> 
> If I delete the call to device_create() in ehv_bc_init() (so that it creates the
> TTY devices only, and not the character devices), I get this:
> 
> # ls -l /sys/class/tty/ttyEHV*
> lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV0
> -> ../../devices/virtual/tty/ttyEHV0
> lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV1
> -> ../../devices/virtual/tty/ttyEHV1
> lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV2
> -> ../../devices/virtual/tty/ttyEHV2
> 
> >> > I'm also running a Fedora 13 x86 system, just to see if I need a full modern OS
> >> > to see these files.  Again, there is no /dev/serial/, even though I have serial
> >> > ports.
> > Dynamic ones like a usb to serial device?
> 
> No, not dynamic ones.
> 
> >> > Also not that since I'm not registering the byte channels as serial devices, I
> >> > wouldn't expect anything in /dev/serial/ to reference them.
> >> > 
> >> > What does my driver need to do in order for these /dev/xxxx/ entries to contain
> >> > that information?
> 
> > See the udev rules for details.
> 
> udev rules still need some way for the driver to tell user-space that
> /dev/ttyEHV0 is associated with byte channel handle 73.  I still don't know what
> mechanism my driver is supposed to use to make that information available to
> user space.
> 
> I could fake it by doing this:
> 
> for (i = 0; i < num_byte_channels; i++) {
> 	bc->handle = get_the_byte_channel_handle(i);
> 	ehv_bc_driver->name_base = bc->handle - i;
> 	tty_register_device(ehv_bc_driver, i, NULL);

Why are you not setting up a parent device of your tty device?  That
should be essencial.

> }
> 
> This actually works and does what I want, but I seriously doubt it's acceptable.
>  When I do this, I get:
> 
> # ls -l /dev/ttyEH*
> crw-rw----    1 root     uucp     253,   0 Jan  1 00:00 /dev/ttyEHV73
> crw-rw----    1 root     uucp     253,   1 Jan  1 00:00 /dev/ttyEHV76
> crw-rw----    1 root     uucp     253,   2 Jan  1 00:00 /dev/ttyEHV79

Does that work for you?  Looks fine to me :)

But again, you really should get the driver model portion right...

thanks,

greg k-h
