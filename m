Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2EUGGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:06:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35146 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2EUGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:06:36 -0400
Date: Mon, 21 May 2012 16:06:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?B?IkV6ZXF1aWVsIEdhcmPDrWEi?= <elezegarcia@gmail.com>
Subject: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-Id: <20120521160624.a5e16748fb11670778ea9b3f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_16_06_24_+1000_ar2TzHY9+O/oBT1l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_16_06_24_+1000_ar2TzHY9+O/oBT1l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/staging/media/easycap/easycap_main.c between various commits from
the v4l-dvb tree and commit 5df773120477 ("USB: Staging: media: easycap:
remove err() usage") from the usb tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/easycap/easycap_main.c
index aed9537,6f83d36..0000000
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@@ -3401,176 -3126,6 +3401,175 @@@ static void config_easycap(struct easyc
  			}
  		}
  	}
 +}
 +
 +/*
 + * This function is called from within easycap_usb_disconnect() and is
 + * protected by semaphores set and cleared by easycap_usb_disconnect().
 + * By this stage the device has already been physically unplugged,
 + * so peasycap->pusb_device is no longer valid.
 + */
 +static void easycap_delete(struct kref *pkref)
 +{
 +	struct easycap *peasycap;
 +
 +	peasycap =3D container_of(pkref, struct easycap, kref);
 +	if (!peasycap) {
 +		SAM("ERROR: peasycap is NULL: cannot perform deletions\n");
 +		return;
 +	}
 +
 +	/* Free video urbs */
 +	free_video_urbs(peasycap);
 +
 +	/* Free video isoc buffers */
 +	free_isocbuffers(peasycap);
 +
 +	/* Free video field buffers */
 +	free_fieldbuffers(peasycap);
 +
 +	/* Free video frame buffers */
 +	free_framebuffers(peasycap);
 +
 +	/* Free audio urbs */
 +	free_audio_urbs(peasycap);
 +
 +	/* Free audio isoc buffers */
 +	free_audio_buffers(peasycap);
 +
 +	free_easycap(peasycap);
 +
 +	JOT(4, "ending.\n");
 +}
 +
 +static const struct v4l2_file_operations v4l2_fops =3D {
 +	.owner		=3D THIS_MODULE,
 +	.open		=3D easycap_open_noinode,
 +	.unlocked_ioctl	=3D easycap_unlocked_ioctl,
 +	.poll		=3D easycap_poll,
 +	.mmap		=3D easycap_mmap,
 +};
 +
 +static int easycap_register_video(struct easycap *peasycap)
 +{
 +	/*
 +	 * FIXME: This is believed to be harmless,
 +	 * but may well be unnecessary or wrong.
 +	 */
 +	peasycap->video_device.v4l2_dev =3D NULL;
 +
 +	strcpy(&peasycap->video_device.name[0], "easycapdc60");
 +	peasycap->video_device.fops =3D &v4l2_fops;
 +	peasycap->video_device.minor =3D -1;
 +	peasycap->video_device.release =3D (void *)(&videodev_release);
 +
 +	video_set_drvdata(&(peasycap->video_device), (void *)peasycap);
 +
 +	if (0 !=3D (video_register_device(&(peasycap->video_device),
 +					VFL_TYPE_GRABBER, -1))) {
- 		err("Not able to register with videodev");
 +		videodev_release(&(peasycap->video_device));
 +		return -ENODEV;
 +	}
 +
 +	peasycap->registered_video++;
 +
 +	SAM("registered with videodev: %i=3Dminor\n",
 +	    peasycap->video_device.minor);
 +	    peasycap->minor =3D peasycap->video_device.minor;
 +
 +	return 0;
 +}
 +
 +/*
 + * When the device is plugged, this function is called three times,
 + * one for each interface.
 + */
 +static int easycap_usb_probe(struct usb_interface *intf,
 +			    const struct usb_device_id *id)
 +{
 +	struct usb_device *usbdev;
 +	struct usb_host_interface *alt;
 +	struct usb_endpoint_descriptor *ep;
 +	struct usb_interface_descriptor *interface;
 +	struct easycap *peasycap;
 +	int i, j, rc;
 +	u8 bInterfaceNumber;
 +	u8 bInterfaceClass;
 +	u8 bInterfaceSubClass;
 +	int okalt[8], isokalt;
 +	int okepn[8];
 +	int okmps[8];
 +	int maxpacketsize;
 +
 +	usbdev =3D interface_to_usbdev(intf);
 +
 +	alt =3D usb_altnum_to_altsetting(intf, 0);
 +	if (!alt) {
 +		SAY("ERROR: usb_host_interface not found\n");
 +		return -EFAULT;
 +	}
 +
 +	interface =3D &alt->desc;
 +	if (!interface) {
 +		SAY("ERROR: intf_descriptor is NULL\n");
 +		return -EFAULT;
 +	}
 +
 +	/* Get properties of probed interface */
 +	bInterfaceNumber =3D interface->bInterfaceNumber;
 +	bInterfaceClass =3D interface->bInterfaceClass;
 +	bInterfaceSubClass =3D interface->bInterfaceSubClass;
 +
 +	JOT(4, "intf[%i]: num_altsetting=3D%i\n",
 +			bInterfaceNumber, intf->num_altsetting);
 +	JOT(4, "intf[%i]: cur_altsetting - altsetting=3D%li\n",
 +		bInterfaceNumber,
 +		(long int)(intf->cur_altsetting - intf->altsetting));
 +	JOT(4, "intf[%i]: bInterfaceClass=3D0x%02X bInterfaceSubClass=3D0x%02X\n=
",
 +			bInterfaceNumber, bInterfaceClass, bInterfaceSubClass);
 +
 +	/*
 +	 * A new struct easycap is always allocated when interface 0 is probed.
 +	 * It is not possible here to free any existing struct easycap.
 +	 * This should have been done by easycap_delete() when the device was
 +	 * physically unplugged.
 +	 * The allocated struct easycap is saved for later usage when
 +	 * interfaces 1 and 2 are probed.
 +	 */
 +	if (0 =3D=3D bInterfaceNumber) {
 +		/*
 +		 * Alloc structure and save it in a free slot in
 +		 * easycapdc60_dongle array
 +		 */
 +		peasycap =3D alloc_easycap(bInterfaceNumber);
 +		if (!peasycap)
 +			return -ENOMEM;
 +
 +		/* Perform basic struct initialization */
 +		init_easycap(peasycap, usbdev, intf, bInterfaceNumber);
 +
 +		/* Dynamically fill in the available formats */
 +		rc =3D easycap_video_fillin_formats();
 +		if (0 > rc) {
 +			SAM("ERROR: fillin_formats() rc =3D %i\n", rc);
 +			return -EFAULT;
 +		}
 +		JOM(4, "%i formats available\n", rc);
 +
 +		/* Populate easycap.inputset[] */
 +		rc =3D populate_inputset(peasycap);
 +		if (rc < 0)
 +			return rc;
 +		JOM(4, "finished initialization\n");
 +	} else {
 +		peasycap =3D get_easycap(usbdev, bInterfaceNumber);
 +		if (!peasycap)
 +			return -ENODEV;
 +	}
 +
 +	config_easycap(peasycap, bInterfaceNumber,
 +				 bInterfaceClass,
 +				 bInterfaceSubClass);
 =20
  	/*
  	 * Investigate all altsettings. This is done in detail
@@@ -3854,9 -3562,33 +3853,12 @@@
  		JOM(4, "registered device instance: %s\n",
  			peasycap->v4l2_device.name);
 =20
 -		/*
 -		 * FIXME: This is believed to be harmless,
 -		 * but may well be unnecessary or wrong.
 -		 */
 -		peasycap->video_device.v4l2_dev =3D NULL;
 -
 -
 -		strcpy(&peasycap->video_device.name[0], "easycapdc60");
 -		peasycap->video_device.fops =3D &v4l2_fops;
 -		peasycap->video_device.minor =3D -1;
 -		peasycap->video_device.release =3D (void *)(&videodev_release);
 -
 -		video_set_drvdata(&(peasycap->video_device), (void *)peasycap);
 -
 -		if (0 !=3D (video_register_device(&(peasycap->video_device),
 -							VFL_TYPE_GRABBER, -1))) {
 +		rc =3D easycap_register_video(peasycap);
- 		if (rc < 0)
++		if (rc < 0) {
+ 			dev_err(&intf->dev,
+ 				"Not able to register with videodev\n");
 -			videodev_release(&(peasycap->video_device));
  			return -ENODEV;
+ 		}
 -
 -		peasycap->registered_video++;
 -		SAM("registered with videodev: %i=3Dminor\n",
 -						peasycap->video_device.minor);
 -		peasycap->minor =3D peasycap->video_device.minor;
 -
  		break;
  	}
  	/* 1: Audio control */

--Signature=_Mon__21_May_2012_16_06_24_+1000_ar2TzHY9+O/oBT1l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPudtgAAoJEECxmPOUX5FE1hYP/jHK5O8h8gsJghOiPMMoX7Fg
uHLdqJya7wBNRIuam44233cIFNHizW2l4aFjHAJnfiyD+gZ84bd6wosDq89tRsCb
D/I121tZuSLfGXns69dnJ8YqbLa4UVzl/OsgpIVr6oQFWZzlnZtHf1qxN+F30eJN
aSIMErDisEJ+QTiKwou1SpNiijMHCqM3ojUsKJ7DeXdu8XI5byEHurEDmNDH9zLC
hMKjXNv1VW71RdpugNQi8K6lgg521Ur0/YKFrNewmNb6e2yIy2TYcfAVPv+QmobN
+HGA1R4lTCWaVBVBEnZ9h39W/u/ArLA2nkXbABmJk0+7NreYquJzdx3BCV4Pd3pj
+CdOvto6kZxUUur0pXJSTS/Cw6CUDtqV0Hzz2zkty4sW5LgEBv8fR6+nPkKL853P
0ZD98BOe23TRXCx5e4AWaR3ChGxu+7dV/uyU98Za9zQ19+QYX23gaAH6x3WnI9DV
cTgdKmjB0qepDS3ivoojvjki2zgMlmEIwbAJceOxOk3oRYmSIeRf+eCfJeK6/7S9
czDNTWH01E2oNRPoNKbbZsKOw/NUYv9jtkoBWAc6iQyLiPCWPjcv8t6uuBG/ykw3
Y+bnDTA+I7Hn9QEQulInrv4mXHD8LPQ7WwkM3BNL3MXJjG8GkYz/ipjynFcBzSZ0
1UXxqqI69Exh6LcdUzjT
=FSjy
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_16_06_24_+1000_ar2TzHY9+O/oBT1l--
