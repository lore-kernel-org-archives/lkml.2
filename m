Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662Ab2J3VOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:14:45 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38290 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab2J3VOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:14:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121030192157.11000.12874.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
	<20121030192157.11000.12874.stgit@warthog.procyon.org.uk>
Date: Tue, 30 Oct 2012 14:14:42 -0700
X-Google-Sender-Auth: ehAvL8JOMJscy4hQiiFpDsMF7K8
Message-ID: <CAGXu5jL6hqy-5aZQnLetxDh+XyDr5HUDYKCuPw_dcS7RQB77_w@mail.gmail.com>
Subject: Re: [PATCH 17/23] pefile: Strip the wrapper off of the cert data block
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

On Tue, Oct 30, 2012 at 12:21 PM, David Howells <dhowells@redhat.com> wrote:
> The certificate data block in a PE binary has a wrapper around the PKCS#7
> signature we actually want to get at.  Strip this off and check that we've got
> something that appears to be a PKCS#7 signature.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  crypto/asymmetric_keys/pefile_parser.c |   60 ++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
>
>
> diff --git a/crypto/asymmetric_keys/pefile_parser.c b/crypto/asymmetric_keys/pefile_parser.c
> index efae278..24c117e 100644
> --- a/crypto/asymmetric_keys/pefile_parser.c
> +++ b/crypto/asymmetric_keys/pefile_parser.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/pe.h>
> +#include <linux/asn1.h>
>  #include <keys/asymmetric-subtype.h>
>  #include <keys/asymmetric-parser.h>
>  #include <crypto/hash.h>
> @@ -138,6 +139,61 @@ static int pefile_parse_binary(struct key_preparsed_payload *prep,
>  }
>
>  /*
> + * Check and strip the PE wrapper from around the signature and check that the
> + * remnant looks something like PKCS#7.
> + */
> +static int pefile_strip_sig_wrapper(struct key_preparsed_payload *prep,
> +                                   struct pefile_context *ctx)
> +{
> +       struct win_certificate wrapper;
> +       const u8 *pkcs7;
> +
> +       if (ctx->sig_len < 8) {
> +               pr_devel("Signature wrapper too short\n");
> +               return -ELIBBAD;
> +       }
> +
> +       memcpy(&wrapper, prep->data + ctx->sig_offset, 8);

Instead of the literal 8, sizeof(wrapper)?

> +       pr_devel("sig wrapper = { %x, %x, %x }\n",
> +                wrapper.length, wrapper.revision, wrapper.cert_type);
> +       if (wrapper.length != ctx->sig_len) {
> +               pr_devel("Signature wrapper len wrong\n");
> +               return -ELIBBAD;
> +       }
> +       if (wrapper.revision != WIN_CERT_REVISION_2_0) {
> +               pr_devel("Signature is not revision 2.0\n");
> +               return -ENOTSUPP;
> +       }
> +       if (wrapper.cert_type != WIN_CERT_TYPE_PKCS_SIGNED_DATA) {
> +               pr_devel("Signature certificate type is not PKCS\n");
> +               return -ENOTSUPP;
> +       }
> +
> +       ctx->sig_offset += 8;
> +       ctx->sig_len -= 8;

Same for these?

> +       if (ctx->sig_len == 0) {
> +               pr_devel("Signature data missing\n");
> +               return -EKEYREJECTED;
> +       }
> +
> +       /* What's left should a PKCS#7 cert */
> +       pkcs7 = prep->data + ctx->sig_offset;
> +       if (pkcs7[0] == (ASN1_CONS_BIT | ASN1_SEQ)) {
> +               if (pkcs7[1] == 0x82 &&
> +                   pkcs7[2] == (((ctx->sig_len - 4) >> 8) & 0xff) &&
> +                   pkcs7[3] ==  ((ctx->sig_len - 4)       & 0xff))
> +                       return 0;
> +               if (pkcs7[1] == 0x80)
> +                       return 0;
> +               if (pkcs7[1] > 0x82)
> +                       return -EMSGSIZE;

Can these literals be replaced with something more meaningful?

> +       }
> +
> +       pr_devel("Signature data not PKCS#7\n");
> +       return -ELIBBAD;
> +}
> +
> +/*
>   * Parse a PE binary.
>   */
>  static int pefile_key_preparse(struct key_preparsed_payload *prep)
> @@ -152,6 +208,10 @@ static int pefile_key_preparse(struct key_preparsed_payload *prep)
>         if (ret < 0)
>                 return ret;
>
> +       ret = pefile_strip_sig_wrapper(prep, &ctx);
> +       if (ret < 0)
> +               return ret;
> +
>         return -ENOANO; // Not yet complete
>  }
>
>



-- 
Kees Cook
Chrome OS Security
