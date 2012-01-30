Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2A3CZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:25:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35469 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2A3CZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:25:07 -0500
Date: Mon, 30 Jan 2012 13:24:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-Id: <20120130132451.1049903dbf990fed5876e5bc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Jan_2012_13_24_51_+1100_vZNGS/udJE+aM3Iz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Jan_2012_13_24_51_+1100_vZNGS/udJE+aM3Iz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/acpi/processor_driver.c between commit 54d5dcc45af7 ("ACPI
processor hotplug: Split up acpi_processor_add") from Linus' tree and
commit 9061e0e16700 ("ACPI: Load acpi-cpufreq from processor driver
automatically") from the driver-core tree.

I fixed it up (I think- see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/processor_driver.c
index 2b805d7,e6920d0..0000000
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@@ -459,71 -440,6 +459,72 @@@ static struct notifier_block acpi_cpu_n
  	    .notifier_call =3D acpi_cpu_soft_notify,
  };
 =20
 +/*
 + * acpi_processor_start() is called by the cpu_hotplug_notifier func:
 + * acpi_cpu_soft_notify(). Getting it __cpuinit{data} is difficult, the
 + * root cause seem to be that acpi_processor_uninstall_hotplug_notify()
 + * is in the module_exit (__exit) func. Allowing acpi_processor_start()
 + * to not be in __cpuinit section, but being called from __cpuinit funcs
 + * via __ref looks like the right thing to do here.
 + */
 +static __ref int acpi_processor_start(struct acpi_processor *pr)
 +{
 +	struct acpi_device *device =3D per_cpu(processor_device_array, pr->id);
 +	int result =3D 0;
 +
 +#ifdef CONFIG_CPU_FREQ
 +	acpi_processor_ppc_has_changed(pr, 0);
++	acpi_processor_load_module(pr);
 +#endif
 +	acpi_processor_get_throttling_info(pr);
 +	acpi_processor_get_limit_info(pr);
 +
 +	if (!cpuidle_get_driver() || cpuidle_get_driver() =3D=3D &acpi_idle_driv=
er)
 +		acpi_processor_power_init(pr, device);
 +
 +	pr->cdev =3D thermal_cooling_device_register("Processor", device,
 +						   &processor_cooling_ops);
 +	if (IS_ERR(pr->cdev)) {
 +		result =3D PTR_ERR(pr->cdev);
 +		goto err_power_exit;
 +	}
 +
 +	dev_dbg(&device->dev, "registered as cooling_device%d\n",
 +		pr->cdev->id);
 +
 +	result =3D sysfs_create_link(&device->dev.kobj,
 +				   &pr->cdev->device.kobj,
 +				   "thermal_cooling");
 +	if (result) {
 +		printk(KERN_ERR PREFIX "Create sysfs link\n");
 +		goto err_thermal_unregister;
 +	}
 +	result =3D sysfs_create_link(&pr->cdev->device.kobj,
 +				   &device->dev.kobj,
 +				   "device");
 +	if (result) {
 +		printk(KERN_ERR PREFIX "Create sysfs link\n");
 +		goto err_remove_sysfs_thermal;
 +	}
 +
 +	return 0;
 +
 +err_remove_sysfs_thermal:
 +	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
 +err_thermal_unregister:
 +	thermal_cooling_device_unregister(pr->cdev);
 +err_power_exit:
 +	acpi_processor_power_exit(pr, device);
 +
 +	return result;
 +}
 +
 +/*
 + * Do not put anything in here which needs the core to be online.
 + * For example MSR access or setting up things which check for cpuinfo_x86
 + * (cpu_data(cpu)) values, like CPU feature flags, family, model, etc.
 + * Such things have to be put in and set up above in acpi_processor_start=
()
 + */
  static int __cpuinit acpi_processor_add(struct acpi_device *device)
  {
  	struct acpi_processor *pr =3D NULL;

--Signature=_Mon__30_Jan_2012_13_24_51_+1100_vZNGS/udJE+aM3Iz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJf9zAAoJEECxmPOUX5FE7x8P/35AqERLRdksI6upwgEfIJhn
iWcrp6SdgC4g3aHU8Nwy59/AHF8YLGF7WgLZ+kUGslMqWBp5K387YvQB4eiX82hc
h+AUkpP2ZSdii1626VLkPbBKMf1Z95Fx4VwP2UUIZVkGtGWEFT9rDC3QMCdBnUjs
L5mT/DMs0YZfDhjnbj/aK0NLwDXSwYR5IWS796h0czMjWUGUuoBXwq8nVv53RiFW
QAPFQ7AKsZtqaFEAkjt1f6LkrgWTHRs5Dav1gXlzzkWa2yoQ6qej8VySoNGDRmFt
UjXeNPXVbW7C5hrasEvhjLShTHGvTX02On04vldGeOtv6mlvZxA0ilmsvq7fKcJ3
ZtCIGqtERyYbKYy2VyWEJ2TQrySRxsImtzAKc/WUcO2Dgu1mD19GtKesMt1mTjdJ
N69qMtqyzUXB6VuzifCAEE9yjG4xJl3MuCtsaV2gDSEIlNm7WHtz83hhpVnyVUgy
Gv/3Cwl+oBr9dkE3apcdCVNAuiAnliys6aHvh5Qp4jFTxEVYMu0VVCuV2LpQowGq
zoR7+lOZ3z5q43ox347mwzS0apCptrPcSd4pMXxF4Q5BINf/BAPjUvgPDv2V7TMW
2/uyc+TMzaojOvWBxcXBPU2i5AAhS81OGxtXsGQHI8ciU98gVc0Wzs2jVLNWuVjU
7VqRL2XzAe2ZdUjT9dkD
=/Ym+
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Jan_2012_13_24_51_+1100_vZNGS/udJE+aM3Iz--
