Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab1LGVqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:46:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45120 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1LGVqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:46:07 -0500
Date: Wed, 7 Dec 2011 13:46:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Holasek <pholasek@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] NUMA x86: add constraints check for nid parameters
In-Reply-To: <20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com> <20111201133451.5fc1ee7b.akpm@linux-foundation.org> <20111201231441.GA3293@stainedmachine.redhat.com> <20111201152851.7e39f034.akpm@linux-foundation.org> <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com> <20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Petr Holasek wrote:

> This patch adds constraints checks for numa_set_distance()
> function. It emits warning when pxms are used uninitialized
> when parsing the SRAT.
> 

The changelog also needs to indicate that, in addition to emitting the 
warning, that this will avoid a store to a negative index in the 
numa_distance[] array, that's the real thing you're trying to catch.  This 
would happen if pxm_to_node() is returning NUMA_NO_NODE which is what the 
pxm-to-node mapping is initialized to.

> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> ---
>  arch/x86/mm/numa.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index fbeaaf4..42c12b6 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -430,8 +430,9 @@ static int __init numa_alloc_distance(void)
>   * calls are ignored until the distance table is reset with
>   * numa_reset_distance().
>   *
> - * If @from or @to is higher than the highest known node at the time of
> - * table creation or @distance doesn't make sense, the call is ignored.
> + * If @from or @to is higher than the highest known node or lower than zero
> + * at the time of table creation or @distance doesn't make sense, the call
> + * is ignored.
>   * This is to allow simplification of specific NUMA config implementations.
>   */
>  void __init numa_set_distance(int from, int to, int distance)
> @@ -439,7 +440,8 @@ void __init numa_set_distance(int from, int to, int distance)
>  	if (!numa_distance && numa_alloc_distance() < 0)
>  		return;
>  
> -	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
> +	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
> +			from < 0 || to < 0) {
>  		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
>  			    from, to, distance);

That warning doesn't look appropriate for negative node ids, it should be 
modified to say the node ids or distance are out of bounds.  One more 
revision?

>  		return;
