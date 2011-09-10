Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab1IJVSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 17:18:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44947 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934084Ab1IJVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 17:18:47 -0400
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC/PATCH] On HP ACPI brokenness and fan control in particular
Date: Sat, 10 Sep 2011 23:18:27 +0200
Message-Id: <1315689507-18615-1-git-send-email-giuseppe.bilotta@gmail.com>
X-Mailer: git-send-email 1.7.7.rc0.367.g41b413
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

(I might have overdone it with the cc list, feel free to trim as
appropriate). (Also, the post is rather long, you can skip to the final
parts if you don't care about the hows and whys.)

TL;DR version: the HP ACPI sucks but we can actually access the fan
speeds (for reading) and have a modicum of control on them. I can try
doing the coding, but I need guidance because I've never touched
something this complex. Preliminary tentative code is at the end.

Long version follows.

I happen to be a not-so-happy owner of a 3-years-old HP Pavilion dv5,
but the issues I'm having, from what I could gather browsing the
internet, are affecting many if not all HP Pavilion (and corresponding
Compaq-branded) models.

'Recently' (say, before the summer), after some kernel upgrade,  my
laptop started overheating without the fans starting up. If I shut down
and then restart the computer while hot (and I mean still in the 90C
range), the fans would spin up and generally (but not always) keep
spinning for the rest of the laptop usage. Symptoms of the problem
included fans not spinning up _ever at all_ on the first cold (literally
cold) boot, even with the temperature sensors going over 90C, but also
fans spinning down (even though not shutting down completely) after a
_hot_ boot during kernel boot up, while devices where initialized, as if
the BIOS was thinking about giving the o.s. thermal control of the
system.

This led me to suspect some bad interaction between the BIOS ACPI and
the way Linux handled it. After a few rather dissatisfying rounds of
debugging I think I may be getting rather close to a solution, to the
point where I can (manually) juggle around the ACPI bits to query the
fan speed and even tell the BIOS to go back to handling it as necessary
(or something like that).

As it happens, the DSDT table in this HP (but from what I've seen on the
internet, it's pretty much the same in many other models) is a _horrible
mess_. I'm pretty sure this doesn't come as a surprise for most of you,
who are probably used to even worse stuff. Anyway.

For starters, here's my current `acpi -V` output

    Battery 0: Full, 100%, rate information unavailable
    Battery 0: design capacity 6000 mAh, last full capacity 4288 mAh = 71%
    Adapter 0: on-line
    Thermal 0: ok, 58.0 degrees C
    Thermal 0: trip point 0 switches to mode hot at temperature 105.0 degrees C
    Thermal 0: trip point 1 switches to mode passive at temperature 135.0 degrees C
    Cooling 0: LCD 0 of 10
    Cooling 1: Processor 0 of 10
    Cooling 2: Processor 0 of 10

The good news is, the battery information and AC adapter information are
quite correct. The _temperature_ information is correct too. The
tripping points are not (more on this later). There are no _active_
cooling device being repoterd (which is bad, and false, because there
are fans mounted, and working, on this laptop).

Also the output is actually _wrong_: LCD control is found on
/sys/class/thermal/cooling_device2, while 0 and 1 act on the CPUs. This
might be a bug in `acpi`, though, not sure, and it might be related to
the fact that the _PSL in the thermal zone only reports the CPU(s) as
actual passive cooling devices (who adds the LCD to the list?).

I'm not sure why the LCD is marked as a cooling device: operating on its
cur_state 'works' in the sense that it operates on the backlight (the
settings are actually complementary to the brightness effects that can
be manipulated via /sys/class/backlight/acpi_video0, so that setting 10
in one place corresponds to setting 0 in the other, and conversely). I'm
not sure if this kind of duplication is standard, and/or if also needs
special handling kernel-side. Also, it doesn't directly affect the fan
problem, so I'm just mentioning because it was a discovery that my lack
of expertise found unusual.

I'm not going to bore you with `dmesg | grep -i acpi`, but a few
highlights are

    DMI 2.4 present.
    DMI: Hewlett-Packard HP Pavilion dv5 Notebook PC/3603, BIOS F.09 07/23/2008

    ACPI: RSDP 00000000000fe020 00024 (v02 HPQOEM)
    ACPI: XSDT 00000000bfdfe120 00064 (v01 HPQOEM SLIC-MPC 00000001      01000013)
    ACPI: FACP 00000000bfdfd000 000F4 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: DSDT 00000000bfded000 0B32F (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: FACS 00000000bfd92000 00040
    ACPI: HPET 00000000bfdfc000 00038 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: APIC 00000000bfdfb000 0006C (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: MCFG 00000000bfdfa000 0003C (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: ASF! 00000000bfdf9000 000A5 (v32 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: SLIC 00000000bfdec000 00176 (v01 HPQOEM SLIC-MPC 06040000  LTP 00000001)
    ACPI: BOOT 00000000bfdeb000 00028 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
    ACPI: SSDT 00000000bfdea000 00655 (v01  PmRef    CpuPm 00003000 INTL 20051117)

    ACPI: EC: Look up EC in DSDT

    [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored

    ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62

     pci0000:00: Requesting ACPI _OSC control (0x1d)
     pci0000:00: ACPI _OSC control (0x1c) granted

    [Firmware Bug]: Invalid critical threshold (0)
    thermal LNXTHERM:00: registered as thermal_zone0
    ACPI: Thermal Zone [TZ01] (45 C)

    acpi device:08: registered as cooling_device2

(full dmesg and whatever can be provided if necessary). There is
actually a more up-to-date BIOS (F.21), but I'm having troubles finding
a way to install it: HP kindly decided to only provide a
Windows-driver-driven installation, without even the boot disk option,
and flashrom doesn't support my hardware; plus, even if I had a way to
use it (via some Windows live or temporary installation), I wouldn't
want to risk bricking my laptop with it, something that seems
particularly prone to happening with these 'InsydeFlash' thing. _And_,
the internet (again) tells me that not much has changed with respect to
this on the new BIOSes anyway.

So what about the critical thresholds? iasl comes to the rescue and we
can start seeing some pretty horrible stuff. For starters, _OSI queries.
The PCI0 device has this brilliant piece of code:

    Name (TPOS, Zero)
    Method (_INI, 0, NotSerialized)
    {
        If (CondRefOf (_OSI, Local0))
        {
            If (_OSI ("Linux"))
            {
                Store (0x03E8, OSYS)
                Store (0x80, TPOS)
            }
            Else
            {
                Store (0x07D1, OSYS)
                Store (0x08, TPOS)
            }

            If (_OSI ("Windows 2001 SP2"))
            {
                Store (0x07D2, OSYS)
                Store (0x11, TPOS)
            }

            If (_OSI ("Windows 2006"))
            {
                Store (0x07D6, OSYS)
                Store (0x40, TPOS)
            }
        }
        Else
        {
            Store (0x07D0, OSYS)
            Store (0x04, TPOS)
        }
    }

(more on TPOS later). The actual OS detection is used in an awfully lot
of places, but in the thermal zone handling it's done in something
similar to the worst possible way. We have, for ThermalZone(TZ01),

    Method (_HOT, 0, Serialized)
    {
        If (LEqual (OSYS, 0x07D6))
        {
            If (LEqual (TJMX, 0x64))
            {
                Return (0x0EC6)
            }

            If (LEqual (TJMX, 0x55))
            {
                Return (0x0E30)
            }
        }
    }

    Method (_CRT, 0, Serialized)
    {
        If (LLess (OSYS, 0x07D6))
        {
            If (LEqual (TJMX, 0x64))
            {
                Return (0x0EC6)
            }

            If (LEqual (TJMX, 0x55))
            {
                Return (0x0E30)
            }
        }
    }

TJMX is a field in

    OperationRegion (NVST, SystemMemory, 0xBFDBEED4, 0x000000F8)
    Field (NVST, AnyAcc, Lock, Preserve)

which is always only tested against those two values (0x64/0x55), it's
never set from the ACPI, and I _suspect_ being (related to) the 'Fan
always on' setting in the BIOS.

But the important part here is this: if the o.s. responds to the Windows
Vista _OSI query, then _HOT reports some values, but _CRT does not. And
conversely. Otherwise, or if, for any reason, TJMX does not have either
expected value, the _HOT and/or _CRT queries will _not even return a
value_.

Not sure why Linux ends up using 105 C, so the question is if we would
like to somehow detect the situation and somehow use the HP provided
value (126/141), or is it not even worth trying?

(By the way, there are other reasons why we might want to reply to the
"Windows 2006" _OSI query, such as HPET._STA returning 0x0F instead of
0x0B, or having access to the QBTN & similar devices (PNP0C32, Direct
App Launch, discussed on the LKML as Quickstart now and then), but
that's a different matter).

Back to the thermal zone, the DSDT reserves some additional surprises.
There is an OTHD method which I couldn't really understand what it does
(ultimately, it calls a CPUL method that, under appropriate conditions,
notifies 0x80 to the CPU(s)). But what really interests us the most are
these two methods:

    Method (FRSP, 0, NotSerialized)
    {
        Store (Zero, Local2)
        If (ECOK)
        {
            Store (\_SB.PCI0.LPC.EC0.RPM1, Local0)
            Store (\_SB.PCI0.LPC.EC0.RPM2, Local1)
            ShiftLeft (Local1, 0x08, Local1)
            Or (Local0, Local1, Local0)
            If (LNotEqual (Local0, Zero))
            {
                Divide (0x00075300, Local0, Local0, Local2)
            }
        }

        Return (Local2)
    }

    Method (FSSP, 1, NotSerialized)
    {
        If (ECOK)
        {
            If (LNotEqual (Arg0, Zero))
            {
                Store (Zero, \_SB.PCI0.LPC.EC0.SFAN)
            }
            Else
            {
                Store (0x02, \_SB.PCI0.LPC.EC0.SFAN)
            }
        }
    }

I don't know why it took me a while to understand that FRSP = Fan Read
SPeed, and FSSP = Fan Set SPeed (or something like that). There are also
two auxiliary variables next to it, which are not used

    Name (FMAX, 0x1388)
    Name (FMIN, Zero)

which are probably the maximum and minimum fan speed.

Using the `acpi_call` module which is being developed by the Linux
Hybrid Graphics project I have been in fact able to verify that FRSP
_does_ return the fan speed, and that FSSP _does_, in fact, turn the
fans on/off:

    $ echo "\_TZ.TZ01.FRSP" | sudo tee /proc/acpi/call && echo $(cat /proc/acpi/call)
    \_TZ.TZ01.FRSP
    0x3ee
    $ echo "\_TZ.TZ01.FSSP 0" | sudo tee /proc/acpi/call && echo $(cat /proc/acpi/call)
    \_TZ.TZ01.FSSP 0
    0x2
    $ echo "\_TZ.TZ01.FRSP" | sudo tee /proc/acpi/call && echo $(cat /proc/acpi/call)
    \_TZ.TZ01.FRSP
    0x0
    $ echo "\_TZ.TZ01.FSSP 1" | sudo tee /proc/acpi/call && echo $(cat /proc/acpi/call)
    \_TZ.TZ01.FSSP 1
    0x0
    $ echo "\_TZ.TZ01.FRSP" | sudo tee /proc/acpi/call && echo $(cat /proc/acpi/call)
    \_TZ.TZ01.FRSP
    0x415

BADUM-TSCH!

So I'm thinking that we need something like an hp_acpi module that
exposes a cooling device which is queried/controlled by the FRSP and
FSSP methods. I tried hacking up something along those lines, but I
think I'll need help to do more sophisticated stuff.

I would also like to know what's the best approach, and what can
actually be done to tie this new exposed cooling device with the rest of
the thermal stuff. Also, for debugging purposes, I would like to access
e.g. SFAN for writing: does the Linux ACPI interface provide methods for
that?

After the sig is "as much as I could do" about an hp_acpi module. It's a
proof a concept, so it's not even in the form of a kernel patch (I'm
actually developing it off-tree at the moment.) It manages to expose a
cooling device that reports the fan speed, and you can switch it on/off
by echoing non-zero/zero to its cur_state. Comments and suggestions?

-- 
Giuseppe Bilotta


/*
 *  hp_acpi.c - HP Laptop ACPI Extras
 *
 *
 *  Copyright (C) 2011 Giuseppe Bilotta
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */


#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define HP_ACPI_VERSION "0.01"

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/thermal.h>
#include <acpi/acpi.h>
#include <acpi/acpi_drivers.h>

MODULE_AUTHOR("Giuseppe Bilotta");
MODULE_DESCRIPTION("HP Laptop ACPI Extras Driver");
MODULE_LICENSE("GPL");

static struct thermal_cooling_device *hpfan_dev;

#define HP_EC0 "\\_SB.PCI0.LPC.EC0"
#define HP_FAN_STATUS "SFAN"
#define HP_FAN_RPM1   "RPM1"
#define HP_FAN_RPM2   "RPM2"
#define HP_TZ  "\\_TZ.TZ01"
#define HP_FAN_SPEED  HP_TZ ".FRSP"
#define HP_FAN_SET    HP_TZ ".FSSP"
#define HP_FAN_MAX    HP_TZ ".FMAX"

static int debug_TJMX_value(void)
{
	unsigned long long val;
	acpi_handle handle;
	acpi_status status;

	status = acpi_get_handle(NULL, HP_TZ, &handle);
	if (ACPI_FAILURE(status)) {
		pr_err("unable to get TZ handle\n");
		return -ENODEV;
	}

	status = acpi_evaluate_integer(handle, "TJMX", NULL, &val);

	if (ACPI_FAILURE(status)) {
		pr_err("couldn't evaluate TJMX\n");
		return -ENODEV;
	}

	pr_info("TJMX value: %llu\n", val);

	return 0;
}

static int is_valid_acpi_path(const char *methodName)
{
	acpi_handle handle;
	acpi_status status;

	status = acpi_get_handle(NULL, (char *)methodName, &handle);
	return !ACPI_FAILURE(status);
}

static unsigned long hp_read_fan_speed(void)
{
	unsigned long long val;
	acpi_status status = acpi_evaluate_integer(NULL, HP_FAN_SPEED, NULL, &val);

	if (ACPI_FAILURE(status))
		return -ENODEV;

	return (unsigned long)val;
}

static int hp_set_fan_ctl(int val, unsigned long long *out)
{
	struct acpi_object_list params;
	union acpi_object in_obj;
	acpi_status status;

	params.count = 1;
	params.pointer = &in_obj;
	in_obj.type = ACPI_TYPE_INTEGER;
	in_obj.integer.value = val;

	status = acpi_evaluate_integer(NULL, HP_FAN_SET, &params, out);
	if (ACPI_FAILURE(status))
		return -ENODEV;

	return 0;
}

static int
hpfan_get_max_state(struct thermal_cooling_device *cdev, unsigned long *state)
{
	unsigned long long val;
	acpi_status status = acpi_evaluate_integer(NULL, HP_FAN_MAX, NULL, &val);

	if (ACPI_FAILURE(status))
		return -ENODEV;

	*state = (unsigned long)val;
	return 0;
}

static int
hpfan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long *state)
{
	unsigned long rpm = hp_read_fan_speed();
	if (rpm < 0)
		return rpm;

	*state = rpm;
	return 0;
}

static int
hpfan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
{
	unsigned long long reply;
	int err = hp_set_fan_ctl(state, &reply);
	if (err < 0)
		return err;

	return 0;
}

static struct thermal_cooling_device_ops hpfan_cooling_ops = {
	.get_max_state = hpfan_get_max_state,
	.get_cur_state = hpfan_get_cur_state,
	.set_cur_state = hpfan_set_cur_state,
};

static void hpfan_unregister(void)
{
	if (hpfan_dev) {
		hpfan_set_cur_state(hpfan_dev, 1);
		thermal_cooling_device_unregister(hpfan_dev);
		hpfan_dev = NULL;
	}
}

static int __init hp_acpi_init(void)
{
	if (acpi_disabled)
		return -ENODEV;

	if (!is_valid_acpi_path(HP_FAN_SPEED) ||
	    !is_valid_acpi_path(HP_FAN_SET))
		return -ENODEV;

	hpfan_dev = thermal_cooling_device_register("hp-fan", NULL,
						    &hpfan_cooling_ops);

	if (IS_ERR(hpfan_dev)) {
		hpfan_unregister();
		return -EINVAL;
	}

	debug_TJMX_value();

	return hpfan_set_cur_state(hpfan_dev, 1);
}

static void hp_acpi_exit(void)
{
	hpfan_unregister();
}

module_init(hp_acpi_init);
module_exit(hp_acpi_exit);


