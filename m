Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2FABKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:10:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59433 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2FABKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:10:25 -0400
Message-ID: <4FC8167F.60807@gmail.com>
Date: Fri, 01 Jun 2012 03:10:23 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] Eliminate UDF duplication
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig40F99240D839B07F77916802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig40F99240D839B07F77916802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I don't insist on this one as I find dedicated UTF-8-UTF-16 neater,
simple, easier to understand and faster. However it seems that for
maintenance and compatibility reasons it's preferable for it to go.
If you want to keep it I'll adjust my next patch.

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/udf/Kconfig   |    5 --
 fs/udf/super.c   |   47 +++++--------
 fs/udf/udf_sb.h  |    2 -
 fs/udf/udfdecl.h |    3 +-
 fs/udf/unicode.c |  206 +++---------------------------------------------=
------
 5 files changed, 28 insertions(+), 235 deletions(-)

diff --git a/fs/udf/Kconfig b/fs/udf/Kconfig
index 0e0e99b..bbc8e60 100644
--- a/fs/udf/Kconfig
+++ b/fs/udf/Kconfig
@@ -11,8 +11,3 @@ config UDF_FS
 	  module will be called udf.
=20
 	  If unsure, say N.
-
-config UDF_NLS
-	bool
-	default y
-	depends on (UDF_FS=3Dm && NLS) || (UDF_FS=3Dy && NLS=3Dy)
diff --git a/fs/udf/super.c b/fs/udf/super.c
index ac8a348..e165142 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -296,9 +296,7 @@ static int udf_show_options(struct seq_file *seq, str=
uct dentry *root)
 	 * volume, partition, fileset and rootdir seem to be ignored
 	 * currently
 	 */
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
-		seq_puts(seq, ",utf8");
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
+	if (sbi->s_nls_map)
 		seq_printf(seq, ",iocharset=3D%s", sbi->s_nls_map->charset);
=20
 	return 0;
@@ -515,14 +513,11 @@ static int udf_parse_options(char *options, struct =
udf_options *uopt,
 			uopt->rootdir =3D option;
 			break;
 		case Opt_utf8:
-			uopt->flags |=3D (1 << UDF_FLAG_UTF8);
+			uopt->nls_map =3D load_nls("utf8");
 			break;
-#ifdef CONFIG_UDF_NLS
 		case Opt_iocharset:
 			uopt->nls_map =3D load_nls(args[0].from);
-			uopt->flags |=3D (1 << UDF_FLAG_NLS_MAP);
 			break;
-#endif
 		case Opt_uignore:
 			uopt->flags |=3D (1 << UDF_FLAG_UID_IGNORE);
 			break;
@@ -806,16 +801,18 @@ static int udf_load_pvoldesc(struct super_block *sb=
, sector_t block)
 #endif
 	}
=20
-	if (!udf_build_ustr(instr, pvoldesc->volIdent, 32))
-		if (udf_CS0toUTF8(outstr, instr)) {
+	if (!udf_build_ustr(instr, pvoldesc->volIdent,
+			    32 * NLS_MAX_CHARSET_SIZE))
+		if (udf_CS0toNLS(UDF_SB(sb)->s_nls_map, outstr, instr)) {
 			strncpy(UDF_SB(sb)->s_volume_ident, outstr->u_name,
 				outstr->u_len > 31 ? 31 : outstr->u_len);
 			udf_debug("volIdent[] =3D '%s'\n",
 				  UDF_SB(sb)->s_volume_ident);
 		}
=20
-	if (!udf_build_ustr(instr, pvoldesc->volSetIdent, 128))
-		if (udf_CS0toUTF8(outstr, instr))
+	if (!udf_build_ustr(instr, pvoldesc->volSetIdent,
+			    128 * NLS_MAX_CHARSET_SIZE))
+		if (udf_CS0toNLS(UDF_SB(sb)->s_nls_map, outstr, instr))
 			udf_debug("volSetIdent[] =3D '%s'\n", outstr->u_name);
=20
 	brelse(bh);
@@ -1908,22 +1905,14 @@ static int udf_fill_super(struct super_block *sb,=
 void *options, int silent)
 	if (!udf_parse_options((char *)options, &uopt, false))
 		goto error_out;
=20
-	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
-	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
-		udf_err(sb, "utf8 cannot be combined with iocharset\n");
-		goto error_out;
-	}
-#ifdef CONFIG_UDF_NLS
-	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
+	if (!uopt.nls_map) {
 		uopt.nls_map =3D load_nls_default();
-		if (!uopt.nls_map)
-			uopt.flags &=3D ~(1 << UDF_FLAG_NLS_MAP);
-		else
-			udf_debug("Using default NLS map\n");
+		if (!uopt.nls_map) {
+			udf_err(sb, "Unable to load NLS");
+			goto error_out;
+		}
+		udf_debug("Using default NLS map\n");
 	}
