Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1DOHSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 03:18:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56248 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1DOHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 03:18:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: cpusets: randomize node rotor used in cpuset_mem_spread_node()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110414160145.0830.A69D9226@jp.fujitsu.com>
References: <20110414065146.GA19685@tiehlicka.suse.cz> <20110414160145.0830.A69D9226@jp.fujitsu.com>
Message-Id: <20110415161831.12F8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 16:18:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops.
I should have look into !mempolicy part too.
I'm sorry.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index e7548de..f59c686 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1119,6 +1119,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>   	}
>  	mpol_fix_fork_child_flag(p);
>  #endif
> +#ifdef CONFIG_CPUSETS
> +	p->cpuset_mem_spread_rotor = node_random(&p->mems_allowed);
> +	p->cpuset_slab_spread_rotor = node_random(&p->mems_allowed);
> +#endif

Michal, I think this should be

#ifdef CONFIG_CPUSETS
	if (cpuset_do_page_mem_spread())
		p->cpuset_mem_spread_rotor = node_random(&p->mems_allowed);
	if (cpuset_do_slab_mem_spread())
		p->cpuset_slab_spread_rotor = node_random(&p->mems_allowed);
#endif

because 99.999% people don't use cpuset's spread mem/slab feature and
get_random_int() isn't zero cost.

What do you think?



