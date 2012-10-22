Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab2JVQQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:16:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JVQQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:16:15 -0400
Date: Mon, 22 Oct 2012 11:16:10 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/4] device_cgroup: add proper checking when changing
 default behavior
Message-ID: <20121022161610.GD23199@sergelap>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022134537.447117744@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022134537.447117744@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> Before changing a group's default behavior to ALLOW, we must check if its
> parent's behavior is also ALLOW.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

Thanks, Aristeu.

> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> --- github.orig/security/device_cgroup.c	2012-10-19 16:36:50.135790476 -0400
> +++ github/security/device_cgroup.c	2012-10-19 16:48:50.710978125 -0400
> @@ -344,6 +344,17 @@ static int parent_has_perm(struct dev_cg
>  	return may_access(parent, ex);
>  }
>  
> +/**
> + * may_allow_all - checks if it's possible to change the behavior to
> + *		   allow based on parent's rules.
> + * @parent: device cgroup's parent
> + * returns: != 0 in case it's allowed, 0 otherwise
> + */
> +static inline int may_allow_all(struct dev_cgroup *parent)
> +{
> +	return parent->behavior == DEVCG_DEFAULT_ALLOW;
> +}
> +
>  /*
>   * Modify the exception list using allow/deny rules.
>   * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
> @@ -364,6 +375,8 @@ static int devcgroup_update_access(struc
>  	char temp[12];		/* 11 + 1 characters needed for a u32 */
>  	int count, rc;
>  	struct dev_exception_item ex;
> +	struct cgroup *p = devcgroup->css.cgroup;
> +	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -375,9 +388,13 @@ 	memset(&ex, 0, sizeof(ex));
>  	case 'a':
>  		switch (filetype) {
>  		case DEVCG_ALLOW:
> -			if (!parent_has_perm(devcgroup, &ex))
> +			if (!may_allow_all(parent))
>  				return -EPERM;
>  			dev_exception_clean(devcgroup);
> +			rc = dev_exceptions_copy(&devcgroup->exceptions,
> +						 &parent->exceptions);
> +			if (rc)
> +				return rc;
>  			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			break;
>  		case DEVCG_DENY:
> 
