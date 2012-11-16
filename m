Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab2KPAgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:36:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:23381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab2KPAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:36:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,259,1352102400"; 
   d="scan'208";a="242959497"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] x86/irq,io_apic: Fix wrong unmask_ioapic calling when
 the irq is masked
Thread-Topic: [PATCH] x86/irq,io_apic: Fix wrong unmask_ioapic calling when
 the irq is masked
Thread-Index: AQHNwjzqz8BIim47t0G9dlOVrY/BYZfrn+ew
Date: Fri, 16 Nov 2012 00:36:12 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1CE9A9@SHSMSX101.ccr.corp.intel.com>
References: <1352911962.15558.1676.camel@cliu38-desktop-build>
In-Reply-To: <1352911962.15558.1676.camel@cliu38-desktop-build>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAG0aajt001269

Hi Thomas and Ingo,

Could you have a look for this patch? It fix the wrong unmask action.
Thanks.

> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Thursday, November 15, 2012 12:53 AM
> To: mingo@redhat.com; tglx@linutronix.de
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: [PATCH] x86/irq,io_apic: Fix wrong unmask_ioapic calling when the irq
> is masked
> 
> 
> There is one typical case will cause this issue, that is:
> One io-apic interrupt with ONE_SHOT and threaded, when interrupt is coming:
> handle_fasteoi_irq()
> --> mask_irq(desc)
>     ...
>     desc->irq_data.chip->irq_eoi(&desc->irq_data)[ack_apic_level]
>     --> ioapic_irqd_mask()
>         ...
>         ioapic_irqd_unmask()
> 
> After that, the irq will be in unmasked state.
> 
> It will break the ONE_SHOT and threaded irq, and brings some unwanted
> issues.
> Here adding the irqd_irq_masked() condition to know if unmasking action is
> needed.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 1817fa9..d963e76 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2479,7 +2479,8 @@ static inline void ioapic_irqd_unmask(struct irq_data
> *data,
>  		 */
>  		if (!io_apic_level_ack_pending(cfg))
>  			irq_move_masked_irq(data);
> -		unmask_ioapic(cfg);
> +		if (!irqd_irq_masked(data))
> +			unmask_ioapic(cfg);
>  	}
>  }
>  #else
> --
> 1.7.0.4
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
