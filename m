Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab0JHTI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:08:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48572 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0JHTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:08:56 -0400
Date: Fri, 8 Oct 2010 14:08:57 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] ecryptfs: added ecryptfs_mount_auth_tok_only mount
 parameter
Message-ID: <20101008190857.GB15669@boomer>
References: <201010061831.32663.roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010061831.32663.roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Oct 06, 2010 at 06:31:32PM +0200, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch adds a new mount parameter 'ecryptfs_mount_auth_tok_only' to force 
> ecryptfs to use only authentication tokens which signature has been 
> specified at mount time with parameters 'ecryptfs_sig' and 'ecryptfs_fnek_sig'. 
> In this way, after disabling the passthrough and the encrypted view modes,
> it's possible to make available to users only files encrypted with the specified
> authentication token.
> 
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---

Hey Roberto - The commit message tells me what this patch does, but I'm
curious about why you want to do it. Not that it is a bad idea, but I'd
like to understand if it will be a useful feature before adding another
mount option. Each mount option increases testing that must be covered,
although the additional code path here is extremely simple.

An example scenario would be much appreciated.

Why would the user have files encrypted with other keys in the lower
directory? Without any type of encryption policy support in eCryptfs,
I would think that all files in the lower filesystem would be encrypted
only by the keys specified by the ecryptfs*_sig parameters.

>  fs/ecryptfs/ecryptfs_kernel.h |    1 +
>  fs/ecryptfs/keystore.c        |    7 +++++++
>  fs/ecryptfs/main.c            |    8 +++++++-
>  3 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 0032a9f..59ab793 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -377,6 +377,7 @@ struct ecryptfs_mount_crypt_stat {
>  #define ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES      0x00000010
>  #define ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK   0x00000020
>  #define ECRYPTFS_GLOBAL_ENCFN_USE_FEK          0x00000040
> +#define ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY    0x00000080
>  	u32 flags;
>  	struct list_head global_auth_tok_list;
>  	struct mutex global_auth_tok_list_mutex;
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 643d011..93f7785 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -459,6 +459,13 @@ ecryptfs_find_auth_tok_for_sig(
>  	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
>  						  mount_crypt_stat, sig)) {
>  
> +		/* if the flag ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY is set in the
> +		 * mount_crypt_stat structure, we prevent to use auth toks that are
> +		 * not inserted through the ecryptfs_add_global_auth_tok function.
> +		 */
> +		if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY)
> +			return -EINVAL;
> +
>  		rc = ecryptfs_keyring_auth_tok_for_sig(auth_tok_key, auth_tok,
>  						       sig);
>  	} else
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index cbd4e18..e372226 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -208,7 +208,8 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
>         ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
>         ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
>         ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
> -       ecryptfs_opt_unlink_sigs, ecryptfs_opt_err };
> +       ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
> +       ecryptfs_opt_err };
>  
>  static const match_table_t tokens = {
>  	{ecryptfs_opt_sig, "sig=%s"},
> @@ -223,6 +224,7 @@ static const match_table_t tokens = {
>  	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=%s"},
>  	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
>  	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
> +	{ecryptfs_opt_mount_auth_tok_only, "ecryptfs_mount_auth_tok_only"},
>  	{ecryptfs_opt_err, NULL}
>  };
>  
> @@ -406,6 +408,10 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
>  		case ecryptfs_opt_unlink_sigs:
>  			mount_crypt_stat->flags |= ECRYPTFS_UNLINK_SIGS;
>  			break;
> +		case ecryptfs_opt_mount_auth_tok_only:
> +			mount_crypt_stat->flags |= 
> +				ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY;
> +			break;
>  		case ecryptfs_opt_err:
>  		default:
>  			printk(KERN_WARNING
> -- 
> 1.7.2.3


