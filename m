Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2ACPQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:16:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45463 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752854Ab2ACPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:16:19 -0500
Date: Tue, 3 Jan 2012 10:16:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>, Jack Stone <jwjstone@fastmail.fm>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <201201031250.52580.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1201031002050.1452-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012, Oliver Neukum wrote:

> > The USB suspend/resume function does that "unbind/rebind" dance, and
> > that causes a "device_attach()". Which causes a probe() to be called.
> > 
> > Should it do that? I think not, not if the ID's haven't changed. But I
> > don't know the USB layer all that well.
> 
> The ID has changed. That is why we run into this problem.
> And indeed the USB layer does the rebind only if either
> 
> a) ID has changed

That's not true, or at least, it shouldn't be true.

If the ID has changed then there's nothing to rebind.  The old device
is gone; it cannot be resumed or rebound at all.  That's the theory,
and indeed things really do work that way during reset-resume.

Now, during an ordinary resume, the USB core does not check IDs.  It
assumes that if suspend power was provided to the bus and the device
was connected to the bus the entire time, then the device remains
unchanged.  Perhaps this assumption is a mistake, but so far I haven't
seen any data to prove that it is.

> b) the driver tells us that it cannot deal with a device that has lost its state

This case applies only in situations where the driver doesn't have a 
reset_resume method.  The uvc driver does have one.

(You left out a third case: The driver doesn't have any suspend/resume
methods.  But this case applies only when the device has not lost its
state, and besides, the uvc driver does have these methods.)

Alan Stern

