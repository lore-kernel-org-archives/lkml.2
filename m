Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1CKPWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:22:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab1CKPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:22:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <roger.quadros@nokia.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 11 Mar 2011 16:22:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, ext Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4D79F068.2080009@linaro.org> <4D7A191B.7040100@linaro.org> <4D7A34F1.7070601@nokia.com>
In-Reply-To: <4D7A34F1.7070601@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111622.10722.arnd@arndb.de>
X-Provags-ID: V02:K0:sd0YUulkjm4TtfFzqkoZeUFnDHlmzZGI+itXT1UB1WO
 s5o9/7EKnhqxW18AyCDnj4TjXdAqeZGE43mX9XsUIQNXGTOsBD
 5veWBJFReSd0yxWaET5ZajGehqJFgowCW/OQzJhCu391kQ6B54
 dTNssG0772W0/Q2vWaRqfmFf0xM/Roylvi0TsGQN5v9vMSVypJ
 wOw4Q/+gT5fadVWAjTmZQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Roger Quadros wrote:
> > There is no reason I can see that onboard USB assets should continue to
> > be treated differently to miss out on the same capability because they
> > are USB and not I2C, particularly as a permanently NULL platform_data
> > pointer is already sitting there in the usb_device's .dev already
> > exactly for this use.
> 
> What do you want to set in platform data? the ethernet device name? 
> Isn't that better done in user space using udev rules?

A udev rule would solve the problem at hand, but I'd consider that
an ugly workaround as well. The naming in the kernel is really
bogus -- any USB device that has a fixed address gets treated
as eth0, while others become usb0, with the same driver,
see the code fragment below.

A lot of things depend on ethernet device naming, which you
may consider to be broken, but it won't change any time soon.
Changing all of them to be named eth%d would of course break
other tools, so that is not an option either.

The most simple way to solve this particular problem is to
remove the check for "net->dev_addr [0] & 0x02", which only
has any effect on the smsc75xx and smsc95xx drivers, both of
which are for real ethernet devices, not point-to-point
USB links.

That would however still leave the problem of the missing
mac address, which is not good if you want to work with the
system using dhcp.

	Arnd
---
        strcpy (net->name, "usb%d");
                // heuristic:  "usb%d" for links we know are two-host,
                // else "eth%d" when there's reasonable doubt.  userspace
                // can rename the link if it knows better.
                if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
                    (net->dev_addr [0] & 0x02) == 0)
                        strcpy (net->name, "eth%d");
                /* WLAN devices should always be named "wlan%d" */
                if ((dev->driver_info->flags & FLAG_WLAN) != 0)
                        strcpy(net->name, "wlan%d");
                /* WWAN devices should always be named "wwan%d" */
                if ((dev->driver_info->flags & FLAG_WWAN) != 0)
                        strcpy(net->name, "wwan%d");
