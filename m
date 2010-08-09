Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0HINyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:54:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:50208 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab0HINyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:54:38 -0400
Subject: Re: [PATCH] Add quick erase format option
From: Stefani Seibold <stefani@seibold.net>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1281353344.2332.8.camel@brekeke>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 09 Aug 2010 15:54:29 +0200
Message-ID: <1281362069.20181.16.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 09.08.2010, 14:29 +0300 schrieb Artem Bityutskiy: 
> On Mon, 2010-08-09 at 10:52 +0200, Stefani Seibold wrote:
> > Am Montag, den 09.08.2010, 09:37 +0100 schrieb David Woodhouse:
> > > On Mon, 2010-08-09 at 09:25 +0100, stefani@seibold.net wrote:
> > > > From: Stefani Seibold <stefani@seibold.net>
> > > > 
> > > > This patch add a quick format option which skips erasing of already erased
> > > > flash blocks. This is useful for first time production environments where
> > > > the flash arrived erased.
> > > > 
> > > > Signed-off-by: Stefani Seibold <stefani@seibold.net> 
> > > 
> > > This scares me, given the lengths we had to go to in JFFS2 to cope with
> > > blocks which *look* like they're erased, but which actually start losing
> > > data as soon as you start writing to them because the erase didn't
> > > complete.
> > > 
> > 
> > I know the drawback. This is why it is only an option which must be
> > enabled. And in most use cases there is a subsequent ubimkvol, which
> > will fail if the flash is not correct initialized.
> > 
> > Flash are normally delivered erased. So this save in our production
> > environment (Nokia Siemens Networks) about 5 minutes per device (256 MB
> > NOR CFI Flash).
> > 
> > The old JFFS2 was very fast to install the first time on a flash, it was
> > only a simple mount of the MTD partition. 
> 
> Not sure what you do, but both UBI and UBIFS auto-format flash if it is
> empty, and attaching empty flash should be very fast.
> 

I was never able to mount a UBIFS without a previous ubimkvol, despite
the flash is already erased.

Here are my timing results mounting an already erased flash as UBIFS:

ubiattach /dev/ubi_ctrl -m 5 -d 1              -->   2.023s
ubimkvol /dev/ubi1 -m -N flash                 --> 294.574s
mount -t ubifs -o sync ubi1:flash /mnt         -->   0.221s

And this are the timing results when i do an ubiformat first:

ubiformat /dev/mtd5                            --> 299.111s
ubiattach /dev/ubi_ctrl -m 5 -d 1              -->   0.129s
ubimkvol /dev/ubi1 -m -N flash                 -->   1.784s
mount -t ubifs -o sync ubi1:flash /mnt         -->   0.220s

And this are the results with my patched version of the ubiformat tool
using an already erased flash:

ubiformat /dev/mtd5 -E                         -->   5.475s
ubiattach /dev/ubi_ctrl -m 5 -d                -->   0.130s
ubimkvol /dev/ubi1 -m -N flash                 -->   1.699s
mount -t ubifs -o sync ubi1:flash /mnt         -->   0.220s

As you can see this is 296.818s vs. 7.524 or 40 times faster.

Maybe i do something wrong, but i have no idea. Can u explain it to me?

BTW: The flash is a 128 MB CFI AMD NOR and the size of the mtd5
partition is 47 MB.

> But yes, the first volume creation ioctl will block until everything is
> erased, although this is just an implementation issue and in theory,
> fixable.
> 
> > Which the quick format option i have now only a slightly first time
> > installation overhead compared to JFFS2. Without this option the
> > overhead is more than 5 minutes.
> 
> Are you flashing an UBI image in production? Then what you can do if you
> want to be faster is to flash only the blocks which contain image date,
> and leave the rest intact, UBI will erase them and write EC header to
> them when you first boot the device.
> 

No, we only initialize the flash, mount it as UBIFS and copy files.

> So I think it is better to add an --pristine-flash option, or something
> like this. In this case ubiformat won't erase anything, and will assume
> everything is 0xFFed without reading. This should be faster and I think
> is better to do.
> 

This patch assumes nothing, it will skip the erase of the PEB if all
bytes in the EC header are 0xff. I think this is safer than your
suggestion.

- Stefani


