Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0KBK5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 06:57:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35143 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0KBK5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 06:57:09 -0400
Subject: Re: [PATCH v1.1 4/4] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <201011021030.27253.roberto.sassu@polito.it>
References: <1286827903-3066-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1286827903-3066-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <201011021030.27253.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 06:56:52 -0400
Message-ID: <1288695412.16939.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 10:30 +0100, Roberto Sassu wrote:
> The buffer 'derived_buf' in the function get_derived_key() must be
> allocated dynamically in order to make room for an arbitrary length
> master key.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  security/keys/encrypted_defined.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
> index 5331925..65d9b13 100644
> --- a/security/keys/encrypted_defined.c
> +++ b/security/keys/encrypted_defined.c
> @@ -289,10 +289,20 @@ enum derived_key_type { ENC_KEY, AUTH_KEY };
>  static int get_derived_key(char *derived_key, enum derived_key_type key_type,
>  			   void *master_key, unsigned int master_keylen)
>  {
> -	char derived_buf[hash_size + 10];
> +	char *derived_buf;
>  	int ret;
> +	unsigned int derived_buf_len;
> +
> +	derived_buf_len = strlen("AUTH_KEY") + 1 + master_keylen;
> +	if (derived_buf_len < hash_size)
> +		derived_buf_len = hash_size;
> +
> +	derived_buf = kzalloc(derived_buf_len, GFP_KERNEL);
> +	if (!derived_buf) {
> +		pr_err("encrypted_key: out of memory\n");
> +		return -ENOMEM;
> +	}
>  
> -	memset(derived_buf, 0, sizeof derived_buf);

Thanks Roberto!

>  	if (key_type)
>  		strcpy(derived_buf, "AUTH_KEY");
>  	else
> @@ -301,6 +311,7 @@ static int get_derived_key(char *derived_key, enum derived_key_type key_type,
>  	memcpy(derived_buf + strlen(derived_buf) + 1, master_key,
>  	       master_keylen);
>  	ret = calc_hash(derived_key, derived_buf, sizeof derived_buf);
> +	kfree(derived_buf);
>  	return ret;
>  }
>  

Yes, and the length in calc_hash() would then need to be
derived_buf_len.

thanks,

Mimi

