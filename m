Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0CVNvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:51:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab0CVNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BXiiR6sz3TURAEWBWngtTtt3TEKNFTl9TW3jWbyfvAbY2E49j3quI9n3Bw0z7yc1rs
         cj/UjcywmR4TYrr+2xzD8Wppn5DyInQThWjLRHd+h7INmJeye7DuKiuMyFfdfvdfLi3+
         V1vsUPeJaFj4tk2wm30KMq5CqMZkfnX2DInEM=
Date: Mon, 22 Mar 2010 15:52:35 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH] Fix key f70f4b50 not in .data in thermal_sys
Message-ID: <20100322135235.GA3388@swordfish.minsk.epam.com>
References: <20100309102754.GA3316@swordfish.minsk.epam.com>
 <20100309141826.GC28606@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20100309141826.GC28606@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nope. Sorry, I didn't test carefully. Oh, Monday...
Proposed patch doesn't fix the problem. The given below
patch does.

Note that thermal_zone_bind_cooling_device part was proposed by=20
Wolfram Sang here:
https://patchwork.kernel.org/patch/87359/

So, Wolfram, we need to cooperate to solve the problem.


Initialize sysfs attributes before device_create_file call.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5066de5..ecb181d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -505,6 +505,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	tz->temp_input.attr.attr.name =3D tz->temp_input.name;
 	tz->temp_input.attr.attr.mode =3D 0444;
 	tz->temp_input.attr.show =3D temp_input_show;
+	sysfs_attr_init(&tz->temp_input.attr.attr);
 	result =3D device_create_file(hwmon->device, &tz->temp_input.attr);
 	if (result)
 		goto unregister_hwmon_device;
@@ -517,6 +518,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 			tz->temp_crit.attr.attr.name =3D tz->temp_crit.name;
 			tz->temp_crit.attr.attr.mode =3D 0444;
 			tz->temp_crit.attr.show =3D temp_crit_show;
+			sysfs_attr_init(&tz->temp_crit.attr.attr);
 			result =3D device_create_file(hwmon->device,
 						    &tz->temp_crit.attr);
 			if (result)
@@ -725,6 +727,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zon=
e_device *tz,
 		goto release_idr;
=20
 	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	sysfs_attr_init(&dev->attr.attr);
 	dev->attr.attr.name =3D dev->attr_name;
 	dev->attr.attr.mode =3D 0444;
 	dev->attr.show =3D thermal_cooling_device_trip_point_show;

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkundiMACgkQfKHnntdSXjQf5gQAi6Scx5SpaezHH5XsxwkYjALY
B+FEZy7mrtt4rkufsyi+eT16P2VmlK9Pu4LfLOi8hSHrfRoP9qkkkZ3qbIbdsfF0
6kb4iPPzm2kMFgPY1f/3wjVUtAze+ZWerXoNC7EoTscd4FVFCCIPC3OOXZgRF+VE
ncnHtwfPCJYWrTtWR04=
=bosw
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
