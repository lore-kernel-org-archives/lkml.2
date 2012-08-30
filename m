Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2H3NHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 09:07:37 -0400
Received: from mail.anarazel.de ([217.115.131.40]:38281 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2H3NHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 09:07:36 -0400
From: Andres Freund <andres@anarazel.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression 3.5->3.6: usb keyboard not working anymore
Date: Thu, 30 Aug 2012 15:07:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-andres-00208-g9b44425; KDE/4.8.4; x86_64; ; )
Cc: Bernhard Seibold <mail@bernhard-seibold.de>, Jiri Kosina <jkosina@suse.cz>
References: <201208301434.26195.andres@anarazel.de>
In-Reply-To: <201208301434.26195.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OW2PQdG63RL1Ai/"
Message-Id: <201208301507.26992.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_OW2PQdG63RL1Ai/
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Hi,

On Thursday, August 30, 2012 02:34:25 PM Andres Freund wrote:
> With a quick grep I just discovered that a new driver for this (or
> similar?) keyboards has been added. I have *not* compiled this in though:
> +# CONFIG_HID_LENOVO_TPKBD is not set
> 
> Is the new, unconditional, entry in the hid_have_special_driver struct the
> problem?
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8e3a6b2..f695680 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1544,6 +1544,7 @@ static const struct hid_device_id
> hid_have_special_driver[] = {
>     { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
>     { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC,
> USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
>     { HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 )
> }, +   { HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD)
> }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER)
> }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER)
> }, { HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2)
> },
> 
> Other entries seem to be protected via things like:
> #if IS_ENABLED(CONFIG_HID_LOGITECH_DJ)
> 
> I have somewhat obsoleted my original line of thought in this email, but
> hell. Will try this and send a patch if it works.
Works.

Could somebody integrate the attached patch?

Greetings,

Andres

--Boundary-00=_OW2PQdG63RL1Ai/
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-HID-Continue-to-work-if-the-new-Lenovo-Keyboard-driv.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-HID-Continue-to-work-if-the-new-Lenovo-Keyboard-driv.patch"

=46rom 9b44425d4f9e68b8d5fbc1d4909fd7e580a82f0b Mon Sep 17 00:00:00 2001
=46rom: Andres Freund <andres@anarazel.de>
Date: Thu, 30 Aug 2012 14:37:14 +0200
Subject: [PATCH] HID: Continue to work if the new Lenovo Keyboard driver is
 not configured

c1dcad2d32d0252e8a3023d20311b52a187ecda3 added a new driver configured by
HID_LENOVO_TPKBD but made the hid_have_special_driver entry non-optional wh=
ich
lead to a recognized but non-working device if the new driver wasn't
configured (which is the correct default).

Signed-off-by: Andres Freund <andres@anarazel.de>
=2D--
 drivers/hid/hid-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8bf8a64..4bddc5e 100644
=2D-- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1558,7 +1558,9 @@ static const struct hid_device_id hid_have_special_dr=
iver[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYB=
OARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
=2D 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
+#if IS_ENABLED(CONFIG_HID_LENOVO_TPKBD)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
=2D-=20
1.7.10.rc3.3.g19a6c.dirty


--Boundary-00=_OW2PQdG63RL1Ai/--
