Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2DRS5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:57:39 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43795 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2DRS5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:57:37 -0400
Date: Wed, 18 Apr 2012 18:58:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 26/43] userns: Convert in_group_p and in_egroup_p to
 use kgid_t
Message-ID: <20120418185835.GC5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-26-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-26-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  include/linux/cred.h |    4 ++--
>  kernel/groups.c      |   14 ++++++--------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index fac0579..917dc5a 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -73,8 +73,8 @@ extern int groups_search(const struct group_info *, kgid_t);
>  #define GROUP_AT(gi, i) \
>  	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
>  
> -extern int in_group_p(gid_t);
> -extern int in_egroup_p(gid_t);
> +extern int in_group_p(kgid_t);
> +extern int in_egroup_p(kgid_t);
>  
>  /*
>   * The common credentials for a thread group
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 84156f2..6b2588d 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -256,27 +256,25 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>  /*
>   * Check whether we're fsgid/egid or in the supplemental group..
>   */
> -int in_group_p(gid_t grp)
> +int in_group_p(kgid_t grp)
>  {
>  	const struct cred *cred = current_cred();
>  	int retval = 1;
>  
> -	if (grp != cred->fsgid)
> -		retval = groups_search(cred->group_info,
> -				       make_kgid(cred->user_ns, grp));
> +	if (!gid_eq(grp, cred->fsgid))
> +		retval = groups_search(cred->group_info, grp);
>  	return retval;
>  }
>  
>  EXPORT_SYMBOL(in_group_p);
>  
> -int in_egroup_p(gid_t grp)
> +int in_egroup_p(kgid_t grp)
>  {
>  	const struct cred *cred = current_cred();
>  	int retval = 1;
>  
> -	if (grp != cred->egid)
> -		retval = groups_search(cred->group_info,
> -				       make_kgid(cred->user_ns, grp));
> +	if (!gid_eq(grp, cred->egid))
> +		retval = groups_search(cred->group_info, grp);
>  	return retval;
>  }
>  
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
