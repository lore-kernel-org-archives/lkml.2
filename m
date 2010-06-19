Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0FSOq2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:46:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53190 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab0FSOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:46:27 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2 18/26] MMC: Add JZ4740 mmc driver
In-Reply-To: <1276924111-11158-19-git-send-email-lars@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <1276924111-11158-19-git-send-email-lars@metafoo.de>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Sat, 19 Jun 2010 15:46:25 +0100
Message-ID: <87ocf7ozb2.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 07:08:23 +0200, Lars-Peter Clausen <lars@metafoo.de> wrote:
> This patch adds support for the mmc controller on JZ4740 SoCs.
> 

Hey Lars-Peter,

I had a quick look over this patch and it looks OK. Just a few comments.

> +static void jz4740_mmc_timeout(unsigned long data)
> +{
> +	struct jz4740_mmc_host *host = (struct jz4740_mmc_host *)data;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&host->lock, flags);
> +	if (!host->waiting) {
> +		spin_unlock_irqrestore(&host->lock, flags);
> +		return;
> +	}
> +
> +	host->waiting = 0;
> +
> +	spin_unlock_irqrestore(&host->lock, flags);
> +
> +	host->req->cmd->error = -ETIMEDOUT;
> +	jz4740_mmc_request_done(host);
> +}
> +

Taking a spinlock and disabling interrupts seems like too much overhead
to simply test and clear a bit. Wouldn't it be better to implement this
with test_and_clear_bit(), which on MIPS will likely be implemented with
ll/sc instructions? It's particularly important to keep this
low-overhead since this bit is modified in the interrupt handler.

> +static void jz4740_mmc_request_done(struct jz4740_mmc_host *host)
> +{
> +	struct mmc_request *req;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&host->lock, flags);
> +	req = host->req;
> +	host->req = NULL;
> +	host->waiting = 0;
> +	spin_unlock_irqrestore(&host->lock, flags);
> +
> +	if (!unlikely(req))
> +		return;
> +
> +	mmc_request_done(host->mmc, req);
> +}
> +

Am I right in thinking that this spinlock guards against the interrupt
handler and the timeout function running at the same time? So it's not
really possible to drop the spinlock from here?
