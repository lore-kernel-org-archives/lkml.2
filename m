Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0JLUTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 16:19:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52622 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0JLUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 16:19:21 -0400
Subject: Re: [PATCH v1.1 3/4] keys: add new trusted key-type
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20101012012215.GA12906@hallyn.com>
References: <1286827903-3066-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1286827903-3066-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101012012215.GA12906@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 16:19:12 -0400
Message-ID: <1286914752.3148.148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 20:22 -0500, Serge E. Hallyn wrote: 
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> 
> Looks fine to me, and very useful.
> 
> Acked-by: Serge E. Hallyn <serge@hallyn.com>
> 
> (for 1-3, haven't looked at 4 yet and won't tonight)

Thanks Serge!

> > +config TRUSTED_KEYS
> > +	tristate "TRUSTED KEYS"
> > +	depends on KEYS && TCG_TPM
> > +	select CRYPTO
> > +	select CRYPTO_HMAC
> > +	select CRYPTO_SHA1
> > +	help
> > +	  This option provides support for creating/sealing/unsealing keys
> > +	  in the kernel. Trusted keys are TPM generated random numbers
> > +	  symmetric keys, RSA sealed by the TPM, and only unsealed by the
> > +	  TPM, if boot PCRs and other criteria match.  Userspace ever only
> > +	  sees/stores encrypted blobs.
> 
> "
> This option provides support for creating, sealing, and unsealing keys
> in the kernel.  Trusted keys are ramdon symmetric keys created
> RSA-sealed, and stored in the TPM.  The TPM only unseals the keys if the
> boot PCRs and other criteria match.  Userspace can only ever see
> encrypted blobs.
> "

Better, but keys are not stored in the TPM. How about:

This option provides support for creating, sealing, and unsealing keys
in the kernel.  Trusted keys are random number symmetric keys, generated
and RSA-sealed by the TPM. The TPM only unseals the keys, if the boot
PCRs and other criteria match.  Userspace can only ever see encrypted
blobs.

> > diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
> > new file mode 100644
> > index 0000000..0bd935f
> > --- /dev/null
> > +++ b/security/keys/trusted_defined.c
> > @@ -0,0 +1,999 @@
> > +/*
> > + * Copyright (C) 2010 IBM Corporation
> > + *
> > + * Author:
> > + * David Safford <safford@us.ibm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation, version 2 of the License.
> > + *
> > + * File: trusted_defined.c
> 
> (don't put filenames in comments :)

There are plenty of examples containing the filename.  I guess this
changed at some point. Thanks for bringing it to my attention.

> > + * Defines a new kernel key-type called 'trusted'. Trusted keys are
> > + * TPM generated random numbers, RSA sealed by the TPM, and only unsealed
> > + * by the TPM, if boot PCRs and other criteria match. Trusted keys are
> > + * created/sealed/unsealed in the kernel. Userspace ever only sees/stores
> > + * encrypted blobs.
> > + *
> > + * Keys are sealed under the SRK, which must have the default
> > + * authorization value (20 zeros).
> 
> What does this mean?  They have to be sealed by a key that starts
> with 20 zeros?  (of course it doesn't mean that, but i don't understand
> what it does mean :)

Defines a new kernel key-type called 'trusted'.  Trusted keys are random
number symmetric keys, generated and RSA-sealed by the TPM. The TPM only
unseals the keys, if the boot PCRs and other criteria match.  Userspace
can only ever see encrypted blobs.

Trusted keys are sealed with the Storage Root Key(SRK). The SRK usage
authorization value is the well-known authorization value of 20 zeroes. 

(In english this means we follow accepted convention and do not bother 
with a password on the SRK.)

> > This can be set at takeownership
> > + * time with the trouser's utility "tpm_takeownership -u -z".
> > + *
> > + * Usage:
> > + *   keyctl add trusted name "NEW keylen [hex_pcrinfo]" ring
> > + *   keyctl add trusted name "LOAD hex_blob" ring
> > + *   keyctl update key "UPDATE hex_pcrinfo"
> > + *   keyctl print keyid
> > + * keys can be 32 - 128 bytes, blob max is 1024 hex ascii characters
> > + * binary pcrinfo max is 512 hex ascii characters
> > + */
> > +
> > +#include <linux/uaccess.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/slab.h>
> > +#include <linux/parser.h>
> > +#include <linux/string.h>
> > +#include <keys/user-type.h>
> > +#include <keys/trusted-type.h>
> > +#include <linux/key-type.h>
> > +#include <linux/random.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/scatterlist.h>
> > +#include <linux/crypto.h>
> > +#include <linux/tpm.h>
> > +
> > +#include "trusted_defined.h"
> > +
> > +static char hmac_alg[] = "hmac(sha1)";
> > +static char hash_alg[] = "sha1";
> > +
> > +static int init_sha1_desc(struct hash_desc *desc)
> > +{
> > +	int rc;
> > +
> > +	desc->tfm = crypto_alloc_hash(hash_alg, 0, CRYPTO_ALG_ASYNC);
> > +	if (IS_ERR(desc->tfm)) {
> > +		rc = PTR_ERR(desc->tfm);
> > +		return rc;
> > +	}
> > +	desc->flags = 0;
> > +	rc = crypto_hash_init(desc);
> > +	if (rc)
> > +		crypto_free_hash(desc->tfm);
> > +	return rc;
> > +}
> > +
> > +static int init_hmac_desc(struct hash_desc *desc, unsigned char *key,
> > +			  int keylen)
> > +{
> > +	int rc;
> > +
> > +	desc->tfm = crypto_alloc_hash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
> > +	if (IS_ERR(desc->tfm)) {
> > +		rc = PTR_ERR(desc->tfm);
> > +		return rc;
> > +	}
> > +	desc->flags = 0;
> > +	crypto_hash_setkey(desc->tfm, key, keylen);
> > +	rc = crypto_hash_init(desc);
> > +	if (rc)
> > +		crypto_free_hash(desc->tfm);
> > +	return rc;
> > +}
> > +
> > +static int TSS_sha1(unsigned char *data, int datalen, unsigned char *digest)
> > +{
> > +	struct hash_desc desc;
> > +	struct scatterlist sg[1];
> > +	int rc;
> > +
> > +	rc = init_sha1_desc(&desc);
> > +	if (rc != 0)
> > +		return rc;
> > +
> > +	sg_init_one(sg, data, datalen);
> > +	crypto_hash_update(&desc, sg, datalen);
> > +	crypto_hash_final(&desc, digest);
> > +	crypto_free_hash(desc.tfm);
> > +	return rc;
> 
> In later functions where rc can only be 0, you 'return 0;', but here
> you return rc.  Is that an oversight, or is there something actually
> wrong here (like a missing hunk)?

just inconsistent

> There are also several places where you:
> 
> > +	datablob = kzalloc(datalen + 1, GFP_KERNEL);
> > +	if (!datablob)
> > +		return -ENOMEM;
> > +	memcpy(datablob, data, datalen);
> 
> don't need to kzalloc.
> 
> -serge

true, will correct.

thanks!

Mimi 

