Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0KSQnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab0KSQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:43:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1290120166-3132-6-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-6-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.4 5/5] keys: add new key-type encrypted
Date: Fri, 19 Nov 2010 16:43:20 +0000
Message-ID: <10563.1290185000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +static int datablob_format(char __user *buffer,
> +			   struct encrypted_key_payload *epayload,
> +			   int asciiblob_len)

size_t?  There are other instances where you should be using size_t too.

> +	index = strcspn(epayload->master_desc, ":");
> +	if (index == strlen(epayload->master_desc))
> +		goto out;

For single chars, use strchr() rather than strcspn(), and if you happen to
know the length too, use memchr().  This also means you don't need to do the
strlen() again to check the result.

> +	memset(derived_key, 0, sizeof derived_key);
> +	ret = get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen)

Is the memset() actually necessary?

> +	decrypted_datalen = (unsigned short)dlen;

Unnecessary cast.

> +	*(datablob + datalen) = 0;
> +	*(buf + datalen) = 0;

Use [].

> +	if (index == strlen(new_master_desc)
> +	    || (strncmp(new_master_desc, epayload->master_desc, index) != 0)) {

Superfluous brackets.

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +	mkey = request_master_key(epayload, &master_key, &master_keylen);
> +	if (IS_ERR(mkey))
> +		return PTR_ERR(mkey);
> +
> +	memset(derived_key, 0, sizeof derived_key);
> +	ret = get_derived_key(derived_key, ENC_KEY, master_key, master_keylen);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = derived_key_encrypt(epayload, derived_key, sizeof derived_key);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = datablob_hmac_append(epayload, master_key, master_keylen);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = datablob_format(buffer, epayload, asciiblob_len);
> +	if (ret < 0)
> +		goto out;
> +
> +	rcu_read_unlock();

NAK!  This is not safe.  You may not sleep whilst you hold the RCU read lock
on the master key.  At the very least, datablob_format() may sleep as it
writes to userspace.

I think what you should do is ignore RCU entirely and read lock the master
key's semaphore.

> +	ret = aes_get_sizes();
> +	return ret;

Merge.

David
