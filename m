Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2GaIVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 04:21:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2GaIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 04:21:46 -0400
Date: Tue, 31 Jul 2012 10:21:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Denis Efremov <yefremov.denis@gmail.com>
cc: Kurt Garloff <garloff@suse.de>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmscsim: spin_unlock_irq in interrupt handler fix
In-Reply-To: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
Message-ID: <Pine.LNX.4.64.1207311006171.27888@axis700.grange>
References: <1342853283-32549-1-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:1hdcHCipdw/HjZ/hriQ+E6J7Yez1Kvh7JKBkdYRzV1R
 WVCf0IS2AI8mZNytsj6wTiS0r44h5wQnEWA1SNsyWd32CYlWt/
 4qlGi8sV5oEowPe9NfF75NVxu98vLzyvtIA9eAVkJlD408SgbO
 e+gh5D+ZoZ09K77mMRxlGmjU5DWFxGjnBUF+SXVmTs2Wk3U39r
 /2/Bf+Aoth+RouwfORYwVAPg+kFZ6QlMpX8zuLpA/iPj8r05kS
 CL1ygOoNp3gNztdhpW2TIBfq6E7f35kUmI1lF+Z4HF+1JvjBTD
 FZ3uc5J83eygE68Te5punMvW7w+2/V7pC3L5CinAjxr1Sm+vX1
 yXkV3vbpqzTsHHsze9qvSwYfxPflrP5/F0WJN1YemMJtirydR0
 szYgJDaQVjocg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, been ages since the last patch to this driver has hit my mail:-)

On Sat, 21 Jul 2012, Denis Efremov wrote:

> The replacement of spin_lock_irq/spin_unlock_irq pair in interrupt
> handler by spin_lock_irqsave/spin_lock_irqrestore pair.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Right, unconditionally enabling local IRQs in an ISR seems rude. BUT: 
unfortunately, it's not as easy as this. From DC390_Interrupt() 
dc390_DataOut_0() and dc390_DataIn_0() can be called, which also use 
spin_lock_irq() / spin_unlock_irq()... So, maybe adding a flags field to 
struct dc390_acb and using it on all 3 occasions would be the easiest and 
safest fix...

Thanks
Guennadi

> ---
>  drivers/scsi/tmscsim.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index a1baccc..0b9d68a 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -654,6 +654,7 @@ DC390_Interrupt(void *dev_id)
>      u8  phase;
>      void   (*stateV)( struct dc390_acb*, struct dc390_srb*, u8 *);
>      u8  istate, istatus;
> +    unsigned long flags;
>  
>      sstatus = DC390_read8 (Scsi_Status);
>      if( !(sstatus & INTERRUPT) )
> @@ -665,7 +666,7 @@ DC390_Interrupt(void *dev_id)
>      //dstatus = DC390_read8 (DMA_Status);
>      //DC390_write32 (DMA_ScsiBusCtrl, EN_INT_ON_PCI_ABORT);
>  
> -    spin_lock_irq(pACB->pScsiHost->host_lock);
> +    spin_lock_irqsave(pACB->pScsiHost->host_lock, flags);
>  
>      istate = DC390_read8 (Intern_State);
>      istatus = DC390_read8 (INT_Status); /* This clears Scsi_Status, Intern_State and INT_Status ! */
> @@ -736,7 +737,7 @@ DC390_Interrupt(void *dev_id)
>      }
>  
>   unlock:
> -    spin_unlock_irq(pACB->pScsiHost->host_lock);
> +    spin_unlock_irqrestore(pACB->pScsiHost->host_lock, flags);
>      return IRQ_HANDLED;
>  }
>  
> -- 
> 1.7.7
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
