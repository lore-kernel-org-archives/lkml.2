Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1KRTxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:53:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1KRTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:53:38 -0500
Date: Fri, 18 Nov 2011 11:53:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Holasek <pholasek@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH 1/2] NUMA emulation x86_64: numa=fake parameter for
 custom nodes distance
Message-Id: <20111118115336.18de45a0.akpm@linux-foundation.org>
In-Reply-To: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 12:55:07 +0100
Petr Holasek <pholasek@redhat.com> wrote:

> As default, when numa emulation is turned on, node distance table
> uses physical distance, so for 4 nodes emulated on 1 physical table is
> 
> node   0   1   2   3
> 0:  10  10  10  10
> 1:  10  10  10  10
> 2:  10  10  10  10
> 3:  10  10  10  10
> 
> This patch adds new [distance] argument to
> 
> numa=fake=<number/size of nodes>[,distance]
> 
> When distance argument is used, it sets linear distance between nodes
> like that:
> 
>     __distance__
> ___|___     ____|___     ________     ________
> |       |   |        |   |        |   |        |
> | node1 |---| node 2 |---| node 3 |---| node 4 |
> |_______|   |________|   |________|   |________|
> |                        |             |
> |                        |             |
> |____distance * 2________|             |
> |                                      |
> |____________distance * 3______________|
> 
> This feature might be useful for testing some numa awareness features in
> both user and kernel spaces.
> 

"might" is a red flag.  We don't merge things which might be useful!

*Is* it useful?  If so then please tell us why and explain how it might
be useful to others.

> @@ -404,6 +406,17 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
>  			emu_nid_to_phys[i] = dfl_phys_nid;
>  
> +	/* load distance level parameter */
> +	dist_level = -1;
> +	c = strchr(emu_cmdline, ',');
> +	if (c) {
> +		c++;
> +		ret = kstrtoul(c, 10, &dist_level);
> +		if (ret < 0 || dist_level < LOCAL_DISTANCE ||
> +				dist_level * max_emu_nid > ULONG_MAX)
> +			dist_level = -1;

If this happens, the user goofed and we should tell them, with a printk.


[patch 2/2] adds the documentation for the feature and should be
included in the same patch as the implementation.

