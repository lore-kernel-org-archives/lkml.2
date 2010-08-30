Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0H3SVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:21:18 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:45226 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0H3SVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:21:16 -0400
Date: Mon, 30 Aug 2010 20:19:54 +0200
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
Message-ID: <20100830181954.GE31068@darkside.kls.lan>
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
 <20100819193146.GB32665@darkside.kls.lan>
 <4C6E2833.6080407@canonical.com>
 <20100820090824.GA23186@darkside.kls.lan>
 <4C7505A2.3000402@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <4C7505A2.3000402@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hoZxPH4CaxYzWscb
Content-Type: multipart/mixed; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Ike,

On Wed, Aug 25, 2010 at 07:59:30PM +0800, Ike Panhc wrote:
> On 08/20/2010 05:08 PM, Mario 'BitKoenig' Holbe wrote:
> > On Fri, Aug 20, 2010 at 03:01:07PM +0800, Ike Panhc wrote:
> >> Could you attach or upload the DSDT of S12 somewhere I can reach?
> >=20
> > http://sandbox.fem.tu-ilmenau.de/s12/dsdt-s12-via.dsl
> >=20
> >> I check DSDT for S10-3 and B550, return value of _CFG is fixed.
> >> [Ref: http://people.ubuntu.com/~ikepanhc/DSDTs]
> >=20
> > Looks more fixed than on my S12, indeed.
> > I don't really speak AML, but while S10-3 ILDD (called from _CFG) seems
> > to read fixed values only, here on S12 PHSR (called from _CFG) seems to
> > do some kind of I/O operation. I'm not sure about this, but it somehow
> > looks like.
> >=20
> It accesses something in system memory, but I have no idea what will happ=
en
> after writing..

Well, the pattern looks like I/O - mmapped I/O.
        Store (Arg1, \_SB.INF0)
        Store (Arg0, \_SB.BCMD)
        Store (Zero, \_SB.SMIC)
        Store (\_SB.INF0, Local0)

Note that INF0 is written before and read after writing SMIC. Hence,
for this to be useful, something must have happened inbetween, i.e.
I/O :)

> There are two variables need to be written for turning on/off bluetooth. =
They are
> BTST(in memory) and BTEN(is EC register). I will guess there are some syn=
c failed
> when enable bluetooth.

What exactly do you mean with "there are some sync failed"? I don't see
anything like that in the logs.

> This could be a plan. I have several idea to go and need your help.
> - Add some debug message to read BTST/BTEN when turning on/off bluetooth.
> - Force to set BTST/BTEN before reading _CFG
> - Provide a module parm to force enable rf devices.
>=20
> Will have the drivers and please test it and let me know the result.

Hmmm, I don't know if I got you right. I didn't find any new drivers to
test, so I tried to add some more debug code myself. Hope this helps.
I added some code to show_ideapad_cam() to be able to asynchronously
trigger reading of BTST, BTEN, and BTPS. As before: the patch attached
is not for inclusion but to show what I did. I'm usually not a kernel
hacker, so please take a serious look at what I did before trusting the
results :)

I attached a full protocol of actions I performed including kernel
dmesges. Typed commands are prepended by #, manual actions and comments
are enclosed in <>, kernel messages are timestamped, the rest is output
of the commands.
Basically I did the following:
0. I started with a fresh powered up system, all RF devices powered on.
1. I hw-switched RF off and back on, which went okay.
2. I sw-switched BT off and back on, which resulted in erroneous
initialization.
3. I again sw-switched BT off and back on, which resulted in BT being
completely gone.
4. I hw-switched RF off and back on, which brought BT back and
operational.

> > I played with the hardware killswitch under Linux. The bluetooth device
> > disappears and re-appears there and always seems to initialize
> > correctly. No USB read errors this way.
=2E..
> > I'm not exactly sure what this means - especially because I don't know
> > how the hardware killswitch works internally.
> > It *could* mean, the initialization problem is proably something that
> > could be dealt with in the USB layer long term (and would then probably
> > not have to be worked around anymore in ideapad_laptop). I'm not sure
> > about this, because this would mean the hard killswitch power-cut
> > somehow differs from the soft killswitch power-cut.
> Usually the hw rf switch turning off PHY only. When turning off, device a=
nd
> its driver is still there. I believe S12 is designed in this way after
> reading your test result.

Hmmm, I don't understand your reasoning here.
I said the device disappears and re-appears when using the hw rf switch,
this doesn't look like it would turn off PHY only.


best regards
   Mario
