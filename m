Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab0DKFJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 01:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0DKFJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 01:09:12 -0400
Message-ID: <4BC1596F.2020900@redhat.com>
Date: Sun, 11 Apr 2010 02:09:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Remote Controller subsystem status
References: <E1O0o8u-0007A9-7r@www.linuxtv.org>
In-Reply-To: <E1O0o8u-0007A9-7r@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those that are following the discussions, we're having lots of fun with the
Remote Controller support those days ;)

We're basically re-writing the entire subsystem, that used to be part of V4L/DVB
core and drivers, into a core subsystem that can be used not only by media
drivers, but also for separate Remote Controllers, like those media center
infra red remote controllers. The idea is to also add support to send raw
events to userspace applications like lirc. It started pretending to work
just with Infra Red, but it makes sense to be used also with other type of
transmission media, so Remote Controller is a more general name.

We had some important additions on the kernel drivers those days, and I did
some major changes at the userspace tool that is meant to control the keymap
tables used by Remote Controllers (ir-keytable). I also fixed yesterday two 
kernel bugs at ir-core, that affected the userspace app.

So, both the kernel driver and the userspace tool are in sync. With this, I 
hope we don't need to change anymore any existing sysfs attribute (yet, this 
might happen until kernel 2.6.35, where I expect that those changes will be 
merged). Currently, only ir-keytable uses those sysfs attributes.

The current version of the ir-keytable application is providing full support 
to all features currently exported via sysfs by the remote controller sysfs 
class, at:
	/sys/class/rc

Without any parameter, it lists all Remote Controllers on the machine:

$ ir-keytable 
Found /sys/class/rc/rc0/ (/dev/input/event8) with:
        Driver saa7134, raw software decoder, table rc-avermedia-m135a-rm-jx
        Supported protocols: NEC RC-5   Enabled protocols: RC-5 
Found /sys/class/rc/rc1/ (/dev/input/event9) with:
        Driver em28xx, hardware decoder, table rc-rc5-hauppauge-new
        Supported protocols: NEC RC-5   Current protocols: RC-5 
Found /sys/class/rc/rc2/ (/dev/input/event10) with:
        Driver cx88xx, hardware decoder, table rc-pixelview-mk12
        Supported protocols: other      Current protocols: NEC 

There are parameters for reading the current table, to add another table to the
driver, to clear the drivers table and to change the current protocol (on hardware
decoders) or the enabled protocols (on software decoders).

The most interesting option is "-a" or "--auto-load". It reads a file with rules
that associates a device (by its driver name and by the table name - both info
provided by the kernel driver), with a file with the corresponding keymap.

The idea is to use it to automatically load a table via udev, with a rule like:

ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/local/bin/ir-keytable -v -a /etc/rc_maps.cfg -s $name"

Note: The above rule is not working yet (at least on the very quick test
I did here with udev, just before starting writing this email).
Currently, it is giving this error message:

[16009.232502] ir-keytable[20836]: segfault at 4 ip 08048bb1 sp bf8fb110 error 4 in ir-keytable[8048000+5000]
[16009.242716] Process 20836(ir-keytable) has RLIMIT_CORE set to 0
[16009.248744] Aborting core

I intend to do enable the core dump and do some tests to check why and fix it, but
for sure not today. In fact, it may take some time, since I'm going to travel 
those days to the Collaboration Summit. Maybe I'll find time to fix it only 
after my return. Of course, people are welcome to fix it before ;)

Anyway, with what we currently have, we have both the IR subsystem and the userspace
application in a good shape for testing.

There are still lots of things to do. On a very quick brainstorm, this is a non-exhaustive
lists of tasks for a TODO list:

- Add support for 64 bits scancode tables, using EVIOCGKEYCODEBIG/EVIOCSKEYCODEBIG;
- Port the DVB drivers to IR core;
- Remove ir-common module from V4L drivers (It currently contains only a few decoders - 
  one of them  is pulse-distance - not implemented yet on rc-core);
- Add the full scancodes for all RC tables;
- Fix the script to get the new table formats and locations (better to port DVB drivers first);
- Add lirc_dev;
- Add other IR drivers;
- Rename IR to RC on all files and move the subsystem to a better location (probably, this will be
  the final step);
- Add support for filtering scancode/keycode maps into different event devices;
- Use it with other Remote Controller devices (HID, Bluetooth, radio RC?);
- Cleanups;
- Add more decoders;
- IR blaster/transmitter;
- Merge some keymaps;
  ...

Currently, all kernel patches are at the main development tree for V4L/DVB
(and, as consequence, being exported to linux-next):
	http://git.linuxtv.org/v4l-dvb.git

The userspace application (ir-keycode) is at:
	http://git.linuxtv.org/v4l-utils.git

The make install will install it at the binary dir and copy the keymaps into /etc/rc_keymaps,
together with an automatic mode example file, at /etc/rc_maps.cfg.example.

I keep maintaining an experimental tree for new IR patches under testing at:
	http://git.linuxtv.org/mchehab/ir.git
	(today status: it is in sync with v4l-dvb.git).

Thank you all that are helping to improve it,
Mauro

Mauro Carvalho Chehab wrote:

> Subject: keytable: Add an example for rc_maps.cfg
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Sun Apr 11 00:58:13 2010 -0300
> 
> 
>  utils/keytable/rc_maps.cfg.example |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)




> 
> ---
> 
> http://git.linuxtv.org/v4l-utils.git?a=commitdiff;h=82b1322de3964390657289116dc08fe4a714f085
> 
> diff --git a/utils/keytable/rc_maps.cfg.example b/utils/keytable/rc_maps.cfg.example
> new file mode 100644
> index 0000000..bfbae52
> --- /dev/null
> +++ b/utils/keytable/rc_maps.cfg.example
> @@ -0,0 +1,27 @@
> +#
> +# Keymaps table
> +#
> +# This table creates an association between a keycode file and a kernel
> +# driver. It can be used to automatically override a keycode definition.
> +#
> +# Although not yet tested, it is mented to be added at udev.
> +#
> +# To use, you just need to run:
> +#	./ir-keytable -a
> +#
> +# Or, if the remote is not the first device:
> +#	./ir-keytable -a -s rc1		# for RC at rc1
> +#
> +
> +# Format:
> +#	driver - name of the driver provided via uevent - use * for any driver
> +#	table -  RC keymap table, provided via uevent - use * for any table
> +#	file - file name. If directory is not specified, it will default to
> +#		/etc/rc_keymaps.
> +
> +#driver	table				file
> +cx8800	*				./keycodes/rc5_hauppauge_new
> +*	rc-avermedia-m135a-rm-jx	./keycodes/kworld_315u
> +saa7134	rc-avermedia-m135a-rm-jx	./keycodes/keycodes/nec_terratec_cinergy_xs
> +em28xx	*				./keycodes/kworld_315u
> +*	*				./keycodes/rc5_hauppauge_new
> 
