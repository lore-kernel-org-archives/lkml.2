Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2IXN3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:29:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2IXN3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:29:34 -0400
Date: Mon, 24 Sep 2012 23:29:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Kelly <alex.page.kelly@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20120924232926.fb112c6db45baba74a6224b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_23_29_26_+1000_fLC/xTfCYvdb.1uN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_23_29_26_+1000_fLC/xTfCYvdb.1uN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/exec.c
between commits b40b89c2da16 ("new helper: replace_fd()") and
be28f112a5e5 ("do_coredump(): make sure that descriptor table isn't
shared") from the vfs tree and commit "coredump: move core dump
functionality into its own file" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/exec.c
index 6b2e20b,d9bd87b..0000000
--- a/fs/exec.c
+++ b/fs/exec.c
diff --git a/fs/coredump.c b/fs/coredump.c
index 9692329..6ef9888 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -438,23 +438,14 @@ static void wait_for_dump_helpers(struct file *file)
 static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 {
 	struct file *files[2];
-	struct fdtable *fdt;
 	struct coredump_params *cp =3D (struct coredump_params *)info->data;
-	struct files_struct *cf =3D current->files;
 	int err =3D create_pipe_files(files, 0);
 	if (err)
 		return err;
=20
 	cp->file =3D files[1];
=20
-	sys_close(0);
-	fd_install(0, files[0]);
-	spin_lock(&cf->file_lock);
-	fdt =3D files_fdtable(cf);
-	__set_open_fd(0, fdt);
-	__clear_close_on_exec(0, fdt);
-	spin_unlock(&cf->file_lock);
-
+	replace_fd(0, files[0], 0);
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] =3D (struct rlimit){1, 1};
=20
@@ -472,6 +463,7 @@ void do_coredump(long signr, int exit_code, struct pt_r=
egs *regs)
 	int retval =3D 0;
 	int flag =3D 0;
 	int ispipe;
+	struct files_struct *displaced;
 	bool need_nonrelative =3D false;
 	static atomic_t core_dump_count =3D ATOMIC_INIT(0);
 	struct coredump_params cprm =3D {
@@ -625,6 +617,12 @@ void do_coredump(long signr, int exit_code, struct pt_=
regs *regs)
 			goto close_fail;
 	}
=20
+	/* get us an unshared descriptor table; almost always a no-op */
+	retval =3D unshare_files(&displaced);
+	if (retval)
+		goto close_fail;
+	if (displaced)
+		put_files_struct(displaced);
 	retval =3D binfmt->core_dump(&cprm);
 	if (retval)
 		current->signal->group_exit_code |=3D 0x80;

--Signature=_Mon__24_Sep_2012_23_29_26_+1000_fLC/xTfCYvdb.1uN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYGA2AAoJEECxmPOUX5FEGhkP/jTK+pXANaXNjdLFbrHBfTiF
5/KPV2Kc+j8tldNQuQ99XpatHyRo2s0EjR/K6UfnywpqaH1Rjc9WZN0HeLTvlznK
dOfbTlbmtUhrZECd/5hVkujTwKLBZG5DC/NqHZIODkrXSw/WILqWSRR69PbWe8DU
k7z//yiOMo2PuV1kn1O495UlfpLtKcfJQYfgXr7SHpSLDXhq2fFiGGP5FPEtkYiK
TSgocbyxLkZvB/FNUJHwEzb+Uv6UmhKtsfJgbM+2z/323fdlyLgkZkwaPAn8yipH
4l/rC1vCf/58tjaU1AlhSEqYMaItbwCE6C4oAZLccv8OqsHIammY297IxwrO7ZSp
/o2t9fGxN+zbrs4TS19T6hM2HvcMDzvq6sY8s2/oUAFyIOiVSLkJOP1Mh26GjFKu
NXc3oxe10fVyEQzDvj1nNGsmAqYXU2cnBxfwOJVpzX5y6U1H2nu5uHd2Zm6/3LXl
RoBlRPKf93FLlCvRJkQT0e5dnIJjGwlZCSPfSaXXP6rA4gc2K6aZHdmLehXaw52v
47VRUYx4Hq95oAAyjNykw4UO1SdMiSMWaFhsaeHfs+Gjxj/lHkCCtQwcg89O7uS2
LfvBsmVQp6aj450mvMgOwjZVmqmh44qEr1juEqgYxoiQIK02Dtu5zMzGNbnRazHE
HgQxRFnU1LMc1Ty7DPTN
=inex
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_23_29_26_+1000_fLC/xTfCYvdb.1uN--
