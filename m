Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0KLCup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:50:45 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:45042 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825Ab0KLCuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:50:44 -0500
Message-ID: <000901cb8214$65880180$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Alan Cox" <alan@linux.intel.com>
Cc: <andrew.chih.howe.khor@intel.com>, <kok.howg.ewe@intel.com>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Tobias Klauser" <tklauser@distanz.ch>,
        "Feng Tang" <feng.tang@intel.com>,
        "Mike Frysinger" <vapier@gentoo.org>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Ben Dooks" <ben-linux@fluff.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4CD8D5A2.1080202@dsn.okisemi.com><20101109103737.40bfab7b@linux.intel.com><000901cb816e$22528490$66f8800a@maildom.okisemi.com> <20101111114244.6250ab48@linux.intel.com>
Subject: Re: [PATCH] EG20T: Update PCH_UART driver to 2.6.36
Date: Fri, 12 Nov 2010 11:50:39 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 11, 2010 8:42 PM, Alan Cox wrote:

> > > 
> > > The PCH DMA will have been included in the kernel anyway before this
> > > merge so you can remove the ifdefs and include it regardless
> > 
> > No.
> > PCH DMA have been already included at 2.6.36.
> > You can see "pch_dma.c" in drivers/dma.
> 
> So that means pch_dma is always in the kernel source tree as of 2.6.36
> - so the ifdef can go away ?

In case low traffic,
If UART driver is DMA mode only,
1byte data is also transferred using DMA.
This overhead is too big.
As a result, 1byte DMA transfer is slower than Non-DMA mode.
Thus, I think Non-DMA mode is also necessary.

> 
> > > tty = tty_port_tty_get(...)
> > > 
> > > and when finished tty_kref_put(tty);
> > > 
> > > Also tty may be NULL, if the port closed as you were doing this, so
> > > check the return from tty_port_tty_get and act accordingly.
> > 
> > I have a question.
> > Though I can't find any accepted UART driver uses these
> > functions(tty_port.../tty_kref...), What's for ?
> 
> We are gradually going through converting them all and I'm trying to
> make sure no new ones creep in that don't use tty_port_tty_get.
> 
> Basically it does this
> 
> tty_port_tty_get()
> 
> will return either a tty pointer with a reference (ie the tty will not
> be deleted while you hold it), or will return NULL if the physical port
> is no longer connected to a tty through close/hangup. It does all the
> locking internally to ensure this is done safely.
> 
> tty_kref_put()
> 
> drops the reference it obtained and after that point if the tty
> reference count hits zero it may be deleted.
> 
> It ensures this cannot occur
> 
> CPU1 CPU2
> 
> interrupt:
> tty = port->port.tty
> close
> port->port.tty = NULL
> kfree tty
> write to tty

Thank you for yor explanation.
I will add above.

> 
> 
> 
> > Many UART drivers accepted by upstream use the above macro, right ?
> 
> As far as possible the selection should be done at runtime, especially
> for PC class devices. Linux distributors want to build a single kernel
> for everything so having it runtime configured helps a lot.
> 
> 
> > > If you don't support CPARMRK then you should clear that bit in
> > > termios->c_flag so the caller knows it couldn't be set.
> > 
> > Sorry, I don't know CPARMRK.
> > What's CPARMRK ?
> 
> Sorry my fault. I mean CMSPAR
> 
> CMSPAR if set selects mark/space parity. If your hardware doesn't
> support this then do
> 
> termios->c_cflag &= ~CMSPAR;

eg20t doesn't support mark/space parity.
I will add above.

> 
> 
> > I will use dma_alloc_coherent.

I have modified and test.
Both  __get_free_page and dma_alloc_coherent work well.
I have a question.
Could you tell me the defferencies 
 __get_free_page(GFP_DMA) and dma_alloc_coherent ?

> > 
> > > 
> > > I assume the correct device in this case would be the DMA
> > > controller ?
> > 
> > Sorry, I can't understand your saying "correct device".
> > What does "correct device" mean ?
> 
> dma_alloc_coherent takes a device pointer which should be the device
> which is doing the DMA.

Yes, UART cooperates with DMA controller for UART DMA transfer.
Can you satisfy the above my answer ?
(I may not understand your intension correctly)

> 
> > Do you mean UART Rx/Tx interrupt Enable/Disable ?
> > If yes, the control hava been already implemented.
> > For example, in handle_tx (called from IRQ handler),
> > you can see pch_uart_hal_disable_interrupt().
> 
> I will take another look next time the patch is submitted. However if
> you are relying on disabling an IRQ source to avoid the interrupt
> running in parallel with another routine remember on a multithreaded
> CPU and on some hardware that it is possible for this to occur
> 
> 
> CPU1 CPU2
> Interrupt arrives
> Disable interrupt
> Interrupt routine runs Other code runs
> 
> 

Yes, I have used spin_lock_irqsave.
Do you mean we should implement another method for lock model ?


I will post the latst patch soon.

--
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
