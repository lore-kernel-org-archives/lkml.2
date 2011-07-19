Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1GSMX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 08:23:27 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:43450 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1GSMX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 08:23:26 -0400
Subject: Re: [PATCH] [media] imon: don't submit urb before rc_dev set up
References: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com> <1311007609-28210-1-git-send-email-jarod@redhat.com> <4E24B3B5.5080200@psychogeeks.com>
Content-Transfer-Encoding: 8BIT
From: Jarod Wilson <jwilson@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
In-Reply-To: <4E24B3B5.5080200@psychogeeks.com>
Message-Id: <D7E52A85-331A-4650-94F0-C1477F457457@redhat.com>
Date: Tue, 19 Jul 2011 08:23:19 -0400 (EDT)
To: Chris W <lkml@psychogeeks.com>
Cc: Jarod Wilson <jarod@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: Zimbra 6.0.9_GA_2686 (MobileSync - Apple-iPhone3C1/810.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 18, 2011, at 6:29 PM, Chris W <lkml@psychogeeks.com> wrote:

> On 19/07/11 02:46, Jarod Wilson wrote:
>> The interface 0 urb callback was being wired up before the rc_dev device
>> was allocated, meaning the callback could be called with a null rc_dev,
>> leading to an oops. This likely only ever happens on the older 0xffdc
>> SoundGraph devices, which continually trigger interrupts even when they
>> have no valid keydata, and the window in which it could happen is small,
>> but its actually happening regularly for at least one user, and its an
>> obvious fix. Compile and sanity-tested with one of my own imon devices.
> 
> As the "at least one user" I can confirm that the patch has indeed
> corrected the problem on my 2.6.38-gentoo-r6, 2.6.39.3 vanilla, and
> 3.0.0-rc7 kernels.
> 
> This is what loading the module with the "debug=1" option outputs:
> 
> input: iMON Panel, Knob and Mouse(15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input7
> imon 4-2:1.0: Unknown 0xffdc device, defaulting to VFD and iMON IR (id 0x00)

Ugh, damn, that change broke the ffdc device auto-detection... Better than a crash, but lemme see if I can alter things slightly so we can have our cake and eat it too...


> Registered IR keymap rc-imon-pad
> input: iMON Remote (15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc2/input8
> rc2: iMON Remote (15c2:ffdc) as
> /devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/rc/rc2
> imon 4-2:1.0: iMON device (15c2:ffdc, intf0) on usb<4:3> initialized
> usbcore: registered new interface driver imon
> intf0 decoded packet: 00 00 00 00 00 00 24 01
> intf0 decoded packet: 00 00 00 00 00 00 24 01
> intf0 decoded packet: 00 00 00 00 00 00 24 01
> intf0 decoded packet: 00 00 00 00 00 00 24 01
> ...
> 
> The decoded packet lines are fast and furious with no deliberate IR
> input (the VFD is in use), which might explain how this device managed
> to break the code in the small window available.

Yep. I hate hate hate hate the ffdc imon hardware, for this and multiple other reasons (including the nasty hack used for ffdc device type auto-detection)... My ffdc devices do similar constant spewing, but never triggered the oops, so maybe yours is even worse, or your system is faster, or a kernel config change made a difference here...


> Thank you Jarod and Andy for taking the time to track this problem down
> to give it a drubbing.

Thanks for the testing and patience, hopefully just one more patch to test out before we can say case closed here...

--jarod