-#endif
-	if (!(uopt.flags & (1 << UDF_FLAG_NLS_MAP)))
-		uopt.flags |=3D (1 << UDF_FLAG_UTF8);
=20
 	fileset.logicalBlockNum =3D 0xFFFFFFFF;
 	fileset.partitionReferenceNum =3D 0xFFFF;
@@ -2049,10 +2038,8 @@ error_out:
 	if (sbi->s_partitions)
 		for (i =3D 0; i < sbi->s_partitions; i++)
 			udf_free_partition(&sbi->s_partmaps[i]);
-#ifdef CONFIG_UDF_NLS
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (sbi->s_nls_map)
 		unload_nls(sbi->s_nls_map);
-#endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
@@ -2112,10 +2099,8 @@ static void udf_put_super(struct super_block *sb)
 	if (sbi->s_partitions)
 		for (i =3D 0; i < sbi->s_partitions; i++)
 			udf_free_partition(&sbi->s_partmaps[i]);
-#ifdef CONFIG_UDF_NLS
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
+	if (sbi->s_nls_map)
 		unload_nls(sbi->s_nls_map);
-#endif
 	if (!(sb->s_flags & MS_RDONLY))
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 42ad69a..6a4de63 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -21,8 +21,6 @@
 #define UDF_FLAG_UNDELETE		6
 #define UDF_FLAG_UNHIDE			7
 #define UDF_FLAG_VARCONV		8
-#define UDF_FLAG_NLS_MAP		9
-#define UDF_FLAG_UTF8			10
 #define UDF_FLAG_UID_FORGET     11    /* save -1 for uid to disk */
 #define UDF_FLAG_UID_IGNORE     12    /* use sb uid instead of on disk u=
id */
 #define UDF_FLAG_GID_FORGET     13
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index ebe1031..a4349e4 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -211,7 +211,8 @@ extern int udf_get_filename(struct super_block *, uin=
t8_t *, uint8_t *, int);
 extern int udf_put_filename(struct super_block *, const uint8_t *, uint8=
_t *,
 			    int);
 extern int udf_build_ustr(struct ustr *, dstring *, int);
-extern int udf_CS0toUTF8(struct ustr *, const struct ustr *);
+int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
+		 const struct ustr *ocu_i);
=20
 /* ialloc.c */
 extern void udf_free_inode(struct inode *);
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 9b1b2de..7df644d 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -80,178 +80,8 @@ static int udf_build_ustr_exact(struct ustr *dest, ds=
tring *ptr, int exactsize)
 	return 0;
 }
