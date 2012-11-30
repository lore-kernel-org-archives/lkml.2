Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2K3QdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:33:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62019 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2K3Qc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:32:58 -0500
Date: Fri, 30 Nov 2012 08:32:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121130163254.GB4478@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <20121128165719.GB31314@kroah.com>
 <50B8C7BF.4000004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B8C7BF.4000004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 04:50:39PM +0200, Eli Billauer wrote:
> Thanks for the remarks.
> 
> I'm sending the updated patches in a minute. Basically, I divided
> the module into three (one core, one for PCIe and one for OF) and
> made several corrections.
> 
> On 11/28/2012 06:57 PM, Greg KH wrote:
> >What is the user/kernel interface for this driver?  Is it documented
> >anywhere?
> There's a rather extensive documentation for download at the site.
> The docs for the host side mostly instruct common UNIX programming
> techniques: The device files are just data pipes to FIFOs in the
> FPGA, behaving like one would expect.

As we need to review the user/kernel api here, putting the docs as part
of the driver submission is a good idea :)

I didn't know, nor do I trust, that a random web site would have the
correct documentation for a kernel driver.

> >>+#if (PAGE_SIZE<  4096)
> >>+#error Your processor architecture has a page size smaller than 4096
> >>+#endif
> >That can never happen.  Even if it does, you don't care about that in
> >the driver.
> >
> I removed this check because it can't happen. But the driver *does*
> care about this, since it creates a lot of buffers with different
> alignments, hence depending on the pages' alignment.

Alignment is different than the size of a page.  What happens if your
driver runs on a machine with a page size bigger than 4K?  You need to
be able to handle that properly, so perhaps you should check that?

> >>+static struct class *xillybus_class;
> >Why not just use the misc interface instead of your own class?
> When Xillybus is used, the whole system's mission is usually around
> it (e.g. it's a computer doing data acquisition through the Xillybus
> pipes). So giving it a high profile makes sense, I believe. Besides,
> a dozen of device files are not rare.

It is no problem to create dozens of misc devices.  It makes your driver
smaller, contain less code that I have to audit and you have to ensure
you got right, and it removes another user of 'struct class' which we
are trying to get rid of anyway.  So please, move to use a misc device.

thanks,

greg k-h
