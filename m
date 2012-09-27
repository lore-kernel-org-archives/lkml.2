Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2I0HiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:38:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab2I0Hh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:37:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,495,1344182400"; 
   d="scan'208";a="5926546"
Message-ID: <5064008B.70103@cn.fujitsu.com>
Date: Thu, 27 Sep 2012 15:30:19 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org, tglx@linutronix.de,
        mingo@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: use the correct macros
References: <50625633.6020808@jp.fujitsu.com>
In-Reply-To: <50625633.6020808@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 15:24:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 15:24:47,
	Serialize complete at 2012/09/27 15:24:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/26/2012 09:11 AM, Yasuaki Ishimatsu Wrote:
> This patch fixes to use the correct macros. 

But you don't fix all. For example:
=================
	arg.start_pfn = pfn;
	arg.nr_pages = nr_pages;
	arg.status_change_nid = -1;     <====== here

	nid = page_to_nid(pfn_to_page(pfn));
	if (node_present_pages(nid) == 0)
		arg.status_change_nid = nid;

	ret = memory_notify(MEM_GOING_ONLINE, &arg);
==================

There is the same problem in the function offline_pages() too.

Thanks
Wen Congyang

> 
> CC: Len Brown <lenb@kernel.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    2 +-
>  drivers/acpi/numa.c         |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-3.6-rc5/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-3.6-rc5.orig/arch/x86/kernel/acpi/boot.c	2012-09-13 15:44:30.000000000 +0900
> +++ linux-3.6-rc5/arch/x86/kernel/acpi/boot.c	2012-09-13 15:46:31.743850426 +0900
> @@ -601,7 +601,7 @@ static void __cpuinit acpi_map_cpu2node(
>  	int nid;
>  
>  	nid = acpi_get_node(handle);
> -	if (nid == -1 || !node_online(nid))
> +	if (nid == NUMA_NO_NODE || !node_online(nid))
>  		return;
>  	set_apicid_to_node(physid, nid);
>  	numa_set_node(cpu, nid);
> Index: linux-3.6-rc5/drivers/acpi/numa.c
> ===================================================================
> --- linux-3.6-rc5.orig/drivers/acpi/numa.c	2012-09-13 15:44:59.000000000 +0900
> +++ linux-3.6-rc5/drivers/acpi/numa.c	2012-09-13 15:46:03.079850552 +0900
> @@ -327,12 +327,12 @@ int acpi_get_pxm(acpi_handle h)
>  			return pxm;
>  		status = acpi_get_parent(handle, &phandle);
>  	} while (ACPI_SUCCESS(status));
> -	return -1;
> +	return PXM_INVAL;
>  }
>  
>  int acpi_get_node(acpi_handle *handle)
>  {
> -	int pxm, node = -1;
> +	int pxm, node = NUMA_NO_NODE;
>  
>  	pxm = acpi_get_pxm(handle);
>  	if (pxm >= 0 && pxm < MAX_PXM_DOMAINS)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

