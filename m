Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1AEIb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:31:27 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48596 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1AEIbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:31:25 -0500
Date: Wed, 5 Jan 2011 02:31:13 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org,
        safford@watson.ibm.com, ramunno@polito.it, kirkland@canonical.com
Subject: Re: [RFC][PATCH v2 6/6] eCryptfs: added support for the encrypted
 key type
Message-ID: <20110105083112.GC15439@boyd.l.tihix.com>
References: <1293533302-22868-1-git-send-email-roberto.sassu@polito.it>
 <1293533302-22868-7-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293533302-22868-7-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Dec 28, 2010 at 11:48:16AM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> The function ecryptfs_keyring_auth_tok_for_sig() has been modified in order
> to search keys of both 'user' and 'encrypted' types.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |   11 +++++++++--
>  fs/ecryptfs/keystore.c        |   15 +++++++++++----
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index a27cad4..068eade 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -29,6 +29,7 @@
>  #define ECRYPTFS_KERNEL_H
> 
>  #include <keys/user-type.h>
> +#include <keys/encrypted-type.h>
>  #include <linux/fs.h>
>  #include <linux/fs_stack.h>
>  #include <linux/namei.h>
> @@ -81,8 +82,14 @@ struct ecryptfs_page_crypt_context {
>  static inline struct ecryptfs_auth_tok *
>  ecryptfs_get_key_payload_data(struct key *key)
>  {
> -	return (struct ecryptfs_auth_tok *)
> -		(((struct user_key_payload*)key->payload.data)->data);
> +#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)

I'll echo Mimi's v1 patchset comments on moving these ifdefs to header
files. Please see the "#ifdef and preprocessor use in general"
subsection of Documentation/development-process/4.Coding for more info.

Tyler

> +	if (key->type == &key_type_encrypted)
> +		return (struct ecryptfs_auth_tok *)
> +			(&((struct encrypted_key_payload *)key->payload.data)->payload_data);
> +	else
> +#endif
> +		return (struct ecryptfs_auth_tok *)
> +			(((struct user_key_payload *)key->payload.data)->data);
>  }
> 
>  #define ECRYPTFS_SUPER_MAGIC 0xf15f
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 73811cf..8d72635 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1542,10 +1542,17 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
> 
>  	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
>  	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> -		printk(KERN_ERR "Could not find key with description: [%s]\n",
> -		       sig);
> -		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> -		goto out;
> +#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
> +		(*auth_tok_key) = request_key(&key_type_encrypted, sig, NULL);
> +		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> +#endif
> +			printk(KERN_ERR "Could not find key with description: [%s]\n",
> +			      sig);
> +			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> +			goto out;
> +#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
> +		}
> +#endif
>  	}
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {
> -- 
> 1.7.2.3
> 


