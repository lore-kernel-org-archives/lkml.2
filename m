Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0LDOzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:55:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0LDOza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:55:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KZXNzrDrzC+uHbvXUqRYQaD0rbB6Prp1VvZjt8HSZ9PEHlBjCoAdS4v1NUlzZ+gtUs
         z0S5pWNBBBIloFTlN8FgMfJVBePE5+jiURNLt+rBqy2TGhWmqouRsdzNsQL/MOdRVo7U
         mb+4htSYcnsaozw1MHC+ZT4tkvhNN+Z1x/aOw=
Date: Sat, 4 Dec 2010 15:55:22 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 1/8] Introduce dynamic clock devices
Message-ID: <20101204145343.GA8390@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
 <201011080738.41871.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011080738.41871.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 07:38:41AM +0100, Arnd Bergmann wrote:
> On Thursday 04 November 2010, Richard Cochran wrote:
> > +struct clock_device {
> > +	struct file_operations fops;
> > +	struct file_operations *driver_fops;
> > +	struct clock_device_operations *ops;
> > +	struct cdev cdev;
> > +	struct kref kref;
> > +	struct mutex mux;
> > +	void *priv;
> > +	int index;
> > +	bool zombie;
> > +};
> 
> You should really not need the file_operations here, neither the
> struct nor the pointer. Just define a static file_operations
> structure containing clock_device_open and clock_device_release,
> and whatever else you might need, then add the driver's operations
> to clock_device_operations, and pass the clock_device pointer
> directly to them, instead of passing the file/inode pointers.

Arnd, I'm working a revision of this series, and I am not sure I
understand your comment.

The intent here was to allow clock drivers to register a character
device through the clock_device API, since some clocks (hpet, rtc)
already offer a chardev interface.

The same FD from the open character device will also be usable as a
clockid for the generic posix clock_get/settime calls. Thus, the
clock_device layer needs to hook into the file open/release functions.

Are you suggesting that I simply offer all of the functions from a
'struct file_operations' (sans file/inode) in the 'struct
clock_device_operations' too?

I wanted to avoid duplicating the file_operations functions, so that
future changes in those functions would automatically trickle down to
the clock drivers.

Thanks,
Richard



