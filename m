Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2JQAll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 20:41:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45325 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2JQAlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 20:41:39 -0400
Date: Wed, 17 Oct 2012 11:41:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20121017114128.898aac160643d3224ac8a975@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Oct_2012_11_41_28_+1100_Jh3vhzj7isP+d77J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Oct_2012_11_41_28_+1100_Jh3vhzj7isP+d77J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got conflicts in
security/keys/keyring.c and security/keys/process_keys.c between commit
9a56c2db49e7 ("userns: Convert security/keys to the new userns
infrastructure") from Linus' tree and commit 96b5c8fea6c0 ("KEYS: Reduce
initial permissions on keys") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc security/keys/keyring.c
index 6e42df1,9270ba0..0000000
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@@ -256,9 -256,9 +256,9 @@@ error
  /*
   * Allocate a keyring and link into the destination keyring.
   */
 -struct key *keyring_alloc(const char *description, uid_t uid, gid_t gid,
 +struct key *keyring_alloc(const char *description, kuid_t uid, kgid_t gid,
- 			  const struct cred *cred, unsigned long flags,
- 			  struct key *dest)
+ 			  const struct cred *cred, key_perm_t perm,
+ 			  unsigned long flags, struct key *dest)
  {
  	struct key *keyring;
  	int ret;
diff --cc security/keys/process_keys.c
index a58f712,b58d938..0000000
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@@ -45,15 -46,15 +45,17 @@@ int install_user_keyrings(void
  	struct user_struct *user;
  	const struct cred *cred;
  	struct key *uid_keyring, *session_keyring;
+ 	key_perm_t user_keyring_perm;
  	char buf[20];
  	int ret;
 +	uid_t uid;
 =20
+ 	user_keyring_perm =3D (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_ALL;
  	cred =3D current_cred();
  	user =3D cred->user;
 +	uid =3D from_kuid(cred->user_ns, user->uid);
 =20
 -	kenter("%p{%u}", user, user->uid);
 +	kenter("%p{%u}", user, uid);
 =20
  	if (user->uid_keyring) {
  		kleave(" =3D 0 [exist]");
@@@ -72,9 -73,9 +74,9 @@@
 =20
  		uid_keyring =3D find_keyring_by_name(buf, true);
  		if (IS_ERR(uid_keyring)) {
 -			uid_keyring =3D keyring_alloc(buf, user->uid, (gid_t) -1,
 +			uid_keyring =3D keyring_alloc(buf, user->uid, INVALID_GID,
- 						    cred, KEY_ALLOC_IN_QUOTA,
- 						    NULL);
+ 						    cred, user_keyring_perm,
+ 						    KEY_ALLOC_IN_QUOTA, NULL);
  			if (IS_ERR(uid_keyring)) {
  				ret =3D PTR_ERR(uid_keyring);
  				goto error;
@@@ -88,8 -89,9 +90,9 @@@
  		session_keyring =3D find_keyring_by_name(buf, true);
  		if (IS_ERR(session_keyring)) {
  			session_keyring =3D
 -				keyring_alloc(buf, user->uid, (gid_t) -1,
 +				keyring_alloc(buf, user->uid, INVALID_GID,
- 					      cred, KEY_ALLOC_IN_QUOTA, NULL);
+ 					      cred, user_keyring_perm,
+ 					      KEY_ALLOC_IN_QUOTA, NULL);
  			if (IS_ERR(session_keyring)) {
  				ret =3D PTR_ERR(session_keyring);
  				goto error_release;

--Signature=_Wed__17_Oct_2012_11_41_28_+1100_Jh3vhzj7isP+d77J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQff64AAoJEECxmPOUX5FE57sP/1Vg8oJv8KWci3xRlJrbKZ3A
HHYg8njqt8azfB7NX7TEbK1ZmeXIsAMt8wKoonzla1BJM98XI1VDXmslToqpVUhW
nJ+JRuZdI7iiWukTChlrnz9YUdUh+OHBy/iLh+WsozsjMeiF9sEmzbytryvzoaNK
PIS2HdPQDjHWBY1Aqo1/gQmktzrWuDTs5yqAES802nOB02w3nuCNq0TNhc7YsMHu
+s4NovPLbmYuS+yRtDHSNg6coK+Fx4FoHDvH6Y5GocveUMpVkXF3LtRiAfbA2aS4
6mHyLCOtzDRyTb9KwFF/XximXEyY8ORecgMguUTPFpIYJze8Moe5wiLYK4LXpB6v
n/LRmv9lEo6RBNcK0Cd23rxI6juZA+GMcd5IPEaNpV+sn31Ym8X16Tn3bw2+fifo
R/F5kCWN6n5+g5l8E/L4B5BYgw2TgfJPQYf7eGask3qkVArXZvSWJZGsSk6JGi91
XDx/HqUxZJUTmR4lq1USTixNWHObPcFgVx4HdRbnN7qe60IoT+ww5OSmPhox/y81
sxFjyD9JO/u38qRb0wSLTTdPSpcxU4s/p/3nD8GSRCHorOrGcZz8jDVM/CthXVtE
ZFReaRUnM23IJyT39zJn2D1XRGpVN3yvQwoA1s5bdK1Ogxzx9+4qjyLL3FcgnJP6
A68yfrv6xMMZTFh8bBaK
=PY1+
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Oct_2012_11_41_28_+1100_Jh3vhzj7isP+d77J--
