Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1GAQM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:12:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:56450 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab1GAQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,459,1304319600"; 
   d="scan'208";a="22421536"
Date: Fri, 1 Jul 2011 09:12:53 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org
Subject: Re: Regression 3.0-rc5+ : khubd blocked
Message-ID: <20110701161253.GC5598@xanatos>
References: <4E0DC172.9010504@tudelft.nl>
 <Pine.LNX.4.44L0.1107011106380.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.1107011106380.1988-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 11:21:50AM -0400, Alan Stern wrote:
> On Fri, 1 Jul 2011, Éric Piel wrote:
> 
> > Hello,
> > I've come across to what looks like a regression in the kernel a
> > few commits after 3.0-rc5.
> > 
> > When I turn off a usb hub, to which my mouse and keyboard are connected,
> > and then turn it on again, they are not detected again. After unplugging
> > it and waiting a few minutes I get a "task khubd:621 blocked for more
> > than 120 seconds."
> > 
> > I haven't investigated much. It seems reproducible here on my x86_64
> > laptop. It doesn't seem to happen on a 3.0-rc4. Maybe important, my
> > kernel already has commit 2e34b429a404675dc4fc4ad2ee339eea028da3ca
> > "Merge branch 'usb-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6"
> > 
> > Let me know if you need me to investigate more, or maybe there is
> > already a fix for that bug?
> > 
> > Below is the whole message of the hung. 
> > 
> > Cheers,
> > Éric
> > 
> > 
> > Jul  1 14:08:16 dutifh kernel: INFO: task khubd:621 blocked for more than 120 seconds.
> > Jul  1 14:08:16 dutifh kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > Jul  1 14:08:16 dutifh kernel: khubd           D ffff88013a30dfd8     0   621      2 0x00000000
> > Jul  1 14:08:16 dutifh kernel: ffff88013a30db00 0000000000000046 ffff88013a30da10 ffffffffa00dd852
> > Jul  1 14:08:16 dutifh kernel: ffff88013b954320 ffff88013a30dfd8 ffff88013a30dfd8 ffff88013a30dfd8
> > Jul  1 14:08:16 dutifh kernel: ffff88013b891660 ffff88013b954320 ffff8800bb0084c0 dead000000100100
> > Jul  1 14:08:16 dutifh kernel: Call Trace:
> > Jul  1 14:08:16 dutifh kernel: [<ffffffffa00dd852>] ? usb_hcd_giveback_urb+0x72/0xe0 [usbcore]
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff8109e24f>] ? __rcu_read_unlock+0x2f/0x200
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff81388634>] __mutex_lock_slowpath+0xf4/0x190
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff8138806d>] mutex_lock+0x1d/0x40
> > Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e1e22>] usb_set_interface+0x62/0x250 [usbcore]
> > Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e3b9f>] usb_unbind_interface+0x10f/0x180 [usbcore]
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff81269217>] __device_release_driver+0x77/0xd0
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff81269297>] device_release_driver+0x27/0x40
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff81268d83>] bus_remove_device+0x73/0xb0
> > Jul  1 14:08:16 dutifh kernel: [<ffffffff81266845>] device_del+0x125/0x1a0
> > Jul  1 14:08:16 dutifh kernel: [<ffffffffa00e192c>] usb_disable_device+0x7c/0x1a0 [usbcore]
> > Jul  1 14:08:16 dutifh kernel: [<ffffffffa00d9f80>] usb_disconnect+0xa0/0x140 [usbcore]
> 
> It appears that this was caused by Sarah's commit 
> fccf4e86200b8f5edd9a65da26f150e32ba79808 (USB: Free bandwidth when 
> usb_disable_device is called).  usb_disconnect() grabs the 
> bandwidth_mutex before calling usb_disable_device(), which calls down 
> indirectly to usb_set_interface(), which tries to acquire the 
> bandwidth_mutex.

Ugh, yeah, and that patch was marked for stable.  I haven't seen it go
by into the stable trees yet.  Alan, can you mark your bug fix patch for
stable?

> This patch should fix the problem.  Still, this whole area cries out 
> for some serious rewriting.

Yes, it isn't pretty.  Patches welcome. :)

Sarah Sharp

> Index: usb-3.0/drivers/usb/core/message.c
> ===================================================================
> --- usb-3.0.orig/drivers/usb/core/message.c
> +++ usb-3.0/drivers/usb/core/message.c
> @@ -1273,6 +1273,8 @@ int usb_set_interface(struct usb_device 
>  			interface);
>  		return -EINVAL;
>  	}
> +	if (iface->unregistering)
> +		return -ENODEV;
>  
>  	alt = usb_altnum_to_altsetting(iface, alternate);
>  	if (!alt) {
> 
