Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab1CRPbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:31:01 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37994 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801Ab1CRPaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:30:55 -0400
Date: Fri, 18 Mar 2011 10:30:50 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH 4/5] eCryptfs: move ecryptfs_find_auth_tok_for_sig() call
 before mutex_lock
Message-ID: <20110318153049.GB22193@boyd.l.tihix.com>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
 <1300362538-11502-5-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300362538-11502-5-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Mar 17, 2011 at 12:48:53PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> The ecryptfs_find_auth_tok_for_sig() call is moved before the
> mutex_lock(s->tfm_mutex) instruction in order to avoid possible deadlocks
> that may occur by holding the lock on the two semaphores 'key->sem' and
> 's->tfm_mutex' in reverse order.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/keystore.c |   42 +++++++++++++++++++++++-------------------
>  1 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index e35d745..d066217 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -538,6 +538,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
>  			     char *filename, size_t filename_size)
>  {
>  	struct ecryptfs_write_tag_70_packet_silly_stack *s;
> +	struct ecryptfs_auth_tok *auth_tok;

Why declare a new ecryptfs_auth_tok struct pointer here? The idea behind
the ecryptfs_write_tag_70_packet_silly_stack struct is to keep stack
size at a minimum. Since it already has s->auth_tok, I don't see why we
would need to declare a new one.

>  	struct key *auth_tok_key = NULL;
>  	int rc = 0;
> 
> @@ -550,6 +551,16 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
>  	}
>  	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
>  	(*packet_size) = 0;
> +	rc = ecryptfs_find_auth_tok_for_sig(
> +		&auth_tok_key,
> +		&auth_tok, mount_crypt_stat,
> +		mount_crypt_stat->global_default_fnek_sig);
> +	if (rc) {
> +		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> +		       "fnek sig [%s]; rc = [%d]\n", __func__,
> +		       mount_crypt_stat->global_default_fnek_sig, rc);
> +		goto out;
> +	}
>  	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(
>  		&s->desc.tfm,
>  		&s->tfm_mutex, mount_crypt_stat->global_default_fn_cipher_name);
> @@ -635,16 +646,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
>  		goto out_free_unlock;
>  	}
>  	dest[s->i++] = s->cipher_code;
> -	rc = ecryptfs_find_auth_tok_for_sig(
> -		&auth_tok_key,
> -		&s->auth_tok, mount_crypt_stat,
> -		mount_crypt_stat->global_default_fnek_sig);
> -	if (rc) {
> -		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> -		       "fnek sig [%s]; rc = [%d]\n", __func__,
> -		       mount_crypt_stat->global_default_fnek_sig, rc);
> -		goto out_free_unlock;
> -	}
> +	s->auth_tok = auth_tok;
>  	/* TODO: Support other key modules than passphrase for
>  	 * filename encryption */
>  	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
> @@ -831,6 +833,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
>  			     char *data, size_t max_packet_size)
>  {
>  	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
> +	struct ecryptfs_auth_tok *auth_tok;

Same here as above.

Tyler

>  	struct key *auth_tok_key = NULL;
>  	int rc = 0;
> 
> @@ -898,6 +901,15 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
>  		       __func__, s->cipher_code);
>  		goto out;
>  	}
> +	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
> +					    &auth_tok, mount_crypt_stat,
> +					    s->fnek_sig_hex);
> +	if (rc) {
> +		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> +		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
> +		       rc);
> +		goto out;
> +	}
>  	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&s->desc.tfm,
>  							&s->tfm_mutex,
>  							s->cipher_string);
> @@ -944,15 +956,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
>  	 * >= ECRYPTFS_MAX_IV_BYTES. */
>  	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
>  	s->desc.info = s->iv;
> -	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
> -					    &s->auth_tok, mount_crypt_stat,
> -					    s->fnek_sig_hex);
> -	if (rc) {
> -		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> -		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
> -		       rc);
> -		goto out_free_unlock;
> -	}
> +	s->auth_tok = auth_tok;
>  	/* TODO: Support other key modules than passphrase for
>  	 * filename encryption */
>  	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
> -- 
> 1.7.4
> 


