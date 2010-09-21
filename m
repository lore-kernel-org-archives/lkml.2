Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab0IURJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:09:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:36698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0IURJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:09:32 -0400
Date: Tue, 21 Sep 2010 10:07:28 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Phil Turmel <philip@turmel.org>,
        Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st
 insert, ignored on 2nd insert, lsusb stuck at usbdev_open
Message-ID: <20100921170728.GA10105@suse.de>
References: <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz>
 <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
 <20100921165048.GB8756@suse.de>
 <alpine.LNX.2.00.1009211852010.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009211852010.26813@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 06:55:36PM +0200, Jiri Kosina wrote:
> On Tue, 21 Sep 2010, Greg KH wrote:
> 
> > > > I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
> > > > makes the difference. When unset, the problem doesn't trigger, and 
> > > > usb_find_interface() always returns the proper interface. When 
> > > > CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> > > > 
> > > > I'll look into that.
> > > 
> > > Apparently the problem is that intf->minors doesn't get initialized 
> > > properly.  This patch should fix it.  Everybody, please try it out.
> > 
> > Wow, what happened to suddenly cause this?  Nothing has changed here in
> > a long time.
> > 
> > wierd.
> 
> It doesn't hit you if you are calling usb_register_dev() for all the 
> instances you have, as the first device will have minor '0', the second 
> one '1', etc.
> 
> But if you are calling usb_find_interface() for devices that have never 
> been registered through usb_register_dev(), then you have a problem, as 
> usb_find_interface() will match those unregistered devices (as minor == 0 
> in such cases).
> 
> This is probably quite rare scenario, and hiddev (which might be the only 
> in-kernel driver doing this?) has moved to usb_find_interface() only 
> recently.

Ah, ok, that makes sense, I never thought of someone calling that
function if they had never registered a device :)

When did hiddev make this change?  We need to know that for the -stable
backport of this patch.

Alan, care to resend the patch in a format I can apply it?

thanks,

greg k-h
