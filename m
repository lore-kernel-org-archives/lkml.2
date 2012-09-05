Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2IEDVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:21:37 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:36259 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2IEDVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:21:36 -0400
Date: Wed, 5 Sep 2012 03:22:10 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/6] device_cgroup: stop using simple_strtoul()
Message-ID: <20120905032209.GD13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
 <20120904143421.144153057@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904143421.144153057@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> This patch converts the code to use kstrtou32() instead of simple_strtoul()
> which is deprecated. The real size of the variables are u32, so use kstrtou32
> instead of kstrtoul
> 
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

phew, i'm afraid i'm not up on the latest 'best parsing techniques' 
but the end result looks correct (just not sure it's optimal).

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> 
> ---
>  security/device_cgroup.c |   28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-08-21 10:51:05.751689805 -0400
> +++ github/security/device_cgroup.c	2012-08-21 10:51:15.015951623 -0400
> @@ -361,8 +361,8 @@
>  				   int filetype, const char *buffer)
>  {
>  	const char *b;
> -	char *endp;
> -	int count;
> +	char temp[12];		/* 11 + 1 characters needed for a u32 */
> +	int count, rc;
>  	struct dev_whitelist_item wh;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -405,8 +405,16 @@
>  		wh.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.major = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &wh.major);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> @@ -419,8 +427,16 @@
>  		wh.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.minor = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &wh.minor);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
