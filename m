Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0GMRNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:13:14 -0400
Received: from ns.penguin.cz ([84.21.108.25]:45065 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab0GMRNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:13:13 -0400
X-Greylist: delayed 1553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 13:13:12 EDT
Subject: Re: usb gadget on zaurus and kexec
From: Stanislav Brabec <utx@penguin.cz>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
        arminlitzel@web.de, kernel list <linux-kernel@vger.kernel.org>,
        lenz@cs.wisc.edu, rpurdie@rpsys.net, pave@ucw.cz,
        thommycheck@gmail.com, zaurus-devel@www.linuxtogo.org,
        omegamoon@gmail.com
In-Reply-To: <20100713112649.GA17065@atrey.karlin.mff.cuni.cz>
References: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz>
	 <AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com>
	 <AANLkTilCvgvf9Ch55f878nTNTue8tHYmcrLEywsjnylY@mail.gmail.com>
	 <201006100900.23981.marek.vasut@gmail.com> <87wru7xc4z.fsf@free.fr>
	 <20100713112649.GA17065@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Tue, 13 Jul 2010 18:47:06 +0200
Message-ID: <1279039626.9908.50.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Hrubis wrote:

> Would be great. So far the GPIO for usb host/slave cable detection is not used
> on spitz so there is no way to switch to USB slave for gadgets to work if you
> don't want to play with devmem2.

Well, just the driver is missing, the hardware is there. See attached
usb-auto script using pxaregs utility.

There is another issue in the gadget mode (probably including the latest
kernels): If host mode is not active, it should turn USB power off. It
does not, and it causes soft short circuit in client mode. It also makes
impossible to differentiate between no cable and client cable.

Here are GPIOs to control OTG:
SPITZ_GPIO_USB_DEVICE	GPIO35	USB Client power is present
SPITZ_GPIO_USB_HOST	GPIO37	USB OTG 5V Host power supply control
SPITZ_GPIO_USB_CONNECT	GPIO41	USB Host Cable is connected

----------- usb-auto ----------
#!/bin/sh

if test -z "$CLIENT_MODULE" ; then
# Uncomment client module you want by default (only one at a time is possible in 2.6.26RP):
	CLIENT_MODULE=g_ether
	#CLIENT_MODULE=g_file_storage
fi

if test `pxaregs GPLR1_41 | sed -n 's/.*\(.\)  GPIO.*/\1/p'` = 0 ; then
	echo "Host cable is present."
	pxaregs GPSR1_37 1 # Turn on USB power
	rmmod g_file_storage g_ether pxa27x_udc 2>/dev/null
	sleep 1
	modprobe ohci-hcd 2>/dev/null
else
	pxaregs GPCR1_37 1 # Turn off USB power
	sleep 1 # Wait a bit to discharge capacitors
	if test `pxaregs GPLR1_35 | sed -n 's/.*\(.\)  GPIO.*/\1/p'` = 0 ; then
		echo "No cable in USB."
		ifdown usb0 2>/dev/null
		sleep 1
		rmmod g_file_storage g_ether pxa27x_udc 2>/dev/null
		sleep 1
		rmmod ohci-hcd 2>/dev/null
	else
		echo "Client cable is present."
		rmmod ohci-hcd 2>/dev/null
		sleep 1
		modprobe pxa27x_udc
		modprobe $CLIENT_MODULE
		ifup usb0 2>/dev/null
	fi
fi
-------------------------------

-- 
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

