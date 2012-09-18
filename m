Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2IRWyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:54:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58753 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813Ab2IRWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <1347670122-25824-2-git-send-email-yinghai@kernel.org>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org> <1347670122-25824-2-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Sep 2012 16:53:52 -0600
Message-ID: <CAErSpo4-tGvDHrgmJJG5Q4wxmqWQGYx-rm+m2rV-=B1WOiGGaw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Use correct type when freeing bus resource list
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Should use struct pci_bus_resource instead of struct pci_host_bridge_window

Looks good, and this is all my fault, sorry.  Applied to a
pci/yinghai-misc branch.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  drivers/pci/bus.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/pci/bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/bus.c
> +++ linux-2.6/drivers/pci/bus.c
> @@ -87,11 +87,15 @@ EXPORT_SYMBOL_GPL(pci_bus_resource_n);
>  void pci_bus_remove_resources(struct pci_bus *bus)
>  {
>         int i;
> +       struct pci_bus_resource *bus_res, *tmp;
>
>         for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
>                 bus->resource[i] = NULL;
>
> -       pci_free_resource_list(&bus->resources);
> +       list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
> +               list_del(&bus_res->list);
> +               kfree(bus_res);
> +       }
>  }
>
>  /**
