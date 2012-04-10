Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2DJKoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:44:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35181 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab2DJKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:44:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F840ED6.3050408@jp.fujitsu.com>
Date: Tue, 10 Apr 2012 19:43:34 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, matsumoto.hiroo@jp.fujitsu.com,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] PCI: correctly flush workqueue when destroy pcie
 hotplug controller
References: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you're rignt.

Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

(2012/04/08 3:18), Jiang Liu wrote:
> When destroying a PCIe hotplug controller, all work items associated with
> that controller should be flushed.  Function pcie_cleanup_slot() calls
> cancel_delayed_work() and flush_workqueue() to achieve that.
> Function flush_workqueue() will flush all work items already submitted,
> but new work items submitted by those already submitted work items may
> still be in live state when returning from flush_workqueue().
> 
> For the extreme case, pciehp driver may expierence following calling path:
> 1) pcie_isr() ->  pciehp_handle_xxx() ->  queue_interrupt_event()->queue_work()
> 2) interrupt_event_handler() ->  handle_button_press_event() ->
>     queue_delayed_work()
> 3) pciehp_queue_pushbutton_work() ->  queue_work()
> 
> So enhance pcie_cleanup_slot() to correctly flush workqueue when destroying
> PCIe hotplug controller.
> 
> Signed-off-by: Jiang Liu<jiang.liu@huawei.com>
> ---
>   drivers/pci/hotplug/pciehp_hpc.c |   13 ++++++++++++-
>   1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index d4fa705..9a48a51 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -890,8 +890,19 @@ static int pcie_init_slot(struct controller *ctrl)
>   static void pcie_cleanup_slot(struct controller *ctrl)
>   {
>   	struct slot *slot = ctrl->slot;
> -	cancel_delayed_work(&slot->work);
> +
> +	/*
> +	 * Following workqueue flushing logic is to deal with the special call path:
> +	 * 1) pcie_isr() ->  pciehp_handle_xxx() ->
> +	 *    queue_interrupt_event(pciehp_wq_event)->queue_work(pciehp_wq)
> +	 * 2) interrupt_event_handler() ->  handle_button_press_event() ->
> +	 *    queue_delayed_work(pciehp_wq)
> +	 * 3) pciehp_queue_pushbutton_work() ->  queue_work(pciehp_wq)
> +	 */
>   	flush_workqueue(pciehp_wq);
> +	cancel_delayed_work_sync(&slot->work);
> +	flush_workqueue(pciehp_wq);
> +
>   	kfree(slot);
>   }
> 

