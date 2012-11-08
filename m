Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2KHBtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:49:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab2KHBtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:49:00 -0500
X-IronPort-AV: E=Sophos;i="4.80,735,1344182400"; 
   d="scan'208";a="6157649"
Message-ID: <509B0B7F.3030308@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 09:31:43 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: lenb@kernel.org, rjw@sisk.pl, yongjun_wei@trendmicro.com.cn,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH -next] ACPI: fix missing unlock on error in acpi_memory_remove_memory()
References: <CAPgLHd_=OTwu-3tVXT0o8+x=N_9dZOkQ4A7HFr0SNdUiyAy_yw@mail.gmail.com>
In-Reply-To: <CAPgLHd_=OTwu-3tVXT0o8+x=N_9dZOkQ4A7HFr0SNdUiyAy_yw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 09:24:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 09:24:53,
	Serialize complete at 2012/11/08 09:24:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, wei

At 11/07/2012 08:38 PM, Wei Yongjun Wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing mutex_unlock() before return from function
> acpi_memory_remove_memory() in the error handling case.
> 
> Introduce by commit 85fcb3758c10e063a2a30dfad75017097999deed
> 'ACPI / memory-hotplug: introduce a mutex lock to protect the list in acpi_memory_device'
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks for your patch.

Dan Carpenter has told me this problem. I fix it, but don't
resend it because it is in test now.

Thanks
Wen Congyang

> ---
>  drivers/acpi/acpi_memhotplug.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 92c973a..e573e87 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -325,8 +325,10 @@ static int acpi_memory_remove_memory(struct acpi_memory_device *mem_device)
>  	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
>  		if (info->enabled) {
>  			result = remove_memory(info->start_addr, info->length);
> -			if (result)
> +			if (result) {
> +				mutex_unlock(&mem_device->list_lock);
>  				return result;
> +			}
>  		}
>  
>  		list_del(&info->list);
> 
> 
> 

