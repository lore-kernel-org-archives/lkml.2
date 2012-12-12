Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2LLKfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:35:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38181 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab2LLKfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:35:52 -0500
Date: Wed, 12 Dec 2012 12:28:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zihan@huawei.com>, <Lin.Lei@huawei.com>, <greg@kroah.com>,
        <neil.yi@huawei.com>, <wangyuhua@huawei.com>, <huqiao36@huawei.com>
Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Message-ID: <20121212102839.GD2440@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Vw0j8UKbyX0bfpA"
Content-Disposition: inline
In-Reply-To: <fe8c905bb12.b12fe8c905b@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6Vw0j8UKbyX0bfpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

ok, let's start.

On Wed, Dec 12, 2012 at 06:20:33PM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
>=20
> 1. To optimize the match rules for the Huawei USB storage devices. Avoid =
to load USB storage driver for modem interface with Huawei devices.
> 2. Add to support new switch command for new Huawei USB dongles.

first of all you're doing a whole lot more than these two things and
your commit log is a lot over 72 characters.

> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> -------------------------------------------------------------------------=
------------------------
> diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/dri=
vers/usb/storage/initializers.c
> --- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.=
000000000 +0800
> +++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-12 16:26:53.0000=
00000 +0800
> @@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_dat
>  	return 0;
>  }
> =20
> -/* This places the HUAWEI E220 devices in multi-port mode */
> -int usb_stor_huawei_e220_init(struct us_data *us)
> +/* This places the HUAWEI usb dongles in multi-port mode */
> +static int usb_stor_huawei_feature_init(struct us_data *us)

renaming this function doesn't look like is part of $SUBJECT

