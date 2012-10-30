Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766Ab2J3VoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:44:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34599 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2J3VoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:44:11 -0400
MIME-Version: 1.0
In-Reply-To: <20121030192222.11000.27076.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
	<20121030192222.11000.27076.stgit@warthog.procyon.org.uk>
Date: Tue, 30 Oct 2012 14:44:10 -0700
X-Google-Sender-Auth: j8Di5Z7dvNUM68hEjex0vzpyjTU
Message-ID: <CAGXu5jLi=Nw0EmiMzCyZN9=0o4ubknK_fixwYJnaU0UrrqnUug@mail.gmail.com>
Subject: Re: [PATCH 20/23] pefile: Digest the PE binary and compare to the
 PKCS#7 data
From: Kees Cook <keescook@chromium.org>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, pjones@redhat.com, jwboyer@redhat.com,
        mjg@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 12:22 PM, David Howells <dhowells@redhat.com> wrote:
> Digest the signed parts of the PE binary, canonicalising the section table
> before we need it, and then compare the the resulting digest to the one in the
> PKCS#7 signed content.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  crypto/asymmetric_keys/pefile_parser.c |  198 ++++++++++++++++++++++++++++++++
>  1 file changed, 198 insertions(+)
>
>
> diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
> index 42b9696..9ede195 100644
> --- a/crypto/asymmetric_keys/pefile_parser.c
> +++ b/crypto/asymmetric_keys/pefile_parser.c
> @@ -194,6 +194,193 @@ static int pefile_strip_sig_wrapper(struct key_preparsed_payload *prep,
>  }
>
>  /*
> + * Compare two sections for canonicalisation.
> + */
> +static int pefile_compare_shdrs(const void *a, const void *b)
> +{
> +       const struct section_header *shdra = a;
> +       const struct section_header *shdrb = b;
> +       int rc;
> +
> +       if (shdra->data_addr > shdrb->data_addr)
> +               return 1;
> +       if (shdrb->data_addr > shdra->data_addr)
> +               return -1;
> +
> +       if (shdra->virtual_address > shdrb->virtual_address)
> +               return 1;
> +       if (shdrb->virtual_address > shdra->virtual_address)
> +               return -1;
> +
> +       rc = strcmp(shdra->name, shdrb->name);
> +       if (rc != 0)
> +               return rc;
> +
> +       if (shdra->virtual_size > shdrb->virtual_size)
> +               return 1;
> +       if (shdrb->virtual_size > shdra->virtual_size)
> +               return -1;
> +
> +       if (shdra->raw_data_size > shdrb->raw_data_size)
> +               return 1;
> +       if (shdrb->raw_data_size > shdra->raw_data_size)
> +               return -1;
> +
> +       return 0;
> +}
> +
> +/*
> + * Load the contents of the PE binary into the digest, leaving out the image
> + * checksum and the certificate data block.
> + */
> +static int pefile_digest_pe_contents(struct key_preparsed_payload *prep,
> +                                    struct pefile_context *ctx,
> +                                    struct shash_desc *desc)
> +{
> +       unsigned *canon, tmp, loop, i, hashed_bytes;
> +       int ret;
> +
> +       /* Digest the header and data directory, but leave out the image
> +        * checksum and the data dirent for the signature.
> +        */
> +       ret = crypto_shash_update(desc, prep->data, ctx->image_checksum_offset);
> +       if (ret < 0)
> +               return ret;
> +
> +       tmp = ctx->image_checksum_offset + sizeof(uint32_t);
> +       ret = crypto_shash_update(desc, prep->data + tmp,
> +                                 ctx->cert_dirent_offset - tmp);
> +       if (ret < 0)
> +               return ret;
> +
> +       tmp = ctx->cert_dirent_offset + sizeof(struct data_dirent);
> +       ret = crypto_shash_update(desc, prep->data + tmp,
> +                                 ctx->header_size - tmp);

header_size is not verified, so this update can walk past datalen, or
be truncated, which is probably worse here, IIUC. I think it might be
better to make sure every field that goes into ctx is sanity-checked.

> +       if (ret < 0)
> +               return ret;
> +
> +       canon = kcalloc(ctx->n_sections, sizeof(unsigned), GFP_KERNEL);

n_sections is unverified too, so this and the loops after are troublesome.

> +       if (!canon)
> +               return -ENOMEM;
> +
> +       /* We have to canonicalise the section table, so we perform an
> +        * insertion sort.
> +        */
> +       canon[0] = 0;
> +       for (loop = 1; loop < ctx->n_sections; loop++) {
> +               for (i = 0; i < loop; i++) {
> +                       if (pefile_compare_shdrs(&ctx->secs[canon[i]],
> +                                                &ctx->secs[loop]) > 0) {
> +                               memmove(&canon[i + 1], &canon[i],
> +                                       (loop - i) * sizeof(canon[0]));
> +                               break;
> +                       }
> +               }
> +               canon[i] = loop;
> +       }
> +
> +       hashed_bytes = ctx->header_size;
> +       for (loop = 0; loop < ctx->n_sections; loop++) {
> +               i = canon[loop];
> +               if (ctx->secs[i].raw_data_size == 0)
> +                       continue;
> +               ret = crypto_shash_update(desc,
> +                                         prep->data + ctx->secs[i].data_addr,
> +                                         ctx->secs[i].raw_data_size);
> +               if (ret < 0) {
> +                       kfree(canon);
> +                       return ret;
> +               }
> +               hashed_bytes += ctx->secs[i].raw_data_size;
> +       }
> +       kfree(canon);
> +
> +       if (prep->datalen > hashed_bytes) {
> +               tmp = hashed_bytes + ctx->certs_size;
> +               ret = crypto_shash_update(desc,
> +                                         prep->data + hashed_bytes,
> +                                         prep->datalen - tmp);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +/*
> + * Digest the contents of the PE binary, leaving out the image checksum and the
> + * certificate data block.
> + */
> +static int pefile_digest_pe(struct key_preparsed_payload *prep,
> +                           struct pefile_context *ctx)
> +{
> +       struct crypto_shash *tfm;
> +       struct shash_desc *desc;
> +       size_t digest_size, desc_size;
> +       void *digest;
> +       int ret;
> +
> +       kenter(",%u", ctx->digest_algo);
> +
> +       /* Allocate the hashing algorithm we're going to need and find out how
> +        * big the hash operational data will be.
> +        */
> +       tfm = crypto_alloc_shash(pkey_hash_algo_name[ctx->digest_algo], 0, 0);
> +       if (IS_ERR(tfm))
> +               return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
> +
> +       desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
> +       digest_size = crypto_shash_digestsize(tfm);
> +
> +       if (digest_size != ctx->digest_len) {
> +               pr_debug("Digest size mismatch (%zx != %x)\n",
> +                        digest_size, ctx->digest_len);
> +               ret = -EBADMSG;
> +               goto error_no_desc;
> +       }
> +       pr_devel("Digest: desc=%zu size=%zu\n", desc_size, digest_size);
> +
> +       ret = -ENOMEM;
> +       desc = kzalloc(desc_size + digest_size, GFP_KERNEL);
> +       if (!desc)
> +               goto error_no_desc;
> +
> +       desc->tfm   = tfm;
> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +       ret = crypto_shash_init(desc);
> +       if (ret < 0)
> +               goto error;
> +
> +       ret = pefile_digest_pe_contents(prep, ctx, desc);
> +       if (ret < 0)
> +               goto error;
> +
> +       digest = (void *)desc + desc_size;
> +       ret = crypto_shash_final(desc, digest);
> +       if (ret < 0)
> +               goto error;
> +
> +       pr_devel("Digest calc = [%*ph]\n", ctx->digest_len, digest);
> +
> +       /* Check that the PE file digest matches that in the MSCODE part of the
> +        * PKCS#7 certificate.
> +        */
> +       if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
> +               pr_debug("Digest mismatch\n");
> +               ret = -EKEYREJECTED;
> +       } else {
> +               pr_debug("The digests match!\n");
> +       }
> +
> +error:
> +       kfree(desc);
> +error_no_desc:
> +       crypto_free_shash(tfm);
> +       kleave(" = %d", ret);
> +       return ret;
> +}
> +
> +/*
>   * Parse a PE binary.
>   */
>  static int pefile_key_preparse(struct key_preparsed_payload *prep)
> @@ -230,6 +417,17 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
>
>         pr_devel("Digest: %u [%*ph]\n", ctx.digest_len, ctx.digest_len, ctx.digest);
>
> +       /* Generate the digest and check against the PKCS7 certificate
> +        * contents.
> +        */
> +       ret = pefile_digest_pe(prep, &ctx);
> +       if (ret < 0)
> +               goto error;
> +
> +       ret = pkcs7_verify(pkcs7);
> +       if (ret < 0)
> +               goto error;
> +
>         ret = -ENOANO; // Not yet complete
>
>  error:
>

-Kees

-- 
Kees Cook
Chrome OS Security
