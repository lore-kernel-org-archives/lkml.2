Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab1CIUPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:15:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61710 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1CIUPj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 9 Mar 2011 15:15:39 -0500
Date: Wed, 9 Mar 2011 15:14:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Xen-devel] [PATCH R4 7/7] xen/balloon: Memory hotplug support
 for Xen balloon driver
Message-ID: <20110309201403.GJ8049@dumpdata.com>
References: <20110308215049.GH27331@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308215049.GH27331@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D77DFAB.005A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		credit = current_target() - balloon_stats.current_pages;
> +		credit = current_credit();
>  
> -		if (credit > 0)
> -			state = increase_reservation(credit);
> +		if (credit > 0) {
> +			if (balloon_is_inflated())
> +				state = increase_reservation(credit);
> +			else
> +				state = reserve_additional_memory(credit);
> +		}

This code manipulation of where the current_target becomes current_credit
(and that logic) should be split off in its own patch.

Otherwise all the patches that touch Xen code look good.
>  
>  		if (credit < 0)
>  			state = decrease_reservation(-credit);
> @@ -458,6 +594,14 @@ static int __init balloon_init(void)
>  	balloon_stats.retry_count = 1;
>  	balloon_stats.max_retry_count = 16;
>  
> +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> +	balloon_stats.hotplug_pages = 0;
> +	balloon_stats.balloon_hotplug = 0;
> +
> +	register_online_page_notifier(&xen_online_page_nb);
> +	register_memory_notifier(&xen_memory_nb);
> +#endif
> +
>  	register_balloon(&balloon_sysdev);
>  
>  	/*
> -- 
> 1.5.6.5
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
