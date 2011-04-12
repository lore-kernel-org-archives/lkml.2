Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1DLSw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:52:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1DLSw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=izcgywgSPvjZZlkdPaVrMXhbOaerYiW1WgzTTWWyWDsiuqt9MHLBdi+mnv3qvx7C5e
         41xJRGax8fzSrxmhixqosEcC/8T1xwQNOMfc6ACcx0qzFM8DmRE8lyG3KGB52OO9HcJ7
         VEETzxn1GV2Ap2ViqBU0/X9DjTV7K0vkDOmJI=
Date: Wed, 13 Apr 2011 03:52:21 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux.com
Subject: Re: [PATCH 2/4]percpu_counter: use correct API
Message-ID: <20110412185221.GC16342@mtj.dyndns.org>
References: <1302595441.3981.128.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302595441.3981.128.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:04:01PM +0800, Shaohua Li wrote:
> percpu_counter_sum_positive never returns negative, since there
> is a negative check, I changed it to percpu_counter_sum.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/fs/ext4/balloc.c
> ===================================================================
> --- linux.orig/fs/ext4/balloc.c	2011-04-12 15:48:42.000000000 +0800
> +++ linux/fs/ext4/balloc.c	2011-04-12 15:48:50.000000000 +0800
> @@ -506,7 +506,7 @@ static int ext4_has_free_blocks(struct e
>  	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
>  						EXT4_FREEBLOCKS_WATERMARK) {
>  		free_blocks  = percpu_counter_sum_positive(fbc);
> -		dirty_blocks = percpu_counter_sum_positive(dbc);
> +		dirty_blocks = percpu_counter_sum(dbc);
>  		if (dirty_blocks < 0) {
>  			printk(KERN_CRIT "Dirty block accounting "
>  					"went wrong %lld\n",

The right thing to do would be removing if (dirty_blocks < 0) and keep
using _positive.  perpcu_counter_sum() may return a negative number
spuriously (that's the whole point of _positive functions) and may
trigger the critial error path when nothing is really wrong.

Thanks.

-- 
tejun
