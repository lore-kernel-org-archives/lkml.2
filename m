Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab1CRDFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:05:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36952 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab1CRDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:05:46 -0400
Date: Thu, 17 Mar 2011 22:05:39 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH 3/5] eCryptfs: verify authentication tokens before their
 use
Message-ID: <20110318030539.GA16889@boyd.l.tihix.com>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
 <1300362538-11502-4-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300362538-11502-4-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Mar 17, 2011 at 12:48:52PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> Authentication tokens content may change if another requestor calls the
> update() method of the corresponding key. The new function
> ecryptfs_verify_auth_tok_from_key() retrieves the authentication token from
> the provided key and verifies if it is still valid before being used to
> encrypt or decrypt an eCryptfs file.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    3 +-
>  fs/ecryptfs/keystore.c        |  107 ++++++++++++++++++++++++++++-------------
>  fs/ecryptfs/main.c            |    4 +-
>  3 files changed, 77 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 8282031..85728e9 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -333,7 +333,6 @@ struct ecryptfs_global_auth_tok {
>  	u32 flags;
>  	struct list_head mount_crypt_stat_list;
>  	struct key *global_auth_tok_key;
> -	struct ecryptfs_auth_tok *global_auth_tok;
>  	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
>  };
> 
> @@ -726,6 +725,8 @@ int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
>  int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  				      struct ecryptfs_auth_tok **auth_tok,
>  				      char *sig);
> +int ecryptfs_verify_auth_tok_from_key(struct key *auth_tok_key,
> +				      struct ecryptfs_auth_tok **auth_tok);

This shouldn't go in the header file. It only seems to be used in
keystore.c.

