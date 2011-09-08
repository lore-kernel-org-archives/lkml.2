Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1IHPNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:13:19 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:8110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1IHPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:13:10 -0400
X-IronPort-AV: E=Sophos;i="4.68,351,1312156800"; 
   d="scan'208";a="7680104"
Date: Thu, 8 Sep 2011 16:21:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH x86,mm]  fix pgt_buf_end when memory hotplug
In-Reply-To: <4E688C03.7080608@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1109081616450.12963@kaball-desktop>
References: <4E688C03.7080608@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Lai Jiangshan wrote:
> 
> When I test memory hotplug, such message is always outputted when hot-adding
> a memory block:
> 
> initial kernel pagetable allocation wasted ffffffffffffffff pages

I take you are using tip/x86/mm, because that is the only branch that
contains that warning.


> This message comes from init_memory_mapping(), it shows "pgt_buf_end" is
> incorrect here, and I found it was caused by alloc_low_page().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index bbaaa00..e138e0a 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -317,7 +317,7 @@ void __init cleanup_highmap(void)
>  
>  static __ref void *alloc_low_page(unsigned long *phys)
>  {
> -	unsigned long pfn = pgt_buf_end++;
> +	unsigned long pfn;
>  	void *adr;
>  
>  	if (after_bootmem) {
> @@ -327,6 +327,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
>  		return adr;
>  	}
>  
> +	pfn = pgt_buf_end++;
>  	if (pfn >= pgt_buf_top)
>  		panic("alloc_low_page: ran out of memory");


This patch makes sense to me. It would also make sense to print the
"allocation wasted" warning only if (!after_bootmem).
