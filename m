Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0HSTc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:32:57 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:39273 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0HSTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:32:55 -0400
Date: Thu, 19 Aug 2010 21:31:46 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Ike Panhc <ike.pan@canonical.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
Message-ID: <20100819193146.GB32665@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Ike Panhc <ike.pan@canonical.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corentin Chary <corentincj@iksaif.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Brown, Len" <len.brown@intel.com>,
	Matthew Garrett <mjg@redhat.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
 <1282127719.2747.211.camel@localhost>
 <20100818155128.GA24363@darkside.kls.lan>
 <4C6CA31D.6030407@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
In-Reply-To: <4C6CA31D.6030407@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: multipart/mixed; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2010 at 11:21:01AM +0800, Ike Panhc wrote:
> On 08/18/2010 11:51 PM, Mario 'BitKoenig' Holbe wrote:
> > It works for me too on S12 w/ VIA Nano - at least somehow... I have two
=2E..
> > Fn-Esc switches the Camera off and on, but there seems to be no soft
> > killswitch for it. I have no idea how to parse through acpidump to find
> You can find the entry by "find /sys/devices -name 'camera_power'"

Thanks a lot. I found it and it works.

> > 2nd: both Bluetooth killswitches reproducibly disappear when I block
> > ideapad_bluetooth either via Gnome bluetooth-applet or via rfkill block
> > 1 and subsequently reboot.

All right, I did some more testing...

I was not able to reproduce this with Windows somewhere in the game -
neither via switching BT off in Windows and rebooting to Windows nor via
switching BT off in Linux and rebooting to Windows nor via switching BT
off in Windows and rebooting to Linux.

> This is interesting. looks like the cfgbit will change on S12 if BIOS
> remember it has to shutdown when booting. I will try if the same problem
> happen on my ideapads.

Yes, the cfgbit changes. It's normally 0xd0000 and it's 0xc0000 when the
bluetooth switch is not detected.

It's not that reproducible as it first appeared to be. Sometimes it does
not happen, i.e. sometimes after rfkill block 1 and reboot the
bluetooth killswitch is available again.

If the bluetooth killswitch is not available, a second reboot usually
makes it available again.

Once the cfgbit is 0xc0000 it's stable, i.e. modprobe -r ideapad-laptop;
modprobe ideapad-laptop doesn't change anything.

I tried to enforce the existence of the bluetooth killswitch (the
attached diff is not for inclusion but to show what I did) with some
kind of success:

[  682.260288] ideapad_acpi_add(): cfg=3D0xc0000
[  682.260293] ideapad_acpi_add(): found: ideapad_camera
[  682.260297] ideapad_acpi_add(): found: ideapad_wlan
[  682.260301] ideapad_acpi_add(): forced: ideapad_bluetooth
[  682.856049] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 2
[  683.028220] usb 4-1: New USB device found, idVendor=3D0a5c, idProduct=3D=
2150
[  683.028234] usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[  683.028244] usb 4-1: Product: BCM2046 Bluetooth Device

So, forcing the existence of the killswitch enables the bluetooth
device. I'm also able to switch if off again - the bluetooth device
disappears. Trying to switch it back on then fails - the bluetooth
device does not appear again. But this case doesn't work all that well
anyways even with cfgbit 0xd0000:

$ rfkill block 1
[  124.648059] usb 4-1: USB disconnect, address 2
[  124.648512] btusb_intr_complete: hci0 urb f6825700 failed to resubmit (1=
9)
[  124.648531] btusb_bulk_complete: hci0 urb f697ee80 failed to resubmit (1=
9)
[  124.649510] btusb_bulk_complete: hci0 urb f6872400 failed to resubmit (1=
9)
[  124.650114] btusb_send_frame: hci0 urb f67acf00 submission failed
$ rfkill unblock 1
[  133.148059] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 3
[  148.260042] usb 4-1: device descriptor read/64, error -110
$ rfkill block 1
[  151.092060] hub 4-0:1.0: unable to enumerate USB device on port 1
$ rfkill unblock 1
[  155.628052] usb 4-1: new full speed USB device using uhci_hcd and addres=
s 4
[  170.740049] usb 4-1: device descriptor read/64, error -110
[  185.956033] usb 4-1: device descriptor read/64, error -110

