Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1LVPUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:20:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62848 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1LVPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:20:18 -0500
Date: Thu, 22 Dec 2011 07:20:11 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Message-ID: <20111222152011.GA17084@google.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF2EDA7.4010004@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 04:43:19PM +0800, Li Zefan wrote:
> Always check the validity of mount options in parse_cgroupfs_options().
> 
> No functional change.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 4936d88..bdb7994 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  	    (opts->subsys_bits & mask))
>  		return -EINVAL;
>  
> -
>  	/* Can't specify "none" and some subsystems */
>  	if (opts->subsys_bits && opts->none)
>  		return -EINVAL;
> @@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  		return -EINVAL;
>  
>  	/*
> +	 * This can happen only when none of the subsystems is enabled
> +	 * in the system.
> +	 */
> +	if (!opts->subsys_bits && !opts->none)
> +		return -EINVAL;

The three ifs here share a lot and I think sharing the common parts
would make the logic clearer.  e.g. The first and this can be easily
combined to (bool)opts->subsys_bits != (bool)opts->none which would
explain the logic better too.

> @@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
>  	int ret;
>  	struct cgroup_sb_opts *opts = data;
>  
> -	/* If we don't have a new root, we can't set up a new sb */
> -	if (!opts->new_root)
> -		return -EINVAL;
> -

And where did this one go?

Thanks.

-- 
tejun
