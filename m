Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1BQMz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:55:59 -0500
Received: from smtp207.alice.it ([82.57.200.103]:48125 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab1BQMz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:55:57 -0500
Date: Thu, 17 Feb 2011 13:55:40 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Marcin Tolysz <tolysz@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        greg@kroah.com, stern@rowland.harvard.edu
Subject: Re: [PATCH v4 1/1] hid: Add HID Report Descriptor to sysfs.
Message-Id: <20110217135540.7a54acb8.ospite@studenti.unina.it>
In-Reply-To: <1295841018-8561-2-git-send-email-alan@signal11.us>
References: <20110123225935.GB12488@kroah.com>
	<1295841018-8561-2-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Feb_2011_13_55_40_+0100_D9_Am/5PXnfpH.nr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Feb_2011_13_55_40_+0100_D9_Am/5PXnfpH.nr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Jan 2011 22:50:18 -0500
Alan Ott <alan@signal11.us> wrote:

> Add a new binary sysfs entry called report_descriptor which contains
> the HID report descriptor.
>=20
> Signed-off-by: Alan Ott <alan@signal11.us>

Adding Marcin Tolysz to CC, he is interested in a mechanism to
override the hid_descriptor from userspace dynamically.

Marcin, now that this 'report_descriptor' sysfs attribute has been
accepted as read-only in mainline, maybe you could implement the .write
method for it if your firmware approach to override hid descriptors
would not be accepted. Just pointing at an alternative option, not sure
if it is the best one.

Regards,
   Antonio

> ---
>  Documentation/ABI/testing/sysfs-driver-hid |   10 ++++++++
>  drivers/hid/hid-core.c                     |   33 ++++++++++++++++++++++=
++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-hid
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid b/Documentation/A=
BI/testing/sysfs-driver-hid
> new file mode 100644
> index 0000000..b6490e1
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-hid
> @@ -0,0 +1,10 @@
> +What:		For USB devices	: /sys/bus/usb/devices/<busnum>-<devnum>:<config =
num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/report_descri=
ptor
> +		For BT devices	: /sys/class/bluetooth/hci<addr>/<hid-bus>:<vendor-id>:=
<product-id>.<num>/report_descriptor
> +		Symlink		: /sys/class/hidraw/hidraw<num>/device/report_descriptor
> +Date:		Jan 2011
> +KernelVersion:	2.0.39
> +Contact:	Alan Ott <alan@signal11.us>
> +Description:	When read, this file returns the device's raw binary HID
> +		report descriptor.
> +		This file cannot be written.
> +Users:		HIDAPI library (http://www.signal11.us/oss/hidapi)
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index d678cf3..32bbd5d 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1159,6 +1159,32 @@ static bool hid_hiddev(struct hid_device *hdev)
>  	return !!hid_match_id(hdev, hid_hiddev_list);
>  }
> =20
> +
> +static ssize_t
> +read_report_descriptor(struct file *filp, struct kobject *kobj,
> +		struct bin_attribute *attr,
> +		char *buf, loff_t off, size_t count)
> +{
> +	struct device *dev =3D container_of(kobj, struct device, kobj);
> +	struct hid_device *hdev =3D container_of(dev, struct hid_device, dev);
> +
> +	if (off >=3D hdev->rsize)
> +		return 0;
> +
> +	if (off + count > hdev->rsize)
> +		count =3D hdev->rsize - off;
> +
> +	memcpy(buf, hdev->rdesc + off, count);
> +
> +	return count;
> +}
> +
> +static struct bin_attribute dev_bin_attr_report_desc =3D {
> +	.attr =3D { .name =3D "report_descriptor", .mode =3D 0444 },
> +	.read =3D read_report_descriptor,
> +	.size =3D HID_MAX_DESCRIPTOR_SIZE,
> +};
> +
>  int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  {
>  	static const char *types[] =3D { "Device", "Pointer", "Mouse", "Device",
> @@ -1169,6 +1195,7 @@ int hid_connect(struct hid_device *hdev, unsigned i=
nt connect_mask)
>  	char buf[64];
>  	unsigned int i;
>  	int len;
> +	int ret;
> =20
>  	if (hdev->quirks & HID_QUIRK_HIDDEV_FORCE)
>  		connect_mask |=3D (HID_CONNECT_HIDDEV_FORCE | HID_CONNECT_HIDDEV);
> @@ -1230,6 +1257,11 @@ int hid_connect(struct hid_device *hdev, unsigned =
int connect_mask)
>  		bus =3D "<UNKNOWN>";
>  	}
> =20
> +	ret =3D device_create_bin_file(&hdev->dev, &dev_bin_attr_report_desc);
> +	if (ret)
> +		hid_warn(hdev,
> +			 "can't create sysfs report descriptor attribute err: %d\n", ret);
> +
>  	hid_info(hdev, "%s: %s HID v%x.%02x %s [%s] on %s\n",
>  		 buf, bus, hdev->version >> 8, hdev->version & 0xff,
>  		 type, hdev->name, hdev->phys);
> @@ -1240,6 +1272,7 @@ EXPORT_SYMBOL_GPL(hid_connect);
> =20
>  void hid_disconnect(struct hid_device *hdev)
>  {
> +	device_remove_bin_file(&hdev->dev, &dev_bin_attr_report_desc);
>  	if (hdev->claimed & HID_CLAIMED_INPUT)
>  		hidinput_disconnect(hdev);
>  	if (hdev->claimed & HID_CLAIMED_HIDDEV)
> --=20
> 1.7.0.4
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__17_Feb_2011_13_55_40_+0100_D9_Am/5PXnfpH.nr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1dGswACgkQ5xr2akVTsAG1CwCgrDIg269TM9eo4FP9DTLkHEAX
3ucAn1S/8qDuImX6hmPt9Ct2aTGn7dVP
=eoXW
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Feb_2011_13_55_40_+0100_D9_Am/5PXnfpH.nr--
