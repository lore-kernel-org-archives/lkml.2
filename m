Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1D0OFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:05:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab1D0OFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:05:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Wed, 27 Apr 2011 16:05:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        m-watkins@ti.com
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201104271516.30951.arnd@arndb.de> <FED5DF6465AF41C58DBD4E0EEB200E60@subhasishg>
In-Reply-To: <FED5DF6465AF41C58DBD4E0EEB200E60@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271605.09537.arnd@arndb.de>
X-Provags-ID: V02:K0:/VsM0ZQxOlG/cmYGfyew0+aQjR+y0ZrFBkfEySZ97Sz
 F8IzLuBGK4e6+Iv6JSokdpGqzFU6mBp81BQHhUw0uGP0AK5vlQ
 GSd2gLSdKvUwi6dYsgTBr8g3aPlUjSRibeaVYYFPXQzK4YUcKv
 cikV7ZuByz5DxTr4/x8OgG9puLHuf5YkYzrnPwZAFOSqY1Hb+9
 iKUtYyDv2RE5Fq8bL3a3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Subhasish Ghosh wrote:
> >
> > If I read your code correctly, you hardwire the usage of the two
> > PRUs in the da850 board code, which makes it impossible to use
> > them in different ways even if the hardware supports it. If this is
> > indeed the case, using an MFD device might not be the best option
> > and we should try to come up with a way to dynamically repurpose
> > the PRU with some user interface.
> 
> SG -- It depends upon how the firmware is implemented. If another
>             firmware is downloaded on it, it will emulate another device.
>             Also, if a firmware emulated on it supports switching between 
> devices,
>             that too is possible. Its just a microcontroller, we can do 
> whatever we feel like
>             with it. Both the PRUs have separate instruction/data ram, so 
> both can be used
>             to implement two different devices.

I see. So the problem that I see with the current code is that you
force the system to provide a set of devices from the MFD, which
then get passed to the individual drivers (uart and can) that load
the firmware they need. Please correct me if I am reading your code
wrong.

What I suggest you do instead is to have the request_firmware
call in the low-level MFD driver, so the user can provide the
firmware that he/she wants to use, and then the MFD driver will
create the devices that match the firmware loaded into the device.

You can easily do that by adding a small header to the firmware
format and interpret that header by the MFD driver. When the name
of the subdevice is part of that header, the MFD driver does not
need to understand the difference, it can simply pass that on
when creating its child devices.

	Arnd
