Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3AJQMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:12:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab3AJQMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:12:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGXu5jJtuorV9GcetPA+v9K4p-jX4oacaDPrJ3j+RTM+eK5kFA@mail.gmail.com>
References: <CAGXu5jJtuorV9GcetPA+v9K4p-jX4oacaDPrJ3j+RTM+eK5kFA@mail.gmail.com> <24937.1357218319@warthog.procyon.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pull "Load keys from signed PE binaries" branch into linux-next
Date: Thu, 10 Jan 2013 16:12:15 +0000
Message-ID: <8057.1357834335@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> This is a quick review of the devel-pekeys tree...

Thanks!

> +static int public_key_verify_signature_2(const struct key *key,
> 
> Maybe name this "key_verify_signature" instead of using the trailing _2?

I would prefer that it begin with "public_key_" as that reflects the what it
deals with and makes it easier for me to find.

> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -24,72 +24,83 @@
> [...]
> -       tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig_hash_algo],
> 0, 0);
> +       tfm = crypto_alloc_shash(pkey_hash_algo_name[cert->sig.pkey_hash_algo],
> 0, 0);
> 
> I think, even if it wasn't done before, it's worth bounds-checking the
> array access here too.

Probably not necessary, but I should check that we have the algorithms if the
number is in range.  How about:

	--- a/crypto/asymmetric_keys/x509_public_key.c
	+++ b/crypto/asymmetric_keys/x509_public_key.c
	@@ -176,6 +176,16 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
			goto error_free_cert;
		}

	+	if (cert->pub->pkey_algo > PKEY_ALGO__LAST ||
	+	    cert->sig.pkey_algo > PKEY_ALGO__LAST ||
	+	    cert->sig.pkey_hash_algo > PKEY_HASH__LAST ||
	+	    !pkey_algo[cert->pub->pkey_algo] ||
	+	    !pkey_algo[cert->sig.pkey_algo] ||
	+	    !pkey_hash_algo_name[cert->sig.pkey_hash_algo]) {
	+		ret = -ENOPKG;
	+		goto error_free_cert;
	+	}
	+
		cert->pub->algo = pkey_algo[cert->pub->pkey_algo];
		cert->pub->id_type = PKEY_ID_X509;
	 

> +       tfm = crypto_alloc_shash(pkey_hash_algo_name[pkcs7->sig.pkey_hash_algo],
> +                                0, 0);
> 
> More of my paranoia for array access here. :)

I've added this at the top of pkc7_digest():

	if (pkcs7->sig.pkey_hash_algo > PKEY_HASH__LAST ||
	    pkey_hash_algo_name[pkcs7->sig.pkey_hash_algo])
		return -ENOPKG;

> --- /dev/null
> +++ b/crypto/asymmetric_keys/pkcs7_trust.c
> @@ -0,0 +1,145 @@
> [...]
> +       id[signer_len + 0] = ':';
> +       id[signer_len + 1] = ' ';
> 
> the key matching routing seems to not expect this trailing space
> character? Also, is there some risk here that a requested signer
> string could include a ":" character to confuse things?

This bit of asymmetric_key_match() takes care of that:

	/* See if the full key description matches as is */
	if (key->description && strcmp(key->description, description) == 0)
		return 1;

David
