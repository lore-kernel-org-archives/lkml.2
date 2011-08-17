Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HQMtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:49:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50186 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1HQMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:48:59 -0400
Subject: Re: [PATCH 2/8] Staging: hv: vmbus: Invoke vmbus_on_msg_dpc()
 directly
From: Sasha Levin <levinsasha928@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <1313446327-10650-2-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-1-git-send-email-kys@microsoft.com>
	 <1313446327-10650-2-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 17 Aug 2011 15:47:47 +0300
Message-ID: <1313585267.15004.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 15:12 -0700, K. Y. Srinivasan wrote:
> The message processing function needs to execute on the same CPU where
> the interrupt was taken. tasklets cannot gurantee this; so, invoke the 
> function directly.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---

tasklets are guaranteed to run on the same CPU as the function that
scheduled them.

Unless I'm missing something?

>  drivers/staging/hv/vmbus_drv.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index bb25c5b..1d4e878 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -39,7 +39,6 @@
>  
>  static struct acpi_device  *hv_acpi_dev;
>  
> -static struct tasklet_struct msg_dpc;
>  static struct tasklet_struct event_dpc;
>  
>  unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
> @@ -425,7 +424,7 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
>  	/* Check if there are actual msgs to be process */
>  	if (msg->header.message_type != HVMSG_NONE) {
>  		handled = true;
> -		tasklet_schedule(&msg_dpc);
> +		vmbus_on_msg_dpc(0);
>  	}
>  
>  	page_addr = hv_context.synic_event_page[cpu];
> @@ -465,7 +464,6 @@ static int vmbus_bus_init(int irq)
>  	}
>  
>  	/* Initialize the bus context */
> -	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
>  	tasklet_init(&event_dpc, vmbus_on_event, 0);
>  
>  	/* Now, register the bus  with LDM */

-- 

Sasha.

