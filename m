Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2JLUwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:52:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:57078 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2JLUwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:52:13 -0400
Date: Fri, 12 Oct 2012 22:52:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: anish kumar <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with
 irq thread
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A195A8D@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1210122248070.2779@ionos>
References: <1350045084.13178.19.camel@cliu38-desktop-build>  <alpine.LFD.2.02.1210121427490.2779@ionos>  <27240C0AC20F114CBF8149A2696CBE4A19587A@SHSMSX101.ccr.corp.intel.com>  <alpine.LFD.2.02.1210121440160.2779@ionos>  <27240C0AC20F114CBF8149A2696CBE4A1958B9@SHSMSX101.ccr.corp.intel.com>
  <alpine.LFD.2.02.1210121533560.2779@ionos>  <27240C0AC20F114CBF8149A2696CBE4A195A6B@SHSMSX101.ccr.corp.intel.com> <1350055478.8329.24.camel@anish-Inspiron-N5050> <27240C0AC20F114CBF8149A2696CBE4A195A8D@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Liu, Chuansheng wrote:
> > -----Original Message-----
> > From: anish kumar [mailto:anish198519851985@gmail.com]
> > Sent: Friday, October 12, 2012 11:25 PM
> > To: Liu, Chuansheng
> > Cc: Thomas Gleixner; linux-kernel@vger.kernel.org
> > Subject: RE: [PATCH] genirq: for edge interrupt IRQS_ONESHOT support with irq
> > thread
> > 
> > On Fri, 2012-10-12 at 14:57 +0000, Liu, Chuansheng wrote:
> > > > On SMP an interrupt which is raised after the ack() again before the
> > > > handler finishes, can invoke another delivery on a different CPU,
> > > > which then sees the IRQ_INPROGESS flag, masks it and flags it
> > > > PENDING. When the primary handler on the first CPU returns, it sees
> > > > the PENDING flag, unmasks and invokes the handler another time.
> > > In this case, when IRQ_INPROGRESS flag is set, on another CPU, it will
> > > mask and ack it, if before the primary handler on the first CPU returns,
> > > the edge interrupt is raised again, it will be lost, right?
> > Why will the interrupt be raised again?Is not it masked?I read tglx
> I means because it is masked, if at this time device issues edge irq,
> It will not be delivered and lost.

No, it is NOT lost. The irq is marked PENDING already, so we invoke
the handler again and handle it. And before we invoke the handler
another time we unmask it.

It does not matter at all whether the interrupt has been sent five
times while it was masked. What matters is that we recorded the first
one and set the PENDING flag. That way we invoke the interrupt handler
again and keep stuff rolling.

Thanks,

	tglx
