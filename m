Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0FZCc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 22:32:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22907 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0FZCc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 22:32:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wigPZPKLxS8Je2Yf4lKs7m8q1pvrIF6CYk5DY48AzEP+oZJuznbKl7ROOop0hg0v6
	fPQ6t22Zsl3jzDk4gqA+A==
MIME-Version: 1.0
In-Reply-To: <20100610145706.15588.4562.stgit@e102109-lin.cambridge.arm.com>
References: <20100610145706.15588.4562.stgit@e102109-lin.cambridge.arm.com>
Date: Fri, 25 Jun 2010 19:32:22 -0700
Message-ID: <AANLkTimdHs25zHe8DJUaOOo7wYW14Ds4c2ORaSBhRxSg@mail.gmail.com>
Subject: Re: [PATCH] sata_sil24: Use memory barriers before issuing commands
From: Grant Grundler <grundler@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Colin Tuckley <colin.tuckley@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 7:57 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> The data in the cmd_block buffers may reach the main memory after the
> writel() to the device ports.

"ia-64 Linux Kernel" (mosberger and eranian) uses exactly this sequence
as an example for wmb() on page 303.

I'm curious about the system that exposed this problem. I believe wmb() fixes
 an issue not exposed on most machines. Can any general comments be
made about cache coherency, memory ordering (weak?), instruction ordering
 (super scalar?), etc. ?

The explanation above is a bit short (most people won't understand it).


> This patch introduces two calls to wmb() to ensure the relative ordering.

And as Tejun asked, the comment where wmb() gets used should clearly
explain which host memory writes are targetted by the wmb().

thanks,
grant

>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Colin Tuckley <colin.tuckley@arm.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/ata/sata_sil24.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index e925051..6392fdb 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -622,6 +622,7 @@ static int sil24_exec_polled_cmd(struct ata_port *ap, int pmp,
>        irq_enabled = readl(port + PORT_IRQ_ENABLE_SET);
>        writel(PORT_IRQ_COMPLETE | PORT_IRQ_ERROR, port + PORT_IRQ_ENABLE_CLR);
>
> +       wmb();
>        writel((u32)paddr, port + PORT_CMD_ACTIVATE);
>        writel((u64)paddr >> 32, port + PORT_CMD_ACTIVATE + 4);
>
> @@ -895,6 +896,7 @@ static unsigned int sil24_qc_issue(struct ata_queued_cmd *qc)
>        paddr = pp->cmd_block_dma + tag * sizeof(*pp->cmd_block);
>        activate = port + PORT_CMD_ACTIVATE + tag * 8;
>
> +       wmb();
>        writel((u32)paddr, activate);
>        writel((u64)paddr >> 32, activate + 4);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
