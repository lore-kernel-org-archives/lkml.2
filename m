Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2BTKCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:02:05 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3211 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab2BTKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:02:03 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4F421A0E.8030805@broadcom.com>
Date: Mon, 20 Feb 2012 11:01:50 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: will these methods work with firmware loading?
References: <4F414230.5040506@lwfinger.net>
In-Reply-To: <4F414230.5040506@lwfinger.net>
X-WSS-ID: 635CC3CB3GG30074689-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 07:40 PM, Larry Finger wrote:
> I sent a previous messages to most of these lists, but got no answer, thus a
> second try.
>
> When a driver loads firmware synchronously in the module_init() path using
> request_firmware(), then there is trouble with timeouts when booting.
>
> I know that changing the request_firmware() call to request_firmware_nowait()
> solves the problem; however, that gives some trouble for driver b43legacy as it
> loads 3 or 4 firmware files depending on the hardware version. When I launch the
> 3 or 4 nowait requests, I get an error because the system is trying to start
> several tasks with the same name.

Yep, the nowait api just kicks off a kernel thread for the firmware request.

> Would it be OK to load the first file with the nowait version, and issue a
> request_firmware() for the others from the callback routine? I think that would
> not cause any problems, but I would like to get confirmation from an expert.

No expert, but that is what I did although the chaining of firmware 
requests does not feel great. Especially for handling error flows. 
Johannes Berg and Kay Sievers mentioned need to unbind/rebind the driver 
upon failed firmware load, but I don't like the idea of building a 
timer-controlled retry mechanism.

> Similarly, if I were to create a work queue, init and schedule it from
> module_init(), and then use synchronous loads to get the firmware from the work
> queue callback, would that get around the boot problem? I know it works as I
> have trial patches; however, my version of udev is not one affected. This method
> is very easy to implement, but again I would like confirmation from an expert.

What boot problem are you referring to? The blocking modprobe? For that 
problem I would say yes. Also here the problem of handling error flows 
exist. If the driver is kicked of during boot with a initramfs missing 
the firmware, should we retry until the real root is mounted?

Gr. AvS

