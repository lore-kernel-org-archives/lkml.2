Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2HOVLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:11:15 -0400
Received: from mga12.intel.com ([143.182.124.36]:22054 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755013Ab2HOVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120815201135.GA10088@amd1>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
	<20120815201135.GA10088@amd1>
Date: Thu, 16 Aug 2012 00:11:10 +0300
Message-ID: <CALLzPKaczBwsj0s5wxTLaZ2_=J_fCdbP2SB0R2oUxMyHLDRYMg@mail.gmail.com>
Subject: Re: [RFC v2 1/7] integrity: added digest calculation function
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:11 PM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Dmitry Kasatkin (dmitry.kasatkin@intel.com):
>> There are several functions, that need to calculate digest.
>> This patch adds common function for use by integrity subsystem.
>>
>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> ---
>>  security/integrity/digsig.c    |   31 +++++++++++++++++++++++++++++--
>>  security/integrity/integrity.h |    3 +++
>>  2 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
>> index 2dc167d..61a0c92 100644
>> --- a/security/integrity/digsig.c
>> +++ b/security/integrity/digsig.c
>> @@ -13,9 +13,9 @@
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>
>>  #include <linux/err.h>
>> -#include <linux/rbtree.h>
>>  #include <linux/key-type.h>
>>  #include <linux/digsig.h>
>> +#include <crypto/hash.h>
>>
>>  #include "integrity.h"
>>
>> @@ -28,7 +28,7 @@ static const char *keyring_name[INTEGRITY_KEYRING_MAX] = {
>>  };
>>
>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>> -                                     const char *digest, int digestlen)
>> +                         const char *digest, int digestlen)
>>  {
>>       if (id >= INTEGRITY_KEYRING_MAX)
>>               return -EINVAL;
>> @@ -46,3 +46,30 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>
>>       return digsig_verify(keyring[id], sig, siglen, digest, digestlen);
>>  }
>> +
>> +int integrity_calc_digest(const char *algo, const void *data, const int len,
>> +                       char *digest)
>> +{
>> +     int rc = -ENOMEM;
>> +     struct crypto_shash *tfm;
>> +
>> +     tfm = crypto_alloc_shash(algo, 0, 0);
>> +     if (IS_ERR(tfm)) {
>> +             rc = PTR_ERR(tfm);
>> +             pr_err("Can not allocate %s (reason: %d)\n", algo, rc);
>> +             return rc;
>> +     } else {
>> +             struct {
>> +                     struct shash_desc shash;
>> +                     char ctx[crypto_shash_descsize(tfm)];
>> +             } desc;
>
> Needless confusing indentation here.  Just move the struct {} desc; to the
> top and drop the else.  That will make it much more readable.
>

Intention was to allocate it only if tfm allocation succeeded..
But indeed failure very unlikely..

thanks.

>> +             desc.shash.tfm = tfm;
>> +             desc.shash.flags = 0;
>> +
>> +             rc = crypto_shash_digest(&desc.shash, data, len, digest);
>> +     }
>> +
>> +     crypto_free_shash(tfm);
>> +     return rc;
>> +}
>> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
>> index e21362a..48ee2d4 100644
>> --- a/security/integrity/integrity.h
>> +++ b/security/integrity/integrity.h
>> @@ -59,6 +59,9 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode);
>>
>>  #ifdef CONFIG_INTEGRITY_SIGNATURE
>>
>> +int integrity_calc_digest(const char *algo, const void *data, const int len,
>> +                       char *digest);
>> +
>>  int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>>                                       const char *digest, int digestlen);
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
