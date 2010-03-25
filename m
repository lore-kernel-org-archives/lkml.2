Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0CYOnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0CYOnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:43:11 -0400
Message-ID: <4BAB7659.1040408@redhat.com>
Date: Thu, 25 Mar 2010 11:42:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>	 <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz>	 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>	 <20091215201933.GK24406@elf.ucw.cz>	 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>	 <20091215203300.GL24406@elf.ucw.cz>	 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com> <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
In-Reply-To: <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got some progress about the IR redesign.

I didn't followed the exact order of the tasks, but I think I've reached an interesting
point where it is now possible to merge lirc_dev driver and to add the decoders to ir-core.

I've setup an experimental tree with upstream+V4L/DVB development and some patches
I did for IR. The RFC patches are available at:

	http://git.linuxtv.org/mchehab/ir.git

This were the original plan we've discussed, back in December:

> On Tue, Dec 15, 2009 at 8:33 AM, Mauro Carvalho Chehab
>
>        1) Port DVB drivers to use ir-core, removing the duplicated (and incomplete
>          - as table size can't change on DVB's implementation) code that exists there;

Pending.

>
>        2) add current_protocol support on other drivers;

Done. Patch were already merged upstream.

The current_protocol attribute shows the protocol(s) that the device is accepting
and allows changing it to another protocol. 

In the case of the em28xx hardware, only one protocol can be active, since the decoder
is inside the hardware. 

On the raw IR decode implementation I've done at the saa7134, all raw pulse events are
sent to all registered decoders, so I'm thinking on using this sysfs node to allow
disabling the standard behavior of passing the IR codes to all decoders, routing it
to just one decoder.

Another alternative would be to show current_protocol only for devices with hardware
decoder, and create one sysfs node for each decoder, allowing enabling/disabling each
decoder individually.

Comments?

>
>        3) link the corresponding input/evdev interfaces with /sys/class/irrcv/irrcv*;

Done. Input devices are created as part of irrcv class.

They basically create one IR class device for each IR driver. For example, my test machine
has one saa7134 and one em28xx device, each with a different IR:

$ tree /sys/class/irrcv/
/sys/class/irrcv/
|-- irrcv0 -> ../../devices/pci0000:00/0000:00:10.0/0000:04:08.0/irrcv/irrcv0
`-- irrcv1 -> ../../devices/pci0000:00/0000:00:0b.1/usb1/1-3/irrcv/irrcv1

$ ls /sys/class/irrcv/irrcv0/ /sys/class/irrcv/irrcv1/
/sys/class/irrcv/irrcv0/:
current_protocol  device  input34  power  subsystem  uevent

/sys/class/irrcv/irrcv1/:
current_protocol  device  input35  power  subsystem  uevent

>
>        4) make the keytable.c application aware of the sysfs vars;

Almost done. The application were re-designed, but it still needs to handle
the current_protocol. It is easy, but I want to work more at the raw decoders
before adding it to the application.

The new ir-keycode program that allows replacing the scancode/keycode table is now at:
	http://git.linuxtv.org/v4l-utils.git

under utils/keycode dir. Replacing a table at irrcv0
is as simple as doing:
	./ir-keytable -c -w keycodes/avermedia_m135a

If you just want to add another table, just remove the "-c" from the above line command.

>
>        5) add an attribute to uniquely identify a remote controller;

Done. The uevent has the driver name and the IR name:

$ cat /sys/class/irrcv/irrcv0/uevent 
NAME="aver-m135a-RM-JX"
DRV_NAME="saa7134"

The idea is to use those identifiers to allow replacing the IR table.

>        6) write or convert an existing application to load IR tables at runtime;

Pending.
>
>        7) get the complete 16-bit scancodes used by V4L drivers;

This is a long time task. A few maps got converted already.
>
>        8) add decoder/lirc_dev glue to ir-core;

Done. Each decoder is a module that registers into ir-core. The core will call all
registered decoders (or lirc_dev) when a raw input event occurs. 

Adding a new decoder or lirc_dev is very simple.

For example, to add lirc_dev, all that is needed, from ir-core POV, is:

1) add a code like this at ir-core.h:

/* from lirc-dev.c */
#ifdef CONFIG_IR_LIRC_DEV
#define load_lirc_dev()      request_module("lirc-dev")
#else
#define load_lirc_dev()      0
#endif

2) Add a call to load_lirc_dev() function at init_decoders(), on ir-raw-event.c,
in order to allow it to be automatically loaded by ir-core.

3) at the lirc-dev.c code, add:

static int lirc_decode(struct input_dev *input_dev,
                       struct ir_raw_event *evs, int len)
{
	/* Lirc code to output data */
}

static struct ir_raw_handler lirc_handler = {
       .decode = lirc_decode,
};

static int __init lirc_init(void)
{
       ir_raw_handler_register(&lirc_handler);
       return 0;
}

static void __exit lirc_exit(void)
{
       ir_raw_handler_unregister(&lirc_handler);
}

With this glue, when ir-core is loaded, it will automatically load
lirc_dev (if compiled).

For sure, a few more callbacks will be needed for lirc to create/delete
the raw interfaces. I'll be adding register/unregister callbacks
that will allow this usage, and also the creation of per-protocol sysfs 
attributes that may need for example to adjust IR timings.

>
>        9) add lirc_dev module and in-kernel decoders;

Partially done. I've implemented one decoder for the NEC protocol as an example, 
and made it working with one of my saa7134 devices.

Some adjustments may be needed for lirc_dev.

>
>        10) extend keycode table replacement to support big/variable sized scancodes;

Pending.

The current limit here is the scancode ioctl's are defined as:

#define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
#define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */

As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
with a keycode, there's not enough bits there for IR.

The better approach seems to create an struct with an arbitrary long size, like:

struct keycode_table_entry {
	unsigned keycode;
	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
	int len;
}

and re-define the ioctls. For example we might be doing:

#define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
#define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
#define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)

Provided that the size for struct keycode_table_entry is different, _IO will generate
a different magic number for those.

Or, instead of using 0x04, just use another sequential number at the 'E' namespace.

An specific function to clear the table is needed with big scancode space,
as already discussed.

I can see two alternatives here:

1) Add the new ioctls to the event interface;
2) add a hook at event do_ioctl logic, allowing it to be extended by the IR core.
3) create another API just for IR, for example, via some sysfs nodes at irrcv class.

I don't like (3): we'll be using sysfs in a place where an ioctl would fit better.

I think (1) is simpler. If Dmitry is ok, I'll prepare a patch for it.

>
>        11) rename IR->RC;

Pending.

>
>        12) redesign or remove ir-common module. It currently handles in-kernel
>            keycode tables and a few helper routines for raw pulse/space decode;

Partially done. The new code for the devices with the NEC protocol doesn't require
ir-common helper routines. After having all the other raw protocol decoders used
by saa7134, we may remove its dependency from ir-common functions.

The breakage of the keycode tables into separate files is the easiest part. I'm
considering to create one *.h file for each keycode table.

>
>        13) move drivers/media/IR to a better place;

Not done.

Comments?

Cheers,
Mauro.

