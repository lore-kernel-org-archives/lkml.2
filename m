Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab0FJQXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:23:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43318 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106Ab0FJQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:23:33 -0400
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <4C110EDD.2010409@kernel.org>
References: <20100610160212.18091.29856.stgit@e102109-lin.cambridge.arm.com>
	 <4C110EDD.2010409@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 10 Jun 2010 17:23:22 +0100
Message-ID: <1276187002.24535.88.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 16:23:23.0191 (UTC) FILETIME=[3F2A7470:01CB08B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 17:12 +0100, Tejun Heo wrote:
> On 06/10/2010 06:02 PM, Catalin Marinas wrote:
> > The data in the cmd_block buffers may reach the main memory after the
> > writel() to the device ports. This patch introduces two calls to wmb()
> > to ensure the relative ordering.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Tested-by: Colin Tuckley <colin.tuckley@arm.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Jeff Garzik <jeff@garzik.org>
> 
> I suppose you have tested and verified that this is actually
> necessary, right?  

Yes, otherwise we get random failures with this device on ARM.

> I've been looking through the docs but couldn't
> find anything which described the ordering between writes to main
> memory and write[bwl]()'s.  One thing that kind of bothers me is that
> r/wmb()'s are for ordering memory accesses among CPUs which
> participate in cache coherency protocol and although it may work right
> in the above case I'm not really sure whether this is the right thing
> to do.  Do you have more information on the subject?

The mb() are not for ordering accesses among CPUs (though they would
cover this case as well). For inter-CPU ordering, we have smp_mb() and
friends. For all other cases, we have the mandatory barriers mb() and
friends and DMA is one of them.

Apart from the memory-barriers.txt document, there is the Device I/O
docbook which mentions something about DMA buffers, though not very
clear on which barriers to use (something like just make sure that the
writes to the buffer reached the memory).

There were some past discussions on linux-arch before and I'm cc'ing
this list again (ARM is not the only architecture with a weakly memory
ordering model).

I'm copying the patch below again for the linux-arch people that haven't
seen the beginning of the thread:


> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index e925051..a5d5aff 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -622,6 +622,11 @@ static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
>  	irq_enabled = readl(port + PORT_IRQ_ENABLE_SET);
>  	writel(PORT_IRQ_COMPLETE | PORT_IRQ_ERROR, port + PORT_IRQ_ENABLE_CLR);
>  
> +	/*
> +	 * The barrier is required to ensure that writes to cmd_block reach
> +	 * the memory before the write to PORT_CMD_ACTIVATE.
> +	 */
> +	wmb();
>  	writel((u32)paddr, port + PORT_CMD_ACTIVATE);
>  	writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
>  
> @@ -895,6 +900,11 @@ static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
>  	paddr = pp->cmd_block_dma + tag * sizeof(*pp->cmd_block);
>  	activate = port + PORT_CMD_ACTIVATE + tag * 8;
>  
> +	/*
> +	 * The barrier is required to ensure that writes to cmd_block reach
> +	 * the memory before the write to PORT_CMD_ACTIVATE.
> +	 */
> +	wmb();
>  	writel((u32)paddr, activate);
>  	writel((u64)paddr >> 32, activate + 4);
>  

Thanks.

-- 
Catalin

