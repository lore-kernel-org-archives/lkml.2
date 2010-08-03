Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0HCAqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:46:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46151 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0HCAqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:46:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] mm: only build per-node scan_unevictable when NUMA is enabled
Cc: kosaki.motohiro@jp.fujitsu.com, Lee Schermerhorn <lee.schermerhorn@hp.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1280780612-10548-1-git-send-email-cascardo@holoscopio.com>
References: <1280780612-10548-1-git-send-email-cascardo@holoscopio.com>
Message-Id: <20100803085421.5A5E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  3 Aug 2010 09:46:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Non-NUMA systems do never create these files anyway, since they are only
> created by driver subsystem when NUMA is configured.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

This patch look good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


However, I'm not sure scan_unevictable feature have enough worth that
we continue to maintain. This feature mean "admins can restore unevictable
even if kernel have some bug". but I haven't seen such situation.

Anyway, I'm waiting Lee's response.


> ---
>  include/linux/swap.h |    5 +++++
>  mm/vmscan.c          |    3 ++-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index ff4acea..3c0876d 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -271,8 +271,13 @@ extern void scan_mapping_unevictable_pages(struct address_space *);
>  extern unsigned long scan_unevictable_pages;
>  extern int scan_unevictable_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
> +#ifdef CONFIG_NUMA
>  extern int scan_unevictable_register_node(struct node *node);
>  extern void scan_unevictable_unregister_node(struct node *node);
> +#else
> +static inline int scan_unevictable_register_node(struct node *node) {return 0;}
> +static inline void scan_unevictable_unregister_node(struct node *node) {}
> +#endif
>  
>  extern int kswapd_run(int nid);
>  extern void kswapd_stop(int nid);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b94fe1b..ba8f6fd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2898,6 +2898,7 @@ int scan_unevictable_handler(struct ctl_table *table, int write,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_NUMA
>  /*
>   * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
>   * a specified node's per zone unevictable lists for evictable pages.
> @@ -2944,4 +2945,4 @@ void scan_unevictable_unregister_node(struct node *node)
>  {
>  	sysdev_remove_file(&node->sysdev, &attr_scan_unevictable_pages);
>  }
> -
> +#endif
> -- 
> 1.7.1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



