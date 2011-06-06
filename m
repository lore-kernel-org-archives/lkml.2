Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1FFRvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:51:12 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:36095 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab1FFRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:51:08 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.134
X-Originating-IP: 94.192.232.89
Subject: Re: Reporting screen/laptop orientation data to userspace
From: Bastien Nocera <hadess@hadess.net>
To: Alberto Mardegan <mardy@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, "Javier S. Pedro" <maemo@javispedro.com>,
        linux-input@vger.kernel.org
Date: Mon, 06 Jun 2011 18:50:36 +0100
In-Reply-To: <4DEC796E.1050307@users.sourceforge.net>
References: <4DE1FA7F.3050308@users.sourceforge.net>
	 <1307116529.2669.130.camel@novo.hadess.net>
	 <4DEC796E.1050307@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307382639.2669.147.camel@novo.hadess.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 09:53 +0300, Alberto Mardegan wrote:
> On 06/03/2011 06:55 PM, Bastien Nocera wrote:
> > Do you also have a discrete accelerometer with that? Or you only ever
> > get notification through there?
> 
> There's a discrete accelerometer, but I suspect that it might be hard for its 
> driver to get accepted into the mainline kernel, since it's directly playing 
> with the EC I/O ports. It's this one:
> 
> https://gitorious.org/iaps/iaps/blobs/master/iaps.c
> 
> The coarse data OTOH comes via a clean WMI interface.

OK.

> > If there is a discrete accelerometer, I'd drop the extra metadata, and
> > send an event through udev, and expect user-space to read from the
> > accelerometer instead.
> 
> You mean, send an event through udev when the WMI interface reports that the 
> orientation has changed, and then expect the userspace to read the values from 
> the accelerometer?
> IMHO, reporting an event with no context data, it's inefficient and ugly 
> (because it forces the userspace to perform additional acctions in order to get 
> the data).

You'll always need to have something in user-space reading the data from
your device, somehow, kernel events don't carry any data, it just says
"foo has changed". Up to the udev rules, and user-space to check up on
it.

> > If there isn't a discrete accelerometer, create a fake one, with some
> > hardcoded data based on the actual orientation of the device.
> 
> This could be a solution in both cases (i.e., even if a discrete accelerometer 
> is available). But it would be nice to have some flags on the input device which 
> tell that this accelerometer is not as precise as one could desire. Is there 
> such a thing?
> 
> > The accelerometer (whether real or fake) should show 3 axis (X/Y/Z).
> >
> > As soon as it's seen some testing, I'll be showing the work I did for
> > GNOME support for automatic rotation based on orientation.
> 
> Do you support choosing the accelerometer device to be used?

Nope. There's usually none, or just the one (and its children).

> The device that I wanted to create is actually something much simpler than an 
> accelerometer; it would just report screen orientation. I believe that some 
> computer screens might have something similar, detecting the screen orientation 
> based on the angle formed between the screen base (or wall mount) and the screen 
> panel... I would assume that if such information exists, this Lenovo Ideapad 
> screen orientation should be reported in a similar way.

Comparing it to the orientation mechanism used in some screens is a
great disservice here. There's no agreed-upon way of receiving events
about it, or how to read the current orientation. It's currently all
per-vendor undocumented gunk (topic came up recently on IRC, and the X
hackers skimmed through the interwebs to find information, there's
none).

This is the latest work I've done[1]:
http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=24569e24dc94a7cffb8031eb0055e8d06cbdcb72

So to support the IdeaPad, I would:
- make it export the orientation of the device in sysfs (kernel-side)
- add a rule in udev to tag that particular device with
ID_INPUT_ACCELEROMETER=1
- add a simple helper (or tweak the accelerometer one in udev) to export
the current orientation through ID_INPUT_ACCELEROMETER_ORIENTATION
- Profit

The only thing I might need to change in gnome-settings-daemon (which
just listens for events, reads the orientation, and changes the XRandR
orientation) is the subsystem used, if your device isn't in the input
subsystem.

The GNOME code lives at:
http://git.gnome.org/browse/gnome-settings-daemon/tree/plugins/orientation

Cheers

[1]: The commit message is missing, here it is:
---8<---
When an "change" event is received on an accelerometer,
open its device node, and from the value, as well as the previous
value of the property, calculate the device's new orientation,
and export it as ID_INPUT_ACCELEROMETER_ORIENTATION.
    
Possible values are:
* undefined
* normal
* bottom-up
* left-up
* right-up
    
Using a udev property means that the property is persistent across
sessions, and that new orientations can be deducted from the previous
one (it allows for a threshold for switching between opposite ends
of the orientation).
    
This system should also be extensible to devices where the accelerometer
is not available to the system (no drivers), but new orientations are
advertised through ACPI events.
---8<---

