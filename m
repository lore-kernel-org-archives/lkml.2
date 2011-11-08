Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1KHDYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:24:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59757 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1KHDYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:24:41 -0500
Date: Tue, 8 Nov 2011 14:24:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>, Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20111108142432.c27531efb6b6f8518e2555a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Nov_2011_14_24_32_+1100_0xwVUgiEQnMTsJm0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Nov_2011_14_24_32_+1100_0xwVUgiEQnMTsJm0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/idle/intel_idle.c between commit 46bcfad7a819 ("cpuidle:
Single/Global registration of idle states") from Linus' tree and commit
"intel_idle: fix API misuse" from the akpm tree.

The former moved the code modified by the latter.  I fixed it up (see
below0 and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/idle/intel_idle.c
index 5d2f8e1,0a53882..0000000
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@@ -424,60 -398,6 +424,60 @@@ static void intel_idle_cpuidle_devices_
  	return;
  }
  /*
 + * intel_idle_cpuidle_driver_init()
 + * allocate, initialize cpuidle_states
 + */
 +static int intel_idle_cpuidle_driver_init(void)
 +{
 +	int cstate;
 +	struct cpuidle_driver *drv =3D &intel_idle_driver;
 +
 +	drv->state_count =3D 1;
 +
 +	for (cstate =3D 1; cstate < MWAIT_MAX_NUM_CSTATES; ++cstate) {
 +		int num_substates;
 +
 +		if (cstate > max_cstate) {
 +			printk(PREFIX "max_cstate %d reached\n",
 +				max_cstate);
 +			break;
 +		}
 +
 +		/* does the state exist in CPUID.MWAIT? */
 +		num_substates =3D (mwait_substates >> ((cstate) * 4))
 +					& MWAIT_SUBSTATE_MASK;
 +		if (num_substates =3D=3D 0)
 +			continue;
 +		/* is the state not enabled? */
 +		if (cpuidle_state_table[cstate].enter =3D=3D NULL) {
 +			/* does the driver not know about the state? */
 +			if (*cpuidle_state_table[cstate].name =3D=3D '\0')
 +				pr_debug(PREFIX "unaware of model 0x%x"
 +					" MWAIT %d please"
 +					" contact lenb@kernel.org",
 +				boot_cpu_data.x86_model, cstate);
 +			continue;
 +		}
 +
 +		if ((cstate > 2) &&
 +			!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 +			mark_tsc_unstable("TSC halts in idle"
 +					" states deeper than C2");
 +
 +		drv->states[drv->state_count] =3D	/* structure copy */
 +			cpuidle_state_table[cstate];
 +
 +		drv->state_count +=3D 1;
 +	}
 +
 +	if (auto_demotion_disable_flags)
- 		smp_call_function(auto_demotion_disable, NULL, 1);
++		on_each_cpu(auto_demotion_disable, NULL, 1);
 +
 +	return 0;
 +}
 +
 +
 +/*
   * intel_idle_cpuidle_devices_init()
   * allocate, initialize, register cpuidle_devices
   */

--Signature=_Tue__8_Nov_2011_14_24_32_+1100_0xwVUgiEQnMTsJm0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuKDwAAoJEECxmPOUX5FE8NEQAJUtpA4t5zSeD+2+tUOSCP8O
BsO9zNpmDhQD33/urTSOECQ7Ym3SsMfT1/AaaB2EYd8aVivqA2UdmzHbFtucnvjL
VfpZcZUMkb3aUfpN8NqNFUPE8BxZshxvAgFRWMHgoeyh1CCPdYFStYDUrTf4WAZp
pqEbyunlx2CbkPQNiaUGft5h0oQkCeXaNKCIIyhMKHJa8mfyNBrlpROdV32dPTPJ
C27hDY/IigNBRJ/tvx5mur4OYcZajyOPqqAi1XI67kf5IJD4vq6nprGUyF2AjyD1
mPjR5En3xMinONF/UyU078qQUjRkOG3Kh/66D8iyZibnPghlrrLpH8nK6FtvWbFa
cF8D6neaS62Aanf3B7qrYChC37QtqSLiSSC7y3k2aIz7YBwvjcMk57ZeWy4OB7xi
n8ahSXNWj71MWHtjnL2rPZrfX9qPREz2+PKah5+BO5SuEGqbTQLa7io1HGEXAg38
jMWl+uUCygieSMn1J8JtUM1edEH8zmnC1HzRS/gPPaA6kQ4OZ/DmTzwfshjHq1Qe
t+D4jh1jGVWFW+W4NJwmKW5fLGusRhJZFRE6ugXk+6nhJWR3azsQiNhdvsEKqjw3
jkCOekoj8BkHFbcpWp6MYeK89CDGTbSytmJs1/QE/MulXRUVvnGGmJ1rYDgpqVHl
cGeRdCrJOSevWXlfqKn9
=NZnJ
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Nov_2011_14_24_32_+1100_0xwVUgiEQnMTsJm0--
