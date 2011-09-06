Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1IFDmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:42:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38111 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab1IFDmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:42:45 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: david.wagner@free-electrons.com, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 Sep 2011 06:44:58 +0300
In-Reply-To: <201108251712.40894.arnd@arndb.de>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <201108241823.20904.arnd@arndb.de> <1314256010.18988.18.camel@sauron>
	 <201108251712.40894.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315280704.19067.14.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry for long delay, did not have time to read my mail.

On Thu, 2011-08-25 at 17:12 +0200, Arnd Bergmann wrote:
> > I think this wasteful. Why should I have block devices which I do not
> > need? If I have 4 UBI volumes, and need only one ubiblk, why should I
> > waste my resources for 3 more of them (e.g., I do not want to waste
> > memory for struct inode for each sysfs entry which these useless block
> > devices will add). Also, will this mean 3 more block devices registered?
> > 
> > I think it is much uglier to have 3 "dummy" block devices and confuse
> > users than have one nice control character device. For the sake of not
> > having a separate control chardev?
> 
> The cost of a block device node in the kernel is rather low. Nowadays,
> sysfs does not even permanently use inodes for entries, it has a much
> more compact internal representation IIRC.
> 
> The main advantage of this approach is not having to set up the 
> block device at all, it would just be there, which e.g. makes it
> possible to put a root file system on it or do something else without
> requiring a user space tool to issue an ioctl.

Yes, I understand, but the cost of each block device is not zero, I did
not measure it, but I believe it would be in Kilobytes. Also, littering
sysfs and /dev with useless block devices is not beautiful - why would
a user want to have or see fake and useless block devices? And as David
said, for some UBI volumes we do not want to have block devices at all.

And BTW, mtdblock is uses exactly this technique, and I had to write
many times to different confused people that they should not look at
those "/dev/mtdblockX" devices, as if they did not exist...

IOW, I think automatic creation for all UBI volumes has more drawbacks
than advantages.

> Evidently you can do everything you need even with that user space
> tool, but IMHO the complexity of doing that is way bigger than
> just creating the block devices right away.

Well, it is jut another step to a set of steps one usually needs to do
to attach an MTD device, create an UBI volume, etc.

> It's not a dummy bus, in this approach it would be a the bus that gets
> used by all ubiblk devices, which is a very common concept by itself.
> It's more like the classic understanding of a 'device class' that Greg
> wants to see get replaced by bus_types in the kernel.

Yes, this sounds OK. Although UBI already has notifiers, so we could
just add 2 more events.

-- 
Best Regards,
Artem Bityutskiy

