Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2JBFrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:47:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2JBFrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:47:03 -0400
Date: Mon, 1 Oct 2012 22:46:56 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [ 026/180] eCryptfs: Improve statfs reporting
Message-ID: <20121002054655.GA17360@boyd>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225158.719221314@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20121001225158.719221314@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-10-02 00:52:23, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.

Hi - Please drop this patch. It incorrectly calculates f_namelen and I
haven't had a chance to fix it yet. When I get a fix ready, I'll forward
the corrected patch to stable@v.k.o. Thanks!

Tyler

>=20
> ------------------
>=20
> From: Tyler Hicks <tyhicks@canonical.com>
>=20
> commit 4a26620df451ad46151ad21d711ed43e963c004e upstream.
>=20
> BugLink: http://bugs.launchpad.net/bugs/885744
>=20
> statfs() calls on eCryptfs files returned the wrong filesystem type and,
> when using filename encryption, the wrong maximum filename length.
>=20
> If mount-wide filename encryption is enabled, the cipher block size and
> the lower filesystem's max filename length will determine the max
> eCryptfs filename length. Pre-tested, known good lengths are used when
> the lower filesystem's namelen is 255 and a cipher with 8 or 16 byte
> block sizes is used. In other, less common cases, we fall back to a safe
> rounded-down estimate when determining the eCryptfs namelen.
>=20
> https://launchpad.net/bugs/885744
>=20
> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
> Reported-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: John Johansen <john.johansen@canonical.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/ecryptfs/crypto.c          |   68 +++++++++++++++++++++++++++++++++++=
+----
>  fs/ecryptfs/ecryptfs_kernel.h |   11 ++++++
>  fs/ecryptfs/keystore.c        |    9 ++---
>  fs/ecryptfs/super.c           |   18 ++++++++++-
>  4 files changed, 92 insertions(+), 14 deletions(-)
>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index 7e164bb..7786bf6 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -2039,6 +2039,17 @@ out:
>  	return;
>  }
> =20
> +static size_t ecryptfs_max_decoded_size(size_t encoded_size)
> +{
> +	/* Not exact; conservatively long. Every block of 4
> +	 * encoded characters decodes into a block of 3
> +	 * decoded characters. This segment of code provides
> +	 * the caller with the maximum amount of allocated
> +	 * space that @dst will need to point to in a
> +	 * subsequent call. */
> +	return ((encoded_size + 1) * 3) / 4;
> +}
> +
>  /**
>   * ecryptfs_decode_from_filename
>   * @dst: If NULL, this function only sets @dst_size and returns. If
> @@ -2057,13 +2068,7 @@ ecryptfs_decode_from_filename(unsigned char *dst, =
size_t *dst_size,
>  	size_t dst_byte_offset =3D 0;
> =20
>  	if (dst =3D=3D NULL) {
> -		/* Not exact; conservatively long. Every block of 4
> -		 * encoded characters decodes into a block of 3
> -		 * decoded characters. This segment of code provides
> -		 * the caller with the maximum amount of allocated
> -		 * space that @dst will need to point to in a
> -		 * subsequent call. */
> -		(*dst_size) =3D (((src_size + 1) * 3) / 4);
> +		(*dst_size) =3D ecryptfs_max_decoded_size(src_size);
>  		goto out;
>  	}
>  	while (src_byte_offset < src_size) {
> @@ -2289,3 +2294,52 @@ out_free:
>  out:
>  	return rc;
>  }
> +
> +#define ENC_NAME_MAX_BLOCKLEN_8_OR_16	143
> +
> +int ecryptfs_set_f_namelen(long *namelen, long lower_namelen,
> +			   struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
> +{
> +	struct blkcipher_desc desc;
> +	struct mutex *tfm_mutex;
> +	size_t cipher_blocksize;
> +	int rc;
> +
> +	if (!(mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)) {
> +		(*namelen) =3D lower_namelen;
> +		return 0;
> +	}
> +
> +	rc =3D ecryptfs_get_tfm_and_mutex_for_cipher_name(&desc.tfm, &tfm_mutex,
> +			mount_crypt_stat->global_default_fn_cipher_name);
> +	if (unlikely(rc)) {
> +		(*namelen) =3D 0;
> +		return rc;
> +	}
> +
> +	mutex_lock(tfm_mutex);
> +	cipher_blocksize =3D crypto_blkcipher_blocksize(desc.tfm);
> +	mutex_unlock(tfm_mutex);
> +
> +	/* Return an exact amount for the common cases */
> +	if (lower_namelen =3D=3D NAME_MAX
> +	    && (cipher_blocksize =3D=3D 8 || cipher_blocksize =3D=3D 16)) {
> +		(*namelen) =3D ENC_NAME_MAX_BLOCKLEN_8_OR_16;
> +		return 0;
> +	}
> +
> +	/* Return a safe estimate for the uncommon cases */
> +	(*namelen) =3D lower_namelen;
> +	(*namelen) -=3D ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
> +	/* Since this is the max decoded size, subtract 1 "decoded block" len */
> +	(*namelen) =3D ecryptfs_max_decoded_size(*namelen) - 3;
> +	(*namelen) -=3D ECRYPTFS_TAG_70_MAX_METADATA_SIZE;
> +	(*namelen) -=3D ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES;
> +	/* Worst case is that the filename is padded nearly a full block size */
> +	(*namelen) -=3D cipher_blocksize - 1;
> +
> +	if ((*namelen) < 0)
> +		(*namelen) =3D 0;
> +
> +	return 0;
> +}
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 9685315..4181136 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -219,12 +219,21 @@ ecryptfs_get_key_payload_data(struct key *key)
>  					  * dentry name */
>  #define ECRYPTFS_TAG_73_PACKET_TYPE 0x49 /* FEK-encrypted filename as
>  					  * metadata */
> +#define ECRYPTFS_MIN_PKT_LEN_SIZE 1 /* Min size to specify packet length=
 */
> +#define ECRYPTFS_MAX_PKT_LEN_SIZE 2 /* Pass at least this many bytes to
> +				     * ecryptfs_parse_packet_length() and
> +				     * ecryptfs_write_packet_length()
> +				     */
>  /* Constraint: ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES >=3D
>   * ECRYPTFS_MAX_IV_BYTES */
>  #define ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES 16
>  #define ECRYPTFS_NON_NULL 0x42 /* A reasonable substitute for NULL */
>  #define MD5_DIGEST_SIZE 16
>  #define ECRYPTFS_TAG_70_DIGEST_SIZE MD5_DIGEST_SIZE
> +#define ECRYPTFS_TAG_70_MIN_METADATA_SIZE (1 + ECRYPTFS_MIN_PKT_LEN_SIZE=
 \
> +					   + ECRYPTFS_SIG_SIZE + 1 + 1)
> +#define ECRYPTFS_TAG_70_MAX_METADATA_SIZE (1 + ECRYPTFS_MAX_PKT_LEN_SIZE=
 \
