Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2JIIvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:51:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:61201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2JIIvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:51:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="202240110"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: RE: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
Thread-Topic: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
Thread-Index: AQHNnDjGDpe1bOH9KUSPm3S1s2HgPpewvQtg
Date: Tue, 9 Oct 2012 08:51:33 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A19171C@SHSMSX101.ccr.corp.intel.com>
References: <1348681092.19514.10.camel@cliu38-desktop-build>
	 <1348703122.19514.17.camel@cliu38-desktop-build>
	 <50632767.5050607@linux.vnet.ibm.com>
	 <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com>
	 <50633BA0.5030700@linux.vnet.ibm.com>
 <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q998q2N5003902

One suggestion below, thanks.

> -----Original Message-----
> From: Siddha, Suresh B
> Sent: Thursday, September 27, 2012 6:46 AM
> To: Srivatsa S. Bhat
> Cc: Liu, Chuansheng; tglx@linutronix.de; mingo@redhat.com; x86@kernel.org;
> linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; Paul E.
> McKenney; Peter Zijlstra; rusty@rustcorp.com.au
> Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the irq
> affinity mask
> 
> On Wed, 2012-09-26 at 23:00 +0530, Srivatsa S. Bhat wrote:
> > On 09/26/2012 10:36 PM, Suresh Siddha wrote:
> > > On Wed, 2012-09-26 at 21:33 +0530, Srivatsa S. Bhat wrote:
> > >> I have some fundamental questions here:
> > >> 1. Why was the CPU never removed from the affinity masks in the original
> > >> code? I find it hard to believe that it was just an oversight, because the
> > >> whole point of fixup_irqs() is to affine the interrupts to other CPUs, IIUC.
> > >> So, is that really a bug or is the existing code correct for some reason
> > >> which I don't know of?
> > >
> > > I am not aware of the history but my guess is that the affinity mask
> > > which is coming from the user-space wants to be preserved. And
> > > fixup_irqs() is fixing the underlying interrupt routing when the cpu
> > > goes down
> >
> > and the code that corresponds to that is:
> > irq_force_complete_move(irq); is it?
> 
> No. irq_set_affinity()
> 
> > > with a hope that things will be corrected when the cpu comes
> > > back online. But  as Liu noted, we are not correcting the underlying
> > > routing when the cpu comes back online. I think we should fix that
> > > rather than modifying the user-specified affinity.
> > >
> >
> > Hmm, I didn't entirely get your suggestion. Are you saying that we should
> change
> > data->affinity (by calling ->irq_set_affinity()) during offline but maintain a
> > copy of the original affinity mask somewhere, so that we can try to match it
> > when possible (ie., when CPU comes back online)?
> 
> Don't change the data->affinity in the fixup_irqs() and shortly after a
> cpu is online, call irq_chip's irq_set_affinity() for those irq's who
> affinity included this cpu (now that the cpu is back online,
> irq_set_affinity() will setup the HW routing tables correctly).
> 
> This presumes that across the suspend/resume, cpu offline/online
> operations, we don't want to break the irq affinity setup by the
> user-level entity like irqbalance etc...
> 
In fixup_irqs(), could we untouch the data->affinity, but calling ->irq_set_affinity() without offlined CPU.
If so, the better affinity is set, and user-space can use the data->affinity correctly, also new affinity setting
will and online cpus.

> > > That happens only if the irq chip doesn't have the irq_set_affinity() setup.
> >
> > That is my other point of concern : setting irq affinity can fail even if
> > we have ->irq_set_affinity(). (If __ioapic_set_affinity() fails, for example).
> > Why don't we complain in that case? I think we should... and if its serious
> > enough, abort the hotplug operation or atleast indicate that offline failed..
> 
> yes if there is a failure then we are in trouble, as the cpu is already
> disappeared from the online-masks etc. For platforms with
> interrupt-remapping, interrupts can be migrated from the process context
> and as such this all can be done much before.
> 
> And for legacy platforms we have done quite a few changes in the recent
> past like using eoi_ioapic_irq() for level triggered interrupts etc,
> that makes it as safe as it can be. Perhaps we can move most of the
> fixup_irqs() code much ahead and the lost section of the current
> fixup_irqs() (which check IRR bits and use the retrigger function to
> trigger the interrupt on another cpu) can still be done late just like
> now.
> 
> thanks,
> suresh

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
