Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab0HLMr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:47:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35894 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979Ab0HLMrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sKfFeDIPNnXTEpW2DmQbwl4djy2rk5WlBrC0K4xfqcYzavRMQc3vdkggHfPsLqnRgV
         MFKjKQFivNRbVV5J9sGS7xspsLenZfb9MbtZr/eMuVtSpQdE5LFuVj8mDhxtEOBE90eI
         uFr94YG1XfuUFAm9GAt+O9vuuq2ZjQlJ3rmMc=
Date: Thu, 12 Aug 2010 15:51:56 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: using smp_processor_id() in preemptible [00000000] code
Message-ID: <20100812125156.GA12274@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Got this error today:
[13874.228704] BUG: using smp_processor_id() in preemptible [00000000] code=
: bash/10661
[13874.228715] caller is thermal_throttle_add_dev+0x20/0xa4
[13874.228721] Pid: 10661, comm: bash Not tainted 2.6.36-rc0-git11-07631-gf=
a34556-dirty #109
[13874.228725] Call Trace:
[13874.228738]  [<ffffffff811f6285>] debug_smp_processor_id+0xc9/0xe4
[13874.228744]  [<ffffffff8136ccac>] thermal_throttle_add_dev+0x20/0xa4
[13874.228750]  [<ffffffff8136cd82>] thermal_throttle_cpu_callback+0x52/0xb5
[13874.228759]  [<ffffffff81057198>] notifier_call_chain+0x32/0x5e
[13874.228767]  [<ffffffff8103c818>] ? cpu_maps_update_begin+0x12/0x14
[13874.228774]  [<ffffffff810571e3>] __raw_notifier_call_chain+0x9/0xb
[13874.228780]  [<ffffffff8103c6db>] __cpu_notify+0x1b/0x2d
[13874.228786]  [<ffffffff8136eeb2>] _cpu_up+0x6b/0xe9
[13874.228792]  [<ffffffff8136ef7a>] cpu_up+0x4a/0x57
[13874.228799]  [<ffffffff813638b7>] store_online+0x41/0x6e
[13874.228807]  [<ffffffff8129186b>] sysdev_store+0x1b/0x1d
[13874.228816]  [<ffffffff8113188e>] sysfs_write_file+0x103/0x13f
[13874.228824]  [<ffffffff810da5ff>] vfs_write+0xb1/0x14e
[13874.228830]  [<ffffffff810da898>] sys_write+0x45/0x6c
[13874.228840]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b


My first though was:

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu=
/mcheck/therm_throt.c
index c2a8b26..1269661 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -205,7 +205,9 @@ static int therm_throt_process(bool new_event, int even=
t, int level)
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
 {
 	int err;
-	struct cpuinfo_x86 *c =3D &cpu_data(smp_processor_id());
+	int cpu =3D get_cpu();
+	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
+	put_cpu();
=20
 	err =3D sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)



My second though was - should we call smp_processor_id/get_id in thermal_th=
rottle_add_dev?
We know cpu when calling thermal_throttle_add_dev (in thermal_throttle_cpu_=
callback and=20
thermal_throttle_init_device), so we can pass cpu when calling it.=20
My second though was:


diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu=
/mcheck/therm_throt.c
index c2a8b26..bcd8499 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,11 +202,12 @@ static int therm_throt_process(bool new_event, int ev=
ent, int level)
=20
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+				unsigned int cpu)
 {
 	int err;
-	struct cpuinfo_x86 *c =3D &cpu_data(smp_processor_id());
-
+	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
+=09
 	err =3D sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)
 		return err;
@@ -251,7 +252,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nf=
b,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err =3D thermal_throttle_add_dev(sys_dev);
+		err =3D thermal_throttle_add_dev(sys_dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -287,7 +288,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err =3D thermal_throttle_add_dev(get_cpu_sysdev(cpu));
+		err =3D thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU



Which one is the correct?


	Sergey

--DocE+STaALJfprDB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxj7mwACgkQfKHnntdSXjS7xAP9GKic1i66EB/nVcGnvqYwPYhg
qqTEVVBkwp/yhGgmQjVytwi1mecKK4PWwoPLPQTxUtO0si0yoXm57fHrtukBWgXb
EikP44fznF/YuRKNjWU2e1tLl2vL8FEvP66tVoxCnaQTTAKKS4lCvLPEald39leu
2RB7Iv2kj/lLF4F4obM=
=XJfs
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
