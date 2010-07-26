Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0GZHlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:41:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:21852 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0GZHlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,260,1278313200"; 
   d="scan'208";a="538731463"
Subject: Re: [PATCH] acpi: fix apei related table size checking
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C49D3C5.4000007@kernel.org>
References: <4C49D3C5.4000007@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 15:41:39 +0800
Message-ID: <1280130099.2771.150.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-24 at 01:39 +0800, Yinghai Lu wrote: 
> also check if we can find right action in apei.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
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

It seems that the header_length field is not set properly by BIOS on my
testing machine which I used to develop the original code. Will try to
contact BIOS guys to make sure.

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

-ENOENT is better here?

Best Regards,
Huang Ying


