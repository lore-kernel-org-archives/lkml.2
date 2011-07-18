Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1GRW3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:29:14 -0400
Received: from ppp118-208-7-216.lns20.bne1.internode.on.net ([118.208.7.216]:45360
	"EHLO mail.psychogeeks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab1GRW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:29:13 -0400
Message-ID: <4E24B3B5.5080200@psychogeeks.com>
Date: Tue, 19 Jul 2011 08:29:09 +1000
From: Chris W <lkml@psychogeeks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110620 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] imon: don't submit urb before rc_dev set up
References: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com> <1311007609-28210-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1311007609-28210-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/11 02:46, Jarod Wilson wrote:
> The interface 0 urb callback was being wired up before the rc_dev device
> was allocated, meaning the callback could be called with a null rc_dev,
> leading to an oops. This likely only ever happens on the older 0xffdc
> SoundGraph devices, which continually trigger interrupts even when they
> have no valid keydata, and the window in which it could happen is small,
> but its actually happening regularly for at least one user, and its an
> obvious fix. Compile and sanity-tested with one of my own imon devices.

As the "at least one user" I can confirm that the patch has indeed
corrected the problem on my 2.6.38-gentoo-r6, 2.6.39.3 vanilla, and
3.0.0-rc7 kernels.

This is what loading the module with the "debug=1" option outputs:

input: iMON Panel, Knob and Mouse(15c2:ffdc) as
/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input7
imon 4-2:1.0: Unknown 0xffdc device, defaulting to VFD and iMON IR (id 0x00)
Registered IR keymap rc-imon-pad
input: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc2/input8
rc2: iMON Remote (15c2:ffdc) as
/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc2
imon 4-2:1.0: iMON device (15c2:ffdc, intf0) on usb<4:3> initialized
usbcore: registered new interface driver imon
intf0 decoded packet: 00 00 00 00 00 00 24 01
intf0 decoded packet: 00 00 00 00 00 00 24 01
intf0 decoded packet: 00 00 00 00 00 00 24 01
intf0 decoded packet: 00 00 00 00 00 00 24 01
...

The decoded packet lines are fast and furious with no deliberate IR
input (the VFD is in use), which might explain how this device managed
to break the code in the small window available.

Thank you Jarod and Andy for taking the time to track this problem down
to give it a drubbing.

Regards,
Chris

-- 
Chris Williams
Brisbane, Australia
