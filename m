Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2AWQPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:15:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750969Ab2AWQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:14:59 -0500
Date: Mon, 23 Jan 2012 11:14:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Glass <sjg@chromium.org>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot
 time
In-Reply-To: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1201231104410.1372-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012, Simon Glass wrote:

> First, backing up a bit, there are at least two ways to solve this.
> One is to have the drivers only call usb_add_hcd() from a work queue
> or similar - i.e. not as part of their initcall execution. The other
> is what I have done here.
> 
> Before I go much further I would like to know which is
> best/preferable. Because in answer to your questions I'm not sure
> drivers have a way of dealing with failure of delayed init. It would
> need notification back to the driver at least.

I thought about this a little more.  Maybe it's okay not to unbind the 
driver when the async initialization fails.  After all, it's not like 
any other driver is going to want to manage that hardware.

But that still leaves problems.  Unregistration should work properly
even when async init fails.  The easiest solution seems to be to clear
hcd->self.root_hub whenever async initialization fails, and then in
usb_remove_hcd, return immediately if hcd->self.root_hub isn't set.  
Doing things this way, you avoid the need to modify all those
controller drivers.

That's not all.  You have a race between unbinding and async
initialization.  Probably you will need to make the work routine lock
the hcd->self.controller device, for mutual exclusion with unbinding.  
In addition, usb_remove_hcd should try to cancel the work routine, in
case it hasn't run yet.  And finally, for the case where both things
end up running concurrently, the work routine should check whether
unbinding has already started and fail immediately if it has.

Alan Stern

