Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0GLAIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 20:08:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab0GLAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 20:08:50 -0400
X-Authority-Analysis: v=1.1 cv=FmZLatDjtfD3C7oE6GdrxaCbsxiNBR9ZXBX9JZchN1o= c=1 sm=0 a=oHObucO0UQQA:10 a=GQCbJdZ--msA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=pGLkceISAAAA:8 a=hBqU3vQJAAAA:8 a=Z4Rwk6OoAAAA:8 a=swR7W9_4ddrjJen3iLgA:9 a=u10fKoUQluEoHr266g66r37qU9gA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=4gZ4WExUoD4A:10 a=zRoV-LlUuCdadAwS:21 a=CKr2PT_X6wZXI9PF:21 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Sun, 11 Jul 2010 19:10:22 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dan Carpenter <error27@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] cgroups: save space for the terminator
Message-ID: <20100712001022.GA6832@hallyn.com>
References: <20100710105429.GW19184@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100710105429.GW19184@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Carpenter (error27@gmail.com):
> The original code didn't leave enough space for a NULL terminator.
> These strings are copied with strcpy() into fixed length buffers in
> cgroup_root_from_opts().
>  
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Hmm, yes - the fact that kstrndup() allocs len+1 probably threw off
the author of these original lines.  Thanks for spotting this!

Acked-by: Serge E. Hallyn <serge@hallyn.com>


> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3ac6f5b..a942820 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1102,7 +1102,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  			if (opts->release_agent)
>  				return -EINVAL;
>  			opts->release_agent =
> -				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
> +				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
>  			if (!opts->release_agent)
>  				return -ENOMEM;
>  		} else if (!strncmp(token, "name=", 5)) {
> @@ -1123,7 +1123,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  			if (opts->name)
>  				return -EINVAL;
>  			opts->name = kstrndup(name,
> -					      MAX_CGROUP_ROOT_NAMELEN,
> +					      MAX_CGROUP_ROOT_NAMELEN - 1,
>  					      GFP_KERNEL);
>  			if (!opts->name)
>  				return -ENOMEM;
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
