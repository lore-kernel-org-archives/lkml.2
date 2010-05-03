Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab0ECWEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:04:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48825 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab0ECWEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:04:32 -0400
Date: Mon, 3 May 2010 17:04:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KEYS: Fix an RCU warning in the reading of user
 keys
Message-ID: <20100503220420.GA6968@us.ibm.com>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Fix an RCU warning in the reading of user keys:
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> security/keys/user_defined.c:202 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 1 lock held by keyctl/3637:
>  #0:  (&key->sem){+++++.}, at: [<ffffffff811a80ae>] keyctl_read_key+0x9c/0xcf
> 
> stack backtrace:
> Pid: 3637, comm: keyctl Not tainted 2.6.34-rc5-cachefs #18
> Call Trace:
>  [<ffffffff81051f6c>] lockdep_rcu_dereference+0xaa/0xb2
>  [<ffffffff811aa55f>] user_read+0x47/0x91
>  [<ffffffff811a80be>] keyctl_read_key+0xac/0xcf
>  [<ffffffff811a8a06>] sys_keyctl+0x75/0xb7
>  [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

heck it also serves to document it a bit, as looking at the fn
itself it's not clear that it is called under key->sem.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  security/keys/user_defined.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
> index 7c687d5..e9aa079 100644
> --- a/security/keys/user_defined.c
> +++ b/security/keys/user_defined.c
> @@ -199,7 +199,8 @@ long user_read(const struct key *key, char __user *buffer, size_t buflen)
>  	struct user_key_payload *upayload;
>  	long ret;
> 
> -	upayload = rcu_dereference(key->payload.data);
> +	upayload = rcu_dereference_protected(
> +		key->payload.data, rwsem_is_locked(&((struct key *)key)->sem));
>  	ret = upayload->datalen;
> 
>  	/* we can return the data as is */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
