Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0FYAWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:22:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49420 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0FYAWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XkNQFSLzGYxqjvLvj2WT4y0hyyhRfshx3GJfqoDy/Sy65GI3bFrrIRjZwG67jrolFX
         yXzS2Wh04AuPvIJbe0aBUSVFT6RoFeuihMP62NaiKURlsFmyP8AUnfqWn0SxmtrtMrMa
         dy1iOmH2BaLeAp/Ku6Gw/MJvQnitdXewHESXg=
Message-ID: <4C23F6C1.7070603@garzik.org>
Date: Thu, 24 Jun 2010 20:22:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org>
In-Reply-To: <1276443098-20653-12-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 11:31 AM, Tejun Heo wrote:
> Thanks to its age, ATA is very susceptible to IRQ delivery problems in
> both directions - lost and spurious interrupts.  In traditional PATA,
> the IRQ line is ultimately out of the controller and driver's control.
> Even relatively new SATA isn't free from these issues.  Many
> controllers still emulate the traditional IDE interface which doesn't
> have reliable way to indicate interrupt pending state and there also
> is an issue regarding the interpretation of nIEN on both sides of the
> cable.
>
> Most of these problems can be worked around by using the new IRQ
> expecting mechanism without adding noticeable overhead.  In ATA,
> almost all operations are initiated by the host and the controller
> signals progress or completion using IRQ.  IRQ expecting can easily be
> added in libata core and applied to all libata drivers.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> ---
>   drivers/ata/libata-core.c |   15 +++++++++++++--
>   drivers/ata/libata-eh.c   |    4 +++-
>   drivers/ata/libata-sff.c  |   37 +++++++++++++++++++------------------
>   include/linux/libata.h    |    2 ++
>   4 files changed, 37 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index ddf8e48..9a0aaa0 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4972,6 +4972,8 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
>   {
>   	struct ata_port *ap = qc->ap;
>
> +	unexpect_irq(ap->irq_expect, false);
> +
>   	/* XXX: New EH and old EH use different mechanisms to
>   	 * synchronize EH with regular execution path.
>   	 *

Unconditional use of unexpect_irq() here seems incorrect for some cases, 
such as sata_mv's use, where ata_qc_complete() is called multiple times 
rather than a singleton ata_qc_complete_multiple() call.

	Jeff






