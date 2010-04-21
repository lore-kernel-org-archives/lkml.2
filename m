Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab0DUUMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:12:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35723 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab0DUUMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:12:23 -0400
Date: Wed, 21 Apr 2010 13:12:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, eric.dumazet@gmail.com,
       keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix an RCU warning in the reading of user keys
Message-ID: <20100421201219.GJ2563@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100421163634.14538.74339.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421163634.14538.74339.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 05:36:35PM +0100, David Howells wrote:
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

Queued for 2.6.34, thank you David!

							Thanx, Paul

> Signed-off-by: David Howells <dhowells@redhat.com>
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
