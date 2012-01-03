Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2ACCqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 21:46:03 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36667 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751019Ab2ACCp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 21:45:59 -0500
Date: Mon, 2 Jan 2012 21:45:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Stone <jwjstone@fastmail.fm>, Oliver Neukum <oliver@neukum.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <20120102215028.GA15701@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1201022136190.20386-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jan 2012, Matthew Garrett wrote:

> It's not theoretical hardware. This appears to be the current behaviour 
> of the isight devices. If you reboot they retain their firmware. If you 
> suspend, they don't. So if we have a flow like this:
> 
> 1) user boots from cold. Device comes up with generic USB ID.
> 2) isight_firmware loads and binds. Firmware is loaded. Device 
> disconnects and reconnects with an ID that's bound by the UVC driver.
> 3) user reboots. Device comes up with UVC ID. isight_firmware doesn't 
> bind.
> 4) user suspends.
> 5) user resumes. isight_firmware binds and attempts to load firmware.

Wait a second.  Why does isight_firmware bind at this time?  Binding to
new devices is handled by khubd, which doesn't start running again
until after the resume is finished (the device appears to be new
because its descriptors have changed).  At that point there should be
no trouble reloading the firmware.

> then just caching the firmware is inadequate - we had never previously 
> seen the device on this boot, so we've never loaded it in order to cache 
> it. isight_firmware could unconditionally load the firmware on module 
> load just in case a device is plugged in, but that seems even less 
> elegant than caching it.
> 
> Now this is obviously somewhat mitigated because isight_firmware won't 
> have been autoloaded at (3), so won't be there at (5) unless the user's 
> manually loaded it. But insmodding a driver shouldn't result in stuff 
> breaking later.

I don't see how this matters very much.  Certainly not enough to
justify all the effort put into this email thread already.

Regardless of what isight_firmware does, the original UVC device 
instance is gone.  The new device instance won't appear until the khubd 
thread starts running again, after the resume is finished.  As far as 
userspace is concerned, that's all that matters.

Even in situations where isight_firmware does somehow manage to bind
during resume, the only question is how it can avoid hanging or
delaying the resume procedure.  Doing an async firmware load will solve
that.

Alan Stern

