Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab0LCNmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:42:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0LCNmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:42:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <1290556535.2604.16.camel@localhost.localdomain>
References: <1290556535.2604.16.camel@localhost.localdomain> <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.5 5/5] keys: add new key-type encrypted
Date: Fri, 03 Dec 2010 13:42:05 +0000
Message-ID: <4182.1291383725@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +#define KEY_TRUSTED_PREFIX "trusted:"
> +#define KEY_TRUSTED_PREFIX_LEN (sizeof (KEY_TRUSTED_PREFIX) - 1)
> +#define KEY_USER_PREFIX "user:"
> +#define KEY_USER_PREFIX_LEN (sizeof (KEY_USER_PREFIX) - 1)

I'd recommend using static const char arrays.

> +static int datablob_parse(char *datablob, char **master_desc,
> ...
> +		*hex_encoded_data = *hex_encoded_iv + (2 * ivsize) + 2;

Do you need to validate the length of the string here?

> +static struct key *request_trusted_key(const char *trusted_desc,
> +				       u8 **master_key,
> +				       unsigned int *master_keylen)

You need to annotate the function with an __acquires() to indicate that it
returns with a lock held for Sparse checking.  I think you should be able to
do:

	__acquires(tkey->sem)

on the line before the '{'.

> +static struct key *request_user_key(const char *master_desc, u8 **master_key,
> +				    unsigned int *master_keylen)

Ditto.

> +static struct sdesc *init_sdesc(struct crypto_shash *alg)
> +{
> +	struct sdesc *sdesc;
> +	int size;
> +
> +	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
> +	sdesc = kmalloc(size, GFP_KERNEL);

I think I'd call it alloc_sdesc() rather than init_sdesc().

> +static int calc_hmac(u8 *digest, const u8 *key, const unsigned int keylen,
> +		     const u8 *buf, const unsigned int buflen)

size_t not 'const unsigned int' please.  There are multiple of these within
the patch.

> +	sg_set_buf(&sg_out[0], epayload->decrypted_data,
> +		   (unsigned int)epayload->decrypted_datalen);

Superfluous cast.

David
