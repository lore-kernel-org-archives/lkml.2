Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2JVQPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:15:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42816 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2JVQPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:15:00 -0400
Date: Mon, 22 Oct 2012 11:14:54 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 3/4] device_cgroup: stop using simple_strtoul()
Message-ID: <20121022161454.GC23199@sergelap>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022134537.125748392@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022134537.125748392@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> This patch converts the code to use kstrtou32() instead of simple_strtoul()
> which is deprecated. The real size of the variables are u32, so use kstrtou32
> instead of kstrtoul
> 
> 
> Cc: Dave Jones <davej@redhat.com>
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
> ---
>  security/device_cgroup.c |   28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2012-10-19 16:35:46.366102913 -0400
> +++ github/security/device_cgroup.c	2012-10-19 16:35:50.801229331 -0400
> @@ -361,8 +361,8 @@ static int devcgroup_update_access(struc
>  				   int filetype, const char *buffer)
>  {
>  	const char *b;
> -	char *endp;
> -	int count;
> +	char temp[12];		/* 11 + 1 characters needed for a u32 */
> +	int count, rc;
>  	struct dev_exception_item ex;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -405,8 +405,16 @@ 		return 0;
>  		ex.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		ex.major = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &ex.major);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> @@ -419,8 +427,16 @@ 		ex.major = simple_strtoul(b, &endp, 10
>  		ex.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		ex.minor = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &ex.minor);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> 
