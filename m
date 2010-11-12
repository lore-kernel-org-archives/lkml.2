Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0KLTqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:46:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0KLTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:46:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Fri, 12 Nov 2010 19:45:35 +0000
Message-ID: <26689.1289591135@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Defines a new kernel key-type called 'encrypted'. Encrypted keys are

Many of the comments I made against patch #3 also apply here.  Use 'Define'
rather than 'Defines' here for example.

> index 0000000..e2312e0
> --- /dev/null
> +++ b/include/keys/encrypted-type.h
> @@ -0,0 +1,30 @@
> +/* encrypted-type.h: encrypted-defined key type

Don't include the names of files in the files.

> +struct encrypted_key_payload {
> +	struct rcu_head rcu;	/* RCU destructor */

That comment is not really needed.

> +	char *master_desc;	/* datablob: master key name */
> +	char *datalen;		/* datablob: decrypted key length */
> +	void *iv;		/* datablob: iv */
> +	void *encrypted_data;	/* datablob: encrypted key */

But the variable name is 'encrypted_data'...

> +	unsigned short datablob_len;	/* length of datablob */
> +	unsigned short decrypted_datalen;	/* decrypted data length */
> +	char decrypted_data[0];	/* decrypted data +  datablob + hmac */

If any of these are binary data rather than character data, I'd use u8 rather
than char.

> --- /dev/null
> +++ b/security/keys/encrypted_defined.c
> @@ -0,0 +1,816 @@
> +/*
> + * Copyright (C) 2010 IBM Corporation
> + *
> + * Author:
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + *
> + * File: encrypted_defined.c

Don't do that.

> + *
> + * Defines a new kernel key-type called 'encrypted'. Encrypted keys
> + * are kernel generated random numbers, which are encrypted/decrypted
> + * using a 'master' key. The 'master' key can either be a trusted-key or
> + * user-key type. Encrypted keys are created/encrypted/decrypted in the
> + * kernel. Userspace ever only sees/stores encrypted blobs.
> + *
> + * keyctl add "encrypted" "name" "NEW master-key-name keylen" ring
> + * keyctl add "encrypted" "name" "LOAD master-key-name keylen hex_blob" ring
> + * keyctl update keyid "UPDATE master-key-name"

Merge with the documentation file in Documentation/ from patch 3 and stick a
pointer to that file here.

> +static char hash_alg[] = "sha256";
> +static char hmac_alg[] = "hmac(sha256)";

const.

> +static int hash_size = SHA256_DIGEST_SIZE;

???  This is a numeric constant, but you're telling the compiler you want to
store it in the .data section.  Is there a reason?

> +static char blkcipher_alg[] = "cbc(aes)";

const.

> +static int ivsize;
> +static int blksize;
> +static int MAX_DATA_SIZE = 4096;
> +static int MIN_DATA_SIZE = 20;

Initialised numeric constants.

> +static int aes_get_sizes(int *ivsize, int *blksize)

It's only used in one place in the file, and it only sets global vars.  Why
pass pointers to them?

> +enum {
> +	Opt_err = -1, Opt_new = 1, Opt_load,
> +	Opt_update, Opt_NEW, Opt_LOAD, Opt_UPDATE
> +};

Why skip 0?

> +static match_table_t key_tokens = {

const.

> +	{Opt_new, "new"},
> +	{Opt_NEW, "NEW"},
> +	{Opt_load, "load"},
> +	{Opt_LOAD, "LOAD"},
> +	{Opt_update, "update"},
> +	{Opt_UPDATE, "UPDATE"},
> +	{Opt_err, NULL}

Is case significant?  If not, you don't need duplicated constants.  Why do you
care about the capitalisation here (and only in a restricted sense) when you
didn't in the trusted keys patch?

> +/* datablob_format - format as an ascii string, before copying to userspace */

I would split this over three lines.

> +static int datablob_format(char __user *buffer,
> +			   struct encrypted_key_payload *epayload,
> +			   int asciiblob_len)
> +{
> +	char *ascii_buf, *bufp;
> +	char *iv = (char *)epayload->iv;

Unnecessary cast.  iv is void*.

> +	int ret = 0;
> +	int len;
> +	int i;
> +
> +	ascii_buf = kmalloc(asciiblob_len + 1, GFP_KERNEL);
> +	if (!ascii_buf)
> +		return -ENOMEM;
> +
> +	*(ascii_buf + asciiblob_len) = '\0';

That's what square brackets are for.

> +	len = sprintf(ascii_buf, "%s %s ", epayload->master_desc,
> +		      epayload->datalen);

datalen is not a string.

> +static struct key *request_trusted_key(char *trusted_desc, void **master_key,
> +				       unsigned int *master_keylen)
> +{
> +	struct trusted_key_payload *tpayload;
> +	struct key *tkey;
> +
> +	tkey = request_key(&key_type_trusted, trusted_desc, NULL);
> +	if (IS_ERR(tkey))
> +		goto error;
> +
> +	tpayload = tkey->payload.data;
> +	*master_key = tpayload->key;
> +	*master_keylen = tpayload->key_len;

You can't do this.  You've defined an update method, so the pointer may change
under you, and the pointee may be destroyed without warning.  You've been
using RCU, so you should use that.  You need to use rcu_read_{,un}lock() and
rcu_dereference() and you must be aware that the payload may be destroyed from
the moment you drop the RCU read lock.

You're returning a pointer to the key, so you perhaps don't really need to
access the payload at this point.

> +static struct key *request_user_key(char *master_desc, void **master_key,
> +				    unsigned int *master_keylen)
> +{
> +	struct user_key_payload *upayload;
> +	struct key *ukey;
> +
> +	ukey = request_key(&key_type_user, master_desc, NULL);
> +	if (IS_ERR(ukey))
> +		goto error;
> +
> +	upayload = ukey->payload.data;
> +	*master_key = upayload->data;
> +	*master_keylen = (unsigned int)upayload->datalen;

Ditto.

> +static int init_desc(struct hash_desc *desc, char *alg)
> +{
> +	int ret;
> +
> +	desc->tfm = crypto_alloc_hash(alg, 0, CRYPTO_ALG_ASYNC);

Use shash so that you don't have to use the SG interface.

> +static int calc_hmac(char *digest, char *key, int keylen,
> +		     char *buf, size_t buflen)

Can key be const?  Should digest, key and buf be u8* or void* if they're
binary data rather than string data?  This sort of thing should perhaps be
percolated through all your functions.

> +static int calc_hash(char *digest, void *buf, int buflen)

Can buf be const?

> +static int get_derived_key(char *derived_key, enum derived_key_type key_type,
> +			   void *master_key, unsigned int master_keylen)

master_key should be const.  master_keylen should perhaps be size_t.

> +static struct key *request_master_key(struct encrypted_key_payload *epayload,
> +				      void **master_key,
> +				      unsigned int *master_keylen)
> +{
> +	struct key *mkey;
> +
> +	mkey = request_trusted_key(epayload->master_desc,
> +				   master_key, master_keylen);
> +	if (IS_ERR(mkey)) {
> +		mkey = request_user_key(epayload->master_desc,
> +					master_key, master_keylen);
> +		if (IS_ERR(mkey)) {
> +			pr_info("encrypted_key: trusted/user key %s not found",
> +				epayload->master_desc);
> +			return mkey;
> +		}
> +	}
> +	dump_master_key(*master_key, *master_keylen);
> +	return mkey;
> +}

Why do you allow the master key to be supplied by a user-defined key rather
than requiring a trusted-key unconditionally?

Note that the description of a user-defined key should prefixed to distinguish
it from other random user-defined keys.

> +static int derived_key_encrypt(struct encrypted_key_payload *epayload,
> +			       void *derived_key, unsigned int derived_keylen)

Should derived_key be const and derived_keylen be size_t?

> +static int datablob_hmac_append(struct encrypted_key_payload *epayload,
> +				void *master_key, unsigned int master_keylen)

More const and size_t?  There are plenty more places where you should probably
be using const or size_t.  I'm not going to list any further

> +static void encrypted_rcu_free(struct rcu_head *rcu)
> +{
> +	struct encrypted_key_payload *epayload;
> +
> +	epayload = container_of(rcu, struct encrypted_key_payload, rcu);
> +	memset(epayload->decrypted_data, 0, epayload->decrypted_datalen);
> +	kfree(epayload);

I presume you don't need to release the stuff pointed to by epayload before
the memset because __ekey_init() makes the pointers point at offsets into the
payload blob.

> +static int __init init_encrypted(void)
> +{
> +	int ret;
> +
> +	ret = register_key_type(&key_type_encrypted);
> +	if (ret < 0)
> +		return ret;
> +	ret = aes_get_sizes(&ivsize, &blksize);
> +	return ret;

Merge those two lines into one.

> +static inline void dump_master_key(void *master_key, unsigned int master_keylen)
> +{
> +	print_hex_dump(KERN_ERR, "master key: ", DUMP_PREFIX_NONE, 32, 1,
> +		       master_key, (size_t) master_keylen, 0);

You don't need to cast master_keylen like this.  The compiler will do that
automatically.  In fact, master_key should be const and master_key_len should
probably be size_t.

> +static inline void dump_decrypted_data(struct encrypted_key_payload
> *epayload)

const.

> +static inline void dump_encrypted_data(struct encrypted_key_payload *epayload,
> +				       unsigned int encrypted_datalen)

const and size_t.  And further instances thereof further down.

David
