Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0ICXy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:54:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab0ICXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:54:58 -0400
Date: Fri, 3 Sep 2010 16:54:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix integer overflow in groups_search
Message-Id: <20100903165446.378e8ceb.akpm@linux-foundation.org>
In-Reply-To: <4C7FC0B4.3040005@redhat.com>
References: <4C7FC0B4.3040005@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 17:20:20 +0200
Jerome Marchand <jmarchan@redhat.com> wrote:

> 
> gid_t is a unsigned int. If group_info contains a gid greater than
> MAX_INT, groups_search() function may look on the wrong side of the 
> search tree.
> This solves some unfair "permission denied" problems.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 53b1916..253dc0f 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -143,10 +143,9 @@ int groups_search(const struct group_info *group_info, gid_t grp)
>  	right = group_info->ngroups;
>  	while (left < right) {
>  		unsigned int mid = (left+right)/2;
> -		int cmp = grp - GROUP_AT(group_info, mid);
> -		if (cmp > 0)
> +		if (grp > GROUP_AT(group_info, mid))
>  			left = mid + 1;
> -		else if (cmp < 0)
> +		else if (grp < GROUP_AT(group_info, mid))
>  			right = mid;
>  		else
>  			return 1;

hah, that's some pretty ancient code there.  You must have a lot of
groups.

The patch is a no-brainer and I guess you've encountered the bug in
real kernels so I think we'll wave the fix at the -stable guys for
backporting, OK?

