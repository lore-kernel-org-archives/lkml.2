Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1AYWl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:41:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:54293 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1AYWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:41:27 -0500
Date: Tue, 25 Jan 2011 16:41:22 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, ramunno@polito.it, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 6/6] eCryptfs: added support for the encrypted
 key type
Message-ID: <20110125224122.GB12392@boyd.l.tihix.com>
References: <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
 <1295887497-20198-7-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295887497-20198-7-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Jan 24, 2011 at 05:44:54PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> The function ecryptfs_keyring_auth_tok_for_sig() has been modified in order
> to search keys of both 'user' and 'encrypted' types.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Acked-by: Gianluca Ramunno <ramunno@polito.it>

Thanks for the new revision.

Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

> ---
>  fs/ecryptfs/ecryptfs_kernel.h |   41 +++++++++++++++++++++++++++++++++++++++--
>  fs/ecryptfs/keystore.c        |   11 +++++++----
>  2 files changed, 46 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 2e2242f..2b50397 100644
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
> @@ -78,11 +79,47 @@ struct ecryptfs_page_crypt_context {
>  	} param;
>  };
> 
> +#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
> +static inline struct ecryptfs_auth_tok *
> +ecryptfs_get_encrypted_key_payload_data(struct key *key)
> +{
> +	if (key->type == &key_type_encrypted)
> +		return (struct ecryptfs_auth_tok *)
> +			(&((struct encrypted_key_payload *)key->payload.data)->payload_data);
> +	else
> +		return NULL;
> +}
> +
> +static inline struct key *ecryptfs_get_encrypted_key(char *sig)
> +{
> +	return request_key(&key_type_encrypted, sig, NULL);
> +}
> +
> +#else
> +static inline struct ecryptfs_auth_tok *
> +ecryptfs_get_encrypted_key_payload_data(struct key *key)
> +{
> +	return NULL;
> +}
> +
> +static inline struct key *ecryptfs_get_encrypted_key(char *sig)
> +{
> +	return ERR_PTR(-ENOKEY);
> +}
> +
> +#endif /* CONFIG_ENCRYPTED_KEYS */
> +
>  static inline struct ecryptfs_auth_tok *
>  ecryptfs_get_key_payload_data(struct key *key)
>  {
> -	return (struct ecryptfs_auth_tok *)
> -		(((struct user_key_payload*)key->payload.data)->data);
> +	struct ecryptfs_auth_tok *auth_tok;
> +
> +	auth_tok = ecryptfs_get_encrypted_key_payload_data(key);
> +	if (!auth_tok)
> +		return (struct ecryptfs_auth_tok *)
> +			(((struct user_key_payload *)key->payload.data)->data);
> +	else
> +		return auth_tok;
>  }
> 
>  #define ECRYPTFS_MAX_KEYSET_SIZE 1024
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index c1436cf..17194b8 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1560,10 +1560,13 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
> 
>  	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
>  	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> -		printk(KERN_ERR "Could not find key with description: [%s]\n",
> -		       sig);
> -		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> -		goto out;
> +		(*auth_tok_key) = ecryptfs_get_encrypted_key(sig);
> +		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> +			printk(KERN_ERR "Could not find key with description: [%s]\n",
> +			      sig);
> +			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> +			goto out;
> +		}
>  	}
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {
> -- 
> 1.7.3.4
> 


