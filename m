Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab0FSPaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:30:23 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63983 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157Ab0FSPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:30:22 -0400
Message-ID: <4C1CE25F.70606@metafoo.de>
Date: Sat, 19 Jun 2010 17:29:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2 18/26] MMC: Add JZ4740 mmc driver
References: <1276924111-11158-1-git-send-email-lars@metafoo.de> <1276924111-11158-19-git-send-email-lars@metafoo.de> <87ocf7ozb2.fsf@linux-g6p1.site>
In-Reply-To: <87ocf7ozb2.fsf@linux-g6p1.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Matt Fleming wrote:
> On Sat, 19 Jun 2010 07:08:23 +0200, Lars-Peter Clausen
<lars@metafoo.de> wrote:
>> This patch adds support for the mmc controller on JZ4740 SoCs.
>>
>
> Hey Lars-Peter,
>
> I had a quick look over this patch and it looks OK. Just a few comments.
>
>> +static void jz4740_mmc_timeout(unsigned long data)
>> +{
>> +    struct jz4740_mmc_host *host = (struct jz4740_mmc_host *)data;
>> +    unsigned long flags;
>> +
>> +    spin_lock_irqsave(&host->lock, flags);
>> +    if (!host->waiting) {
>> +        spin_unlock_irqrestore(&host->lock, flags);
>> +        return;
>> +    }
>> +
>> +    host->waiting = 0;
>> +
>> +    spin_unlock_irqrestore(&host->lock, flags);
>> +
>> +    host->req->cmd->error = -ETIMEDOUT;
>> +    jz4740_mmc_request_done(host);
>> +}
>> +
>
> Taking a spinlock and disabling interrupts seems like too much overhead
> to simply test and clear a bit. Wouldn't it be better to implement this
> with test_and_clear_bit(), which on MIPS will likely be implemented with
> ll/sc instructions? It's particularly important to keep this
> low-overhead since this bit is modified in the interrupt handler.
>
Sounds like a good idea :)
>> +static void jz4740_mmc_request_done(struct jz4740_mmc_host *host)
>> +{
>> +    struct mmc_request *req;
>> +    unsigned long flags;
>> +
>> +    spin_lock_irqsave(&host->lock, flags);
>> +    req = host->req;
>> +    host->req = NULL;
>> +    host->waiting = 0;
>> +    spin_unlock_irqrestore(&host->lock, flags);
>> +
>> +    if (!unlikely(req))
>> +        return;
>> +
>> +    mmc_request_done(host->mmc, req);
>> +}
>> +
>
> Am I right in thinking that this spinlock guards against the interrupt
> handler and the timeout function running at the same time? So it's not
> really possible to drop the spinlock from here?
>
Yes, at least that is what it was meant for. But it was there before
the waiting bit and right now I can not construct any code paths that
could lead to jz4740_mmc_request_done from two paths at the same time.
The timer wont call it if the waiting bit is not set and the irq
handler won't wake the threaded irq handler if the waiting bit is not
set. I'll think a bit more about it and eventually drop the spinlock here.
Thanks for your review :)

- Lars

