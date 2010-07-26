Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0GZWPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:15:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:58652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab0GZWPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:15:43 -0400
Date: Mon, 26 Jul 2010 15:14:43 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, pavan_savoy@sify.com
Subject: Re: [PATCH] RFC: drivers:staging:ti-st: netlink for kim/uim
Message-ID: <20100726221443.GA9916@suse.de>
References: <1280148469-14886-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280148469-14886-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 07:47:49AM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Greg, Alan,
> 
> (please do not merge
> &
> long mail warning, please have a look..)
> 
> I hope the driver is close to being good enough to be moved out of
> staging, as one of the last major TODOs which was multiple device
> support is being handled here.

Well, there are other things that need to be resolved before the code is
moved:
	- document the sysfs attributes
	- move most of the current sysfs attributes to debugfs


> However, please comment as to how desperately is this required to get
> this out of staging, the reason is mentioned below..

It's a big deal for you to have to do.

> The per-device context to driver is already provided however, there is
> this small catch in support for multiple devices.
> The kernel space needs to communicate to user-space about the device
> which needs to be used.
> say:-
> 	ST_O platform device is on ttyS0
> 	ST_1 platform device is on ttyS1
> and
> 	ST_2 platform device is on ttySPI0
> 
> each protocol drivers such as BT, FM would be only able to tell which
> platform device they want to bind to, but that device needs to be
> opened/ldisc installtion needs to happen from user-space/UIM.
> 
> background :-
> UIM is the user-space initialization manager for the TI WL7 chipsets
> which is responsible for :-
> 	* opening the tty ONLY when absolutely necessary
> 	* set the baud-rate agreed upon between BT, FM and GPS
> 	(usually the max baud-rate)
> 	* installing/tiocsetd the N_TI_WL ldisc
> 	* un-installing ldisc
> 	* closing the device when not being used.
> 
> KIM is the kernel-space initialization manager for the TI WL7 chipsets
> which is responsible for :-
> 	* enabling the chip-enable GPIO
> 	* communicate to UIM that the tty needs to be used
> 	(it gets to know via the one of the BT/FM/GPS drivers..)
> 	* wait for UIM to install ldisc
> 	* download firmware once tty context is available
> 	* communicate to UIM about the releasing the tty when no-one's
> 	using (again when protos_registered becomes 0)
> 	* disable the chip enable GPIO.
> 
> So, as of now these were being interfaced earlier over /sys/uim/pid and
> signal mechanism, which was then changed to /dev/rfkill and
> rfkill_events over it.

Yes, much better.

> However,
> Since with multiple device support is required the KIM somehow needs to
> inform the UIM to open a particular tty interface - by sending an id or
> the exact device name itself, this is what this patch does.

Why can't you just select the specific rfkill device through that api?

And if it can't select the individual devices, fix that.

Don't create arbitrary netlink interfaces that aren't documented
anywhere please.

thanks,

greg k-h
