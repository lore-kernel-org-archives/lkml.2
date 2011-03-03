Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1CCVXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:23:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41245 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:23:43 -0500
Subject: Re: [Keyrings] [PATCH] KEYS: Add an RCU payload dereference macro
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110303173248.10374.11548.stgit@warthog.procyon.org.uk>
References: <20110303173248.10374.11548.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:23:39 -0500
Message-ID: <1299187419.3658.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 17:32 +0000, David Howells wrote:
> Add an RCU payload dereference macro as this seems to be a common piece of code
> amongst key types that use RCU referenced payloads.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Yes, a lot cleaner. thanks!

Signed-of-by: Mimi Zohar <zohar@us.ibm.com>

> ---
> 
>  include/linux/key.h          |    4 ++++
>  security/keys/encrypted.c    |    3 +--
>  security/keys/trusted.c      |    3 +--
>  security/keys/user_defined.c |    3 +--
>  4 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/key.h b/include/linux/key.h
> index 3db0adc..a6b1edc 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -275,6 +275,10 @@ static inline key_serial_t key_serial(struct key *key)
>  	return key ? key->serial : 0;
>  }
> 
> +#define rcu_dereference_key(KEY)					\
> +	(rcu_dereference_protected((KEY)->payload.rcudata,		\
> +				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
> +
>  #ifdef CONFIG_SYSCTL
>  extern ctl_table key_sysctls[];
>  #endif
> diff --git a/security/keys/encrypted.c b/security/keys/encrypted.c
> index 9e7e4ce..69907a5 100644
> --- a/security/keys/encrypted.c
> +++ b/security/keys/encrypted.c
> @@ -765,8 +765,7 @@ static long encrypted_read(const struct key *key, char __user *buffer,
>  	size_t asciiblob_len;
>  	int ret;
> 
> -	epayload = rcu_dereference_protected(key->payload.data,
> -				  rwsem_is_locked(&((struct key *)key)->sem));
> +	epayload = rcu_dereference_key(key);
> 
>  	/* returns the hex encoded iv, encrypted-data, and hmac as ascii */
>  	asciiblob_len = epayload->datablob_len + ivsize + 1
> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
> index 83fc92e..c99b936 100644
> --- a/security/keys/trusted.c
> +++ b/security/keys/trusted.c
> @@ -1076,8 +1076,7 @@ static long trusted_read(const struct key *key, char __user *buffer,
>  	char *bufp;
>  	int i;
> 
> -	p = rcu_dereference_protected(key->payload.data,
> -			rwsem_is_locked(&((struct key *)key)->sem));
> +	p = rcu_dereference_key(key);
>  	if (!p)
>  		return -EINVAL;
>  	if (!buffer || buflen <= 0)
> diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
> index 02807fb..c6ca866 100644
> --- a/security/keys/user_defined.c
> +++ b/security/keys/user_defined.c
> @@ -184,8 +184,7 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
>  	struct user_key_payload *upayload;
>  	long ret;
> 
> -	upayload = rcu_dereference_protected(
> -		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
> +	upayload = rcu_dereference_key(key);
>  	ret = upayload->datalen;
> 
>  	/* we can return the data as is */
> 
> _______________________________________________
> Keyrings mailing list
> Keyrings@linux-nfs.org
> To change your subscription to this list, please see http://linux-nfs.org/cgi-bin/mailman/listinfo/keyrings


