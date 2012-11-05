Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2KEEq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 23:46:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab2KEEq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 23:46:57 -0500
Date: Mon, 5 Nov 2012 15:46:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the akpm tree with the pm tree
Message-Id: <20121105154646.65ece287a8bd50e844085a9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Nov_2012_15_46_46_+1100_+9EvfthoHz6VXmkc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Nov_2012_15_46_46_+1100_+9EvfthoHz6VXmkc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/acpi/acpi_memhotplug.c between commits 85fcb3758c10 ("ACPI /
memory-hotplug: introduce a mutex lock to protect the list in
acpi_memory_device") and d0fbb400b6f3 ("ACPI / memory-hotplug: add memory
offline code to acpi_memory_device_remove()") from the pm tree and commit
"acpi_memhotplug.c: fix memory leak when memory device is unbound from
the module acpi_memhotplug" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/acpi_memhotplug.c
index 92c973a,62c2c74..0000000
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@@ -131,6 -125,16 +131,18 @@@ acpi_memory_get_resource(struct acpi_re
  	return AE_OK;
  }
 =20
+ static void
+ acpi_memory_free_device_resources(struct acpi_memory_device *mem_device)
+ {
+ 	struct acpi_memory_info *info, *n;
+=20
++	mutex_lock(&mem_device->list_lock);
+ 	list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+ 		kfree(info);
+ 	INIT_LIST_HEAD(&mem_device->res_list);
++	mutex_unlock(&mem_device->list_lock);
+ }
+=20
  static int
  acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
  {
@@@ -504,13 -490,7 +519,13 @@@ static int acpi_memory_device_remove(st
  	if (!device || !acpi_driver_data(device))
  		return -EINVAL;
 =20
 -	acpi_memory_device_free(acpi_driver_data(device));
 +	mem_device =3D acpi_driver_data(device);
 +
 +	result =3D acpi_memory_remove_memory(mem_device);
 +	if (result)
 +		return result;
 +
- 	kfree(mem_device);
++	acpi_memory_device_free(mem_device);
 =20
  	return 0;
  }

--Signature=_Mon__5_Nov_2012_15_46_46_+1100_+9EvfthoHz6VXmkc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQl0S2AAoJEECxmPOUX5FEUo0P/3u05YlhxViXkBJX5xqd4GwU
JjyN0juf7NQAUWYZqUYideMFhexiCqiVDtsYL/j+JEw9wFprhNd5dC1ZwEB6+Q9A
OTvmQ3S3zD2ZVWI1WQrQC7ktzn5NVVEkO/g6nYfy57UfHVvK8kHUnfDOl0VrYQGT
tCOloM2TL+IJ+8mDr1h2ILlsdhiIaini5J7G0jtfMIZC32wnMGhpX53gUIfqq/6v
p/4TPXvGUprPSGX5D7HrtA95MRkLJj/LpfrjslqPBOqWrb8FmRp5lafVD1Ojwzk9
twb+RJk6nPCuOYw7jAzgN8074OsEjJT55eEJ8zsmslZkcfM9WyfBFIZkc0ZpP/vl
vIpVyEjY/WEGPv84fBgM1YbsegPfrL41IAJY5CZUffzjC2Gs8YAorxkww2M0zDr1
ZLv5S7+2kx5gsI8fR8+AK13XCeYi5Prh+7JjxWpyL+L1LV8sleFSQdIS2JXMSrip
+wJBIYd7XpfxKmE3wFaiwW/2Mu8qfeGu8WBy7DcJ6pK9tmqoljnXh5AJu1US9xWf
MI+tdXo/NcCLvj95fYJXNPHsHW9Uva1VZXDPTNOgBs1Lxa3qur3CUXNpqJlORIlu
EzHgPl5KX2WkrOI5SlJxSTpYRqQrlfrN+S/pQRt4B4SxEPWOElZccX84FRm3HJjs
MH0khDV8n9rEhejvqB4J
=++aX
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Nov_2012_15_46_46_+1100_+9EvfthoHz6VXmkc--
