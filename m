Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0DTMqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:46:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58144 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0DTMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XxSucxejfwRMDR5nREu+QXj8dGv2CJjU+CU3fAWrpGp+6S3erVfBCnlY+eQx9FIF4g
         K8qEmeyG+oP3OI9RfSxIVtRTIcnLg1kD5BeljqqinY/Dqk6c6eGhbJkmKhbpRTRNTi7B
         gX6xYeTAaPFYzippBBZ3uIHsk88cpmzAMlbis=
Subject: Re: [PATCH] KEYS: Fix an RCU warning
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100420102549.31890.6348.stgit@warthog.procyon.org.uk>
References: <20100420102549.31890.6348.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 14:46:04 +0200
Message-ID: <1271767564.3845.224.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 avril 2010 à 11:25 +0100, David Howells a écrit :
> Fix the following RCU warning:
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> security/keys/request_key.c:116 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 1 lock held by keyctl/5372:
>  #0:  (key_types_sem){.+.+.+}, at: [<ffffffff811a4e3d>] key_type_lookup+0x1c/0x70
> 
> stack backtrace:
> Pid: 5372, comm: keyctl Not tainted 2.6.34-rc3-cachefs #150
> Call Trace:
>  [<ffffffff810515f8>] lockdep_rcu_dereference+0xaa/0xb2
>  [<ffffffff811a9220>] call_sbin_request_key+0x156/0x2b6
>  [<ffffffff811a4c66>] ? __key_instantiate_and_link+0xb1/0xdc
>  [<ffffffff811a4cd3>] ? key_instantiate_and_link+0x42/0x5f
>  [<ffffffff811a96b8>] ? request_key_auth_new+0x17b/0x1f3
>  [<ffffffff811a8e00>] ? request_key_and_link+0x271/0x400
>  [<ffffffff810aba6f>] ? kmem_cache_alloc+0xe1/0x118
>  [<ffffffff811a8f1a>] request_key_and_link+0x38b/0x400
>  [<ffffffff811a7b72>] sys_request_key+0xf7/0x14a
>  [<ffffffff81052227>] ? trace_hardirqs_on_caller+0x10c/0x130
>  [<ffffffff81393f5c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
> 
> This was caused by doing:
> 
> 	[root@andromeda ~]# keyctl newring fred @s
> 	539196288
> 	[root@andromeda ~]# keyctl request2 user a a 539196288
> 	request_key: Required key not available
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks !

>  security/keys/request_key.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/security/keys/request_key.c b/security/keys/request_key.c
> index 03fe63e..ea97c31 100644
> --- a/security/keys/request_key.c
> +++ b/security/keys/request_key.c
> @@ -68,7 +68,8 @@ static int call_sbin_request_key(struct key_construction *cons,
>  {
>  	const struct cred *cred = current_cred();
>  	key_serial_t prkey, sskey;
> -	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
> +	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
> +		*session;
>  	char *argv[9], *envp[3], uid_str[12], gid_str[12];
>  	char key_str[12], keyring_str[3][12];
>  	char desc[20];
> @@ -112,10 +113,12 @@ static int call_sbin_request_key(struct key_construction *cons,
>  	if (cred->tgcred->process_keyring)
>  		prkey = cred->tgcred->process_keyring->serial;
>  
> -	if (cred->tgcred->session_keyring)
> -		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
> -	else
> -		sskey = cred->user->session_keyring->serial;
> +	rcu_read_lock();
> +	session = rcu_dereference(cred->tgcred->session_keyring);
> +	if (!session)
> +		session = cred->user->session_keyring;
> +	sskey = session->serial;
> +	rcu_read_unlock();
>  
>  	sprintf(keyring_str[2], "%d", sskey);
>  
> 


