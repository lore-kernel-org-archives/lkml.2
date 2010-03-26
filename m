Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0CZNXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:23:36 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33280 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0CZNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:23:10 -0400
Date: Fri, 26 Mar 2010 12:27:55 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
Message-ID: <20100326112755.GB5387@hardeman.nu>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <20091215115011.GB1385@ucw.cz>
 <4B279017.3080303@redhat.com>
 <20091215195859.GI24406@elf.ucw.cz>
 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
 <20091215201933.GK24406@elf.ucw.cz>
 <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BAB7659.1040408@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:42:33AM -0300, Mauro Carvalho Chehab wrote:
> >        10) extend keycode table replacement to support big/variable 
> >        sized scancodes;
> 
> Pending.
> 
> The current limit here is the scancode ioctl's are defined as:
> 
> #define EVIOCGKEYCODE           _IOR('E', 0x04, int[2])                 /* get keycode */
> #define EVIOCSKEYCODE           _IOW('E', 0x04, int[2])                 /* set keycode */
> 
> As int size is 32 bits, and we must pass both 64 (or even bigger) scancodes, associated
> with a keycode, there's not enough bits there for IR.
> 
> The better approach seems to create an struct with an arbitrary long size, like:
> 
> struct keycode_table_entry {
> 	unsigned keycode;
> 	char scancode[32];	/* 32 is just an arbitrary long array - maybe shorter */
> 	int len;
> }
>
> and re-define the ioctls. For example we might be doing:
> 
> #define EVIOCGKEYCODEBIG           _IOR('E', 0x04, struct keycode_table_entry)
> #define EVIOCSKEYCODEBIG           _IOW('E', 0x04, struct keycode_table_entry)
> #define EVIOCLEARKEYCODEBIG        _IOR('E', 0x04, void)
> 
> Provided that the size for struct keycode_table_entry is different, _IO will generate
> a different magic number for those.
> 
> Or, instead of using 0x04, just use another sequential number at the 'E' namespace.
> 
> An specific function to clear the table is needed with big scancode space,
> as already discussed.
> 

I'd suggest:

struct keycode_table_entry {
	unsigned keycode;
	unsigned index;
	unsigned len;
	char scancode[];
};

Use index in EVIOCGKEYCODEBIG to look up a keycode (all other fields are 
ignored), that way no special function to clear the table is necessary, 
instead you do a loop with:

EVIOCGKEYCODEBIG (with index 0)
EVIOCSKEYCODEBIG (with the returned struct from EVIOCGKEYCODEBIG and
		  keycode = KEY_RESERVED)

until EVIOCGKEYCODEBIG returns an error.

This also allows you to get all the current mappings from the kernel 
without having to blindly search through an arbitrarily large keyspace.

Also, EVIOCLEARKEYCODEBIG should be:

#define EVIOCLEARKEYCODEBIG _IOR('E', 0x04, struct keycode_table_entry)

That way a user space application can simply call EVIOCLEARKEYCODEBIG, 
ask the user for an appropriate keycode, fill in the keycode member of 
the struct returned from EVIOCLEARKEYCODEBIG and call EVIOCSKEYCODEBIG.

On a related note, I really think the interface would benefit from 
allowing more than one keytable per irrcv device with an input device 
created per keytable. That way you can have one input device per remote 
control. This implies that EVIOCLEARKEYCODEBIG is a bit misplaced as an 
evdev IOCTL since there's an N-1 mapping between input devices and irrcv 
devices.

ioctl's to set/get keycodes for ir should also take a flag parameter in 
the struct to allow special properties to be set/returned for a given 
keycode mapping (I'm thinking of keycodes which powers on the computer 
for instance, that should be exposed to userspace somehow).

With all of that, the struct might need to be something like:

struct keycode_table_entry {
	unsigned keycode; /* e.g. KEY_A */
	unsigned table;   /* Table index, for multiple keytables */
	unsigned index;   /* Index in the given keytable */
	unsigned flags;   /* For additional functionality */
	unsigned len;     /* Of the struct */
	char scancode[];  /* Per-protocol scancode data follows */
};

Finally, I think irrcv should create a chardev of its own with ioctl's 
like EVIOCLEARKEYCODEBIG (and RX/TX parameter setting ioctl's).  The 
same chardev can be used for IR blasting (by writing data to it once TX 
parameters have been set).


-- 
David Härdeman
