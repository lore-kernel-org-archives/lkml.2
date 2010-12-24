Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0LXPsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:48:37 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55603 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0LXPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:48:35 -0500
Subject: Re: [RFC][PATCH 6/6] ecryptfs: added support for the encrypted key
 type
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
In-Reply-To: <201012231836.28220.roberto.sassu@polito.it>
References: <201012231836.28220.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 10:47:57 -0500
Message-ID: <1293205677.3196.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 18:36 +0100, Roberto Sassu wrote: 
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
> +	if (key->type == &key_type_encrypted)
> +		return (struct ecryptfs_auth_tok *)
> +			(&((struct encrypted_key_payload *)key->payload.data)->payload_data);
> +	else
> +#endif
> +		return (struct ecryptfs_auth_tok *)
> +			(((struct user_key_payload *)key->payload.data)->data);
>  }

'ifdefs' belong in include files. How about defining
ecryptfs_get_encrypted_key_payload_data() with stub function?


> #define ECRYPTFS_SUPER_MAGIC 0xf15f
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

Same here.

thanks,

Mimi

> 	}
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {



