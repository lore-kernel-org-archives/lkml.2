Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2DRStB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:49:01 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35923 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2DRSs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:48:58 -0400
Date: Wed, 18 Apr 2012 18:49:55 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 20/43] userns: Replace user_ns_map_uid and
 user_ns_map_gid with from_kuid and from_kgid
Message-ID: <20120418184955.GE4984@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-20-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-20-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> These function are no longer needed replace them with their more useful equivalents.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/user_namespace.h |   12 ------------
>  ipc/mqueue.c                   |    3 +--
>  kernel/signal.c                |    2 +-
>  net/core/sock.c                |    4 ++--
>  4 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index a2c6145..4e72922 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -69,16 +69,4 @@ static inline void put_user_ns(struct user_namespace *ns)
>  
>  #endif
>  
> -static inline uid_t user_ns_map_uid(struct user_namespace *to,
> -	const struct cred *cred, kuid_t uid)
> -{
> -	return from_kuid_munged(to, uid);
> -}
> -
> -static inline gid_t user_ns_map_gid(struct user_namespace *to,
> -	const struct cred *cred, kgid_t gid)
> -{
> -	return from_kgid_munged(to, gid);
> -}
> -
>  #endif /* _LINUX_USER_H */
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index b53cf34..b6a0d46 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -538,8 +538,7 @@ static void __do_notify(struct mqueue_inode_info *info)
>  			rcu_read_lock();
>  			sig_i.si_pid = task_tgid_nr_ns(current,
>  						ns_of_pid(info->notify_owner));
> -			sig_i.si_uid = user_ns_map_uid(info->notify_user_ns,
> -						current_cred(), current_uid());
> +			sig_i.si_uid = from_kuid_munged(info->notify_user_ns, current_uid());
>  			rcu_read_unlock();
>  
>  			kill_pid_info(info->notify.sigev_signo,
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 2734dc9..d630327 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1026,7 +1026,7 @@ static inline int legacy_queue(struct sigpending *signals, int sig)
>  static inline uid_t map_cred_ns(const struct cred *cred,
>  				struct user_namespace *ns)
>  {
> -	return user_ns_map_uid(ns, cred, cred->uid);
> +	return from_kuid_munged(ns, cred->uid);
>  }
>  
>  #ifdef CONFIG_USER_NS
> diff --git a/net/core/sock.c b/net/core/sock.c
> index b2e14c0..e1ec8ba 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -821,8 +821,8 @@ void cred_to_ucred(struct pid *pid, const struct cred *cred,
>  	if (cred) {
>  		struct user_namespace *current_ns = current_user_ns();
>  
> -		ucred->uid = user_ns_map_uid(current_ns, cred, cred->euid);
> -		ucred->gid = user_ns_map_gid(current_ns, cred, cred->egid);
> +		ucred->uid = from_kuid(current_ns, cred->euid);
> +		ucred->gid = from_kgid(current_ns, cred->egid);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(cred_to_ucred);
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
