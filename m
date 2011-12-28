Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1L1G0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:26:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37040 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1L1G0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:26:33 -0500
Date: Wed, 28 Dec 2011 17:26:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the driver-core tree with the s390 tree
Message-Id: <20111228172611.b23752f58cc9cda66c194dc2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_17_26_11_+1100_KD0==_Z5wuwC_ngX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_17_26_11_+1100_KD0==_Z5wuwC_ngX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/s390/kernel/smp.c between commit 83a24e329084 ("[S390] topology: get
rid of ifdefs") from the s390 tree and commit 8a25a2fd126c ("cpu: convert
'cpu' and 'machinecheck' sysdev_class to a regular subsystem") from the
driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.

I also applied the following merge fix patch (which may not be correct or
enough) for the bits moved into topology.c:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 28 Dec 2011 17:19:21 +1100
Subject: [PATCH] s390: fixup for sysdev removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/s390/kernel/topology.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 08a059d..b635a8b 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -366,8 +366,8 @@ void __init s390_init_cpu_topology(void)
=20
 static int cpu_management;
=20
-static ssize_t dispatching_show(struct sysdev_class *class,
-				struct sysdev_class_attribute *attr,
+static ssize_t dispatching_show(struct device *dev,
+				struct device_attribute *attr,
 				char *buf)
 {
 	ssize_t count;
@@ -378,8 +378,8 @@ static ssize_t dispatching_show(struct sysdev_class *cl=
ass,
 	return count;
 }
=20
-static ssize_t dispatching_store(struct sysdev_class *dev,
-				 struct sysdev_class_attribute *attr,
+static ssize_t dispatching_store(struct device *dev,
+				 struct device_attribute *attr,
 				 const char *buf,
 				 size_t count)
 {
@@ -405,11 +405,11 @@ out:
 	put_online_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_CLASS_ATTR(dispatching, 0644, dispatching_show,
+static DEIVCE_ATTR(dispatching, 0644, dispatching_show,
 			 dispatching_store);
=20
-static ssize_t cpu_polarization_show(struct sys_device *dev,
-				     struct sysdev_attribute *attr, char *buf)
+static ssize_t cpu_polarization_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
 	int cpu =3D dev->id;
 	ssize_t count;
@@ -435,10 +435,10 @@ static ssize_t cpu_polarization_show(struct sys_devic=
e *dev,
 	mutex_unlock(&smp_cpu_state_mutex);
 	return count;
 }
-static SYSDEV_ATTR(polarization, 0444, cpu_polarization_show, NULL);
+static DEVICE_ATTR(polarization, 0444, cpu_polarization_show, NULL);
=20
 static struct attribute *topology_cpu_attrs[] =3D {
-	&attr_polarization.attr,
+	&dev_attr_polarization.attr,
 	NULL,
 };
=20
@@ -448,7 +448,7 @@ static struct attribute_group topology_cpu_attr_group =
=3D {
=20
 int topology_cpu_init(struct cpu *cpu)
 {
-	return sysfs_create_group(&cpu->sysdev.kobj, &topology_cpu_attr_group);
+	return sysfs_create_group(&cpu->dev.kobj, &topology_cpu_attr_group);
 }
=20
 static int __init topology_init(void)
@@ -460,6 +460,6 @@ static int __init topology_init(void)
 	set_topology_timer();
 out:
 	update_cpu_core_map();
-	return sysdev_class_create_file(&cpu_sysdev_class, &attr_dispatching);
+	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/kernel/smp.c
index b1cd329,66cca03..0000000
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@@ -923,21 -889,52 +923,21 @@@ out
  	put_online_cpus();
  	return rc ? rc : count;
  }
- static SYSDEV_ATTR(configure, 0644, cpu_configure_show, cpu_configure_sto=
re);
+ static DEVICE_ATTR(configure, 0644, cpu_configure_show, cpu_configure_sto=
re);
  #endif /* CONFIG_HOTPLUG_CPU */
 =20
- static ssize_t show_cpu_address(struct sys_device *dev,
- 				struct sysdev_attribute *attr, char *buf)
 -static ssize_t cpu_polarization_show(struct device *dev,
 -				     struct device_attribute *attr, char *buf)
 -{
 -	int cpu =3D dev->id;
 -	ssize_t count;
 -
 -	mutex_lock(&smp_cpu_state_mutex);
 -	switch (smp_cpu_polarization[cpu]) {
 -	case POLARIZATION_HRZ:
 -		count =3D sprintf(buf, "horizontal\n");
 -		break;
 -	case POLARIZATION_VL:
 -		count =3D sprintf(buf, "vertical:low\n");
 -		break;
 -	case POLARIZATION_VM:
 -		count =3D sprintf(buf, "vertical:medium\n");
 -		break;
 -	case POLARIZATION_VH:
 -		count =3D sprintf(buf, "vertical:high\n");
 -		break;
 -	default:
 -		count =3D sprintf(buf, "unknown\n");
 -		break;
 -	}
 -	mutex_unlock(&smp_cpu_state_mutex);
 -	return count;
 -}
 -static DEVICE_ATTR(polarization, 0444, cpu_polarization_show, NULL);
 -
+ static ssize_t show_cpu_address(struct device *dev,
+ 				struct device_attribute *attr, char *buf)
  {
  	return sprintf(buf, "%d\n", __cpu_logical_map[dev->id]);
  }
- static SYSDEV_ATTR(address, 0444, show_cpu_address, NULL);
+ static DEVICE_ATTR(address, 0444, show_cpu_address, NULL);
 =20
 -
  static struct attribute *cpu_common_attrs[] =3D {
  #ifdef CONFIG_HOTPLUG_CPU
- 	&attr_configure.attr,
+ 	&dev_attr_configure.attr,
  #endif
- 	&attr_address.attr,
+ 	&dev_attr_address.attr,
 -	&dev_attr_polarization.attr,
  	NULL,
  };
 =20
@@@ -1120,16 -1108,58 +1120,16 @@@ static ssize_t __ref rescan_store(struc
  	rc =3D smp_rescan_cpus();
  	return rc ? rc : count;
  }
- static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
+ static DEVICE_ATTR(rescan, 0200, NULL, rescan_store);
  #endif /* CONFIG_HOTPLUG_CPU */
 =20
 -static ssize_t dispatching_show(struct device *dev,
 -				struct device_attribute *attr,
 -				char *buf)
 -{
 -	ssize_t count;
 -
 -	mutex_lock(&smp_cpu_state_mutex);
 -	count =3D sprintf(buf, "%d\n", cpu_management);
 -	mutex_unlock(&smp_cpu_state_mutex);
 -	return count;
 -}
 -
 -static ssize_t dispatching_store(struct device *dev,
 -				 struct device_attribute *attr,
 -				 const char *buf,
 -				 size_t count)
 -{
 -	int val, rc;
 -	char delim;
 -
 -	if (sscanf(buf, "%d %c", &val, &delim) !=3D 1)
 -		return -EINVAL;
 -	if (val !=3D 0 && val !=3D 1)
 -		return -EINVAL;
 -	rc =3D 0;
 -	get_online_cpus();
 -	mutex_lock(&smp_cpu_state_mutex);
 -	if (cpu_management =3D=3D val)
 -		goto out;
 -	rc =3D topology_set_cpu_management(val);
 -	if (!rc)
 -		cpu_management =3D val;
 -out:
 -	mutex_unlock(&smp_cpu_state_mutex);
 -	put_online_cpus();
 -	return rc ? rc : count;
 -}
 -static DEVICE_ATTR(dispatching, 0644, dispatching_show,
 -			 dispatching_store);
 -
 -static int __init topology_init(void)
 +static int __init s390_smp_init(void)
  {
 -	int cpu;
 -	int rc;
 +	int cpu, rc;
 =20
  	register_cpu_notifier(&smp_cpu_nb);
 -
  #ifdef CONFIG_HOTPLUG_CPU
- 	rc =3D sysdev_class_create_file(&cpu_sysdev_class, &attr_rescan);
+ 	rc =3D device_create_file(cpu_subsys.dev_root, &dev_attr_rescan);
  	if (rc)
  		return rc;
  #endif

--Signature=_Wed__28_Dec_2011_17_26_11_+1100_KD0==_Z5wuwC_ngX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+raDAAoJEECxmPOUX5FEShQP/iq+IC+25HgeIyGhcsA9TgkL
dVP+nN9417jfrTV4ZvLkxVmDnhOOz7yJh9/xtNY5I+9Ao0ySNx3naMiZZQd4eUgn
0L4FL+BdGhSeFzSrwxRfziW/TE1sKuB/+BPq880EPElotpJ5r5UJRpRj3ZPtHDS+
JaBoGRyTPiPXvwPouml1/PwJbYJdRhHdNSGgNwiciVld64gk/rOkrPd985dvW7f3
tnFQlmaEQqyaLe9tdNqyJ4jfSzUjnkC6XFqsB9+V04Abc3D/mNOeFzD7bwUAXFyo
0eURA5xpdt/lpISwIsJJBHFItyUjnDSr7/iliISqHIaXM+BstSCP2pmb6SufhNYi
Bmr3JspKDoGjqUoIrPYjnp/9FJOwy9G09SwJYReBu/kS6cl19Hskxd6577GSwzL/
oK90gDw+CzYy5zcSQ/5Feo2LGliESjju9/XKXFLS9zpJ3VCgQQwLiEuHBwIGvitE
ZRN7jX85D7S0l0sTKYAahd41LU7nwIvSB8p2RTkEIbCoKcGx5z1znLRXfgyIezHV
mOFNdDyvSso0BiAacdAHBG+psGMfYt7vj4ZkRHqWXK/yOLel/U+qih+Qk8Oh+Js5
A4NATTxbSK3bAb6eJOLAIm74x8wYhuJOXk6hgQMV+Sn84gmFMjZ25pVuOLlCdCvR
JfMEOdsh5vJOFJk3FXCC
=q3gA
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_17_26_11_+1100_KD0==_Z5wuwC_ngX--
