Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967039Ab2EOXN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 19:13:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39957 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966655Ab2EOXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 19:13:27 -0400
Message-ID: <4FB2E30C.4010304@gmail.com>
Date: Wed, 16 May 2012 01:13:16 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 7/8] Support non-BMP characters in NTFS.
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig17987F5F05BB965A2AEF1985"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig17987F5F05BB965A2AEF1985
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

ntfs-3g supports non-BMP characters just fine. This patch make standard r=
ead-only driver work as well.
Patch is bigger than required since checkpatch.pl asked me to restructure=
 the code to avoid overlong lines.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/ntfs/unistr.c |   70 ++++++++++++++++++++++++++++++++----------------=
------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/fs/ntfs/unistr.c b/fs/ntfs/unistr.c
index 0d371e7..79f82d2 100644
--- a/fs/ntfs/unistr.c
+++ b/fs/ntfs/unistr.c
@@ -265,33 +265,35 @@ int ntfs_nlstoucs(const ntfs_volume *vol, const cha=
r *ins,
 	int i, o, wc_len;
=20
 	/* We do not trust outside sources. */
-	if (likely(ins)) {
-		ucs =3D kmem_cache_alloc(ntfs_name_cache, GFP_NOFS);
-		if (likely(ucs)) {
-			for (i =3D o =3D 0; i < ins_len; i +=3D wc_len) {
-				wc_len =3D nls->char2uni(ins + i, ins_len - i,
-						&wc);
-				if (likely(wc_len >=3D 0 && wc <=3D 0xffff
-					   && o < NTFS_MAX_NAME_LEN)) {
-					if (likely(wc)) {
-						ucs[o++] =3D cpu_to_le16(wc);
-						continue;
-					} /* else if (!wc) */
-					break;
-				} /* else if (wc_len < 0 ||
-						o >=3D NTFS_MAX_NAME_LEN) */
-				goto name_err;
-			}
-			ucs[o] =3D 0;
-			*outs =3D ucs;
-			return o;
-		} /* else if (!ucs) */
-		ntfs_error(vol->sb, "Failed to allocate buffer for converted "
-				"name from ntfs_name_cache.");
+	if (unlikely(!ins)) {
+		ntfs_error(vol->sb, "Received NULL pointer.");
+		return -EINVAL;
+	}
+
+	ucs =3D kmem_cache_alloc(ntfs_name_cache, GFP_NOFS);
+	if (unlikely(!ucs)) {
+		ntfs_error(vol->sb,
+			   "Failed to allocate buffer for converted "
+			   "name from ntfs_name_cache.");
 		return -ENOMEM;
-	} /* else if (!ins) */
-	ntfs_error(vol->sb, "Received NULL pointer.");
-	return -EINVAL;
+	}
+
+	for (i =3D o =3D 0; i < ins_len; i +=3D wc_len) {
+		int s;
+		wc_len =3D nls->char2uni(ins + i, ins_len - i, &wc);
+		if (unlikely(wc_len < 0 || o >=3D NTFS_MAX_NAME_LEN))
+			goto name_err;
+		if (unlikely(!wc))
+			break;
+		s =3D unicode_to_utf16s(wc, UTF16_LITTLE_ENDIAN, ucs + o,
+				      NTFS_MAX_NAME_LEN - o);
+		if (s <=3D 0)
+			break;
+		o +=3D s;
+	}
+	ucs[o] =3D 0;
+	*outs =3D ucs;
+	return o;
 name_err:
 	kmem_cache_free(ntfs_name_cache, ucs);
 	if (wc_len < 0) {
@@ -342,6 +344,7 @@ int ntfs_ucstonls(const ntfs_volume *vol, const ntfsc=
har *ins,
=20
 	/* We don't trust outside sources. */
 	if (ins) {
+		int step;
 		ns =3D *outs;
 		ns_len =3D outs_len;
 		if (ns && !ns_len) {
@@ -354,9 +357,18 @@ int ntfs_ucstonls(const ntfs_volume *vol, const ntfs=
char *ins,
 			if (!ns)
 				goto mem_err_out;
 		}
-		for (i =3D o =3D 0; i < ins_len; i++) {
-retry:			wc =3D nls->uni2char(le16_to_cpu(ins[i]), ns + o,
-					ns_len - o);
+		for (i =3D o =3D 0; i < ins_len; i +=3D step) {
+			unicode_t uni;
+retry:
+			step =3D utf16s_to_unicode(ins + i, ins_len - i,
+						 UTF16_LITTLE_ENDIAN,
+						 &uni);
+			if (step <=3D 0) {
+				uni =3D le16_to_cpu(ins[i]);
+				step =3D 1;
+			}
+
+			wc =3D nls->uni2char(uni, ns + o, ns_len - o);
 			if (wc > 0) {
 				o +=3D wc;
 				continue;
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig17987F5F05BB965A2AEF1985
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4wwACgkQNak7dOguQgmbGgEAtXIc3s16KZnm5wpxwuZajtxK
jR5ckAYbiv23+5lKuI4A/1Vsb8CLIsfTKNxqgKAEBZGXU4B5AcOkr8VB5C1P9lLy
=JSea
-----END PGP SIGNATURE-----

--------------enig17987F5F05BB965A2AEF1985--
