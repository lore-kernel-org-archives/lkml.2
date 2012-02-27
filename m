Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2B0Ia7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:30:59 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:35267 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2B0Ia6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:30:58 -0500
From: "Jack Wang" <jack_wang@usish.com>
To: "'santosh prasad nayak'" <santoshprasadnayak@gmail.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc: <lindar_liu@usish.com>, <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com><20120226150720.GB4763@mwanda> <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Subject: RE: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Mon, 27 Feb 2012 16:29:50 +0800
Message-ID: <B76D77A74C894381BBF8365C5607758B@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
In-Reply-To: <CAOD=uF4VGsM5AQTSCW4ZRr_n4HUSr0qO3fG_MAtsYgq=ogXvAQ@mail.gmail.com>
Thread-Index: Acz1DBsZdRdm1Dp4SG2ejcJaNwFToQAHcpZQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fix.
Acked-by: Jack Wang <jack_wang@usish.com>
> 
>  In 'mpi_sata_completion'
>  the first call for 'spin_unlock_irqrestore()' is with flags=0,
>  which is as good as 'spin_unlock_irq()' ( unconditional interrupt
>  enabling). If intention of the developer is to enable the interrupt
during
> execution of ' mpi_sata_completion' , then the code changes in the patch
> looks ok.
> 
> If interrupt should not be enabled during execution of
> 'mpi_sata_completion' then
> we can use simple  spin_lock and spin_unlock.
> 
> 
> regards
> santosh
> 
> 
> On Sun, Feb 26, 2012 at 8:37 PM, Dan Carpenter <dan.carpenter@oracle.com>
> wrote:
> > On Sun, Feb 26, 2012 at 07:03:30PM +0530, santosh nayak wrote:
> >> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> >>
> >> Static checker is giving following warning:
> >> " error: calling 'spin_unlock_irqrestore()' with bogus flags"
> >>
> >> The code flow is as shown below:
> >> process_oq() --> process_one_iomb --> mpi_sata_completion
> >>
> >> In 'mpi_sata_completion'
> >> the first call for 'spin_unlock_irqrestore()' is with flags=0,
> >> which is as good as 'spin_unlock_irq()' ( unconditional interrupt
> >> enabling).
> >>
> >> So for better performance 'spin_unlock_irqrestore()' can be replaced
> >> with 'spin_unlock_irq()' and 'spin_lock_irqsave()' can be replaced by
> >> 'spin_lock_irq()'.
> >>
> >
> > process_oq() is called from the interrupt handler pm8001_chip_isr()
> > with interrupts disabled.
> >
> > drivers/scsi/pm8001/pm8001_hwi.c
> >  4301          spin_lock_irqsave(&pm8001_ha->lock, flags);
> >  4302          pm8001_chip_interrupt_disable(pm8001_ha);
> >  4303          process_oq(pm8001_ha);
> >  4304          pm8001_chip_interrupt_enable(pm8001_ha);
> >  4305          spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> >
> > Probably we should just be doing a spin_lock() and spin_unlock()
> > without re-enabling the IRQs.  Should we even be doing that in the
> > irq handler anyway?
> >
> > regards,
> > dan carpenter
> >

