Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2EONAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:00:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:44806 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649Ab2EONAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:00:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="140845361"
Message-ID: <1337087022.2528.204.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: read crypto_lookup from datanodes to znodes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 16:03:42 +0300
In-Reply-To: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-K9g9HOZ7WRo4pvg+AHHx"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K9g9HOZ7WRo4pvg+AHHx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 11:01 +0200, Joel Reardon wrote:
> Crypto_lookup values are now oppertunistically read from the data node he=
ader whenever a data
> node is read from flash and cached in the TNC. The value will be zero unt=
il it
> is read from flash. (If it is needed before it happens to be loaded, i.e.=
, to
> delete a node, then it will be forced read.)
>=20
> It was tested by setting cryptolookup values for new datanodes by their l=
num
> and offset on flash. This was later asserted in the TNC that they were ei=
ther
> zero, or always equal. On mounting, the TNC crypto lookup values were
> confirmed to be zero and later, after reading the corresponding files,
> confirmed they were loaded and corresponded to the location on flash.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
> ---
>  fs/ubifs/gc.c          |    8 +++++++-
>  fs/ubifs/journal.c     |    9 ++++++---
>  fs/ubifs/tnc.c         |   40 ++++++++++++++++++++++++++++++++++++++++
>  fs/ubifs/ubifs-media.h |    3 ++-
>  4 files changed, 55 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
> index f146447..16df2f4 100644
> --- a/fs/ubifs/gc.c
> +++ b/fs/ubifs/gc.c
> @@ -322,15 +322,21 @@ static int move_node(struct ubifs_info *c, struct u=
bifs_scan_leb *sleb,
>  		     struct ubifs_scan_node *snod, struct ubifs_wbuf *wbuf)
>  {
>  	int err, new_lnum =3D wbuf->lnum, new_offs =3D wbuf->offs + wbuf->used;
> +	long long crypto_lookup =3D 0;
>=20
>  	cond_resched();
>  	err =3D ubifs_wbuf_write_nolock(wbuf, snod->node, snod->len);
>  	if (err)
>  		return err;
>=20
> +	if (key_type(c, &snod->key) =3D=3D UBIFS_DATA_KEY) {
> +		struct ubifs_data_node *dn =3D
> +			(struct ubifs_data_node *) snod->node;

We do not cast void *.

> +		crypto_lookup =3D le64_to_cpu(dn->crypto_lookup);
> +	}
>  	err =3D ubifs_tnc_replace(c, &snod->key, sleb->lnum,
>  				snod->offs, new_lnum, new_offs,
> -				snod->len, 0);
> +				snod->len, crypto_lookup);
>  	list_del(&snod->list);
>  	kfree(snod);
>  	return err;
> diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
> index 2072b9a..3f7aa05 100644
> --- a/fs/ubifs/journal.c
> +++ b/fs/ubifs/journal.c
> @@ -89,7 +89,6 @@ static inline void zero_dent_node_unused(struct ubifs_d=
ent_node *dent)
>   */
>  static inline void zero_data_node_unused(struct ubifs_data_node *data)
>  {
> -	data->padding0 =3D 0;
>  	memset(data->padding1, 0, 2);
>  }
>=20
> @@ -735,6 +734,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const =
struct inode *inode,
>=20
>  	dlen =3D UBIFS_DATA_NODE_SZ + out_len;
>  	data->compr_type =3D cpu_to_le16(compr_type);
> +	data->crypto_lookup =3D cpu_to_le64(0);
>=20
>  	/* Make reservation before allocating sequence numbers */
>  	err =3D make_reservation(c, DATAHD, dlen);
> @@ -742,12 +742,14 @@ int ubifs_jnl_write_data(struct ubifs_info *c, cons=
t struct inode *inode,
>  		goto out_free;
>=20
>  	err =3D write_node(c, DATAHD, data, dlen, &lnum, &offs);
> +
>  	if (err)

Please, do not add junk newlines.

>  		goto out_release;
>  	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
>  	release_head(c, DATAHD);
>=20
> -	err =3D ubifs_tnc_add(c, key, lnum, offs, dlen, 0);
> +	err =3D ubifs_tnc_add(c, key, lnum, offs, dlen,
> +			    le64_to_cpu(data->crypto_lookup));
>  	if (err)
>  		goto out_ro;
>=20
> @@ -1226,7 +1228,8 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const =
struct inode *inode,
>=20
>  	if (dlen) {
>  		sz =3D offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
> -		err =3D ubifs_tnc_add(c, &key, lnum, sz, dlen, 0);
> +		err =3D ubifs_tnc_add(c, &key, lnum, sz, dlen,
> +				    le64_to_cpu(dn->crypto_lookup));
>  		if (err)
>  			goto out_ro;
>  	}
> diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
> index b222a72..ac0d03c 100644
> --- a/fs/ubifs/tnc.c
> +++ b/fs/ubifs/tnc.c
> @@ -1431,6 +1431,35 @@ static int maybe_leb_gced(struct ubifs_info *c, in=
t lnum, int gc_seq1)
>  }
>=20
>  /**
> + * tnc_set_crypto_lookup - set the crypto_lookup field in a zbranch.
> + * @c: UBIFS file-system description object
> + * @zbr: the crypto_lookup field is set in this zbranch
> + * @node: a pointer to a node containing the zbranch.
> + *
> + * Crypto_lookup values are stored on flash memory inside the data node.
> + * When the system is running, they should be oppertunistically stored i=
n

What do you mean by "oppertunistically stored" ? Should be
"opportunistically", but my concern is that we _always_ initialize this
when read, not by opportunity.

> + * memory inside the zbranch. This function is called whenever a node
> + * is read from flash memory. If @node is a data node (therefore contain=
ing a
> + * @crypto_lookup field), then:
> + * if @zbr has an unset @crypto_lookup, set it to the value from @node
> + * if @zbr has already a @crypto_lookup, assert they are the same.
> + */
> +static void tnc_set_crypto_lookup(struct ubifs_info *c,
> +				  struct ubifs_zbranch *zbr, void *node)
> +{
> +	if (key_type(c, &(zbr->key)) =3D=3D UBIFS_DATA_KEY) {
> +		struct ubifs_data_node *dn =3D
> +			(struct ubifs_data_node *) node;

No cast.
> +		if (zbr->crypto_lookup !=3D 0) {

No braces.

> +			ubifs_assert(zbr->crypto_lookup =3D=3D
> +				     le64_to_cpu(dn->crypto_lookup));
> +		} else {

Please, introduce a temporary variable for crypto_lookup instead.

--=20
Best Regards,
Artem Bityutskiy

--=-K9g9HOZ7WRo4pvg+AHHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPslQuAAoJECmIfjd9wqK0YegQANIZmCOO6+EE1WT1YDQimAmp
+H7aRRHFd5kJw0/RvtBhv7FFIniLxd8DlAvRmLRAtr3Me5Clw3sTzDEF2Ndf2ZGO
ELy1bL/y3tSzfDw1jgWcgnDAMNx1cZwHmnB2Na9QO9njfkV/vSDTi0CsRMaVkXSa
ww/QPQkl0om2Xi9naus4NiAvbApYmiZXwLYGJUzsNW+svhjcMd4Bee26JoAspqXQ
1LFE4Tg0aUwZ1Y3E+1jYhzedTPaOTsrEdkmePfzBypFWUHPSliHSwBBJPdQpV6Wm
dJ8xl4af6wjoi5mbQbPHPKKfFWn2lmNRKPwRYjzkW1LdYcnQli+SqDEFSep4hXoZ
Ba2f4ZZwQL+JTeXY9SBM4ZCS+dbfhPR3oZoFjoS1eKJIz1YGNpt50Ud409jfGCxK
Irgg6eFUbZUuLOiDb97L74lDuThs+u9scQM+AbcjI6/Kx6SmJVD14XeHGa/KU9ig
+yBRHyhIOnEaKQ3OoFnbc3FS1hks7Zrz6RdxBTsKfdhDmXBZ40WPuaqV1lPxndFT
om+lKA1bfEueM2gmzpKDJUcI1jbMLwr2INIR0fJh71tKuhMXcjHQLjmMKIem23Aq
gp99hM+oXa+EY8BnC3KwnkLLIM7NIagrDFsIoDwIazYttRa5x0DqP1GSM/Jd42C2
U3DaCeXxqORU3avM6tmZ
=PSiS
-----END PGP SIGNATURE-----

--=-K9g9HOZ7WRo4pvg+AHHx--

