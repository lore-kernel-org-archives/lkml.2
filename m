Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1CYWwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:52:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61967 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1CYWwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:52:23 -0400
Date: Fri, 25 Mar 2011 22:52:20 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325225220.GV3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <201103252112.22520.arnd@arndb.de>
 <20110325222346.GS3130@pulham.picochip.com>
 <201103252335.14676.arnd@arndb.de>
 <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 06:38:00PM -0400, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 18:35, Arnd Bergmann wrote:
> > One more thing that I just realized:
> > I think it would be better not to allow arbitrary ioctl commands to
> > be interpreted by the individual drivers. Instead, interpret them
> > in the common code and pass the data to the drivers through separate
> > otp_device_ops function pointers, one per ioctl command.
> >
> > This will reduce the amount of code needed in each driver when you
> > have multiple ones implementing the same ioctls, and help to
> > ensure that they all treat the arguments in the same way.
> 
> i think we should do what the rtc framework did ... there are common
> ioctls which call specific function pointers in the driver, and any
> unhandled ioctls get passed to the driver-specific ioctl function.
> this should cover everyone's needs.

That's what I intended but I guess it isn't that clear from the code.  
Perhaps instead of:

	mutex_lock();
	region->ops->ioctl();
	mutex_unlock();

if I change it to:

	mutex_lock();
	switch (cmd) {
	default:
		region->ops->ioctl();
	}
	mutex_unlock();

then that's a bit clearer.  If there's stuff common across different OTP 
implementations then we can add it to the region ops and decode it here 
and if not fall back to the specific implementation.

Jamie