>  int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
>  			 loff_t offset, size_t size);
>  int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 36b68a6..e35d745 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -405,25 +405,47 @@ out:
> 
>  static int
>  ecryptfs_find_global_auth_tok_for_sig(
> -	struct ecryptfs_global_auth_tok **global_auth_tok,
> +	struct key **auth_tok_key,
> +	struct ecryptfs_auth_tok **auth_tok,
>  	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig)
>  {
>  	struct ecryptfs_global_auth_tok *walker;
>  	int rc = 0;
> 
> -	(*global_auth_tok) = NULL;
> +	(*auth_tok_key) = NULL;
> +	(*auth_tok) = NULL;
>  	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
>  	list_for_each_entry(walker,
>  			    &mount_crypt_stat->global_auth_tok_list,
>  			    mount_crypt_stat_list) {
>  		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {

Since we're adding more logic inside this conditional, I'd like to see
something like this:

if (!memcmp(...))
	continue;

Then proceed with all the newly added logic.

The eCryptfs source is full of long, too descriptive function and
variable names. The less nesting we do now, the easier it will be to
read later. :)

> +			if (walker->flags & ECRYPTFS_AUTH_TOK_INVALID) {
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +
>  			rc = key_validate(walker->global_auth_tok_key);
> -			if (!rc)
> -				(*global_auth_tok) = walker;
> +			if (rc)
> +				goto out;
> +
> +			rc = ecryptfs_verify_auth_tok_from_key(
> +					walker->global_auth_tok_key, auth_tok);
> +			if (rc) {
> +				printk(KERN_WARNING
> +				      "Invalidating auth tok with sig = [%s]\n",
> +				      sig);

Off by one space on the indenting here.

> +				walker->flags |= ECRYPTFS_AUTH_TOK_INVALID;
> +				key_put(walker->global_auth_tok_key);
> +				walker->global_auth_tok_key = NULL;
> +				mount_crypt_stat->num_global_auth_toks--;

It looks like num_global_auth_toks can go away. We increment and
decrement it, but never actually check it.

> +				goto out;
> +			}
> +			(*auth_tok_key) = walker->global_auth_tok_key;
> +			key_get(*auth_tok_key);
>  			goto out;
>  		}
>  	}
> -	rc = -EINVAL;
> +	rc = -ENOENT;
>  out:
>  	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
>  	return rc;
> @@ -451,14 +473,11 @@ ecryptfs_find_auth_tok_for_sig(
>  	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
>  	char *sig)
>  {
> -	struct ecryptfs_global_auth_tok *global_auth_tok;
>  	int rc = 0;
> 
> -	(*auth_tok_key) = NULL;
> -	(*auth_tok) = NULL;
> -	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
> -						  mount_crypt_stat, sig)) {
> -
> +	rc = ecryptfs_find_global_auth_tok_for_sig(auth_tok_key, auth_tok,
> +						   mount_crypt_stat, sig);
> +	if (rc == -ENOENT) {
>  		/* if the flag ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY is set in the
>  		 * mount_crypt_stat structure, we prevent to use auth toks that
>  		 * are not inserted through the ecryptfs_add_global_auth_tok
> @@ -470,8 +489,8 @@ ecryptfs_find_auth_tok_for_sig(
> 
>  		rc = ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
>  						       sig);
> -	} else
> -		(*auth_tok) = global_auth_tok->global_auth_tok;
> +	}
> +
>  	return rc;
>  }
> 
> @@ -1566,7 +1585,23 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  		(*auth_tok_key) = NULL;
>  		goto out;
>  	}
> -	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
> +
> +	rc = ecryptfs_verify_auth_tok_from_key(*auth_tok_key, auth_tok);
> +	if (rc) {
> +		key_put(*auth_tok_key);
> +		(*auth_tok_key) = NULL;
> +		goto out;
> +	}
> +out:
> +	return rc;
> +}
> +
> +int ecryptfs_verify_auth_tok_from_key(struct key *auth_tok_key,
> +				      struct ecryptfs_auth_tok **auth_tok)

Can be marked static.

> +{
> +	int rc = 0;
> +
> +	(*auth_tok) = ecryptfs_get_key_payload_data(auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {
>  		printk(KERN_ERR
>  		       "Data structure version mismatch. "
> @@ -1576,19 +1611,14 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  		       ECRYPTFS_VERSION_MAJOR,
>  		       ECRYPTFS_VERSION_MINOR);
>  		rc = -EINVAL;
> -		goto out_release_key;
> +		goto out;
>  	}
>  	if ((*auth_tok)->token_type != ECRYPTFS_PASSWORD
>  	    && (*auth_tok)->token_type != ECRYPTFS_PRIVATE_KEY) {
>  		printk(KERN_ERR "Invalid auth_tok structure "
>  		       "returned from key query\n");
>  		rc = -EINVAL;
> -		goto out_release_key;
> -	}
> -out_release_key:
> -	if (rc) {
> -		key_put(*auth_tok_key);
> -		(*auth_tok_key) = NULL;
> +		goto out;
>  	}
>  out:
>  	return rc;
> @@ -2325,13 +2355,14 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  				 size_t max)
>  {
>  	struct ecryptfs_auth_tok *auth_tok;
> -	struct ecryptfs_global_auth_tok *global_auth_tok;
> +	struct key *auth_tok_key = NULL;
>  	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
>  		&ecryptfs_superblock_to_private(
>  			ecryptfs_dentry->d_sb)->mount_crypt_stat;
>  	size_t written;
>  	struct ecryptfs_key_record *key_rec;
>  	struct ecryptfs_key_sig *key_sig;
> +	int auth_tok_count = 0;
>  	int rc = 0;
> 
>  	(*len) = 0;
> @@ -2344,21 +2375,18 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  	list_for_each_entry(key_sig, &crypt_stat->keysig_list,
>  			    crypt_stat_list) {
>  		memset(key_rec, 0, sizeof(*key_rec));
> -		rc = ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
> +		rc = ecryptfs_find_global_auth_tok_for_sig(&auth_tok_key,
> +							   &auth_tok,
>  							   mount_crypt_stat,
>  							   key_sig->keysig);
>  		if (rc) {
> -			printk(KERN_ERR "Error attempting to get the global "
> -			       "auth_tok; rc = [%d]\n", rc);
> -			goto out_free;
> -		}
> -		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID) {
>  			printk(KERN_WARNING
>  			       "Skipping invalid auth tok with sig = [%s]\n",

"invalid auth tok" isn't necessarily accurate here. A global auth tok
with that sig simply may not have been found.

> -			       global_auth_tok->sig);
> +			       key_sig->keysig);
> +			rc = 0;
>  			continue;

In my opinion, this is an error condition that can't be ignored. The
user trusts us to wrap the file encryption key of all newly created
files with the key associated with this auth tok. If the auth tok is not
found or is unusable, I don't feel like we should act like everything is
going as planned. What do you think?

>  		}
> -		auth_tok = global_auth_tok->global_auth_tok;
> +		auth_tok_count++;
>  		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
>  			rc = write_tag_3_packet((dest_base + (*len)),
>  						&max, auth_tok,
> @@ -2367,7 +2395,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  			if (rc) {
>  				ecryptfs_printk(KERN_WARNING, "Error "
>  						"writing tag 3 packet\n");
> -				goto out_free;
> +				goto out_release_key;
>  			}
>  			(*len) += written;
>  			/* Write auth tok signature packet */
> @@ -2377,7 +2405,7 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  			if (rc) {
>  				ecryptfs_printk(KERN_ERR, "Error writing "
>  						"auth tok signature packet\n");
> -				goto out_free;
> +				goto out_release_key;
>  			}
>  			(*len) += written;
>  		} else if (auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
> @@ -2387,15 +2415,23 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  			if (rc) {
>  				ecryptfs_printk(KERN_WARNING, "Error "
>  						"writing tag 1 packet\n");
> -				goto out_free;
> +				goto out_release_key;
>  			}
>  			(*len) += written;
>  		} else {
>  			ecryptfs_printk(KERN_WARNING, "Unsupported "
>  					"authentication token type\n");
>  			rc = -EINVAL;
> -			goto out_free;
> +			goto out_release_key;
>  		}
> +		key_put(auth_tok_key);
> +	}
> +	if (!auth_tok_count) {
> +		printk(KERN_WARNING
> +			"Unable to create a new file without a valid "
> +			"authentication token\n");
> +		rc = -EINVAL;
> +		goto out_free;
>  	}
>  	if (likely(max > 0)) {
>  		dest_base[(*len)] = 0x00;
> @@ -2403,6 +2439,9 @@ ecryptfs_generate_key_packet_set(char *dest_base,
>  		ecryptfs_printk(KERN_ERR, "Error writing boundary byte\n");
>  		rc = -EIO;
>  	}
> +out_release_key:
> +	if (rc)
> +		key_put(auth_tok_key);
>  out_free:
>  	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
>  out:
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 758323a..f079473 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -241,14 +241,14 @@ static int ecryptfs_init_global_auth_toks(
>  	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
>  {
>  	struct ecryptfs_global_auth_tok *global_auth_tok;
> +	struct ecryptfs_auth_tok *auth_tok;
>  	int rc = 0;
> 
>  	list_for_each_entry(global_auth_tok,
>  			    &mount_crypt_stat->global_auth_tok_list,
>  			    mount_crypt_stat_list) {
>  		rc = ecryptfs_keyring_auth_tok_for_sig(
> -			&global_auth_tok->global_auth_tok_key,
> -			&global_auth_tok->global_auth_tok,
> +			&global_auth_tok->global_auth_tok_key, &auth_tok,
>  			global_auth_tok->sig);
>  		if (rc) {
>  			printk(KERN_ERR "Could not find valid key in user "
> -- 
> 1.7.4
> 


