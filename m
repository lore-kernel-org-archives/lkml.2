Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab0LASv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:51:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab0LASvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:51:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <1290552635-3356-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290552635-3356-5-git-send-email-zohar@linux.vnet.ibm.com> <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.5 4/5] keys: add new trusted key-type
Date: Wed, 01 Dec 2010 17:48:30 +0000
Message-ID: <9594.1291225710@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +static int TSS_sha1(const unsigned char *data, const unsigned int datalen,
> +		    unsigned char *digest)

You seem to have made a bunch of integer length parameters 'const'.  Why?  I
was suggesting making them size_t, not const.

I was suggesting making the data pointers const.

> +	if (!ret)
> +		TSS_rawhmac(digest, key, keylen, SHA1_DIGEST_SIZE,
> +			    paramdigest, TPM_NONCE_SIZE, h1,
> +			    TPM_NONCE_SIZE, h2, 1, &c, 0, 0);

TSS_rawhmac() can return an error.

> +	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, sizeof tb->data);
> +	memcpy(buf, tb->data + TPM_GETRANDOM_SIZE, len);

trusted_tpm_send() won't fail?

> +static int my_get_random(unsigned char *buf, int len)
> +{
> +	struct tpm_buf *tb;
> +	int ret;
> +
> +	tb = kzalloc(sizeof *tb, GFP_KERNEL);
> +	if (!tb)
> +		return -ENOMEM;
> +	ret = tpm_get_random(tb, buf, len);

Isn't is it pointless to use kzalloc() rather than kmalloc()?

> +	my_get_random(hash, SHA1_DIGEST_SIZE);
> +	return tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash) ? -EINVAL : 0;

my_get_random() won't fail?

> +	ret = TSS_rawhmac(s->secret, key, SHA1_DIGEST_SIZE, TPM_NONCE_SIZE,
> +			  enonce, TPM_NONCE_SIZE, ononce, 0, 0);
> +	return ret;

These can be merged.

> +static int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce)
> +{
> +	int ret;
> +
> +	INIT_BUF(tb);
> +	store16(tb, TPM_TAG_RQU_COMMAND);
> +	store32(tb, TPM_OIAP_SIZE);
> +	store32(tb, TPM_ORD_OIAP);
> +	ret = trusted_tpm_send(TPM_ANY_NUM, tb->data, MAX_BUF_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
> +	*handle = LOAD32(tb->data, TPM_DATA_OFFSET);
> +	memcpy(nonce, &tb->data[TPM_DATA_OFFSET + sizeof(uint32_t)],
> +	       TPM_NONCE_SIZE);
> +	return ret;
> +}

If you don't need to return ret specifically, returning 0 would be more
efficient.

> +	ret = TSS_checkhmac1(tb->data, ordinal, td->nonceodd, sess.secret,
> +			     SHA1_DIGEST_SIZE, storedsize, TPM_DATA_OFFSET, 0,
> +			     0);
> +
> +	/* copy the returned blob to caller */
> +	memcpy(blob, tb->data + TPM_DATA_OFFSET, storedsize);
> +	*bloblen = storedsize;

Don't do that if TSS_checkhmac1() fails.

> +	TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
> +		     enonce1, nonceodd, cont, sizeof(uint32_t),
> +		     &ordinal, bloblen, blob, 0, 0);

TSS_authhmac() is called several times without checking for errors.

> +	ret = TSS_checkhmac2(tb->data, ordinal, nonceodd,
> +			     keyauth, SHA1_DIGEST_SIZE,
> +			     blobauth, SHA1_DIGEST_SIZE,
> +			     sizeof(uint32_t), TPM_DATA_OFFSET,
> +			     *datalen, TPM_DATA_OFFSET + sizeof(uint32_t), 0,
> +			     0);
> +	if (ret < 0)
> +		pr_info("trusted_key: TSS_checkhmac2 failed (%d)\n", ret);
> +	memcpy(data, tb->data + TPM_DATA_OFFSET + sizeof(uint32_t), *datalen);
> +	return ret;

Don't do the memcpy() if TSS_checkhmac2() fails.

> +	ret = tpm_unseal(tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
> +			 o->blobauth, p->key, &p->key_len);
> +	/* pull migratable flag out of sealed key */
> +	p->migratable = p->key[--p->key_len];

Don't do that if tpm_unseal() fails.

> +static const match_table_t key_tokens = {
> +	{Opt_new, "new"},
> +	{Opt_load, "load"},
> +	{Opt_update, "update"},
> +	{Opt_keyhandle, "keyhandle=%s"},
> +	{Opt_keyauth, "keyauth=%s"},
> +	{Opt_blobauth, "blobauth=%s"},
> +	{Opt_pcrinfo, "pcrinfo=%s"},
> +	{Opt_pcrlock, "pcrlock=%s"},
> +	{Opt_migratable, "migratable=%s"},
> +	{Opt_err, NULL}

Spaces after { and before }.  I'd also suggest using tabs to align the strings
vertically, but that's up to you.

> +	p = kzalloc(sizeof *p, GFP_KERNEL);
> +
> +	/* migratable by default */
> +	p->migratable = 1;

NAK!  p might be NULL.

David
