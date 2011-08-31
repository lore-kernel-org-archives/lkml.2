Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1HaCnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:43:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:34223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab1HaCnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:43:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43850231"
Subject: Re: [Devel] [PATCH 1/2] ACPICA: Introduce
 acpi_os_phys_table_override function
From: Lin Ming <ming.m.lin@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jnelson-suse@jamponi.net" <jnelson-suse@jamponi.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "devel@acpica.org" <devel@acpica.org>
In-Reply-To: <1314179290-31526-2-git-send-email-trenn@suse.de>
References: <1314179290-31526-1-git-send-email-trenn@suse.de>
	 <1314179290-31526-2-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 10:43:42 +0800
Message-ID: <1314758622.6486.74.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 17:48 +0800, Thomas Renninger wrote:
> Currently it's only possible to feed acpica with virtual
> address for table overriding.
> This patch introduces a function which allows the OS to
> pass physical addresses for table overriding.
> 
> This is necessary to allow early table overridings of
> arbitrary ACPI tables.
> 
> An extra flag like ACPI_TABLE_ORIGIN_OVERRIDE is not used,
> because physical address overriding is rather transparent
> (the same way acpica expects to get tables from reserved
> memory BIOS regions which is the normal way).
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: devel@acpica.org
> CC: linux-acpi@vger.kernel.org
> CC: lenb@kernel.org
> ---
>  drivers/acpi/acpica/tbinstal.c |   15 +++++++++++++++
>  drivers/acpi/acpica/tbutils.c  |   18 +++++++++++++++++-
>  drivers/acpi/osl.c             |   11 +++++++++++
>  include/acpi/acpiosxf.h        |    4 ++++
>  4 files changed, 47 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
> index 62365f6..b9b9d2a 100644
> --- a/drivers/acpi/acpica/tbinstal.c
> +++ b/drivers/acpi/acpica/tbinstal.c
> @@ -242,6 +242,21 @@ acpi_tb_add_table(struct acpi_table_desc *table_desc, u32 *table_index)
>  		table_desc->pointer = override_table;
>  		table_desc->length = override_table->length;
>  		table_desc->flags = ACPI_TABLE_ORIGIN_OVERRIDE;
> +	} else {
> +		acpi_physical_address address = 0;
> +		u32 table_len = 0;
> +		status = acpi_os_phys_table_override(table_desc->pointer,
> +						     &address, &table_len);
> +		if (ACPI_SUCCESS(status) && table_len && address) {
> +			ACPI_INFO((AE_INFO, "%4.4s @ 0x%p "
> +				   "Phys table override, replaced with:",
> +				   table_desc->pointer->signature,
> +				   ACPI_CAST_PTR(void, table_desc->address)));
> +			table_desc->address = address;
> +			table_desc->pointer = acpi_os_map_memory(address,
> +								 table_len);
> +			table_desc->length = table_len;
> +		}
>  	}
>  
>  	/* Add the table to the global root table list */
> diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
> index 0f2d395..df85afe 100644
> --- a/drivers/acpi/acpica/tbutils.c
> +++ b/drivers/acpi/acpica/tbutils.c
> @@ -499,8 +499,24 @@ acpi_tb_install_table(acpi_physical_address address,
>  		table_to_install = override_table;
>  		flags = ACPI_TABLE_ORIGIN_OVERRIDE;
>  	} else {
> -		table_to_install = mapped_table;
> +		u32 table_len = 0;
> +		acpi_physical_address tmp_addr = 0;
> +
> +		status = acpi_os_phys_table_override(mapped_table,
> +						     &tmp_addr, &table_len);
> +		if (ACPI_SUCCESS(status) && table_len && tmp_addr) {
> +			ACPI_INFO((AE_INFO, "%4.4s @ 0x%p "
> +				   "Phys table override, replaced with:",
> +				   mapped_table->signature,
> +				   ACPI_CAST_PTR(void, address)));
> +			acpi_os_unmap_memory(mapped_table,
> +					     sizeof(struct acpi_table_header));
> +			mapped_table = acpi_os_map_memory(address,
> +					  sizeof(struct acpi_table_header));
> +			address = tmp_addr;
> +		}
>  		flags = ACPI_TABLE_ORIGIN_MAPPED;
> +		table_to_install = mapped_table;
>  	}
>  
>  	/* Initialize the table entry */
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index fa32f58..49b5fa6 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -522,6 +522,17 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
>  	return AE_OK;
>  }
>  
> +acpi_status
> +acpi_os_phys_table_override(struct acpi_table_header *existing_table,
> +			    acpi_physical_address *address, u32 *table_length)
> +{
> +	if (!existing_table)
> +		return AE_BAD_PARAMETER;
> +
> +	table_length = 0;
> +	return AE_OK;
> +}
> +
>  static irqreturn_t acpi_irq(int irq, void *dev_id)
>  {
>  	u32 handled;
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 4543b6f..0bef969 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -95,6 +95,10 @@ acpi_status
>  acpi_os_table_override(struct acpi_table_header *existing_table,
>  		       struct acpi_table_header **new_table);
>  
> +acpi_status
> +acpi_os_phys_table_override(struct acpi_table_header *existing_table,
> +			    acpi_physical_address *address, u32 *table_length);

You add a new interface.
Can we just extend the existing interface: acpi_os_table_override?

Thanks,
Lin Ming

> +
>  /*
>   * Spinlock primitives
>   */
> -- 
> 1.7.3.4
> 
> _______________________________________________
> Devel mailing list
> Devel@acpica.org
> http://lists.acpica.org/listinfo/devel


