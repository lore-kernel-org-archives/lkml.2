Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1BAXQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:16:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46634 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1BAXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:16:48 -0500
Date: Tue, 1 Feb 2011 17:16:42 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] eCryptfs: lock requested keys for writing
Message-ID: <20110201231641.GC23518@boyd.l.tihix.com>
References: <1296211326-2437-1-git-send-email-roberto.sassu@polito.it>
 <1296211326-2437-2-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296211326-2437-2-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Jan 28, 2011 at 11:42:04AM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> Keys requested by eCryptfs are exclusively locked in order to prevent
> modifications by other subjects. In particular those which description is
> specified at mount time are locked until the filesystem is unmounted, these

I don't think the approach taken for the mount wide keys will work for a
couple reasons. The first is that lockdep reports this after a mount:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
mount/1019 is leaving the kernel with locks still held!
1 lock held by mount/1019:
#0:  (&key->sem){+.+.+.}, at: [<ffffffffa021ff12>] ecryptfs_keyring_auth_tok_for_sig+0xe6/0x195 [ecryptfs]

The second is that while this does prevent key_update() from updating
the key underneath us, it just results in `keyctl update` on a mount key
to become a hung task until unmounting the eCryptfs mount.

It looks like we'll have to have more efficient locking for mount keys.

Tyler

> required to decrypt a single file are unlocked immediately after the open.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Reported-by: David Howells <dhowells@redhat.com>
> ---
>  fs/ecryptfs/crypto.c   |    4 +++-
>  fs/ecryptfs/keystore.c |   15 ++++++++++++---
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index bfd8b68..6b32776 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -268,8 +268,10 @@ void ecryptfs_destroy_mount_crypt_stat(
>  		list_del(&auth_tok->mount_crypt_stat_list);
>  		mount_crypt_stat->num_global_auth_toks--;
>  		if (auth_tok->global_auth_tok_key
> -		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID))
> +		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID)) {
> +			up_write(&(auth_tok->global_auth_tok_key->sem));
>  			key_put(auth_tok->global_auth_tok_key);
> +		}
>  		kmem_cache_free(ecryptfs_global_auth_tok_cache, auth_tok);
>  	}
>  	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 4feb78c..c90456a 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -765,8 +765,10 @@ out_free_unlock:
>  out_unlock:
>  	mutex_unlock(s->tfm_mutex);
>  out:
> -	if (auth_tok_key)
> +	if (auth_tok_key) {
> +		up_write(&(auth_tok_key->sem));
>  		key_put(auth_tok_key);
> +	}
>  	kfree(s);
>  	return rc;
>  }
> @@ -1002,8 +1004,10 @@ out:
>  		(*filename_size) = 0;
>  		(*filename) = NULL;
>  	}
> -	if (auth_tok_key)
> +	if (auth_tok_key) {
> +		up_write(&(auth_tok_key->sem));
>  		key_put(auth_tok_key);
> +	}
>  	kfree(s);
>  	return rc;
>  }
> @@ -1566,6 +1570,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  		(*auth_tok_key) = NULL;
>  		goto out;
>  	}
> +	down_write(&((*auth_tok_key)->sem));
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {
>  		printk(KERN_ERR
> @@ -1587,6 +1592,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  	}
>  out_release_key:
>  	if (rc) {
> +		up_write(&((*auth_tok_key)->sem));
>  		key_put(*auth_tok_key);
>  		(*auth_tok_key) = NULL;
>  	}
> @@ -1810,6 +1816,7 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
>  find_next_matching_auth_tok:
>  	found_auth_tok = 0;
>  	if (auth_tok_key) {
> +		up_write(&(auth_tok_key->sem));
>  		key_put(auth_tok_key);
>  		auth_tok_key = NULL;
>  	}
> @@ -1896,8 +1903,10 @@ found_matching_auth_tok:
>  out_wipe_list:
>  	wipe_auth_tok_list(&auth_tok_list);
>  out:
> -	if (auth_tok_key)
> +	if (auth_tok_key) {
> +		up_write(&(auth_tok_key->sem));
>  		key_put(auth_tok_key);
> +	}
>  	return rc;
>  }
> 
> -- 
> 1.7.3.4
> 


