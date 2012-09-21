Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab2IURBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:01:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39155 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2IURBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:01:35 -0400
Date: Fri, 21 Sep 2012 12:50:26 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
Message-ID: <20120921165025.GF4780@phenom.dumpdata.com>
References: <CAE9FiQW0PpBU0N9VzJyNKK9PvaUwokCYeB6w_j4mcN9EV0geLQ@mail.gmail.com>
 <1348076941-410-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348076941-410-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 10:49:00AM -0700, Yinghai Lu wrote:
> Found one system one root bus hot remove get panic.

Boy, this is mangled.

Can you include the name of the system? Perhaps you can
rephrase this to say:

"On XYZ removing the root bus (through ACPI unplug) causes
a panic."

> Panic happens when try to release hostbridge resource.

Can you include the stack trace?
> 
> It turns out that resource get reject during put into resource tree
> because of conflicts.

Come again? Are you saying:

"The reason for this is that the resources was never initialized
properly because of .. (what type of conflict?)"?

> Also that resource parent pointer have random value.
> 
> That invalid value cause it pass through check __release_pci_root_info
> and panic in release_resource.
> 
> Try to use kzalloc instead.

It is not just try, it _is_ using that now.

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
> 
> ---
>  arch/x86/pci/acpi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/acpi.c
> +++ linux-2.6/arch/x86/pci/acpi.c
> @@ -305,7 +305,6 @@ setup_resource(struct acpi_resource *acp
>  	res->flags = flags;
>  	res->start = start;
>  	res->end = end;
> -	res->child = NULL;
>  
>  	if (!pci_use_crs) {
>  		dev_printk(KERN_DEBUG, &info->bridge->dev,
> @@ -434,7 +433,7 @@ probe_pci_root_info(struct pci_root_info
>  
>  	size = sizeof(*info->res) * info->res_num;
>  	info->res_num = 0;
> -	info->res = kmalloc(size, GFP_KERNEL);
> +	info->res = kzalloc(size, GFP_KERNEL);
>  	if (!info->res)
>  		return;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
