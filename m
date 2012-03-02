Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2CBP3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:29:17 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:41454 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758764Ab2CBP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:29:16 -0500
Message-ID: <1330702146.2611.1.camel@bwh-desktop>
Subject: Re: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
From: Ben Hutchings <bhutchings@solarflare.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
CC: <jitendra.kalsaria@qlogic.com>, <ron.mercer@qlogic.com>,
        <linux-driver@qlogic.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Date: Fri, 2 Mar 2012 15:29:06 +0000
In-Reply-To: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18746.005
X-TM-AS-Result: No--11.931100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 20:39 +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> In 'ql_adapter_initialize'
> the first call for 'spin_unlock_irqrestore()' is with hw_flags = 0,
> which is as good as 'spin_unlock_irq()' (unconditional interrupt
> enabling). If this is intended, then for better performance
> 'spin_unlock_irqrestore()' can be replaced with 'spin_unlock_irq()'
> and 'spin_lock_irqsave()' can be replaced by 'spin_lock_irq()

Maybe you should make the same change in ql_adapter_up(), which is the
caller that acquires this spinlock (and certainly shouldn't be called in
IRQ context).

Ben.

> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qla3xxx.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> index d49f6da..8da3e41 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -3017,7 +3017,6 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
>  		(void __iomem *)port_regs;
>  	u32 delay = 10;
>  	int status = 0;
> -	unsigned long hw_flags = 0;
>  
>  	if (ql_mii_setup(qdev))
>  		return -1;
> @@ -3228,9 +3227,9 @@ static int ql_adapter_initialize(struct ql3_adapter *qdev)
>  		value = ql_read_page0_reg(qdev, &port_regs->portStatus);
>  		if (value & PORT_STATUS_IC)
>  			break;
> -		spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
> +		spin_unlock_irq(&qdev->hw_lock);
>  		msleep(500);
> -		spin_lock_irqsave(&qdev->hw_lock, hw_flags);
> +		spin_lock_irq(&qdev->hw_lock);
>  	} while (--delay);
>  
>  	if (delay == 0) {

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