> +					   + ECRYPTFS_SIG_SIZE + 1 + 1)
>  #define ECRYPTFS_FEK_ENCRYPTED_FILENAME_PREFIX "ECRYPTFS_FEK_ENCRYPTED."
>  #define ECRYPTFS_FEK_ENCRYPTED_FILENAME_PREFIX_SIZE 23
>  #define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX "ECRYPTFS_FNEK_ENCRYPTED=
=2E"
> @@ -762,6 +771,8 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t =
*filename_size,
>  			     size_t *packet_size,
>  			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
>  			     char *data, size_t max_packet_size);
> +int ecryptfs_set_f_namelen(long *namelen, long lower_namelen,
> +			   struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
>  int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
>  		       loff_t offset);
> =20
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 8f1a525..4f1feeb 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -548,10 +548,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *rem=
aining_bytes,
>  	 * Octets N3-N4: Block-aligned encrypted filename
>  	 *  - Consists of a minimum number of random characters, a \0
>  	 *    separator, and then the filename */
> -	s->max_packet_size =3D (1                   /* Tag 70 identifier */
> -			      + 3                 /* Max Tag 70 packet size */
> -			      + ECRYPTFS_SIG_SIZE /* FNEK sig */
> -			      + 1                 /* Cipher identifier */
> +	s->max_packet_size =3D (ECRYPTFS_TAG_70_MAX_METADATA_SIZE
>  			      + s->block_aligned_filename_size);
>  	if (dest =3D=3D NULL) {
>  		(*packet_size) =3D s->max_packet_size;
> @@ -806,10 +803,10 @@ ecryptfs_parse_tag_70_packet(char **filename, size_=
t *filename_size,
>  		goto out;
>  	}
>  	s->desc.flags =3D CRYPTO_TFM_REQ_MAY_SLEEP;
> -	if (max_packet_size < (1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1)) {
> +	if (max_packet_size < ECRYPTFS_TAG_70_MIN_METADATA_SIZE) {
>  		printk(KERN_WARNING "%s: max_packet_size is [%zd]; it must be "
>  		       "at least [%d]\n", __func__, max_packet_size,
> -			(1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1));
> +		       ECRYPTFS_TAG_70_MIN_METADATA_SIZE);
>  		rc =3D -EINVAL;
>  		goto out;
>  	}
> diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
> index 1a037f7..557469a 100644
> --- a/fs/ecryptfs/super.c
> +++ b/fs/ecryptfs/super.c
> @@ -30,6 +30,8 @@
>  #include <linux/smp_lock.h>
>  #include <linux/file.h>
>  #include <linux/crypto.h>
> +#include <linux/statfs.h>
> +#include <linux/magic.h>
>  #include "ecryptfs_kernel.h"
> =20
>  struct kmem_cache *ecryptfs_inode_info_cache;
> @@ -137,7 +139,21 @@ static void ecryptfs_put_super(struct super_block *s=
b)
>   */
>  static int ecryptfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> -	return vfs_statfs(ecryptfs_dentry_to_lower(dentry), buf);
> +	struct dentry *lower_dentry =3D ecryptfs_dentry_to_lower(dentry);
> +	int rc;
> +
> +	if (!lower_dentry->d_sb->s_op->statfs)
> +		return -ENOSYS;
> +
> +	rc =3D lower_dentry->d_sb->s_op->statfs(lower_dentry, buf);
> +	if (rc)
> +		return rc;
> +
> +	buf->f_type =3D ECRYPTFS_SUPER_MAGIC;
> +	rc =3D ecryptfs_set_f_namelen(&buf->f_namelen, buf->f_namelen,
> +	       &ecryptfs_superblock_to_private(dentry->d_sb)->mount_crypt_stat);
> +
> +	return rc;
>  }
> =20
>  /**
> --=20
> 1.7.2.1.45.g54fbc
>=20
>=20
>=20

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQan/PAAoJENaSAD2qAscKGLkP/i0kqaMJ79+S+phee2iMt8zz
EvfiekKyQ5pp9UQHEMuKNTnbezDbpDS6Zgy0i7hU0PKtymV8P6fLTSJhty5kXB0U
Tbpb4Wm34xPaDJMOfK/NipZIF8SHFPACYmeAiFFqjA7yjTWMpL6dQt/J6yqeE4u2
25NA+jpeyYM9i98MGdtDh499Pl4gcYmeMbvhS4dx7ern4Ehsoqud8dKCZoxHPDhK
y2Ui+9g4nHt5oG6p/J8Hm688xn9mUIbpz/c+CZfTDrOfYXaPg3vTByr2HJTJ5y4W
LBL7xvL1zr7BeGejbWUv2hqkKpTBGiEoItkV9DOkZquEaqMItqLhiRhfbU5YNjMN
C+yVOqUxVBxf11C2lTcx3VMkkSyc/mWU9Rd4bv2BqAiZeKVyZxJOJfTbZcZAJbuL
n+AjMm4rUp9xJIZZMLhItMlKAvFClM0NdevYRGaJaE9dzgKieRlZpwzKj1qeZtfa
RiF+eX/x/kxQ28pi5QlWw1ksy33APJUJStjoKy1puRF7s9CbdFYu7s7OCtJ9IkBx
V2EBWjkYWLaPuIw9Q36CeJK1IDZrG54rt7AsNJ7pGm6It1JfVSAkmrIO5lNRNWF0
2ltNUPKZhRkMTPyqVcvzZolrZ2Fb0KmzwqUB6IyLjjK7Bt8vc9lwGzroMa+74aEO
TYg1O6g7/HXTm9XdlGQ+
=BRwy
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
