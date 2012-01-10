Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2AJKEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:04:06 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36781 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab2AJKED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:04:03 -0500
Date: Tue, 10 Jan 2012 11:03:57 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120110110357.544d5508@de.ibm.com>
In-Reply-To: <20120110092046.GB32291@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
	<20120110100541.38a3940f@de.ibm.com>
	<20120110092046.GB32291@core.coreip.homeip.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011010-4966-0000-0000-0000011D1CC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012 01:20:46 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Tue, Jan 10, 2012 at 10:05:41AM +0100, Martin Schwidefsky wrote:
> > On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
> > > drivers/s390/cio/device.c:1687:       put_driver(drv);
> > > 
> > > Martin, these calls seem to be useless.  The calls in ccwgroup.c are 
> > > definitely useless; there's no reason to take a reference to a driver 
> > > while it's being unregistered, since it can't go away until the 
> > > unregistration is finished.
> > 
> > The get_driver/put_driver in ccwgroup.c are obviously useless, the caller
> > passed ccwgroup_driver_unregister a ccwgroup_driver reference.
> > I am not so sure about the code in device.c. get_ccwdev_by_busid() gets
> > used e.g. by vmur like this:
> 
> It does not matter how it is being used. Either get_ccwdev_by_busid()
> gets a valid driver structure or you already lost. You can not say that
> get_driver() protects anything, since if there is a chance driver can
> disappear it can disappear before we get to executing get_driver() code.
> 
> So while you might want to audit callers get/put_driver inside of
> get_ccwdev_by_busid() is utterly useless.
 
Agreed, we have to rely on the module reference counting and the various
owner fields to prevent driver unregister while we in a code path that might
call get_ccwdev_by_busid(). Lets keep our fingers crossed that all owner
fields are set correctly.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

