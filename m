Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1HYPNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:13:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1HYPM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind1@gmail.com
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
Date: Thu, 25 Aug 2011 17:12:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: david.wagner@free-electrons.com,
        "linux-mtd" <linux-mtd@lists.infradead.org>,
        "linux-embedded" <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com> <201108241823.20904.arnd@arndb.de> <1314256010.18988.18.camel@sauron>
In-Reply-To: <1314256010.18988.18.camel@sauron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251712.40894.arnd@arndb.de>
X-Provags-ID: V02:K0:CAF6iIursSAzUZcRsMUIXa0uKIlNE2hRsXEWygVmRVc
 3gTuLztQqJQ1ZDfWS2T1Xybl8xAl8hz+oEJGwQfgKhd4QDfIrL
 pqvs7YywrID5ZXhZeVBL+3vZcrrcVhm1zBD5dVQByo8fbrK1+p
 WC3ptEjtS+JFGIbS3YLxRwjB5Lh8WwdEfCNGto0u5KP4CAtkYu
 y1uTL4MSAIc4qP2dR5tKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 August 2011, Artem Bityutskiy wrote:
> On Wed, 2011-08-24 at 18:23 +0200, Arnd Bergmann wrote:
> > That should  be fine, yes. I would probably put them into the same
> > header file though if they are in the same number space even
> > when you use them on distinct devices.
> > 
> > It does feel a little clumsy to have yet another character device
> > to manage the block devices though. What do you think about one
> > of these alternative approaches:
> > 
> > * When the ubi block device driver gets loaded, create one block
> >   device per volume and let the user deal with permissions for
> >   the devices instead of having to first create them as well.
> 
> I think this wasteful. Why should I have block devices which I do not
> need? If I have 4 UBI volumes, and need only one ubiblk, why should I
> waste my resources for 3 more of them (e.g., I do not want to waste
> memory for struct inode for each sysfs entry which these useless block
> devices will add). Also, will this mean 3 more block devices registered?
> 
> I think it is much uglier to have 3 "dummy" block devices and confuse
> users than have one nice control character device. For the sake of not
> having a separate control chardev?

The cost of a block device node in the kernel is rather low. Nowadays,
sysfs does not even permanently use inodes for entries, it has a much
more compact internal representation IIRC.

The main advantage of this approach is not having to set up the 
block device at all, it would just be there, which e.g. makes it
possible to put a root file system on it or do something else without
requiring a user space tool to issue an ioctl.

Evidently you can do everything you need even with that user space
tool, but IMHO the complexity of doing that is way bigger than
just creating the block devices right away.

> > * Use the existing UBI control device for the block devices as
> >   well and just add two more ioctls to create the devices.
> >   You can add a logical bus_type for this so that the ubi block
> >   driver gets automatically loaded matched with the device when
> >   one is created using the control device.
> 
> This sounds  better IMHO, but I am still not sure that adding another
> dummy bus and exposing it in sysfs and more complexity in the ubiblk
> code is more elegant and less wasteful than just creating a separate
> chardev...

It's not a dummy bus, in this approach it would be a the bus that gets
used by all ubiblk devices, which is a very common concept by itself.
It's more like the classic understanding of a 'device class' that Greg
wants to see get replaced by bus_types in the kernel.

	Arnd
