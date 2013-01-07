Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3AGSsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:48:35 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:33449 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3AGSse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:48:34 -0500
MIME-Version: 1.0
In-Reply-To: <1356030701-16284-15-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com> <1356030701-16284-15-git-send-email-sasha.levin@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Jan 2013 11:48:12 -0700
Message-ID: <CAErSpo7aj8WfH_aQQMQaQwYV2Y2R_e787rXQo4EVsKbOFq-DuA@mail.gmail.com>
Subject: Re: [PATCH] PCI: cpqphp: minor cleanup and removal of unreachable paths
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 12:11 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> Remove cases of redundant checks and remote unreachable paths.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks, Sasha.  I applied this for v3.9.

> ---
>  drivers/pci/hotplug/cpqphp_ctrl.c | 57 ++++++++++++++-------------------------
>  1 file changed, 20 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
> index 36112fe..d282019 100644
> --- a/drivers/pci/hotplug/cpqphp_ctrl.c
> +++ b/drivers/pci/hotplug/cpqphp_ctrl.c
> @@ -1900,8 +1900,7 @@ static void interrupt_event_handler(struct controller *ctrl)
>                                         dbg("power fault\n");
>                                 } else {
>                                         /* refresh notification */
> -                                       if (p_slot)
> -                                               update_slot_info(ctrl, p_slot);
> +                                       update_slot_info(ctrl, p_slot);
>                                 }
>
>                                 ctrl->event_queue[loop].event_type = 0;
> @@ -2520,44 +2519,28 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
>
>                 /* If we have IO resources copy them and fill in the bridge's
>                  * IO range registers */
> -               if (io_node) {
> -                       memcpy(hold_IO_node, io_node, sizeof(struct pci_resource));
> -                       io_node->next = NULL;
> +               memcpy(hold_IO_node, io_node, sizeof(struct pci_resource));
> +               io_node->next = NULL;
>
> -                       /* set IO base and Limit registers */
> -                       temp_byte = io_node->base >> 8;
> -                       rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_IO_BASE, temp_byte);
> +               /* set IO base and Limit registers */
> +               temp_byte = io_node->base >> 8;
> +               rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_IO_BASE, temp_byte);
>
> -                       temp_byte = (io_node->base + io_node->length - 1) >> 8;
> -                       rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_IO_LIMIT, temp_byte);
> -               } else {
> -                       kfree(hold_IO_node);
> -                       hold_IO_node = NULL;
> -               }
> -
> -               /* If we have memory resources copy them and fill in the
> -                * bridge's memory range registers.  Otherwise, fill in the
> -                * range registers with values that disable them. */
> -               if (mem_node) {
> -                       memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
> -                       mem_node->next = NULL;
> -
> -                       /* set Mem base and Limit registers */
> -                       temp_word = mem_node->base >> 16;
> -                       rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
> +               temp_byte = (io_node->base + io_node->length - 1) >> 8;
> +               rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_IO_LIMIT, temp_byte);
>
> -                       temp_word = (mem_node->base + mem_node->length - 1) >> 16;
> -                       rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
> -               } else {
> -                       temp_word = 0xFFFF;
> -                       rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
> +               /* Copy the memory resources and fill in the bridge's memory
> +                * range registers.
> +                */
> +               memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
> +               mem_node->next = NULL;
>
> -                       temp_word = 0x0000;
> -                       rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
> +               /* set Mem base and Limit registers */
> +               temp_word = mem_node->base >> 16;
> +               rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
>
> -                       kfree(hold_mem_node);
> -                       hold_mem_node = NULL;
> -               }
> +               temp_word = (mem_node->base + mem_node->length - 1) >> 16;
> +               rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
>
>                 memcpy(hold_p_mem_node, p_mem_node, sizeof(struct pci_resource));
>                 p_mem_node->next = NULL;
> @@ -2627,7 +2610,7 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
>                 /* Return unused bus resources
>                  * First use the temporary node to store information for
>                  * the board */
> -               if (hold_bus_node && bus_node && temp_resources.bus_head) {
> +               if (bus_node && temp_resources.bus_head) {
>                         hold_bus_node->length = bus_node->base - hold_bus_node->base;
>
>                         hold_bus_node->next = func->bus_head;
> @@ -2751,7 +2734,7 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
>                 }
>                 /* If we have prefetchable memory space available and there
>                  * is some left at the end, return the unused portion */
> -               if (hold_p_mem_node && temp_resources.p_mem_head) {
> +               if (temp_resources.p_mem_head) {
>                         p_mem_node = do_pre_bridge_resource_split(&(temp_resources.p_mem_head),
>                                                                   &hold_p_mem_node, 0x100000);
>
> --
> 1.8.0
>
