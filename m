Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3ADVdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:33:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60441 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab3ADVdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:33:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] ACPI: Rework acpi_get_child() to be more efficient
Date: Fri, 04 Jan 2013 22:38:51 +0100
Message-ID: <6591808.qVVzyd5JNI@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <14285317.C5USrgceVP@vostro.rjw.lan>
References: <1644954.gUaZqebo61@vostro.rjw.lan> <14285317.C5USrgceVP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 26, 2012 11:42:49 PM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI: Rework acpi_get_child() to be more efficient
> 
> Observe that acpi_get_child() doesn't need to use the helper
> struct acpi_find_child structure and change it to work without it.
> Also, using acpi_get_object_info() to get the output of _ADR for the
> given device is overkill, because that function does much more than
> just evaluating _ADR (let alone the additional memory allocation
> done by it).
> 
> Moreover, acpi_get_child() doesn't need to loop any more once it has
> found a matching handle, so make it stop in that case.  To prevent
> the results from changing, make it use do_acpi_find_child() as
> a post-order callback.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> The difference from the previous version is the replacement of
> acpi_get_object_info() with the direct execution of _ADR, which is
> more straightforward.

There seem to be no objections, most likely due to the holiday period
that has just ended, but if there are still none, I'm going to push this
for v3.9.

Thanks,
Rafael


> ---
>  drivers/acpi/glue.c |   33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> Index: linux/drivers/acpi/glue.c
> ===================================================================
> --- linux.orig/drivers/acpi/glue.c
> +++ linux/drivers/acpi/glue.c
> @@ -93,40 +93,31 @@ static int acpi_find_bridge_device(struc
>  	return ret;
>  }
>  
> -/* Get device's handler per its address under its parent */
> -struct acpi_find_child {
> -	acpi_handle handle;
> -	u64 address;
> -};
> -
> -static acpi_status
> -do_acpi_find_child(acpi_handle handle, u32 lvl, void *context, void **rv)
> +static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
> +				      void *addr_p, void **ret_p)
>  {
> +	unsigned long long addr;
>  	acpi_status status;
> -	struct acpi_device_info *info;
> -	struct acpi_find_child *find = context;
>  
> -	status = acpi_get_object_info(handle, &info);
> -	if (ACPI_SUCCESS(status)) {
> -		if ((info->address == find->address)
> -			&& (info->valid & ACPI_VALID_ADR))
> -			find->handle = handle;
> -		kfree(info);
> +	status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
> +	if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
> +		*ret_p = handle;
> +		return AE_CTRL_TERMINATE;
>  	}
>  	return AE_OK;
>  }
>  
>  acpi_handle acpi_get_child(acpi_handle parent, u64 address)
>  {
> -	struct acpi_find_child find = { NULL, address };
> +	void *ret = NULL;
>  
>  	if (!parent)
>  		return NULL;
> -	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent,
> -			    1, do_acpi_find_child, NULL, &find, NULL);
> -	return find.handle;
> -}
>  
> +	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, NULL,
> +			    do_acpi_find_child, &address, &ret);
> +	return (acpi_handle)ret;
> +}
>  EXPORT_SYMBOL(acpi_get_child);
>  
>  static int acpi_bind_one(struct device *dev, acpi_handle handle)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
