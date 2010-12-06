Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0LFOP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:15:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0LFOP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:15:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC 1/8] Introduce dynamic clock devices
Date: Mon, 6 Dec 2010 15:14:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <201011080738.41871.arnd@arndb.de> <20101204145343.GA8390@riccoc20.at.omicron.at>
In-Reply-To: <20101204145343.GA8390@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061514.50055.arnd@arndb.de>
X-Provags-ID: V02:K0:UiWPFSTCboZb7dITDq41SxXIt8mSOHk6Y4sJDNT+ruV
 KION8MKxem4aM9EeulR9ICCvLu7l1G8cvImUZ7qLvmCPD9850q
 y/foSJhdPOZTycS+g9QK/YR8GtcznNKn0k2Xc1ZQdk7UGfpUSG
 Dh+IyRmuQ9/HcX/8gO5HYfBGSUVTGqeiuMgJjb4kJB8XnysCeC
 aQrVYhYX67lCieMN6Ko/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 December 2010, Richard Cochran wrote:
> On Mon, Nov 08, 2010 at 07:38:41AM +0100, Arnd Bergmann wrote:
> > On Thursday 04 November 2010, Richard Cochran wrote:
> > > +struct clock_device {
> > > +   struct file_operations fops;
> > > +   struct file_operations *driver_fops;
> > > +   struct clock_device_operations *ops;
> > > +   struct cdev cdev;
> > > +   struct kref kref;
> > > +   struct mutex mux;
> > > +   void *priv;
> > > +   int index;
> > > +   bool zombie;
> > > +};
> > 
> > You should really not need the file_operations here, neither the
> > struct nor the pointer. Just define a static file_operations
> > structure containing clock_device_open and clock_device_release,
> > and whatever else you might need, then add the driver's operations
> > to clock_device_operations, and pass the clock_device pointer
> > directly to them, instead of passing the file/inode pointers.
> 
> Arnd, I'm working a revision of this series, and I am not sure I
> understand your comment.
> 
> The intent here was to allow clock drivers to register a character
> device through the clock_device API, since some clocks (hpet, rtc)
> already offer a chardev interface.
> 
> The same FD from the open character device will also be usable as a
> clockid for the generic posix clock_get/settime calls. Thus, the
> clock_device layer needs to hook into the file open/release functions.

Ok, it wasn't clear that you use this to hook the existing file
operations, I now understand why you did it this way, but I think
my point is still valid.

> Are you suggesting that I simply offer all of the functions from a
> 'struct file_operations' (sans file/inode) in the 'struct
> clock_device_operations' too?

Yes, exactly.

> I wanted to avoid duplicating the file_operations functions, so that
> future changes in those functions would automatically trickle down to
> the clock drivers.

No need, these rarely change. More importantly, if you want to offer
a consistent interface across all these, I would make the interface
as restrictive as possible rather than offering all of the file
operations. Have a look which operations are actually used by the
character devices you want to support, and then pass through the
superset of those, but not more.

	Arnd