--=20
We know that communication is a problem, but the company is not going to
discuss it with the employees.
                       -- Switching supervisor, AT&T Long Lines Division

--iFRdW5/EC4oqxDHL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ideapad_laptop.diff"
Content-Transfer-Encoding: quoted-printable

--- ideapad_laptop.c.orig	2010-08-18 13:35:36.087735426 +0200
+++ ideapad_laptop.c	2010-08-30 19:05:53.116031145 +0200
@@ -170,6 +170,18 @@ static ssize_t show_ideapad_cam(struct d
 	struct ideapad_private *priv =3D dev_get_drvdata(dev);
 	acpi_handle handle =3D priv->handle;
 	unsigned long result;
+	acpi_status res;
+	u64 res64;
+
+	res =3D acpi_evaluate_integer(handle, "\\_SB.BTST", NULL, &res64);
+	if(!ACPI_FAILURE(res))
+		printk(KERN_INFO "BTST: 0x%llx\n", res64);
+	res =3D acpi_evaluate_integer(handle, "\\_SB.BTPS", NULL, &res64);
+	if(!ACPI_FAILURE(res))
+		printk(KERN_INFO "BTPS: 0x%llx\n", res64);
+	res =3D acpi_evaluate_integer(handle, "\\_SB.PCI0.PIB.EC0.BTEN", NULL, &r=
es64);
+	if(!ACPI_FAILURE(res))
+		printk(KERN_INFO "BTEN: 0x%llx\n", res64);
=20
 	if (read_ec_data(handle, 0x1D, &result))
 		return sprintf(buf, "-1\n");
@@ -279,11 +291,19 @@ static int ideapad_acpi_add(struct acpi_
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

--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=protocol

<fresh powered up system>
# cat $(find /sys -name camera_power)
[  140.121467] BTST: 0x1
[  140.121475] BTPS: 0x1
[  140.122378] BTEN: 0x1
1
<hw killswitch off>
[  199.296090] usb 4-1: USB disconnect, address 2
[  199.296789] btusb_intr_complete: hci0 urb f6990300 failed to resubmit (19)
[  199.296808] btusb_bulk_complete: hci0 urb f6990380 failed to resubmit (19)
[  199.297789] btusb_bulk_complete: hci0 urb f6990000 failed to resubmit (19)
[  199.297991] btusb_send_frame: hci0 urb f6766200 submission failed
[  199.784704] wlan0: deauthenticating from 00:1c:f0:e4:3d:a9 by local choice (reason=3)
[  199.786981] cfg80211: Calling CRDA to update world regulatory domain
[  200.852176] b43-phy0: Radio hardware status changed to DISABLED
# cat $(find /sys -name camera_power)
[  219.129098] BTST: 0x1
[  219.129105] BTPS: 0x1
[  219.130017] BTEN: 0x1
1
<hw killswitch on>
[  257.968055] usb 4-1: new full speed USB device using uhci_hcd and address 3
[  258.141407] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2150
[  258.141420] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  258.141431] usb 4-1: Product: BCM2046 Bluetooth Device
[  258.141440] usb 4-1: Manufacturer: Broadcom Corp
[  258.141448] usb 4-1: SerialNumber: 0C6076DC9FD0
[  260.852114] b43-phy0: Radio hardware status changed to ENABLED
[  261.076117] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[  266.592252] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[  266.592264] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[  266.633509] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  269.380720] wlan0: authenticate with 00:1c:f0:e4:3d:a9 (try 1)
[  269.382273] wlan0: authenticated
[  269.382689] wlan0: associate with 00:1c:f0:e4:3d:a9 (try 1)
[  269.385522] wlan0: RX AssocResp from 00:1c:f0:e4:3d:a9 (capab=0x431 status=0 aid=1)
[  269.385534] wlan0: associated
[  269.392770] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  279.928033] wlan0: no IPv6 routers present
# cat $(find /sys -name camera_power)
[  291.431607] BTST: 0x1
[  291.431614] BTPS: 0x1
[  291.433096] BTEN: 0x1
1
# rfkill block $(rfkill list | awk -F: '/ideapad_bluetooth/{print $1}')
[  341.416077] usb 4-1: USB disconnect, address 3
[  341.416547] btusb_intr_complete: hci0 urb f6747b80 failed to resubmit (19)
[  341.416559] btusb_bulk_complete: hci0 urb f6798300 failed to resubmit (19)
[  341.417546] btusb_bulk_complete: hci0 urb f674e080 failed to resubmit (19)
[  341.417944] btusb_send_frame: hci0 urb f67e5500 submission failed
# cat $(find /sys -name camera_power)
[  364.592492] BTST: 0x0
[  364.592499] BTPS: 0x1
[  364.593586] BTEN: 0x0
1
# rfkill unblock $(rfkill list | awk -F: '/ideapad_bluetooth/{print $1}')
[  392.192070] usb 4-1: new full speed USB device using uhci_hcd and address 4
[  392.312040] usb 4-1: device descriptor read/64, error -71
[  392.536066] usb 4-1: device descriptor read/64, error -71
[  392.752073] usb 4-1: new full speed USB device using uhci_hcd and address 5
[  392.872077] usb 4-1: device descriptor read/64, error -71
[  393.096059] usb 4-1: device descriptor read/64, error -71
[  393.312043] usb 4-1: new full speed USB device using uhci_hcd and address 6
[  393.720143] usb 4-1: device not accepting address 6, error -71
[  393.832051] usb 4-1: new full speed USB device using uhci_hcd and address 7
[  394.240083] usb 4-1: device not accepting address 7, error -71
[  394.240105] hub 4-0:1.0: unable to enumerate USB device on port 1
# cat $(find /sys -name camera_power)
[  458.669365] BTST: 0x1
[  458.669372] BTPS: 0x1
[  458.670744] BTEN: 0x1
1
# rfkill block $(rfkill list | awk -F: '/ideapad_bluetooth/{print $1}')
<absolutely no messages, no errors, nothing>
# cat $(find /sys -name camera_power)
[  576.981559] BTST: 0x0
[  576.981567] BTPS: 0x1
[  576.982900] BTEN: 0x0
1
# rfkill unblock $(rfkill list | awk -F: '/ideapad_bluetooth/{print $1}')
<absolutely no messages, device does not appear, no errors, nothing>
# cat $(find /sys -name camera_power)
[  652.939495] BTST: 0x1
[  652.939503] BTPS: 0x1
[  652.941192] BTEN: 0x1
1
<hw killswitch off>
[  701.234772] wlan0: deauthenticating from 00:1c:f0:e4:3d:a9 by local choice (reason=3)
[  701.237446] cfg80211: Calling CRDA to update world regulatory domain
[  702.036108] b43-phy0: Radio hardware status changed to DISABLED
# cat $(find /sys -name camera_power)
[  722.962717] BTST: 0x1
[  722.962724] BTPS: 0x1
[  722.964822] BTEN: 0x1
1
<hw killswitch on>
[  757.028180] b43-phy0: Radio hardware status changed to ENABLED
[  757.379142] usb 4-1: new full speed USB device using uhci_hcd and address 8
[  757.432136] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[  757.552383] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2150
[  757.552396] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  757.552407] usb 4-1: Product: BCM2046 Bluetooth Device
[  757.552415] usb 4-1: Manufacturer: Broadcom Corp
[  757.552423] usb 4-1: SerialNumber: 0C6076DC9FD0
[  762.952258] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[  762.952271] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[  762.985688] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  765.728762] wlan0: authenticate with 00:1c:f0:e4:3d:a9 (try 1)
[  765.730314] wlan0: authenticated
[  765.730738] wlan0: associate with 00:1c:f0:e4:3d:a9 (try 1)
[  765.734126] wlan0: RX AssocResp from 00:1c:f0:e4:3d:a9 (capab=0x431 status=0 aid=1)
[  765.734137] wlan0: associated
[  765.738373] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  775.760029] wlan0: no IPv6 routers present
# cat $(find /sys -name camera_power)
[  797.842123] BTST: 0x1
[  797.842131] BTPS: 0x1
[  797.843030] BTEN: 0x1
1

--iFRdW5/EC4oqxDHL--

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTHv2ShS+e2HeSPbpAQKQ1gf+OD9akiQduPq/yeNSTdJ3sxSZVA9pie+6
lIPa0oQtt9oL95f/6vgv8uL63wL+wXSgr/GolFTRmRohfBmDfKs4+d6XcVvkk1ep
daYalGqa82V+5DOtNIHNFUoNuQTIcBHrMf1DELB3wt5DXmVNqsvTV9cdq67pq7T9
KYYTNcVjA3DRheNSd2PTIAEGO9Isdt05YIhCU6WXAqiJRe+l8KHLpYioZvUjPBQv
7aRfvnWnaUZTHKn/J1CcBVAGzFaTSBwDFYOrl8QRz4gZseA8f/CEVCcOmVxWXV6L
aVwsHedvAHaU8LAURtAa6aBFeE+fPCB0Cko1SVioRj5Qm2DgWmytOA==
=hphH
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
