Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2JJBOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:14:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36934 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab2JJBOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:14:46 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5074CBEB.4040500@jp.fujitsu.com>
Date: Wed, 10 Oct 2012 10:14:19 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <shli@fusionio.com>
Subject: Re: [PATCH] ACPI: dock: Remove redundant ACPI NS walk
References: <1347481849-17973-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1347481849-17973-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

Sorry for late reply.

2012/09/13 5:30, Toshi Kani wrote:
> Combined two ACPI namespace walks, which look for dock stations
> and then bays separately, into a single walk.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---

I have not tested the patch. But it looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   drivers/acpi/dock.c |   26 +++++++-------------------
>   1 files changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 88eb143..ae4ebf2 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -1016,44 +1016,32 @@ static int dock_remove(struct dock_station *ds)
>   }
>   
>   /**
> - * find_dock - look for a dock station
> + * find_dock_and_bay - look for dock stations and bays
>    * @handle: acpi handle of a device
>    * @lvl: unused
> - * @context: counter of dock stations found
> + * @context: unused
>    * @rv: unused
>    *
> - * This is called by acpi_walk_namespace to look for dock stations.
> + * This is called by acpi_walk_namespace to look for dock stations and bays.
>    */
>   static __init acpi_status
> -find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
> +find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
>   {
> -	if (is_dock(handle))
> +	if (is_dock(handle) || is_ejectable_bay(handle))
>   		dock_add(handle);
>   
>   	return AE_OK;
>   }
>   
> -static __init acpi_status
> -find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
> -{
> -	/* If bay is a dock, it's already handled */
> -	if (is_ejectable_bay(handle) && !is_dock(handle))
> -		dock_add(handle);
> -	return AE_OK;
> -}
> -
>   static int __init dock_init(void)
>   {
>   	if (acpi_disabled)
>   		return 0;
>   
> -	/* look for a dock station */
> +	/* look for dock stations and bays */
>   	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -			    ACPI_UINT32_MAX, find_dock, NULL, NULL, NULL);
> +		ACPI_UINT32_MAX, find_dock_and_bay, NULL, NULL, NULL);
>   
> -	/* look for bay */
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -			ACPI_UINT32_MAX, find_bay, NULL, NULL, NULL);
>   	if (!dock_station_count) {
>   		printk(KERN_INFO PREFIX "No dock devices found.\n");
>   		return 0;
> 


