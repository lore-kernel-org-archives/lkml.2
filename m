Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab1CZAWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:22:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45620 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab1CZAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:22:05 -0400
Date: Sat, 26 Mar 2011 00:21:59 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, Mike Frysinger <vapier@gentoo.org>,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110326002159.GY3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
 <20110325225220.GV3130@pulham.picochip.com>
 <201103260002.19291.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103260002.19291.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 12:02:19AM +0100, Arnd Bergmann wrote:
> On Friday 25 March 2011 23:52:20 Jamie Iles wrote:
> > That's what I intended but I guess it isn't that clear from the code.  
> > Perhaps instead of:
> > 
> >         mutex_lock();
> >         region->ops->ioctl();
> >         mutex_unlock();
> > 
> > if I change it to:
> > 
> >         mutex_lock();
> >         switch (cmd) {
> >         default:
> >                 region->ops->ioctl();
> >         }
> >         mutex_unlock();
> > 
> > then that's a bit clearer.  If there's stuff common across different OTP 
> > implementations then we can add it to the region ops and decode it here 
> > and if not fall back to the specific implementation.
> 
> This will make it a lot harder to support compat_ioctl as well.
> Just drop the ->ioctl callback into the driver and make one
> callback per command. Any command that could be reused on
> another driver will then be defined in the common header file
> already and just work on new drivers.

OK, you've convinced me :-)

The only use of an ioctl() at the moment is for locking portions of the 
OTP so perhaps we add a new region op .lock(unsigned long start_addr, 
size_t nr_words).

For the actual ioctl() we should assume byte addressing rather than 
words though and do the conversion in the driver so we can cope with 
devices that don't have 64-bit words and do the locking on a looping 
word-by-word basis.

	struct otp_lock_req {
		__u32	start_addr;
		__u32	byte_count;
	};

The start_addr would be relative to the start of the region.

Mike, would this be OK with you if we used a different ioctl() to the 
one bfin-otp is using currently?  I notice that it's using the OTPLOCK 
ioctl() from MTD but I think it's using the argument in a different way.

Jamie
