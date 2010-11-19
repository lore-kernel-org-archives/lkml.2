Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0KSQXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab0KSQXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:23:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1290120166-3132-5-git-send-email-zohar@linux.vnet.ibm.com>
References: <1290120166-3132-5-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.4 4/5] keys: add new trusted key-type
Date: Fri, 19 Nov 2010 16:23:21 +0000
Message-ID: <10330.1290183801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +keyctl print returns an ascii hex copy of the sealed key, which is in standard

I'd quote 'keyctl print' just so it's obvious where the command ends and the
descriptive text starts.

> +Usage:
> +  keyctl add encrypted name "new key-type:master-key-name keylen" ring
> +  keyctl add encrypted name "load key-type:master-key-name keylen hex_blob" ring
> +  keyctl update keyid "update key-type:master-key-name"
> +
> +where 'key-type' is either 'trusted' or 'user'.

I recommend adding some example commands with all the arguments substituted.
Nothing helps get to grip with an API like knowing what a command is supposed
to look like when it's actually used.

> +static int trusted_tpm_send(u32 chip_num, unsigned char *cmd, int buflen)

There are still a lot of places in here where you should probably be using
const and size_t.

> +static int my_get_random(unsigned char *buf, int len)
> +{
> +	struct tpm_buf *tb;
> +	int ret;
> +
> +	tb = kzalloc(sizeof *tb, GFP_KERNEL);
> +	if (!tb)
> +		return -ENOMEM;
> +	ret = tpm_get_random(tb, buf, len);

Using kzalloc() rather than kmalloc() is a waste of time, I'd've thought.
It's a temporary buffer.  Does it really need to be precleared?

> +	ret = tpm_pcr_extend(TPM_ANY_NUM, pcrnum, hash);
> +	return ret;

Merge.

> +static int trusted_update(struct key *key, const void *data, size_t datalen)
> +{
> ...
> +	*(datablob + datalen) = '\0';

That's what [] is for.

> +	if (new_o)
> +		kfree(new_o);

kfree() can handle a NULL pointer.

> +	if (new_o->pcrlock)
> +		ret = pcrlock(new_o->pcrlock);
> +	rcu_assign_pointer(key->payload.data, new_p);
> +	call_rcu(&p->rcu, trusted_rcu_free);

Should there be a check for pcrlock() failure?

> +/* not already defined in tpm.h - specific to this use */
> +#define TPM_TAG_RQU_COMMAND		193
> +#define TPM_TAG_RQU_AUTH1_COMMAND	194
> ...

Values defined for TPM hardware access really ought to be in a separate file
in include/linux/.  They aren't strictly specific to the trusted key
implementation here; that may be the only user currently in the kernel, but
that doesn't mean there can't be another user.

David
