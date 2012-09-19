Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2ISD4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:56:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35193 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2ISD4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:56:38 -0400
Date: Wed, 19 Sep 2012 13:56:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andre Przywara <andre.przywara@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the workqueues tree with the pm tree
Message-Id: <20120919135625.875ebc4d68279b26f2375150@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_13_56_25_+1000_3tHAfk+Vu0sfBOJk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_13_56_25_+1000_3tHAfk+Vu0sfBOJk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
drivers/cpufreq/powernow-k8.c between commit e1f0b8e9b04a ("cpufreq:
Remove support for hardware P-state chips from powernow-k8") from the pm
tree and commit 5d7efe7bf90f ("cpufreq/powernow-k8: workqueue user
shouldn't migrate the kworker to another CPU") from the workqueues tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpufreq/powernow-k8.c
index 0b19faf,1a40935..0000000
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@@ -978,11 -1104,52 +977,18 @@@ static int transition_frequency_fidvid(
  	return res;
  }
 =20
- /* Driver entry point to switch to the target frequency */
- static int powernowk8_target(struct cpufreq_policy *pol,
- 		unsigned targfreq, unsigned relation)
 -/* Take a frequency, and issue the hardware pstate transition command */
 -static int transition_frequency_pstate(struct powernow_k8_data *data,
 -		unsigned int index)
 -{
 -	u32 pstate =3D 0;
 -	int res, i;
 -	struct cpufreq_freqs freqs;
 -
 -	pr_debug("cpu %d transition to index %u\n", smp_processor_id(), index);
 -
 -	/* get MSR index for hardware pstate transition */
 -	pstate =3D index & HW_PSTATE_MASK;
 -	if (pstate > data->max_hw_pstate)
 -		return -EINVAL;
 -
 -	freqs.old =3D find_khz_freq_from_pstate(data->powernow_table,
 -			data->currpstate);
 -	freqs.new =3D find_khz_freq_from_pstate(data->powernow_table, pstate);
 -
 -	for_each_cpu(i, data->available_cores) {
 -		freqs.cpu =3D i;
 -		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 -	}
 -
 -	res =3D transition_pstate(data, pstate);
 -	freqs.new =3D find_khz_freq_from_pstate(data->powernow_table, pstate);
 -
 -	for_each_cpu(i, data->available_cores) {
 -		freqs.cpu =3D i;
 -		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 -	}
 -	return res;
 -}
 -
+ struct powernowk8_target_arg {
+ 	struct cpufreq_policy		*pol;
+ 	unsigned			targfreq;
+ 	unsigned			relation;
+ };
+=20
+ static long powernowk8_target_fn(void *arg)
  {
- 	cpumask_var_t oldmask;
+ 	struct powernowk8_target_arg *pta =3D arg;
+ 	struct cpufreq_policy *pol =3D pta->pol;
+ 	unsigned targfreq =3D pta->targfreq;
+ 	unsigned relation =3D pta->relation;
  	struct powernow_k8_data *data =3D per_cpu(powernow_data, pol->cpu);
  	u32 checkfid;
  	u32 checkvid;
@@@ -1017,17 -1171,20 +1010,17 @@@
  		pol->cpu, targfreq, pol->min, pol->max, relation);
 =20
  	if (query_current_values_with_pending_wait(data))
- 		goto err_out;
+ 		return -EIO;
 =20
 -	if (cpu_family !=3D CPU_HW_PSTATE) {
 -		pr_debug("targ: curr fid 0x%x, vid 0x%x\n",
 -		data->currfid, data->currvid);
 +	pr_debug("targ: curr fid 0x%x, vid 0x%x\n",
 +		 data->currfid, data->currvid);
 =20
 -		if ((checkvid !=3D data->currvid) ||
 -		    (checkfid !=3D data->currfid)) {
 -			printk(KERN_INFO PFX
 -				"error - out of sync, fix 0x%x 0x%x, "
 -				"vid 0x%x 0x%x\n",
 -				checkfid, data->currfid,
 -				checkvid, data->currvid);
 -		}
 +	if ((checkvid !=3D data->currvid) ||
 +	    (checkfid !=3D data->currfid)) {
 +		pr_info(PFX
 +		       "error - out of sync, fix 0x%x 0x%x, vid 0x%x 0x%x\n",
 +		       checkfid, data->currfid,
 +		       checkvid, data->currvid);
  	}
 =20
  	if (cpufreq_frequency_table_target(pol, data->powernow_table,
@@@ -1038,23 -1195,42 +1031,35 @@@
 =20
  	powernow_k8_acpi_pst_values(data, newstate);
 =20
 -	if (cpu_family =3D=3D CPU_HW_PSTATE)
 -		ret =3D transition_frequency_pstate(data,
 -			data->powernow_table[newstate].index);
 -	else
 -		ret =3D transition_frequency_fidvid(data, newstate);
 +	ret =3D transition_frequency_fidvid(data, newstate);
 +
  	if (ret) {
  		printk(KERN_ERR PFX "transition frequency failed\n");
- 		ret =3D 1;
  		mutex_unlock(&fidvid_mutex);
- 		goto err_out;
+ 		return 1;
  	}
  	mutex_unlock(&fidvid_mutex);
 =20
 -	if (cpu_family =3D=3D CPU_HW_PSTATE)
 -		pol->cur =3D find_khz_freq_from_pstate(data->powernow_table,
 -				data->powernow_table[newstate].index);
 -	else
 -		pol->cur =3D find_khz_freq_from_fid(data->currfid);
 +	pol->cur =3D find_khz_freq_from_fid(data->currfid);
- 	ret =3D 0;
 =20
- err_out:
- 	set_cpus_allowed_ptr(current, oldmask);
- 	free_cpumask_var(oldmask);
- 	return ret;
+ 	return 0;
+ }
+=20
+ /* Driver entry point to switch to the target frequency */
+ static int powernowk8_target(struct cpufreq_policy *pol,
+ 		unsigned targfreq, unsigned relation)
+ {
+ 	struct powernowk8_target_arg pta =3D { .pol =3D pol, .targfreq =3D targf=
req,
+ 					     .relation =3D relation };
+=20
+ 	/*
+ 	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
+ 	 * that we're bound to the current CPU and pol->cpu stays online.
+ 	 */
+ 	if (smp_processor_id() =3D=3D pol->cpu)
+ 		return powernowk8_target_fn(&pta);
+ 	else
+ 		return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
  }
 =20
  /* Driver entry point to verify the policy and range of frequencies */

--Signature=_Wed__19_Sep_2012_13_56_25_+1000_3tHAfk+Vu0sfBOJk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWUJpAAoJEECxmPOUX5FEcmYP/RGC3vGjPxH6GgBX93STeFTD
Lng2QNVuy1KKZ+JFAav8+RZQveb8gC9xSSDFLwFp/VBoGeNQYLhrpvHD1PUI9iPo
X2JJTID+2sZxnB5QFdR4zDJF4PyyxHwX7VvGiFK0XSjrauNrVaI3qEsWpq2XrzsD
Ceiw/XtdtnZ135wSAGRFNpRWkWFBVsWeJg9ow7u05X4oAp3xhfJO/b9mE6yAjM+O
dCqgExdXjFpCIZkJ4tVWx9DYjIbXI/vzf2qMxEFH5Y536+beAjBdEVJAqzT88A1l
UG2QYZeuZCAJyVOKn5y2voMzmsfnbBlUMc90KDVOQ/pYyqpo8rWj3FQ/p869/1zT
gpUPGG8edlT614ylyT+MYaTxJ+bEnethUt41ho9ne8uK8YO0XszTPR6PjX8ZPk7/
WNw6Jb/I13LkQ618gS9DwKfSaI+unkGJJqFqv8UiQMaNPggiDfNT/8dWbqymesRl
2dAtVy+7uEPsXI80C+Souz3HiDiM66X1fYxgluoija/VH5qChTt/ayriHhgGjTHc
AAkDAgl+QpD2GIOOPtyNEBHeU1B16ma9+00hUAvFHftlpa1SGAAmV8XDfniQ7gY4
2HeFqr9Vlg+iKXXVrWYzTWDrt8LvQc6rPq96t4xeU81WTQKw9BCBmLquUiFY+3Tx
FDQLJ8bUbKjqgHEcSMo5
=SGtc
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_13_56_25_+1000_3tHAfk+Vu0sfBOJk--
