Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab2DPFDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:03:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45184 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2DPFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:03:15 -0400
Date: Mon, 16 Apr 2012 15:02:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        James Morris <jmorris@namei.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: linux-next: manual merge of the akpm with the security tree
Message-Id: <20120416150258.273e076e2d6e3b847d3dd9ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_15_02_58_+1000_f8Y0j_ITuQS3NWC9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_15_02_58_+1000_f8Y0j_ITuQS3NWC9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got conflicts in kernel/sys.c
and include/linux/prctl.h between commit 259e5e6c75a9 ("Add PR_{GET,SET}
_NO_NEW_PRIVS to prevent execve from granting privs") from the security
tree and patch "c/r: prctl: add ability to get clear_tid_address" from
the akpm tree.

I fixed them up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/prctl.h
index 711e0a3,ecbe30e..0000000
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@@ -130,19 -130,6 +130,21 @@@
  #define PR_SET_CHILD_SUBREAPER 36
  #define PR_GET_CHILD_SUBREAPER 37
 =20
 -#define PR_GET_TID_ADDRESS     38
 +/*
 + * If no_new_privs is set, then operations that grant new privileges (i.e.
 + * execve) will either fail or not grant them.  This affects suid/sgid,
 + * file capabilities, and LSMs.
 + *
 + * Operations that merely manipulate or drop existing privileges (setresu=
id,
 + * capset, etc.) will still work.  Drop those privileges if you want them=
 gone.
 + *
 + * Changing LSM security domain is considered a new privilege.  So, for e=
xample,
 + * asking selinux for a specific new context (e.g. with runcon) will resu=
lt
 + * in execve returning -EPERM.
 + */
 +#define PR_SET_NO_NEW_PRIVS 38
 +#define PR_GET_NO_NEW_PRIVS 39
 +
++#define PR_GET_TID_ADDRESS     40
+=20
  #endif /* _LINUX_PRCTL_H */
diff --cc kernel/sys.c
index 500c885,1d57adf..0000000
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@@ -2082,16 -2092,9 +2092,19 @@@ SYSCALL_DEFINE5(prctl, int, option, uns
  			error =3D put_user(me->signal->is_child_subreaper,
  					 (int __user *) arg2);
  			break;
 +		case PR_SET_NO_NEW_PRIVS:
 +			if (arg2 !=3D 1 || arg3 || arg4 || arg5)
 +				return -EINVAL;
 +
 +			current->no_new_privs =3D 1;
 +			break;
 +		case PR_GET_NO_NEW_PRIVS:
 +			if (arg2 || arg3 || arg4 || arg5)
 +				return -EINVAL;
 +			return current->no_new_privs ? 1 : 0;
+ 		case PR_GET_TID_ADDRESS:
+ 			error =3D prctl_get_tid_address(me, (int __user **)arg2);
+ 			break;
  		default:
  			error =3D -EINVAL;
  			break;

--Signature=_Mon__16_Apr_2012_15_02_58_+1000_f8Y0j_ITuQS3NWC9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi6gCAAoJEECxmPOUX5FEAQoQAKpsIgUw4gpKGjGGAWbkBkP4
oFzI5J5rvPhT33RsZDSt7tEPJhp8e7fOPriKq9eyLNWLg7pYGxJCt7o24CXFJvzz
99vf8RrAPCxD7lgk7mL6dnaWwFn9TJ4UNoGpr81UXvheztnsxW6DuODtuRRVK8/r
GOuh73VbAAedZmHW9tAugCv3vB5jiiRdfZCZRlXS0rcv2HRzno62g9KwoUKAu1Wq
eSve9S0duqI1oC4FRBhb6NT1IhP8GuXPqxd/oVtqMTaHDygeNxIZvm55lmnaASSG
atnPkPyOYzXV+oy7qIaJoJhcW7r/WdSYArK4HkBgAMp2spDL16gOOMkJWFEa1NhR
gZHZS9MS/7DVhE2PoHbaDtohYnQDp4/ntaiXuepbhTa9yQBBaUdLdgdmUk5EHBLm
RytH4w4LGiElGnNwy1efUk/enJqVwNsHUGF90I8uA8mQ1fzjCt+3HbOVcGrQeLO0
Gk07y9/9ehJVUMGwBnFay9p9e4zxwFGvqfVrVaGB8AhAxX5hBg/OyDIt58KF4cPF
RT0E3Ddud0z97nR3pD9s+aVp/tNd4TTNRD+fcyfRZQw4/Cyoffb27IgpcypLcwBd
iCXBKz4NCm5YyjJZcmwMX4On2s4AEvFzUsvYdh+a8SVsZvmHy1cZU6Cbw2GZTfVW
Wawv3cin0xF0DNcPQBtc
=pcq3
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_15_02_58_+1000_f8Y0j_ITuQS3NWC9--
