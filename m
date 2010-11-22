Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0KVMQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:16:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52234 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab0KVMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:16:07 -0500
Subject: Re: [PATCH v1.4 5/5] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <10563.1290185000@redhat.com>
References: <1290120166-3132-6-git-send-email-zohar@linux.vnet.ibm.com>
	 <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <10563.1290185000@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 07:16:01 -0500
Message-ID: <1290428161.2604.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 16:43 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +static int datablob_format(char __user *buffer,
> > +			   struct encrypted_key_payload *epayload,
> > +			   int asciiblob_len)
> 
> size_t?  There are other instances where you should be using size_t too.

Most of the crypto library calls use "unsigned int". Obviously didn't
quite get everything else. Will look again.  thanks.

> > +	index = strcspn(epayload->master_desc, ":");
> > +	if (index == strlen(epayload->master_desc))
> > +		goto out;
> 
> For single chars, use strchr() rather than strcspn(), and if you happen to
> know the length too, use memchr().  This also means you don't need to do the
> strlen() again to check the result.

Don't have the length, but getting it once and then using strchr/memchr,
should work. thanks.

> > +	memset(derived_key, 0, sizeof derived_key);
> > +	ret = get_derived_key(derived_key, AUTH_KEY, master_key, master_keylen)
> 
> Is the memset() actually necessary?

not sure, will check.

> > +	decrypted_datalen = (unsigned short)dlen;
> 
> Unnecessary cast.

ok

> > +	*(datablob + datalen) = 0;
> > +	*(buf + datalen) = 0;
> 
> Use [].

> > +	if (index == strlen(new_master_desc)
> > +	    || (strncmp(new_master_desc, epayload->master_desc, index) != 0)) {
> 
> Superfluous brackets.
> 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +	mkey = request_master_key(epayload, &master_key, &master_keylen);
> > +	if (IS_ERR(mkey))
> > +		return PTR_ERR(mkey);
> > +
> > +	memset(derived_key, 0, sizeof derived_key);
> > +	ret = get_derived_key(derived_key, ENC_KEY, master_key, master_keylen);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = derived_key_encrypt(epayload, derived_key, sizeof derived_key);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = datablob_hmac_append(epayload, master_key, master_keylen);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	ret = datablob_format(buffer, epayload, asciiblob_len);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	rcu_read_unlock();
> 
> NAK!  This is not safe.  You may not sleep whilst you hold the RCU read lock
> on the master key.  At the very least, datablob_format() may sleep as it
> writes to userspace.

datablob_format() could be split up into formatting the string returned
to userspace and copying it userspace, releasing the lock before copying
it, but that wouldn't resolve the other places it may sleep, like alloc.

> I think what you should do is ignore RCU entirely and read lock the master
> key's semaphore.

thanks, will do.

> > +	ret = aes_get_sizes();
> > +	return ret;
> 
> Merge.
> 
> David

ok

thanks,

Mimi

