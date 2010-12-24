Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0LXQUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 11:20:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:56999 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0LXQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 11:20:54 -0500
Subject: Re: [RFC][PATCH 2/6] encrypted-keys: added additional debug
 messages
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Gianluca Ramunno <ramunno@polito.it>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>, kirkland@canonical.com
In-Reply-To: <201012231834.30497.roberto.sassu@polito.it>
References: <201012231834.30497.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 11:20:42 -0500
Message-ID: <1293207642.3196.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 18:34 +0100, Roberto Sassu wrote:
> Some debug messages have been added in the function datablob_parse() in
> order to better identify errors returned when dealing with 'encrypted'
> keys.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

Other than the patches being mangled by the mailer, nice. Please
re-post.

Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/keys/encrypted_defined.c |   44 +++++++++++++++++++++++++++---------
>  1 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
> index c1c5e27..2bb2c47 100644
> --- a/security/keys/encrypted_defined.c
> +++ b/security/keys/encrypted_defined.c
> @@ -133,46 +133,68 @@ static int datablob_parse(char *datablob, char **master_desc,
>  	substring_t args[MAX_OPT_ARGS];
>  	int ret = -EINVAL;
>  	int key_cmd;
> -	char *p;
> +	char *p, *keyword;
>  
> -	p = strsep(&datablob, " \t");
> -	if (!p)
> +	keyword = strsep(&datablob, " \t");
> +	if (!keyword) {
> +		pr_err("encrypted_key: insufficient parameters specified\n");
>  		return ret;
> -	key_cmd = match_token(p, key_tokens, args);
> +	}
> +	key_cmd = match_token(keyword, key_tokens, args);
>  
>  	*master_desc = strsep(&datablob, " \t");
> -	if (!*master_desc)
> +	if (!*master_desc) {
> +		pr_err("encrypted_key: master key parameter is missing\n");
>  		goto out;
> +	}
>  
> -	if (valid_master_desc(*master_desc, NULL) < 0)
> +	if (valid_master_desc(*master_desc, NULL) < 0) {
> +		pr_err("encrypted_key: master key parameter \'%s\' "
> +		       "is invalid\n", *master_desc);
>  		goto out;
> +	}
>  
>  	if (decrypted_datalen) {
>  		*decrypted_datalen = strsep(&datablob, " \t");
> -		if (!*decrypted_datalen)
> +		if (!*decrypted_datalen) {
> +			pr_err("encrypted_key: keylen parameter is missing\n");
>  			goto out;
> +		}
>  	}
>  
>  	switch (key_cmd) {
>  	case Opt_new:
> -		if (!decrypted_datalen)
> +		if (!decrypted_datalen) {
> +			pr_err("encrypted_key: keyword \'%s\' not allowed when "
> +			       "updating an existent key\n", keyword);
>  			break;
> +		}
>  		ret = 0;
>  		break;
>  	case Opt_load:
> -		if (!decrypted_datalen)
> +		if (!decrypted_datalen) {
> +			pr_err("encrypted_key: keyword \'%s\' not allowed when "
> +			       "updating an existent key\n", keyword);
>  			break;
> +		}
>  		*hex_encoded_iv = strsep(&datablob, " \t");
> -		if (!*hex_encoded_iv)
> +		if (!*hex_encoded_iv) {
> +			pr_err("encrypted_key: hex blob is missing\n");
>  			break;
> +		}
>  		ret = 0;
>  		break;
>  	case Opt_update:
> -		if (decrypted_datalen)
> +		if (decrypted_datalen) {
> +			pr_err("encrypted_key: keyword \'%s\' not allowed when "
> +			       "instantiating a new key\n", keyword);
>  			break;
> +		}
>  		ret = 0;
>  		break;
>  	case Opt_err:
> +		pr_err("encrypted_key: keyword \'%s\' not recognized\n",
> +		       keyword);
>  		break;
>  	}
>  out:


