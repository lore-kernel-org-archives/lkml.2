Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab2CMGhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:37:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53066 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2CMGhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:37:21 -0400
Date: Tue, 13 Mar 2012 17:37:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20120313173712.52ecb636a1e3d4330fe8baff@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_17_37_12_+1100_A20iJuBGM5sdxh6."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_17_37_12_+1100_A20iJuBGM5sdxh6.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
tools/perf/util/header.c tools/perf/util/header.h between commit
330aa675b4f9 ("perf record: Add HEADER_BRANCH_STACK tag") from the tip
tree and commit c415f577eb32 ("perf tools: Add pmu mappings to header
information") from the oprofile tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc tools/perf/util/header.c
index 0d9b6da,626eb90..0000000
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@@ -1321,12 -1372,37 +1388,43 @@@ static void print_cpuid(struct perf_hea
  	free(str);
  }
 =20
 +static void print_branch_stack(struct perf_header *ph __used, int fd __us=
ed,
 +			       FILE *fp)
 +{
 +	fprintf(fp, "# contains samples with branch stack\n");
 +}
 +
+ static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
+ {
+ 	const char *delimiter =3D "# pmu mappings: ";
+ 	char *name;
+ 	int ret;
+ 	u32 pmu_num;
+ 	u32 type;
+=20
+ 	ret =3D read(fd, &pmu_num, sizeof(pmu_num));
+ 	if (ret !=3D sizeof(pmu_num))
+ 		goto error;
+=20
+ 	if (!pmu_num)
+ 		goto error;
+=20
+ 	while (pmu_num--) {
+ 		if (read(fd, &type, sizeof(type)) !=3D sizeof(type))
+ 			goto error;
+ 		name =3D do_read_string(fd, ph);
+ 		fprintf(fp, "%s%s =3D %" PRIu32, delimiter, name, type);
+ 		free(name);
+ 		delimiter =3D ", ";
+ 	}
+=20
+ 	fprintf(fp, "\n");
+=20
+ 	return;
+ error:
+ 	fprintf(fp, "# pmu mappings: not available\n");
+ }
+=20
  static int __event_process_build_id(struct build_id_event *bev,
  				    char *filename,
  				    struct perf_session *session)
@@@ -1531,7 -1607,7 +1629,8 @@@ static const struct feature_ops feat_op
  	FEAT_OPA(HEADER_CMDLINE,	cmdline),
  	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
  	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 +	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
+ 	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
  };
 =20
  struct header_print_data {
diff --cc tools/perf/util/header.h
index 21a6be0,9b4d407..0000000
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@@ -27,7 -27,8 +27,8 @@@ enum=20
  	HEADER_EVENT_DESC,
  	HEADER_CPU_TOPOLOGY,
  	HEADER_NUMA_TOPOLOGY,
 +	HEADER_BRANCH_STACK,
+ 	HEADER_PMU_MAPPINGS,
 -
  	HEADER_LAST_FEATURE,
  	HEADER_FEAT_BITS	=3D 256,
  };

--Signature=_Tue__13_Mar_2012_17_37_12_+1100_A20iJuBGM5sdxh6.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXusYAAoJEECxmPOUX5FEZpIP/RZd/S2mo8kRPMGFuJfBPwmZ
XwJwRGlC+p8B/5TyUW6WOqkipkQvmqt5hMww5yRbfUO/+ROBuhUgUl5wZb8SijGU
IZRaBHDpXx9tTjApVBUNbeQMi9Q5qbJ/CywR92IM5FHbSYc/EFPjXryQOP96OJi8
Lh5vDedD1jKiJqYxGuHFomhbA+p6F8JVCNdrAsMK+LB55epQjLpVd0XJL1y0p/RZ
zvY9Feg3mK4qsGAnoy4fIDngh+9FuPH4ivy3Zg2Ai8AJocEyWnd3m1qH2y821DLU
n+pXZDHHW42a0my2yIp5UTJgyS5BbHwIBvQmbe2ucX2Yvz95W2siShDjzLttLjB8
giSF//ZcM2w0ouSrtHec09yp+UQav12os3JFn5kmgqyeULzvnP3j4UFwdgzNhB7P
lszpFK473Ftl3YM8r8pqLn+m99aBrMl/keJZxuiedCzSUEv8g3UTAEddFRn2eQM5
vAc9x2eb2N3BWCcFGRMt3sX0nNxeIlTnkBXOw+ZQShDwTt+Vu+sb/EBdX/gq/Aig
+cX790dsJoZdrKVGG8oNmjXTItUsgyysjp4qOdrcEy9lphjjU6pJRo8SVEJlx419
lmlarJlT76Xb3x524g8VzOtXWDqGW4rmgR9sTnV14UiB+nJte6weOIUcdFYrrGM8
+zrv74KLnJ2TYkYemNFp
=NpIo
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_17_37_12_+1100_A20iJuBGM5sdxh6.--