Sometimes it doesn't even come back at all on unblock. Seems like the
bluetooth device doesn't really like to be powered off and on that way.
Btw.: once I messed up the bluetooth device that way not even Windows
sees it anymore when I reboot to it.

=46rom all this I'm inclined to assume it has more to do with the
bluetooth device's USB interface than with the killswitch handling
itself. I believe the S12 BIOS just probes the device(s) on it's own and
sets the cfgbit accordingly and sometimes it just doesn't find the
bluetooth device - why ever.

This all does btw. not happen when I use the hci0 killswitch instead.
The device doesn't disappear then, has no issues with re-initialization,
etc. Looks way more stable that way.
I'm not absolutely sure about the different implications of using the
one or the other killswitch - maybe using the ACPI killswitches saves
more power than using the device-specific killswitches because it powers
the device(s) down completely, but that's just a wild guess - maybe it's
absolutely wrong, though.
However, it would probably be worth thinking about not offering the
additional RF killswitches at all but just doing the initialization
stuff to make sure the devices power up and are thus able to be handled
via their own killswitches subsequently.

Please let me know if I can provide more testing - and what kind of :)


Mario
--=20
We know that communication is a problem, but the company is not going to
discuss it with the employees.
                       -- Switching supervisor, AT&T Long Lines Division

--uZ3hkaAS1mZxFaxD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ideapad_laptop.diff"
Content-Transfer-Encoding: quoted-printable

--- ideapad_laptop.c.orig	2010-08-18 13:35:36.087735426 +0200
+++ ideapad_laptop.c	2010-08-19 20:06:59.762979357 +0200
@@ -279,11 +279,19 @@
 	if (read_method_int(adevice->handle, "_CFG", &cfg))
 		return -ENODEV;
=20
+	printk(KERN_INFO "ideapad_acpi_add(): cfg=3D0x%x\n", cfg);
+
 	for (i =3D IDEAPAD_DEV_CAMERA; i < IDEAPAD_DEV_KILLSW; i++) {
-		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
+		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg)) {
 			devs_present[i] =3D 1;
-		else
-			devs_present[i] =3D 0;
+			printk(KERN_INFO "ideapad_acpi_add(): found: %s\n", ideapad_rfk_data[i]=
=2Ename);
+		} else {
+			if(ideapad_rfk_data[i].type =3D=3D RFKILL_TYPE_BLUETOOTH) {
+				devs_present[i] =3D 1;
+				printk(KERN_INFO "ideapad_acpi_add(): forced: %s\n", ideapad_rfk_data[=
i].name);
+			} else
+				devs_present[i] =3D 0;
+		}
 	}
=20
 	/* The hardware switch is always present */

--uZ3hkaAS1mZxFaxD--

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTG2GohS+e2HeSPbpAQLbvAgAjtLLz56lGAamZ/JL8Ipfm/2Tjn+i6zll
+gXyhrECdkX+tuL9wwFpriII/NNJ2tLx6/TiLGROtuKf5Mq64BtPD3+/vkjgBs0A
ujwr9fqG2cG772ns/1unBmpk+WaUaKhaRTBCkbNvJytfmta/ICQUaUfEv6SRV70d
GGBAr4eWLjf/qoU0AYmj+hI5m+oN5Q1umQi3shpbh8rxcW0h6JC/9CWO60O/gBM3
ouU8sC6KB4BWeKTr88wAfswa/95vjFvKz8oXMt4RoQvQV5DAeH7IYaKCmIEYfUkV
hKa/5i8YO//sRmkxodFQX0mExhgrTYTi1Lfw1r75Yh0flM94tCdAlw==
=Ip7t
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
