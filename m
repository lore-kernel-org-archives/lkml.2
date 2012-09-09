Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2IIC5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 22:57:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45029 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab2IIC5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 22:57:08 -0400
Date: Sat, 8 Sep 2012 19:57:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] driver core: driver probe asynchronously
Message-ID: <20120909025702.GB9525@kroah.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 07:25:15AM +0800, Ming Lei wrote:
> Hi,
> 
> This patchset implements asynchronous driver probe for driver_register,
> and try to address the below problems about driver init during
> kernel boot:
> 	- help to solve some dependency problem during kernel boot
> 	(such as, request_firmware is called inside probe when driver
> 	is built in kernel[1])
> 
> The idea behind the patch is very simple:
> 
> 	- seperate driver probe from driver_register and run this part
> 	in one standalone kernel thread context
> 
> 	- so driver_register will become two parts: register the driver
> 	on the bus, and trigger to schedule a kernel thread to do the
> 	driver probe if autoprobe is set

You do realize we tried this out about 5+ years ago, it caused major
problems, no real benefit, and so we removed it (or maybe never did the
final commit with it, it might never have hit Linus's tree due to all of
the problems we found.)

> Fortunately, my OMAP4 based Pandaboard boots fine with the patchset, and
> looks it may work well.
> 
> More or less, some problems might be triggered by these patchset, but
> it should be helpful and not a big deal:
> 	- the dependency problem may be found, and it either exposes
> 	the driver's probelm or help to improve the asynchronous probe
> 	approach
> 
> 	- can use driver_register_sync to work around it
> 
> In summary, there are at least two advantages about asynchronous driver
> probe:
> 	- speedup kernel boot when many drivers are built in kernel

I would be really amazed if this is true in any measurable fashion.
Again, we tried this, and it did seem to be a tiny bit faster, but in
the end, wasn't worth it.

> 	- make driver's probe() not need to consider running something
> 	asynchronously(such as, scsi scan, request_firmware_no_wait, ...),
> 	so easier to write drivers

No, that's a bus issue, not a driver issue.  Busses can do this today,
if they want to, no problem at all.  So, some busses have (maybe, maybe
not, I can't remember, but I think ATA did), and that is the level you
need to do this at, not at the driver core level, sorry.

> It should a very simple way to help to solve the problem[1], without
> any changes on current drivers which call request_firmware() in its
> probe(). BTW, the patchset doesn't solve the problem completely, and
> still some work is needed.

As you state, this doesn't really solve the problem, and will cause a
lot more (think about all the busses that aren't expecting to have their
probe functions called at the same time as other probe functions are
being called.)

So while I applaud the effort, I can't accept this due to the past
history of when it was tried before.

sorry,

greg k-h
