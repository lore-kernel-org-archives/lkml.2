Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab0FJUOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:14:52 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46458 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785Ab0FJUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=e9G0B6EFsZlqY1Zxv0SDdai/F6ex8KL0scWypSs91XtBX8U4uw4n+Qk8SP4A0AQuVF
         o2tj28GX4Z6SaBVBwYKY3mqmwbIJwPXiPJ47X0eDu/LmEeKtr93GPJEWGrA/cZ0nxboh
         91DIQUE2Xx0nUw8UmXKiHXr6R4fK6tDrVmKLc=
Message-ID: <4C1147B2.7090207@garzik.org>
Date: Thu, 10 Jun 2010 16:14:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Colin Tuckley <colin.tuckley@arm.com>
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing commands
References: <20100610160212.18091.29856.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100610160212.18091.29856.stgit@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 12:02 PM, Catalin Marinas wrote:
> The data in the cmd_block buffers may reach the main memory after the
> writel() to the device ports. This patch introduces two calls to wmb()
> to ensure the relative ordering.
>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> Tested-by: Colin Tuckley<colin.tuckley@arm.com>
> Cc: Tejun Heo<tj@kernel.org>
> Cc: Jeff Garzik<jeff@garzik.org>
> ---
>   drivers/ata/sata_sil24.c |   10 ++++++++++
>   1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index e925051..a5d5aff 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -622,6 +622,11 @@ static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
>   	irq_enabled = readl(port + PORT_IRQ_ENABLE_SET);
>   	writel(PORT_IRQ_COMPLETE | PORT_IRQ_ERROR, port + PORT_IRQ_ENABLE_CLR);
>
> +	/*
> +	 * The barrier is required to ensure that writes to cmd_block reach
> +	 * the memory before the write to PORT_CMD_ACTIVATE.
> +	 */
> +	wmb();
>   	writel((u32)paddr, port + PORT_CMD_ACTIVATE);
>   	writel((u64)paddr>>  32, port + PORT_CMD_ACTIVATE + 4);
>
> @@ -895,6 +900,11 @@ static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
>   	paddr = pp->cmd_block_dma + tag * sizeof(*pp->cmd_block);
>   	activate = port + PORT_CMD_ACTIVATE + tag * 8;
>
> +	/*
> +	 * The barrier is required to ensure that writes to cmd_block reach
> +	 * the memory before the write to PORT_CMD_ACTIVATE.
> +	 */
> +	wmb();
>   	writel((u32)paddr, activate);
>   	writel((u64)paddr>>  32, activate + 4);
>

applied


