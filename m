Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2IRWrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:47:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47691 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188Ab2IRWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <1347670122-25824-3-git-send-email-yinghai@kernel.org>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org> <1347670122-25824-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Sep 2012 16:46:46 -0600
Message-ID: <CAErSpo5LMj=wPwYgJfk97hfx9b03fPHZXEvdR6gV2somBTD+4A@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: clear initial value for root info resources
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Found one system one root bus hot remove get panic.
> Panic happens when try to release hostbridge resource.
>
> It turns out that resource get reject during put into resource tree
> because of conflicts.
> Also that resource parent pointer have random value.
>
> That invalid value cause it pass through check __release_pci_root_info
> and panic in release_resource.
>
> Try to use kzalloc instead.

Don't we need the same fix for ia64 in pci_acpi_scan_root()?  Here's
what it does:

        if (windows) {
                controller->window =
                        kmalloc_node(sizeof(*controller->window) * windows,
                                     GFP_KERNEL, controller->node);


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
>         res->flags = flags;
>         res->start = start;
>         res->end = end;
> -       res->child = NULL;
>
>         if (!pci_use_crs) {
>                 dev_printk(KERN_DEBUG, &info->bridge->dev,
> @@ -434,7 +433,7 @@ probe_pci_root_info(struct pci_root_info
>
>         size = sizeof(*info->res) * info->res_num;
>         info->res_num = 0;
> -       info->res = kmalloc(size, GFP_KERNEL);
> +       info->res = kzalloc(size, GFP_KERNEL);
>         if (!info->res)
>                 return;
>
