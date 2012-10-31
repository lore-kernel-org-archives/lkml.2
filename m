Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab2JaRVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:21:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab2JaRVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:21:11 -0400
Date: Wed, 31 Oct 2012 18:21:01 +0100
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Jiri Slaby <jslaby@suse.cz>, cgroups@vger.kernel.org
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Message-ID: <20121031172101.GC20848@serge-ThinkPad-X130e>
References: <20121031160430.GD14789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031160430.GD14789@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems. For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> Andrew, Tejun, this patch needs to make Linus tree ASAP or a revert for
> 4cef7299b4786879a3e113e84084a72b24590c5b.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Pavel Emelyanov <xemul@openvz.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> --- github.orig/security/device_cgroup.c	2012-10-26 17:18:01.739366780 -0400
> +++ github/security/device_cgroup.c	2012-10-29 10:03:33.221918003 -0400
> @@ -352,6 +352,8 @@
>   */
>  static inline int may_allow_all(struct dev_cgroup *parent)
>  {
> +	if (!parent)
> +		return 1;
>  	return parent->behavior == DEVCG_DEFAULT_ALLOW;
>  }
>  
> @@ -376,11 +378,14 @@
>  	int count, rc;
>  	struct dev_exception_item ex;
>  	struct cgroup *p = devcgroup->css.cgroup;
> -	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
> +	struct dev_cgroup *parent = NULL;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> +	if (p->parent)
> +		parent = cgroup_to_devcgroup(p->parent);
> +
>  	memset(&ex, 0, sizeof(ex));
>  	b = buffer;
>  
> @@ -391,11 +396,14 @@
>  			if (!may_allow_all(parent))
>  				return -EPERM;
>  			dev_exception_clean(devcgroup);
> +			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
> +			if (!parent)
> +				break;
> +
>  			rc = dev_exceptions_copy(&devcgroup->exceptions,
>  						 &parent->exceptions);
>  			if (rc)
>  				return rc;
> -			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			break;
>  		case DEVCG_DENY:
>  			dev_exception_clean(devcgroup);
