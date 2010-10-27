Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab0J0OOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:14:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756515Ab0J0ON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:13:57 -0400
Date: Wed, 27 Oct 2010 10:13:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hong Liu <hong.liu@intel.com>
cc: Alan Cox <alan@linux.intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] apds9802als: add runtime PM support
In-Reply-To: <1288139961.19329.401.camel@hongdev>
Message-ID: <Pine.LNX.4.44L0.1010271010170.1650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Oct 2010, Hong Liu wrote:

> In apds9802als_resume, I just want to power up the device, do some
> configuration, and then runtime_suspend the device.

Then you should change the function the way I suggested.  The PM core
will automatically do a runtime suspend after the system has fully
woken up.

> We don't have runtime_idle() implemented, the driver exported sysfs
> entries to user space for data reading, and we do runtime_resume,
> measaure data, runtime_suspend in the read/write funciton of those sysfs
> entries. This is why I want to put the device into runtime suspend
> manually whenever possible.

Your approach will not work.  You _must_ define runtime_idle() if you 
want your driver to suspend correctly.  It doesn't have to be 
complicated; just make it call pm_runtime_suspend().

...

> We don't have runtime_idle() implemented, so I have to manually put the
> device into runtime suspend.

The problem is that the device can be runtime-resumed by code other 
than your own, and that other code will not always do a runtime-suspend 
afterward -- it will do a runtime-idle.  That's why you need to define 
a runtime_idle() callback.

Alan Stern

