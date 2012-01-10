Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2AJJGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:06:01 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50249 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab2AJJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:05:57 -0500
Date: Tue, 10 Jan 2012 10:05:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120110100541.38a3940f@de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011009-3548-0000-0000-000000A33AE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 12:35:09 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> drivers/s390/cio/device.c:1681:       drv = get_driver(&cdrv->driver);
> drivers/s390/cio/device.c:1687:       put_driver(drv);
> 
> Martin, these calls seem to be useless.  The calls in ccwgroup.c are 
> definitely useless; there's no reason to take a reference to a driver 
> while it's being unregistered, since it can't go away until the 
> unregistration is finished.

The get_driver/put_driver in ccwgroup.c are obviously useless, the caller
passed ccwgroup_driver_unregister a ccwgroup_driver reference.
I am not so sure about the code in device.c. get_ccwdev_by_busid() gets
used e.g. by vmur like this:

static struct ccw_driver ur_driver = { .. };

static struct urdev *urdev_get_from_devno(u16 devno)
{
	..
	sprintf(bus_id, "0.0.%04x", devno);
        cdev = get_ccwdev_by_busid(&ur_driver, bus_id);
	..
}

static int ur_open(struct inode *inode, struct file *file)
{
	..
	urd = urdev_get_from_devno(devno);
	..
}

For vmur we should be safe by the fact that ur_open is only possible if
a try_module_get has been successful and the ccw_driver is unregistered
only in the module exit function. But we have to check if this is true
for all users of the get_ccwdev_by_busid() function.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

