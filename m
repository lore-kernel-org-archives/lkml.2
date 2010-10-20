Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0JTAXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:23:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:45660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab0JTAXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565602858"
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101019183720.GN4140@redhat.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
	 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
	 <20101019150701.GR5969@erda.amd.com> <20101019162507.GU5969@erda.amd.com>
	 <20101019183720.GN4140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 08:23:12 +0800
Message-ID: <1287534192.3026.9.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 02:37 +0800, Don Zickus wrote:
> On Tue, Oct 19, 2010 at 06:25:07PM +0200, Robert Richter wrote:
> > On 19.10.10 17:07:01, Robert Richter wrote:
> > > On 15.10.10 22:22:17, Don Zickus wrote:
> > > > From: Huang Ying <ying.huang@intel.com>
> > > > 
> > > > In original NMI handler, NMI reason io port (0x61) is only processed
> > > > on BSP. This makes it impossible to hot-remove BSP. To solve the
> > > > issue, a raw spinlock is used to make the port can be processed on any
> > > > CPU.
> > > > 
> > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > > ---
> > > >  arch/x86/kernel/traps.c |   45 +++++++++++++++++++++++++--------------------
> > > >  1 files changed, 25 insertions(+), 20 deletions(-)
> > 
> > > > @@ -400,28 +405,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> > > >  		return;
> > > >  
> > > >  	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> > > > -	cpu = smp_processor_id();
> > > > -	/* Only the BSP gets external NMIs from the system. */
> > > > -	if (!cpu) {
> > > > -		reason = get_nmi_reason();
> > > > -		if (reason & NMI_REASON_MASK) {
> > > > -			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > > > -			    == NOTIFY_STOP)
> > > > -				return;
> > > > -			if (reason & NMI_REASON_SERR)
> > > > -				pci_serr_error(reason, regs);
> > > > -			else if (reason & NMI_REASON_IOCHK)
> > > > -				io_check_error(reason, regs);
> > > > +	raw_spin_lock(&nmi_reason_lock);
> > > 
> > > What about using raw_spin_trylock() instead? We don't have to wait
> > > here since we are already processing it by another cpu.
> > 
> > This would avoid a global lock and also deadlocking in case of a
> > potential #gp in the nmi handler.
> 
> I would feel more comfortable with it too.  I can't find a reason where
> trylock would do harm.

One possible issue can be as follow:

- PCI SERR NMI raised on CPU 0
- IOCHK NMI raised on CPU 1

If we use try lock, we may get unknown NMI on one CPU. Do you guys think
so?

Best Regards,
Huang Ying


