Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab1CDMS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:18:59 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:35903 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab1CDMS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:18:57 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 4 Mar 2011 13:16:55 +0100
To: Dudley Du <dudl@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "olofj@google.com" <olofj@google.com>,
        "micahc@google.com" <micahc@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Solda (David.Solda@cypress.com)" <David.Solda@cypress.com>
Subject: Re: [PATCH] mouse: Add new i2c-based input mouse driver into input
 subsystem for Cypress i2c trackpad devices.
Message-ID: <20110304121655.GA2670@polaris.bitmath.org>
References: <B27AC323FA92C946BA36D2913DDC8E3701FD6F0B1A3B@VMBX126.ihostexchange.net>
 <20110304090450.GB4323@core.coreip.homeip.net>
 <B27AC323FA92C946BA36D2913DDC8E3701FD6F0B1A51@VMBX126.ihostexchange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B27AC323FA92C946BA36D2913DDC8E3701FD6F0B1A51@VMBX126.ihostexchange.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PvTu0-0000ad-9n.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PvTu0-0000ad-9n d71f6a606bca4712f994160d97e54df8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

to continue Dmitry's questioning, please find comments inline.

> This new driver belongs to Input device Driver, it locates in the layer under Input Core,
> It communicates directly to Cypress I2C trackpad hardware device.
> Cypress I2C trackpad hardware device is a multi-touch device, it uses i2c interface to communicate with host.
> This device can detect one finger movement, can detect multi-finger movements,
> Also it can recognize and report multi-finger movements as predefined gestures.
> So using these trackpad devices, all gesture detect are done in trackpad device, not in driver or upper layers.

This is normally the case for devices conforming to other operating
systems. However, the device-specific gestures are not used in the
linux MT drivers; instead the raw contact data is sent to userspace,
for further processing.

> 
> In brief, the basic functions of this i2c-based input mouse driver are list as bellow:
> 1. connect this driver into i2c subsystem and input subsystem;
>    Because Cypress trackpad devices use i2c interfaces to connect and communicate with host.
> 2. communicate with Cypress trackpad devices to read raw data of fingers movement and detected gestures;
> 3. parse received raw data from trackpad devices into system recognizes data;
> 4. report received finger movement data into input subsystem as cursor movement.
> 5. convert received finger gestures into keyboard press/release, mouse press/release and wheel operations,
>    then report the gestures by reporting combined keyboard press/release, mouse press/release and wheel operations into Input subsystem;
>    that's why there will be virtual keyboard, virtual wheel handling, etc in this driver.
> 6. Do cursor performance filter to improve cursor movement performance;
>    e.g.: make cursor movement much more smooth; improve cursor moving linearity and so on.
> 7. Do gesture performance filter to improve gesture performance;
>    e.g.: when do two fingers vertical scroll operation on a web page, make the web page be scrolled much more smooth,
>          and apply acceleration on the scroll to make low finger movement corresponding to low scrolling,
>          fast finger movement corresponding to fast scrolling and can be enlarged to fit user's sense.
> 8. report data to input subsystem.

Apart from simplicity (which is reason enough), the major reason not
to do gesture handling in the driver is duplication of efforts. Please
simplify the driver to an absolute minimum before submitting for
review.

> Bellow tries to answer the questions in the mail:
> 1. Why there are amount of code to reinterpret data from device and convert to gestures in this driver?
>   1) Trackpad devices use I2C interface to report data through I2C registers. These I2C registers are defined and organized by Cypress,
>      so input subsystem and other trackpad device drivers can't read and recognize the meanings of this registers directly.
>   2) also there are 2 released registers map spec that used in trackpad devices.
>      So there will be two cluster code named gen1 and gen2 to reinterpret data from device.
>   3) also fingers gestures are detected in trackpad device, and the gestures are reported as gesture IDs,
>      These gesture IDs are all defined and only meaningfully to Cypress trackpad devices.
>      That means these gesture IDs can't be recognized by input subsystem and other drivers,
>      So this driver is required to reinterpret the gesture data from device, and cannot do this in user space.

The simple solution is to not report the special gesture data at all,
just raw contact data.

> 2. Why give a choice between relative mode and absolute mode to report data?
>   It's sure that absolute mode can supply more interface to report multi-class data and also provide more data for gesture processing.
>   Currently as we know, with absolute mode, Input subsystem requires trackpad device to report absolute X and Y position data directly,
>   then Input system transfers these data to mousedev driver, and mousedev driver calculates based on this absolute X and Y position data
>   and convert them into X delta and Y delta data. In this processing, mousedev doesn't apply any cursor acceleration function to cursor movement
>   when convert into X delta and Y delta data, so cursor movement shown in screen has no acceleration.
>   That means when fast move finger in trackpad, the cursor movement in screen can't be enlarged just as we use USB mouse device.
>   And in absolute mode, we are unable to add cursor acceleration function to absolution X and Y data.
>   So in order to add cursor acceleration function to cursor movement, we added relative mode also be supported.
>   Because in relative mode, trackpad devices report relative delta data, and based on this relative delta data,
>   driver can apply cursor performance filter to this data, so cursor acceleration function can also be applied in relative mode.

The cursor is a different entity from the touch, and although the
cursor may employ acceleration, the touch on a touchpad cannot; it
stays where it is.

> 3. Why add polling mode supported in this driver?
>   Besides I2C bus hardware pins of VDD, Gound, SDA and SDL, Trackpad device also requires an extended GPIO pin to assert interrupts to host.
>   But for some host devices, there is no extended GPIO pin reserved for this slave interrupt pin (SINT),
>   So for these devices, interrupts from trackpad devices can't be supported, and only polling mode can be used.
>   That's why we add polling mode in this driver, it provides compatible to those device that without extended GPIO pin supported.

An example of a hardware without interrupt support would be appreciated.

Thanks,
Henrik
