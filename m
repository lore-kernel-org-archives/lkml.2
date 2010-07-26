Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab0GZEXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 00:23:18 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:23589 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0GZEXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 00:23:15 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] acpi: fix apei related table size checking
Date: Sun, 25 Jul 2010 22:23:32 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-23-generic; KDE/4.4.2; i686; ; )
Cc: Len Brown <lenb@kernel.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4C49D3C5.4000007@kernel.org>
In-Reply-To: <4C49D3C5.4000007@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007252223.32671.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010 11:39:17 am Yinghai Lu wrote:
> 
> also check if we can find right action in apei.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This should be split into two patches that each fix one thing.

> ---
>  drivers/acpi/apei/apei-base.c |    5 +++++
>  drivers/acpi/apei/einj.c      |    3 ++-
>  drivers/acpi/apei/erst.c      |    3 ++-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/apei/einj.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/apei/einj.c
> +++ linux-2.6/drivers/acpi/apei/einj.c
> @@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fop
>  
>  static int einj_check_table(struct acpi_table_einj *einj_tab)
>  {
> -	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
> +	if (einj_tab->header_length !=
> +	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
>  		return -EINVAL;
>  	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
>  		return -EINVAL;
> Index: linux-2.6/drivers/acpi/apei/erst.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/apei/erst.c
> +++ linux-2.6/drivers/acpi/apei/erst.c
> @@ -749,7 +749,8 @@ __setup("erst_disable", setup_erst_disab
>  
>  static int erst_check_table(struct acpi_table_erst *erst_tab)
>  {
> -	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
> +	if (erst_tab->header_length !=
> +	    (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
>  		return -EINVAL;
>  	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
>  		return -EINVAL;
> Index: linux-2.6/drivers/acpi/apei/apei-base.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/apei/apei-base.c
> +++ linux-2.6/drivers/acpi/apei/apei-base.c
> @@ -163,6 +163,7 @@ int apei_exec_run(struct apei_exec_conte
>  	u32 i, ip;
>  	struct acpi_whea_header *entry;
>  	apei_exec_ins_func_t run;
> +	bool found_action = false;
>  
>  	ctx->ip = 0;
>  
> @@ -178,6 +179,7 @@ rewind:
>  		entry = &ctx->action_table[i];
>  		if (entry->action != action)
>  			continue;
> +		found_action = true;
>  		if (ip == ctx->ip) {
>  			if (entry->instruction >= ctx->instructions ||
>  			    !ctx->ins_table[entry->instruction].run) {
> @@ -198,6 +200,9 @@ rewind:
>  			goto rewind;
>  	}
>  
> +	if (!found_action)
> +		return -ENODEV;
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(apei_exec_run);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
