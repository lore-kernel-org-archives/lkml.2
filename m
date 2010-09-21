Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab0IUQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:55:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab0IUQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:55:40 -0400
Date: Tue, 21 Sep 2010 18:55:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Phil Turmel <philip@turmel.org>,
        Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <20100921165048.GB8756@suse.de>
Message-ID: <alpine.LNX.2.00.1009211852010.26813@pobox.suse.cz>
References: <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz> <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org> <20100921165048.GB8756@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Greg KH wrote:

> > > I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
> > > makes the difference. When unset, the problem doesn't trigger, and 
> > > usb_find_interface() always returns the proper interface. When 
> > > CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> > > 
> > > I'll look into that.
> > 
> > Apparently the problem is that intf->minors doesn't get initialized 
> > properly.  This patch should fix it.  Everybody, please try it out.
> 
> Wow, what happened to suddenly cause this?  Nothing has changed here in
> a long time.
> 
> wierd.

It doesn't hit you if you are calling usb_register_dev() for all the 
instances you have, as the first device will have minor '0', the second 
one '1', etc.

But if you are calling usb_find_interface() for devices that have never 
been registered through usb_register_dev(), then you have a problem, as 
usb_find_interface() will match those unregistered devices (as minor == 0 
in such cases).

This is probably quite rare scenario, and hiddev (which might be the only 
in-kernel driver doing this?) has moved to usb_find_interface() only 
recently.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
