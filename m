Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2HCXXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 19:23:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2HCXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 19:23:40 -0400
Date: Sat, 4 Aug 2012 01:23:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Denis Efremov <yefremov.denis@gmail.com>
cc: Kurt Garloff <garloff@suse.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tmscsim: spin_unlock_irq in interrupt handler fix
In-Reply-To: <1343735613-28392-1-git-send-email-yefremov.denis@gmail.com>
Message-ID: <Pine.LNX.4.64.1208040120210.5170@axis700.grange>
References: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
 <1343735613-28392-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:gyQUaeOIOKqZGeSkHBSsRr3M1bfwv5hp9tTfclxHBUX
 KEdX2ZrHCQIoAc92fk/KeeHcz9JVCTzeeiSD580sLOviisBDuD
 wJSpz87fZfw+rWOSmJQu0I7x1fWurGJJdTC1nOgL2YcpoYaS55
 Ll8WlcDSfRd7DZAXjYXZv1xl3iepqpahFG25YDlxr+A089ZuWr
 E5Oqdu1m/qNrkqfviiH2McJVRk0w7VUOQ+gR1owfXtC8CrqXvG
 iPrmAsPR972pnOJnANDFcm4HGsXSy4v0U5SwfTOPUvRfcT/gyU
 Mss1JHNZ31wE4tKzj/Cvo4AUw8m0aj6H+C9b57o0GNH2LA7ALt
 uhIvha/CbD94fBexyp1Vjy8gSgkyKM8pVOQqDzU1g0Q4wxflvH
 ZxavIp2Ey7jQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Denis Efremov wrote:

> The replacement of spin_lock_irq/spin_unlock_irq pairs which
> can be called from interrupt handler by irqsave/irqrestore
> versions.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Note: I didn't test this. I still have a dc390 card in my PC, so, I could 
test it, but I haven't yet got time for this and I'll be away the next 
week. The patch looks correct and safe. If it does break anything, well, 
we'll get to know about that sooner or later...

Thanks
Guennadi

> ---
>  drivers/scsi/tmscsim.c |   12 ++++++------
>  drivers/scsi/tmscsim.h |    1 +
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index a1baccc..e9b7148 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -665,7 +665,7 @@ DC390_Interrupt(void *dev_id)
>      //dstatus = DC390_read8 (DMA_Status);
>      //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
>  
> -    spin_lock_irq(pACB->pScsiHost->host_lock);
> +    spin_lock_irqsave(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>  
>      istate = DC390_read8 (Intern_State);
>      istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
> @@ -736,7 +736,7 @@ DC390_Interrupt(void *dev_id)
>      }
>  
>   unlock:
> -    spin_unlock_irq(pACB->pScsiHost->host_lock);
> +    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>      return IRQ_HANDLED;
>  }
>  
> @@ -771,9 +771,9 @@ dc390_DataOut_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
>  	    /* Function called from the ISR with the host_lock held and interrupts disabled */
>  	    if (pSRB->SGToBeXferLen)
>  		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
> -		    spin_unlock_irq(pACB->pScsiHost->host_lock);
> +		    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>  		    udelay(50);
> -		    spin_lock_irq(pACB->pScsiHost->host_lock);
> +		    spin_lock_irqsave(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>  		}
>  	    if (!time_before(jiffies, timeout))
>  		printk (KERN_CRIT "DC390: Deadlock in DataOut_0: DMA aborted unfinished: %06x bytes remain!!\n",
> @@ -830,9 +830,9 @@ dc390_DataIn_0(struct dc390_acb* pACB, struct dc390_srb* pSRB, u8 *psstatus)
>  	    /* Function called from the ISR with the host_lock held and interrupts disabled */
>  	    if (pSRB->SGToBeXferLen)
>  		while (time_before(jiffies, timeout) && !((dstate = DC390_read8 (DMA_Status)) & DMA_XFER_DONE)) {
> -		    spin_unlock_irq(pACB->pScsiHost->host_lock);
> +		    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>  		    udelay(50);
> -		    spin_lock_irq(pACB->pScsiHost->host_lock);
> +		    spin_lock_irqsave(pACB->pScsiHost->host_lock, pACB->hlock_flags);
>  		}
>  	    if (!time_before(jiffies, timeout)) {
>  		printk (KERN_CRIT "DC390: Deadlock in DataIn_0: DMA aborted unfinished: %06x bytes remain!!\n",
> diff --git a/drivers/scsi/tmscsim.h b/drivers/scsi/tmscsim.h
> index 77adc54..3f9ea2b 100644
> --- a/drivers/scsi/tmscsim.h
> +++ b/drivers/scsi/tmscsim.h
> @@ -107,6 +107,7 @@ u8		SyncOffset;	/*;for reg. and nego.(low nibble) */
>  struct dc390_acb
>  {
>  struct Scsi_Host *pScsiHost;
> +unsigned long     hlock_flags;
>  u16		IOPortBase;
>  u8		IRQLevel;
>  u8		status;
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
