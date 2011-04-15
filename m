Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1DOVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:09:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:48363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab1DOVJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,221,1301900400"; 
   d="scan'208";a="734038489"
Message-ID: <4DA8B3FB.5020401@linux.intel.com>
Date: Fri, 15 Apr 2011 14:09:15 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        shaohua.li@intel.com, alex.shi@intel.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
References: <1302892769.2577.24.camel@schen9-DESK>
In-Reply-To: <1302892769.2577.24.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/2011 11:39 AM, Tim Chen wrote:
> During RCU walk in path_lookupat and path_openat, the rcu lookup
> frequently failed because when root directory was looked up, seq number
> was not properly set in nameidata.  We dropped out of RCU walk in
> nameidata_drop_rcu due to mismatch in directory entry's seq number.  We
> reverted to slow path walk that need to take references.

Thanks Tim. Adding Andrew, Linus too. IMHO this fix is quite important to
actually make the fabled RCU dcache work -- without it it's just slower 
because
it will fallback nearly allways.

And it's a correctness fix because with the bogus sequence number you 
could fail
to detect a race on root's dentry, leading to very subtle malfunction.

Could it be merged ASAP please?
Also should be a stable candidate for .38 (whoever merges it please
add a Cc: stable@kernel.org # .38)

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

> With the following patch, I saw a 50% increase in an exim mail server
> benchmark throughput on a 4-socket Nehalem-EX system.
>
> Thanks.
>
> Tim
>
> Signed-off-by: Tim Chen<tim.c.chen@linux.intel.com>
> diff --git a/fs/namei.c b/fs/namei.c
> index 3cb616d..e4b27a6 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -697,6 +697,7 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
>   		do {
>   			seq = read_seqcount_begin(&fs->seq);
>   			nd->root = fs->root;
> +			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
>   		} while (read_seqcount_retry(&fs->seq, seq));
>   	}
>   }
>
>

