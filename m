Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0ITWsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:48:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0ITWsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:48:30 -0400
Date: Tue, 21 Sep 2010 00:48:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Andreas Bombe <aeb@debian.org>, Alex Riesen <raa.lkml@gmail.com>,
        Phil Turmel <philip@turmel.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
In-Reply-To: <Pine.LNX.4.44L0.1009201642310.1306-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1009210043460.26813@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1009201642310.1306-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Alan Stern wrote:

> > Thanks Matt and Phill for confirming the line that triggers the oops. As I 
> > am not able to reproduce it myself, it's a bit tricky to track down what 
> > went wrong.
> > 
> > Could you please apply the patch below? It's printing the hid <-> hiddev 
> > <-> usb_interface connections at various stages of probing and open. 
> > Hopefully it'll reveal a little bit what goes wrong and where.
> 
> Jiri:
> 
> There's something very fishy going on here.  Even more so than these 
> bug reports suggest.
> 
> The whole business about hiddev_driver in hiddev.c looks bogus.  It
> doesn't get used for anything and it never binds to an interface.  
> Which means that the usb_find_interface call in hiddev_open should
> never succeed.  At the very least it would need to specify hid_driver
> instead of hiddev_driver.

Yeah. That has been introduced by Arnd while removing BKL, and was bogus. 
It has been fixed by 8fe294caf8c868edd9046251824a0af91991bf43 ("HID: fix 
hiddev's use of usb_find_interface"), which makes it use hid_driver 
(hopefully) correctly.

But since that commit, we are getting NULL pointer dereferences on 
intfdata->hiddev in hiddev_open(). Very likely, it's not fault of that 
commit -- after Arnd's bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a and before 
Guillaume's 8fe294caf8c868edd9046251824a0af91991bf43 we were not hitting 
that codepath at all in fact.

> I have no idea what's really happening.  Can you figure it out?

I am trying, but on my testing systems everything is behaving correctly, 
so it's a bit more difficult. Ideas welcome.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
