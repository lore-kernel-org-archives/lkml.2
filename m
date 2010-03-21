Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0CUKaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:30:11 -0400
Received: from legolas.restena.lu ([158.64.1.34]:36013 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0CUKaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:30:06 -0400
Date: Sun, 21 Mar 2010 11:29:22 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 6/6] hid: add experimental access to PicoLCD device's
 EEPROM and FLASH
Message-ID: <20100321112922.53bb8c6e@neptune.home>
In-Reply-To: <20100321030802.GB29360@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
	<20100320171119.193c5615@neptune.home>
	<20100321030802.GB29360@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Sat, Mar 20, 2010 at 05:11:19PM +0100, Bruno Prémont wrote:
> > The PicoLCD device has a small amount of EEPROM and also provides
> > access to its FLASH where firmware and splash image are saved.
> > In flasher mode FLASH access is the only active feature.
> > 
> > Give read/write access to both via debugfs files.
> > 
> 
> It looks you are allowing multiple users access to these files. What
> will happen if 2 processes try to write EEPROM at the same time?

Writes will be serialized by the wait for response from device with
picolcd_send_and_wait() and it's up to userspace to repeat the
reads/writes in order to get all the data they need if they requested
more that the 20 bytes that can be transferred in a single HID report.

For flash access a concurrent write to same area can cause one of the
writers to conflict with the other one as a write there is a sequence
of operations which can interleave (e.g. A erases, A writes 1/2,
B erases, B writes 1/2, A writes 2nd 1/2, B writes 2nd 1/2 which would
fail).
A single-user open would be a nice work-around for this.
I would prefer to make erase operation explicitly visible to user so
I don't have to do the erase behind the scenes.
I've not yet looked in the area of mtd/nand support if I can use their
interface.

This is the big reason I did put both to debugfs, they (especially
flash access) need to be made visible in a better way.

> > +
> > +static inline int picolcd_init_devfs(struct picolcd_data *data,
> > +		struct hid_report *eeprom_r, struct hid_report *eeprom_w,
> > +		struct hid_report *flash_r, struct hid_report *flash_w,
> > +		struct hid_report *reset)
> > +{
> 
> I don't think this should be forced inline.

Ok, will drop most of the 'inline' keywords as you suggested already
on one of the other patches.

Thanks for the review,
Bruno