>  {
>  	int result;
> =20
> @@ -104,3 +104,60 @@ int usb_stor_huawei_e220_init(struct us_
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> +
> +/*Find the supported Huawei USB dongles*/

comment style is wrong, you miss a space after /* and before */

> +static int usb_stor_huawei_dongles_pid(struct us_data *us)
> +{
> +	int ret =3D 0;
> +	struct usb_interface_descriptor *idesc =3D NULL;

could add a blank line here to aid readability

> +	idesc =3D &us->pusb_intf->cur_altsetting->desc;
> +	if (idesc !=3D NULL && idesc->bInterfaceNumber =3D=3D 0) {
> +			if ((us->pusb_dev->descriptor.idProduct >=3D 0x1401 && us->pusb_dev->=
descriptor.idProduct <=3D 0x1600)
> +					|| (us->pusb_dev->descriptor.idProduct >=3D 0x1c02 && us->pusb_dev-=
>descriptor.idProduct <=3D 0x2202)
> +					|| (us->pusb_dev->descriptor.idProduct =3D=3D 0x1001)
> +					|| (us->pusb_dev->descriptor.idProduct =3D=3D 0x1003)
> +					|| (us->pusb_dev->descriptor.idProduct =3D=3D 0x1004)) {

clearly you didn't even run checkpatch.pl here.

> +				if (us->pusb_dev->descriptor.idProduct >=3D 0x1501=20
                                                                           =
     ^
										trailing
										whitespace

> +					&& us->pusb_dev->descriptor.idProduct <=3D 0x1504) {
> +					ret =3D 0;

ret is already initialized to zero, why do it again ?

> +				} else {
> +					ret =3D 1;
> +				}
> +			}
> +		}
> +	return ret;
> +}
> +
> +static int usb_stor_huawei_scsi_init(struct us_data *us)
> +{
> +	int result =3D 0;
> +	int act_len =3D 0;
> +	unsigned char rewind_cmd[] =3D {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x0=
0, 0x00,=20
                                                                           =
          ^
										     trailing
										     whitespace

> +				      0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> +	struct bulk_cb_wrap bcbw =3D {0};
> +	bcbw.Signature =3D cpu_to_le32(US_BULK_CB_SIGN);
> +	bcbw.Tag =3D 0;
> +	bcbw.DataTransferLength =3D cpu_to_le32(0);
> +	bcbw.Flags =3D bcbw.Lun =3D 0;
> +	bcbw.Length =3D sizeof(rewind_cmd);
> +	memset(bcbw.CDB, 0, sizeof(bcbw.CDB));

the entire structure is already initialized to zero, no ?

> +	memcpy(bcbw.CDB, rewind_cmd, sizeof(rewind_cmd));
> +
> +	result =3D usb_stor_bulk_transfer_buf (us, us->send_bulk_pipe, &bcbw, 3=
1, &act_len);
> +	US_DEBUGP("usb_stor_bulk_transfer_buf performing result is %d, transfer=
 the actual length=3D%d\n", result, act_len);

waaaaaay over 80-characters. Run checkpatch.pl

> +	return result;
> +}
> +
> +int usb_stor_huawei_init(struct us_data *us)
> +{
> +	int result =3D 0;
> +	if(usb_stor_huawei_dongles_pid(us)) {
> +		if ((us->pusb_dev->descriptor.idProduct >=3D 0x1446)) {
> +			result =3D usb_stor_huawei_scsi_init(us);
> +		} else {
> +			result =3D usb_stor_huawei_feature_init(us);
> +		}

read Documentation/CodingStyle, you'll see this is wrong.

> +	}
> +	return result;
> +}
> diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.h linux-3.7/dri=
vers/usb/storage/initializers.h
> --- linux-3.7_bak/drivers/usb/storage/initializers.h	2012-12-11 09:56:11.=
000000000 +0800
> +++ linux-3.7/drivers/usb/storage/initializers.h	2012-12-12 11:43:58.0000=
00000 +0800
> @@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data=20
>   * flash reader */
>  int usb_stor_ucr61s2b_init(struct us_data *us);
> =20
> -/* This places the HUAWEI E220 devices in multi-port mode */
> -int usb_stor_huawei_e220_init(struct us_data *us);
> +/* This places the HUAWEI usb dongles in multi-port mode */
> +int usb_stor_huawei_init(struct us_data *us);
> diff -uprN linux-3.7_bak/drivers/usb/storage/unusual_devs.h linux-3.7/dri=
vers/usb/storage/unusual_devs.h
> --- linux-3.7_bak/drivers/usb/storage/unusual_devs.h	2012-12-11 09:56:11.=
000000000 +0800
> +++ linux-3.7/drivers/usb/storage/unusual_devs.h	2012-12-12 11:47:34.0000=
00000 +0800
> @@ -1527,335 +1527,10 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x
>  /* Reported by fangxiaozhi <huananhu@huawei.com>
>   * This brings the HUAWEI data card devices into multi-port mode
>   */
> -UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
> +UNUSUAL_VENDOR_INTF(  0x12d1, 0x08, 0x06, 0x50,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> -UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
> -		"HUAWEI MOBILE",
> -		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_init,
>  		0),
> =20
>  /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
> diff -uprN linux-3.7_bak/drivers/usb/storage/usb.c linux-3.7/drivers/usb/=
storage/usb.c
> --- linux-3.7_bak/drivers/usb/storage/usb.c	2012-12-11 09:56:11.000000000=
 +0800
> +++ linux-3.7/drivers/usb/storage/usb.c	2012-12-12 11:46:06.000000000 +08=
00
> @@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
>  	.useTransport =3D use_transport,	\
>  }
> =20
> +#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> +		    vendor_name, product_name, use_protocol, use_transport, \
> +		    init_function, Flags) \
> +{ \
> +	.vendorName =3D vendor_name,	\
> +	.productName =3D product_name,	\
> +	.useProtocol =3D use_protocol,	\
> +	.useTransport =3D use_transport,	\
> +	.initFunction =3D init_function,	\
> +}

not part of $SUBJECT, should be a separate patch.

> +
>  static struct us_unusual_dev us_unusual_dev_list[] =3D {
>  #	include "unusual_devs.h"
>  	{ }		/* Terminating entry */
> @@ -131,6 +142,7 @@ static struct us_unusual_dev for_dynamic
>  #undef UNUSUAL_DEV
>  #undef COMPLIANT_DEV
>  #undef USUAL_DEV
> +#undef UNUSUAL_VENDOR_INTF
> =20
>  #ifdef CONFIG_LOCKDEP
> =20
> diff -uprN linux-3.7_bak/drivers/usb/storage/usual-tables.c linux-3.7/dri=
vers/usb/storage/usual-tables.c
> --- linux-3.7_bak/drivers/usb/storage/usual-tables.c	2012-12-11 09:56:11.=
000000000 +0800
> +++ linux-3.7/drivers/usb/storage/usual-tables.c	2012-12-12 11:47:18.0000=
00000 +0800
> @@ -41,6 +41,18 @@
>  #define USUAL_DEV(useProto, useTrans) \
>  { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
> =20
> +/*Define the device is matched with Vendor ID and interface descriptors*/

missing spaces.

> +#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
> +                    vendorName, productName,useProtocol, useTransport, \
> +                    initFunction, flags) \
> +{ \
> +  .match_flags =3D USB_DEVICE_ID_MATCH_INT_INFO | USB_DEVICE_ID_MATCH_VE=
NDOR, \
> +  .idVendor    =3D (id_vendor), \
> +  .bInterfaceClass =3D (cl), \
> +  .bInterfaceSubClass =3D (sc), \
> +  .bInterfaceProtocol =3D (pr), \
> +  .driver_info =3D (flags)}

this should be properly indented with tabs.

> +
>  struct usb_device_id usb_storage_usb_ids[] =3D {
>  #	include "unusual_devs.h"
>  	{ }		/* Terminating entry */
> @@ -50,6 +62,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb
>  #undef UNUSUAL_DEV
>  #undef COMPLIANT_DEV
>  #undef USUAL_DEV
> +#undef UNUSUAL_VENDOR_INTF
> =20
>  /*
>   * The table of devices to ignore
> =20
>=20
>=20
> *************************************************************************=
*****************
>  This email and its attachments contain confidential information from HUA=
WEI, which is intended only for the person or entity whose address is liste=
d above. Any use of the information contained here in any way (including, b=
ut not limited to, total or partial disclosure, reproduction, or disseminat=
ion) by persons other than the intended recipient(s) is prohibited. If you =
receive this email in error, please notify the sender by phone or email
>  immediately and delete it!
>  ************************************************************************=
*****************

this footer should be removed from your mail when you send mails to
public mailing lists.

--=20
balbi

--6Vw0j8UKbyX0bfpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyFxXAAoJEIaOsuA1yqRE7i8QAKlJwwJmjxGX30Ic00L3THbC
BkPYnXjbOWdkcnKLI19JwywfIG0xUcG6VvM3QNFwKDKzJFxviAHZgZm8mAutmoLk
aoN8Ba38V9vsfPaW2/kI8DZnfEn9htNR1tMe8HafSMNengvgkR1orPei01EPkqtx
Oz2SVagi2V9gC4hOncPlWjYdPtJFO8hP2SAotIQdUavAgbS7pDoV+qcryuFlOe8H
qAZUObmb1K3dIldXXGD8ep3f623gm2x+b6kcNoJKrIcwpmq2B7GNskHgCkehNIJ4
JCIG7uo8FrzGpBOOTdCltKCsPOmCqLlD9E/81md94VWFvbEAYMaSegtQMX3zPiXq
27RYjhYqGegBjf4NNi4B+6jf+BfnlAKp6Uki7GLz4GGKn1eJhmsI+rgvyeW3p4jI
xT/X1jRTVn8z+MOCRDWq1VVxpsApGtFXHsEB744895uqNTNYO+aempA3huLOXyva
xsMfMTom6Y45C9/ltjRYJr5Th9VmF7neGqKk/j6jm2KtbfqblthYWHcXRN9SKTfQ
K/mnMjB2kmxmvMdhDrGOe2a4C8nJvulD+UJzk3PaSARVXXhoYp/QO6Fa7JGfNgeB
MRqnJxggZonPK5i+f6XzcHAKJWgdm19LsQU3ZeqWO8sdRWcHq+cHDL8mKdLTM3Ia
7vFJwdNUMOVPhi7F5d2q
=3Oyu
-----END PGP SIGNATURE-----

--6Vw0j8UKbyX0bfpA--
