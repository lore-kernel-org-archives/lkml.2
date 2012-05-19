Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab2ESLe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:34:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41212 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab2ESLew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:34:52 -0400
Message-ID: <1337427288.2041.24.camel@koala>
Subject: Re: [PATCH v3] UBIFS: read crypto_lookup from datanodes to znodes
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 19 May 2012 14:34:48 +0300
In-Reply-To: <alpine.DEB.2.00.1205191027340.18672@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net>
	 <1337087022.2528.204.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205161451250.27131@eristoteles.iwoars.net>
	 <alpine.DEB.2.00.1205191027340.18672@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tXOBn6EoCO/iejn4utao"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tXOBn6EoCO/iejn4utao
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-19 at 10:30 +0200, Joel Reardon wrote:
> Crypto_lookup values are now read from the data node header whenever a
> data node is read from flash and cached in the TNC. The value will be zer=
o
> until it is read from flash. (If it is needed before it happens to be
> loaded, i.e., to delete a node, then it will be forced read.)
>=20
> It was tested by setting cryptolookup values for new datanodes by their
> lnum and offset on flash. This was later asserted in the TNC that they
> were either zero, or always equal. On mounting, the TNC crypto lookup
> values were confirmed to be zero and later, after reading the
> corresponding files, confirmed they were loaded and corresponded to the
> location on flash.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>

I've pushed this patch with minor amendments to the "joel" branch, and
I've applied the renaming patch on top (it also change some logic a bit
to make it more compact) - if you do not like that patch - complain,
I'll remove it. Also I have a request below. Thanks!

> diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
> index 9ecbd37..e03adcf 100644
> --- a/fs/ubifs/ubifs-media.h
> +++ b/fs/ubifs/ubifs-media.h
> @@ -539,6 +539,7 @@ struct ubifs_dent_node {
>   * struct ubifs_data_node - data node.
>   * @ch: common header
>   * @key: node key
> + * @crypto_lookup: the node's cryptographic key's position in the KSA
>   * @size: uncompressed data size in bytes
>   * @compr_type: compression type (%UBIFS_COMPR_NONE, %UBIFS_COMPR_LZO, e=
tc)
>   * @padding: reserved for future, zeroes
> @@ -550,7 +551,7 @@ struct ubifs_dent_node {
>  struct ubifs_data_node {
>  	struct ubifs_ch ch;
>  	__u8 key[UBIFS_KEY_LEN];
> -	__le64 padding0; /* Watch 'zero_data_node_unused()' if changing! */
> +	__le64 crypto_lookup;
>  	__le32 size;
>  	__le16 compr_type;
>  	__u8 padding1[2]; /* Watch 'zero_data_node_unused()' if changing! */

This file is copied to user-space (mtd-utils.git) and I try to keep it
well-documented. Could you please extend 'struct ubifs_data_node' coment
and explain that older versions of UBIFS did not have secure deletion
support and the 'crypto_lookup' field contained all zeroes.

The patch I've applied on top:

=46rom 87c912b858520939da9ef9e258b01a6fe85a342b Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 19 May 2012 14:23:01 +0300
Subject: [PATCH] UBIFS: rename crypto_lookup

Rename 'crypto_lookup' to 'ksa_pos' in order to has shorter lines - the old
name is too long. Also makes code around assertions in the node reading
function a bit more compact.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ubifs/gc.c          |    6 +++---
 fs/ubifs/journal.c     |    4 ++--
 fs/ubifs/tnc.c         |   33 ++++++++++++++-------------------
 fs/ubifs/tnc_misc.c    |   10 ++++------
 fs/ubifs/ubifs-media.h |    4 ++--
 fs/ubifs/ubifs.h       |    8 ++++----
 6 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 4a21358..6c84af3 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -322,7 +322,7 @@ static int move_node(struct ubifs_info *c, struct ubifs=
_scan_leb *sleb,
 		     struct ubifs_scan_node *snod, struct ubifs_wbuf *wbuf)
 {
 	int err, new_lnum =3D wbuf->lnum, new_offs =3D wbuf->offs + wbuf->used;
-	long long crypto_lookup =3D 0;
+	long long ksa_pos =3D 0;
=20
 	cond_resched();
 	err =3D ubifs_wbuf_write_nolock(wbuf, snod->node, snod->len);
@@ -332,11 +332,11 @@ static int move_node(struct ubifs_info *c, struct ubi=
fs_scan_leb *sleb,
 	if (key_type(c, &snod->key) =3D=3D UBIFS_DATA_KEY) {
 		struct ubifs_data_node *dn =3D snod->node;
=20
-		crypto_lookup =3D le64_to_cpu(dn->crypto_lookup);
+		ksa_pos =3D le64_to_cpu(dn->ksa_pos);
 	}
 	err =3D ubifs_tnc_replace(c, &snod->key, sleb->lnum,
 				snod->offs, new_lnum, new_offs,
-				snod->len, crypto_lookup);
+				snod->len, ksa_pos);
 	list_del(&snod->list);
 	kfree(snod);
 	return err;
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index bd69a30..d1c21d1 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -734,7 +734,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const st=
ruct inode *inode,
=20
 	dlen =3D UBIFS_DATA_NODE_SZ + out_len;
 	data->compr_type =3D cpu_to_le16(compr_type);
-	data->crypto_lookup =3D cpu_to_le64(0);
+	data->ksa_pos =3D cpu_to_le64(0);
=20
 	/* Make reservation before allocating sequence numbers */
 	err =3D make_reservation(c, DATAHD, dlen);
@@ -1227,7 +1227,7 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const st=
ruct inode *inode,
 	if (dlen) {
 		sz =3D offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
 		err =3D ubifs_tnc_add(c, &key, lnum, sz, dlen,
-				    le64_to_cpu(dn->crypto_lookup));
+				    le64_to_cpu(dn->ksa_pos));
 		if (err)
 			goto out_ro;
 	}
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index b36d01c..d9de581 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -499,8 +499,8 @@ static int try_read_node(const struct ubifs_info *c, vo=
id *buf, int type,
  *
  * This function tries to read a node and returns %1 if the node is read, =
%0
  * if the node is not present, and a negative error code in the case of er=
ror.
- * It sets @zbr's @crypto_lookup field to the value in the read node if it=
 is
- * a data node.
+ * It sets @zbr's @ksa_pos field to the value in the read node if it is a =
data
+ * node.
  */
 static int fallible_read_node(struct ubifs_info *c, const union ubifs_key =
*key,
 			      struct ubifs_zbranch *zbr, void *node)
@@ -520,17 +520,12 @@ static int fallible_read_node(struct ubifs_info *c, c=
onst union ubifs_key *key,
 		if (keys_cmp(c, key, &node_key) !=3D 0)
 			ret =3D 0;
=20
-		/* If it is actually a data node, read the @crypto_lookup */
+		/* If it is actually a data node, read the @ksa_pos */
 		if (key_type(c, key) =3D=3D UBIFS_DATA_KEY) {
-			long long crypto_lookup;
+			long long ksa_pos =3D le64_to_cpu(dn->ksa_pos);
=20
-			crypto_lookup =3D le64_to_cpu(dn->crypto_lookup);
-			if (zbr->crypto_lookup !=3D 0)
-				ubifs_assert(zbr->crypto_lookup =3D=3D
-					     crypto_lookup);
-			else
-				zbr->crypto_lookup =3D
-					crypto_lookup;
+			ubifs_assert(!zbr->ksa_pos || zbr->ksa_pos =3D=3D ksa_pos);
+			zbr->ksa_pos =3D ksa_pos;
 		}
=20
 	}
@@ -2176,14 +2171,14 @@ do_split:
  * @lnum: LEB number of node
  * @offs: node offset
  * @len: node length
- * @crypto_lookup: the node's cryptographic key's position in the KSA
+ * @ksa_pos: the node's cryptographic key's position in the KSA
  *
  * This function adds a node with key @key to TNC. The node may be new or =
it may
  * obsolete some existing one. Returns %0 on success or negative error cod=
e on
  * failure.
  */
 int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int ln=
um,
-		  int offs, int len, long long crypto_lookup)
+		  int offs, int len, long long ksa_pos)
 {
 	int found, n, err =3D 0;
 	struct ubifs_znode *znode;
@@ -2198,7 +2193,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union u=
bifs_key *key, int lnum,
 		zbr.lnum =3D lnum;
 		zbr.offs =3D offs;
 		zbr.len =3D len;
-		zbr.crypto_lookup =3D crypto_lookup;
+		zbr.ksa_pos =3D ksa_pos;
 		key_copy(c, key, &zbr.key);
 		err =3D tnc_insert(c, znode, &zbr, n + 1);
 	} else if (found =3D=3D 1) {
@@ -2209,7 +2204,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union u=
bifs_key *key, int lnum,
 		zbr->lnum =3D lnum;
 		zbr->offs =3D offs;
 		zbr->len =3D len;
-		zbr->crypto_lookup =3D crypto_lookup;
+		zbr->ksa_pos =3D ksa_pos;
 	} else
 		err =3D found;
 	if (!err)
@@ -2228,7 +2223,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union u=
bifs_key *key, int lnum,
  * @lnum: LEB number of node
  * @offs: node offset
  * @len: node length
- * @crypto_lookup: the node's updated cryptographic key's position in the =
KSA
+ * @ksa_pos: the node's updated cryptographic key's position in the KSA
  *
  * This function replaces a node with key @key in the TNC only if the old =
node
  * is found.  This function is called by garbage collection when node are =
moved.
@@ -2236,7 +2231,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union u=
bifs_key *key, int lnum,
  */
 int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
 		      int old_lnum, int old_offs, int lnum, int offs, int len,
-		      long long crypto_lookup)
+		      long long ksa_pos)
 {
 	int found, n, err =3D 0;
 	struct ubifs_znode *znode;
@@ -2262,7 +2257,7 @@ int ubifs_tnc_replace(struct ubifs_info *c, const uni=
on ubifs_key *key,
 			zbr->lnum =3D lnum;
 			zbr->offs =3D offs;
 			zbr->len =3D len;
-			zbr->crypto_lookup =3D crypto_lookup;
+			zbr->ksa_pos =3D ksa_pos;
 			found =3D 1;
 		} else if (is_hash_key(c, key)) {
 			found =3D resolve_collision_directly(c, key, &znode, &n,
@@ -2500,7 +2495,7 @@ static int tnc_delete(struct ubifs_info *c, struct ub=
ifs_znode *znode, int n)
 			c->zroot.lnum =3D zbr->lnum;
 			c->zroot.offs =3D zbr->offs;
 			c->zroot.len =3D zbr->len;
-			c->zroot.crypto_lookup =3D zbr->crypto_lookup;
+			c->zroot.ksa_pos =3D zbr->ksa_pos;
 			c->zroot.znode =3D znode;
 			ubifs_assert(!ubifs_zn_obsolete(zp));
 			ubifs_assert(ubifs_zn_dirty(zp));
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index aa8a51d..169c9f3 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -309,7 +309,7 @@ static int read_znode(struct ubifs_info *c, int lnum, i=
nt offs, int len,
 		zbr->lnum =3D le32_to_cpu(br->lnum);
 		zbr->offs =3D le32_to_cpu(br->offs);
 		zbr->len  =3D le32_to_cpu(br->len);
-		zbr->crypto_lookup =3D 0;
+		zbr->ksa_pos =3D 0;
 		zbr->znode =3D NULL;
=20
 		/* Validate branch */
@@ -493,12 +493,10 @@ int ubifs_tnc_read_node(struct ubifs_info *c, struct =
ubifs_zbranch *zbr,
=20
 	if (key_type(c, &(zbr->key)) =3D=3D UBIFS_DATA_KEY) {
 		struct ubifs_data_node *dn =3D node;
-		long long crypto_lookup =3D le64_to_cpu(dn->crypto_lookup);
+		long long ksa_pos =3D le64_to_cpu(dn->ksa_pos);
=20
-		if (zbr->crypto_lookup !=3D 0)
-			ubifs_assert(zbr->crypto_lookup =3D=3D crypto_lookup);
-		else
-			zbr->crypto_lookup =3D crypto_lookup;
+		ubifs_assert(!zbr->ksa_pos || zbr->ksa_pos =3D=3D ksa_pos);
+		zbr->ksa_pos =3D ksa_pos;
 	}
=20
 	return 0;
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index e03adcf..55f2ccd 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -539,7 +539,7 @@ struct ubifs_dent_node {
  * struct ubifs_data_node - data node.
  * @ch: common header
  * @key: node key
- * @crypto_lookup: the node's cryptographic key's position in the KSA
+ * @ksa_pos: the node's cryptographic key's position in the KSA
  * @size: uncompressed data size in bytes
  * @compr_type: compression type (%UBIFS_COMPR_NONE, %UBIFS_COMPR_LZO, etc=
)
  * @padding: reserved for future, zeroes
@@ -551,7 +551,7 @@ struct ubifs_dent_node {
 struct ubifs_data_node {
 	struct ubifs_ch ch;
 	__u8 key[UBIFS_KEY_LEN];
-	__le64 crypto_lookup;
+	__le64 ksa_pos;
 	__le32 size;
 	__le16 compr_type;
 	__u8 padding1[2]; /* Watch 'zero_data_node_unused()' if changing! */
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 4283a51..cf990e2 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -738,7 +738,7 @@ struct ubifs_jhead {
  * @lnum: LEB number of the target node (indexing node or data node)
  * @offs: target node offset within @lnum
  * @len: target node length
- * @crypto_lookup: the node's cryptographic key's position in the KSA
+ * @ksa_pos: the node's cryptographic key's position in the KSA
  */
 struct ubifs_zbranch {
 	union ubifs_key key;
@@ -749,7 +749,7 @@ struct ubifs_zbranch {
 	int lnum;
 	int offs;
 	int len;
-	long long crypto_lookup;
+	long long ksa_pos;
 };
=20
 /**
@@ -1577,10 +1577,10 @@ int ubifs_tnc_lookup_nm(struct ubifs_info *c, const=
 union ubifs_key *key,
 int ubifs_tnc_locate(struct ubifs_info *c, const union ubifs_key *key,
 		     void *node, int *lnum, int *offs);
 int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int ln=
um,
-		  int offs, int len, long long crypto_lookup);
+		  int offs, int len, long long ksa_pos);
 int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
 		      int old_lnum, int old_offs, int lnum, int offs, int len,
-		      long long crypto_lookup);
+		      long long ksa_pos);
 int ubifs_tnc_add_nm(struct ubifs_info *c, const union ubifs_key *key,
 		     int lnum, int offs, int len, const struct qstr *nm);
 int ubifs_tnc_remove(struct ubifs_info *c, const union ubifs_key *key);
--=20
1.7.7.6


--=20
Best Regards,
Artem Bityutskiy

--=-tXOBn6EoCO/iejn4utao
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt4VYAAoJECmIfjd9wqK0I6oQAIDmte0LbC1KxwmqbbgXilUY
zbLPm7mjFG4DmMkdSvKY48jzdong7Xj2rA7dzGqM9TQI201/lLMAzg26CUwTyA2K
fz7ZjvF4RhSWHVrDypPBEl10y0wx8LZ5d3Gp8UgH9TCqwdWT4Ni+JotDFP3m/m+L
Q4QL5g1qr7tIxYOd90kJFbCMIiyLWprx6ewOwoqV1d3qYod00OKN0Gp5AUyRV42h
+99ckIl4yhRMk7Iy1v1R29Y5o02bv1/wZJeGHlajiqBMHMVMfZyf0M4WD7Ww0P0L
HUiUYnrYWYNtXOGCZ4OFjcxOKGGQok192KthKVYvM7N37/2FKzi+Ypp5kI87OmVa
nE7MeJ56nu3bFgsyF7aMJVGe06Sju2ROPl22Id5UF2c1Gu4ETsnlnExAe8HQm+9f
MgWiCCHanjrMI5YFd052rQoiz0uf7dDBQuYbTQCHa0hwi6yr2PaDp0Ko2slwElDj
8xD+bnbnXGk3UOaH5uhEXUCtI8AgUXf4xW4iKw9PZSJ1KCUHk1lHLeotkJR7sy7u
MIiJ9g+tltpKIOAxtwoF5hXyzBONlTnMBqzu7s3Wt5tXJPCN/3IgKi8lRotGBNfP
mICp24Jbr4I/mpiWqgRA+eaIvo80NvOTC5MHAJpxBTzjfxDuHul3oGyTqns5CjZJ
ZaUn5Sh4Ip6ftUc2NIkY
=dLAg
-----END PGP SIGNATURE-----

--=-tXOBn6EoCO/iejn4utao--

