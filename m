Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab2LCRo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:44:26 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61103 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2LCRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:44:20 -0500
Date: Mon, 3 Dec 2012 09:44:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/5] device_cgroup: make may_access() stronger
Message-ID: <20121203174414.GI19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.817704289@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127193502.817704289@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 27, 2012 at 02:35:05PM -0500, Aristeu Rozanski wrote:
> @@ -375,22 +376,33 @@
>  			continue;
>  		if (refex->access & (~ex->access))
>  			continue;
> -		match = true;
> +		match = 1;
>  		break;
>  	}
>  
>  	/*
> -	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
> -	 * - the dev cgroup has its default policy to deny + exception list:
> -	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> +	 * The only three possibilities are:
> +	 * devcg->behavior == ALLOW, rule behavior == ALLOW
> +	 * devcg->behavior == ALLOW, rule behavior == DENY
> +	 * devcg->behavior == DENY, rule behavior == DENY
> +	 * the remaining
> +	 * devcg->behavior == DENY, rule behavior == ALLOW
> +	 * won't be possible by hierarchy
> +	 *
> +	 * Since we want to simplify the code, here're the possibilites to
> +	 * make easier to understand:
> +	 *
> +	 * devcg behavior   rule behavior  match  result
> +	 * allow            allow          1      0
> +	 * allow            allow          0      1
> +	 * allow            deny           1      0
> +	 * allow            deny           0      1
> +	 * deny             deny           1      1
> +	 * deny             deny           0      0
>  	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW)
> +		return !match;
> +	return match;

I kinda dislike this.  This isn't a performanc critical path where we
must try our best to shave off a few condition checks.  There's no
reason to encode the test like this.  Please just spell the conditions
out in code rather than trying to build a magic series of equality
tests which somehow ends up spewing out the correct results.

Thanks.

-- 
tejun