=20
-/*
- * udf_ocu_to_utf8
- *
- * PURPOSE
- *	Convert OSTA Compressed Unicode to the UTF-8 equivalent.
- *
- * PRE-CONDITIONS
- *	utf			Pointer to UTF-8 output buffer.
- *	ocu			Pointer to OSTA Compressed Unicode input buffer
- *				of size UDF_NAME_LEN bytes.
- * 				both of type "struct ustr *"
- *
- * POST-CONDITIONS
- *	<return>		Zero on success.
- *
- * HISTORY
- *	November 12, 1997 - Andrew E. Mileski
- *	Written, tested, and released.
- */
-int udf_CS0toUTF8(struct ustr *utf_o, const struct ustr *ocu_i)
-{
-	const uint8_t *ocu;
-	uint8_t cmp_id, ocu_len;
-	int i;
-
-	ocu_len =3D ocu_i->u_len;
-	if (ocu_len =3D=3D 0) {
-		memset(utf_o, 0, sizeof(struct ustr));
-		return 0;
-	}
-
-	cmp_id =3D ocu_i->u_cmpID;
-	if (cmp_id !=3D 8 && cmp_id !=3D 16) {
-		memset(utf_o, 0, sizeof(struct ustr));
-		pr_err("unknown compression code (%d) stri=3D%s\n",
-		       cmp_id, ocu_i->u_name);
-		return 0;
-	}
-
-	ocu =3D ocu_i->u_name;
-	utf_o->u_len =3D 0;
-	for (i =3D 0; (i < ocu_len) && (utf_o->u_len <=3D (UDF_NAME_LEN - 3));)=
 {
-
-		/* Expand OSTA compressed Unicode to Unicode */
-		uint32_t c =3D ocu[i++];
-		if (cmp_id =3D=3D 16)
-			c =3D (c << 8) | ocu[i++];
-
-		/* Compress Unicode to UTF-8 */
-		if (c < 0x80U)
-			utf_o->u_name[utf_o->u_len++] =3D (uint8_t)c;
-		else if (c < 0x800U) {
-			utf_o->u_name[utf_o->u_len++] =3D
-						(uint8_t)(0xc0 | (c >> 6));
-			utf_o->u_name[utf_o->u_len++] =3D
-						(uint8_t)(0x80 | (c & 0x3f));
-		} else {
-			utf_o->u_name[utf_o->u_len++] =3D
-						(uint8_t)(0xe0 | (c >> 12));
-			utf_o->u_name[utf_o->u_len++] =3D
-						(uint8_t)(0x80 |
-							  ((c >> 6) & 0x3f));
-			utf_o->u_name[utf_o->u_len++] =3D
-						(uint8_t)(0x80 | (c & 0x3f));
-		}
-	}
-	utf_o->u_cmpID =3D 8;
-
-	return utf_o->u_len;
-}
-
-/*
- *
- * udf_utf8_to_ocu
- *
- * PURPOSE
- *	Convert UTF-8 to the OSTA Compressed Unicode equivalent.
- *
- * DESCRIPTION
- *	This routine is only called by udf_lookup().
- *
- * PRE-CONDITIONS
- *	ocu			Pointer to OSTA Compressed Unicode output
- *				buffer of size UDF_NAME_LEN bytes.
- *	utf			Pointer to UTF-8 input buffer.
- *	utf_len			Length of UTF-8 input buffer in bytes.
- *
- * POST-CONDITIONS
- *	<return>		Zero on success.
- *
- * HISTORY
- *	November 12, 1997 - Andrew E. Mileski
- *	Written, tested, and released.
- */
-static int udf_UTF8toCS0(dstring *ocu, struct ustr *utf, int length)
-{
-	unsigned c, i, max_val, utf_char;
-	int utf_cnt, u_len;
-
-	memset(ocu, 0, sizeof(dstring) * length);
-	ocu[0] =3D 8;
-	max_val =3D 0xffU;
-
-try_again:
-	u_len =3D 0U;
-	utf_char =3D 0U;
-	utf_cnt =3D 0U;
-	for (i =3D 0U; i < utf->u_len; i++) {
-		c =3D (uint8_t)utf->u_name[i];
-
-		/* Complete a multi-byte UTF-8 character */
-		if (utf_cnt) {
-			utf_char =3D (utf_char << 6) | (c & 0x3fU);
-			if (--utf_cnt)
-				continue;
-		} else {
-			/* Check for a multi-byte UTF-8 character */
-			if (c & 0x80U) {
-				/* Start a multi-byte UTF-8 character */
-				if ((c & 0xe0U) =3D=3D 0xc0U) {
-					utf_char =3D c & 0x1fU;
-					utf_cnt =3D 1;
-				} else if ((c & 0xf0U) =3D=3D 0xe0U) {
-					utf_char =3D c & 0x0fU;
-					utf_cnt =3D 2;
-				} else if ((c & 0xf8U) =3D=3D 0xf0U) {
-					utf_char =3D c & 0x07U;
-					utf_cnt =3D 3;
-				} else if ((c & 0xfcU) =3D=3D 0xf8U) {
-					utf_char =3D c & 0x03U;
-					utf_cnt =3D 4;
-				} else if ((c & 0xfeU) =3D=3D 0xfcU) {
-					utf_char =3D c & 0x01U;
-					utf_cnt =3D 5;
-				} else {
-					goto error_out;
-				}
-				continue;
-			} else {
-				/* Single byte UTF-8 character (most common) */
-				utf_char =3D c;
-			}
-		}
-
-		/* Choose no compression if necessary */
-		if (utf_char > max_val) {
-			if (max_val =3D=3D 0xffU) {
-				max_val =3D 0xffffU;
-				ocu[0] =3D (uint8_t)0x10U;
-				goto try_again;
-			}
-			goto error_out;
-		}
-
-		if (max_val =3D=3D 0xffffU)
-			ocu[++u_len] =3D (uint8_t)(utf_char >> 8);
-		ocu[++u_len] =3D (uint8_t)(utf_char & 0xffU);
-	}
-
-	if (utf_cnt) {
-error_out:
-		ocu[++u_len] =3D '?';
-		printk(KERN_DEBUG pr_fmt("bad UTF-8 character\n"));
-	}
-
-	ocu[length - 1] =3D (uint8_t)u_len + 1;
-
-	return u_len + 1;
-}
-
-static int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
-			const struct ustr *ocu_i)
+int udf_CS0toNLS(struct nls_table *nls, struct ustr *utf_o,
+		 const struct ustr *ocu_i)
 {
 	const uint8_t *ocu;
 	uint8_t cmp_id, ocu_len;
@@ -350,21 +180,12 @@ int udf_get_filename(struct super_block *sb, uint8_=
t *sname, uint8_t *dname,
 	if (udf_build_ustr_exact(unifilename, sname, flen))
 		goto out2;
=20
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
-		if (!udf_CS0toUTF8(filename, unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname =3D %s\n",
-				  sname);
-			goto out2;
-		}
-	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, filename,
-				  unifilename)) {
-			udf_debug("Failed in udf_get_filename: sname =3D %s\n",
-				  sname);
-			goto out2;
-		}
-	} else
+	if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, filename,
+			  unifilename)) {
+		udf_debug("Failed in udf_get_filename: sname =3D %s\n",
+			  sname);
 		goto out2;
+	}
=20
 	len =3D udf_translate_to_linux(dname, filename->u_name, filename->u_len=
,
 				     unifilename->u_name, unifilename->u_len);
@@ -384,16 +205,9 @@ int udf_put_filename(struct super_block *sb, const u=
int8_t *sname,
 	if (!udf_char_to_ustr(&unifilename, sname, flen))
 		return 0;
=20
-	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
-		namelen =3D udf_UTF8toCS0(dname, &unifilename, UDF_NAME_LEN);
-		if (!namelen)
-			return 0;
-	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		namelen =3D udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname,
-					&unifilename, UDF_NAME_LEN);
-		if (!namelen)
-			return 0;
-	} else
+	namelen =3D udf_NLStoCS0(UDF_SB(sb)->s_nls_map, dname,
+			       &unifilename, UDF_NAME_LEN);
+	if (!namelen)
 		return 0;
=20
 	return namelen;
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig40F99240D839B07F77916802
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk/IFn8ACgkQNak7dOguQgmiXAD+LICV+SaFrj0nTM8VLo9urbpr
3Hl1JoqszXMZSHRCi6IA/1HyQCJl+Fi51fo8Q00+3bsBF9IAfGozv8I0mqdNXcUI
=E1fI
-----END PGP SIGNATURE-----

--------------enig40F99240D839B07F77916802--
