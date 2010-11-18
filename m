Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0KRTfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:35:39 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9451 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756162Ab0KRTfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:35:38 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CE58005.7040308@freescale.com>
Date: Thu, 18 Nov 2010 13:35:33 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com> <20101118163321.GA2723@suse.de> <4CE5562B.8080604@freescale.com> <20101118165136.GA3103@suse.de> <4CE55ACB.80207@freescale.com> <20101118171856.GA4283@suse.de> <4CE5647F.5000203@freescale.com> <20101118175832.GA4931@suse.de>
In-Reply-To: <20101118175832.GA4931@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 19:36:36.0545 (UTC) FILETIME=[E9D9A310:01CB8757]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> I just booted a Linux kernel with the driver I just emailed you, and there's no
>> > /dev/serial/ directory.  The only directories under /dev/ are 'shm' and 'pts',
>> > both of which are empty.

> Then plug in a serial port device and see what happens.  You didn't hook
> everything up in your driver correctly it seems, do your devices show up
> under /sys/class/tty?

If I delete the call to device_create() in ehv_bc_init() (so that it creates the
TTY devices only, and not the character devices), I get this:

# ls -l /sys/class/tty/ttyEHV*
lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV0
-> ../../devices/virtual/tty/ttyEHV0
lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV1
-> ../../devices/virtual/tty/ttyEHV1
lrwxrwxrwx    1 root     root            0 Jan  1 00:04 /sys/class/tty/ttyEHV2
-> ../../devices/virtual/tty/ttyEHV2

>> > I'm also running a Fedora 13 x86 system, just to see if I need a full modern OS
>> > to see these files.  Again, there is no /dev/serial/, even though I have serial
>> > ports.
> Dynamic ones like a usb to serial device?

No, not dynamic ones.

>> > Also not that since I'm not registering the byte channels as serial devices, I
>> > wouldn't expect anything in /dev/serial/ to reference them.
>> > 
>> > What does my driver need to do in order for these /dev/xxxx/ entries to contain
>> > that information?

> See the udev rules for details.

udev rules still need some way for the driver to tell user-space that
/dev/ttyEHV0 is associated with byte channel handle 73.  I still don't know what
mechanism my driver is supposed to use to make that information available to
user space.

I could fake it by doing this:

for (i = 0; i < num_byte_channels; i++) {
	bc->handle = get_the_byte_channel_handle(i);
	ehv_bc_driver->name_base = bc->handle - i;
	tty_register_device(ehv_bc_driver, i, NULL);
}

This actually works and does what I want, but I seriously doubt it's acceptable.
 When I do this, I get:

# ls -l /dev/ttyEH*
crw-rw----    1 root     uucp     253,   0 Jan  1 00:00 /dev/ttyEHV73
crw-rw----    1 root     uucp     253,   1 Jan  1 00:00 /dev/ttyEHV76
crw-rw----    1 root     uucp     253,   2 Jan  1 00:00 /dev/ttyEHV79

-- 
Timur Tabi
Linux kernel developer at Freescale

