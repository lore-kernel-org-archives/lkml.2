Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0KKV6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:58:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab0KKV6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:58:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 3/4] keys: add new trusted key-type
Date: Thu, 11 Nov 2010 21:57:50 +0000
Message-ID: <8100.1289512670@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Defines a new kernel key-type called 'trusted'. Trusted keys are
> random number symmetric keys, generated and RSA-sealed by the TPM.
> The TPM only unseals the keys, if the boot PCRs and other criteria
> match.  Userspace can only ever see encrypted blobs.

I'd recommend saying 'Define' not 'Defines'.  You're talking in first or
second person.

I'd also recommend filling out the text to 80 chars and being consistent about
the use of space after a full stop (you sometimes use 1 and sometimes 2 spaces
- I'd recommend 2).

>  include/keys/trusted-type.h     |   32 ++
>  security/Kconfig                |   15 +
>  security/keys/Makefile          |    1 +
>  security/keys/trusted_defined.c | 1101 +++++++++++++++++++++++++++++++++++++++
>  security/keys/trusted_defined.h |  147 ++++++
>  5 files changed, 1296 insertions(+), 0 deletions(-)
>  create mode 100644 include/keys/trusted-type.h
>  create mode 100644 security/keys/trusted_defined.c
>  create mode 100644 security/keys/trusted_defined.h

Documentation/trusted_keys.txt?

> @@ -0,0 +1,32 @@
> +/* trusted-type.h: trusted-defined key type

There's no need to include the name of the file here.  We know what the name
of the file is.

> +struct trusted_key_payload {
> +	struct rcu_head rcu;	/* RCU destructor */

The comment is superfluous.  That's what that struct is for.

> +	unsigned char key[MAX_KEY_SIZE+1];

In general, there should be spaces either side of binary operators like '+'.

> +config TRUSTED_KEYS
> +	tristate "TRUSTED KEYS"
> +	depends on KEYS && TCG_TPM
> +	select CRYPTO
> +	select CRYPTO_HMAC
> +	select CRYPTO_SHA1
> +	help
> +	  This option provides support for creating, sealing, and unsealing
> +	  keys in the kernel. Trusted keys are random number symmetric keys,
> +	  generated and RSA-sealed by the TPM. The TPM only unseals the keys,

Superfluous comma.

> +	  if the boot PCRs and other criteria match.  Userspace can only ever
> +	  see encrypted blobs.

I'd say 'will' rather than 'can'.

> diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> new file mode 100644
> index 0000000..d45964d
> --- /dev/null
> +++ b/security/keys/trusted_defined.c
> @@ -0,0 +1,1101 @@
> +/*
> + * Copyright (C) 2010 IBM Corporation
> + *
> + * Author:
> + * David Safford <safford@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + *
> + * Defines a new kernel key-type called 'trusted'.  Trusted keys are random

Again 'Define'.

> + * number symmetric keys, generated and RSA-sealed by the TPM. The TPM only
> + * unseals the keys, if the boot PCRs and other criteria match.  Userspace
> + * can only ever see encrypted blobs.

And two spaces after full stops please.

> + * By default, trusted keys are sealed with the Storage Root Key (SRK).
> + * The SRK usage authorization value is the well-known value of 20 zeroes.
> + * This can be set at takeownership time with the trouser's utility
> + * "tpm_takeownership -u -z".
> + *
> + * Usage:
> + *   keyctl add trusted name "new keylen [options]" ring
> + *   keyctl update key "update [options]"
> + *   keyctl add trusted name "load hex_blob [pcrlock=pcrnum]" ring
> + *   keyctl print keyid
> + *
> + *       options:
> + *           keyhandle=	 ascii hex value of sealing key
> + *                       default 0x40000000 (SRK)
> + *           keyauth=	 ascii hex auth for sealing key
> + *           		 default 0x00... (40 ascii zeros)
> + *           blobauth=	 ascii hex auth for sealed data
> + *           		 default 0x00... (40 ascii zeros)
> + *           pcrinfo=    ascii hex of PCR_INFO or PCR_INFO_LONG
> + *           		 (no default - create with genpcrinfo util)
> + *           pcrlock=	 pcr number to be extended to "lock" blob
> + *           migratable= 0|1 indicating permission to reseal to new PCR values
> + *           		 default 1 (resealing allowed)
> + *
> + * keyctl print returns an ascii hex copy of the sealed key, which is in
> + * standard TPM_STORED_DATA format.
> + * keys can be 32 - 128 bytes, blob max is 1024 hex ascii characters
> + * binary pcrinfo max is 512 hex ascii characters

I would put this information in a file in the Documentation directory and put
a pointer to the file here.  You can then expand on the command structure
you've defined in the documentation.

> +static char hmac_alg[] = "hmac(sha1)";
> +static char hash_alg[] = "sha1";

Should be const.

> +static int init_sha1_desc(struct hash_desc *desc)
> +{
> +	int rc;
> +
> +	desc->tfm = crypto_alloc_hash(hash_alg, 0, CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(desc->tfm)) {
> +		rc = PTR_ERR(desc->tfm);
> +		return rc;

Those should be merged into one line which would allow you to ditch the braces
also.

> +static int init_hmac_desc(struct hash_desc *desc, unsigned char *key,
> +			  int keylen)
> +{
> +	int rc;
> +
> +	desc->tfm = crypto_alloc_hash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(desc->tfm)) {
> +		rc = PTR_ERR(desc->tfm);
> +		return rc;

Merge.

> +static int TSS_sha1(unsigned char *data, int datalen, unsigned char *digest)
> +{
> +	struct hash_desc desc;
> +	struct scatterlist sg[1];
> +	int rc;
> +
> +	rc = init_sha1_desc(&desc);
> +	if (rc != 0)
> +		return rc;

I'd recommend you be consistent about the use of (rc != 0) and (rc < 0) to
check for errors.

> +	sg_init_one(sg, data, datalen);

You should use the shash interface, not the hash interface.  That way you can
avoid the scatter-gather lists.

> +	rc = crypto_hash_update(&desc, sg, datalen);
> +	if (rc < 0)
> +		goto out;
> +	rc = crypto_hash_final(&desc, digest);
> +out:

You could dispense with the goto and the label simply by inverting the logic
of the if-condition.

> +static int TSS_rawhmac(unsigned char *digest, unsigned char *key,
> +		       unsigned int keylen, ...)
> +{
> +	struct hash_desc desc;
> +	struct scatterlist sg[1];

Again, use shash rather than hash to avoid the SG interface.

> +	unsigned int dlen;
> +	unsigned char *data;
> +	va_list argp;
> +	int error;
> +
> +	error = init_hmac_desc(&desc, key, keylen);
> +	if (error)
> +		return error;
> +
> +	va_start(argp, keylen);
> +	for (;;) {
> +		dlen = (unsigned int)va_arg(argp, unsigned int);

Doesn't va_arg() cast for you?

> +		if (dlen == 0)
> +			break;
> +		data = (unsigned char *)va_arg(argp, unsigned char *);

Ditto, plus several more within the file.

> +/*
> + * Have the TPM seal(encrypt) the trusted key, possibly based on
> + * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
> + */
> +static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
> +		    uint32_t keyhandle, unsigned char *keyauth,
> +		    unsigned char *data, uint32_t datalen,
> +		    unsigned char *blob, uint32_t * bloblen,
> +		    unsigned char *blobauth,
> +		    unsigned char *pcrinfo, uint32_t pcrinfosize)
> +{
> +	struct osapsess sess;
> +	unsigned char encauth[TPM_HASH_SIZE];
> +	unsigned char pubauth[TPM_HASH_SIZE];
> +	unsigned char xorwork[TPM_HASH_SIZE * 2];
> +	unsigned char xorhash[TPM_HASH_SIZE];
> +	unsigned char nonceodd[TPM_NONCE_SIZE];

That's quite a lot of stack space, and you're calling other functions that
also allocate chunks of stack space.

David
