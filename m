Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2ABVuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:50:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44165 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2ABVui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:50:38 -0500
Date: Mon, 2 Jan 2012 21:50:28 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120102215028.GA15701@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm>
 <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org>
 <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 01:27:03PM -0800, Linus Torvalds wrote:

> If we didn't load the firmware before the suspend, then the resume
> function of a device sure as hell had better not load it at resume
> time either.

If the hardware has lost its state then refusing to load the firmware at 
resume time isn't going to leave you with a working device.

> And for chrissake, don't bother making it more complicated than it is,
> just for some theoretical hardware or situation that nobody cares
> about.

It's not theoretical hardware. This appears to be the current behaviour 
of the isight devices. If you reboot they retain their firmware. If you 
suspend, they don't. So if we have a flow like this:

1) user boots from cold. Device comes up with generic USB ID.
2) isight_firmware loads and binds. Firmware is loaded. Device 
disconnects and reconnects with an ID that's bound by the UVC driver.
3) user reboots. Device comes up with UVC ID. isight_firmware doesn't 
bind.
4) user suspends.
5) user resumes. isight_firmware binds and attempts to load firmware.

then just caching the firmware is inadequate - we had never previously 
seen the device on this boot, so we've never loaded it in order to cache 
it. isight_firmware could unconditionally load the firmware on module 
load just in case a device is plugged in, but that seems even less 
elegant than caching it.

Now this is obviously somewhat mitigated because isight_firmware won't 
have been autoloaded at (3), so won't be there at (5) unless the user's 
manually loaded it. But insmodding a driver shouldn't result in stuff 
breaking later.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
