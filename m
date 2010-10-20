Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0JTKDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:03:35 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:23395
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566Ab0JTKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:03:32 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0LAL2LF-01-0TV-02
X-M-MSG: 
Date: Wed, 20 Oct 2010 12:03:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20101020100316.GX5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
 <20101019150701.GR5969@erda.amd.com>
 <20101019162507.GU5969@erda.amd.com>
 <20101019183720.GN4140@redhat.com>
 <1287534192.3026.9.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287534192.3026.9.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.10.10 20:23:12, Huang Ying wrote:
> On Wed, 2010-10-20 at 02:37 +0800, Don Zickus wrote:
> > On Tue, Oct 19, 2010 at 06:25:07PM +0200, Robert Richter wrote:
> > > On 19.10.10 17:07:01, Robert Richter wrote:
> > > > On 15.10.10 22:22:17, Don Zickus wrote:
> > > > > From: Huang Ying <ying.huang@intel.com>
> > > > > 
> > > > > In original NMI handler, NMI reason io port (0x61) is only processed
> > > > > on BSP. This makes it impossible to hot-remove BSP. To solve the
> > > > > issue, a raw spinlock is used to make the port can be processed on any
> > > > > CPU.
> > > > > 
> > > > > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > > > > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > > > > ---
> > > > >  arch/x86/kernel/traps.c |   45 +++++++++++++++++++++++++--------------------
> > > > >  1 files changed, 25 insertions(+), 20 deletions(-)
> > > 
> > > > > @@ -400,28 +405,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> > > > >  		return;
> > > > >  
> > > > >  	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> > > > > -	cpu = smp_processor_id();
> > > > > -	/* Only the BSP gets external NMIs from the system. */
> > > > > -	if (!cpu) {
> > > > > -		reason = get_nmi_reason();
> > > > > -		if (reason & NMI_REASON_MASK) {
> > > > > -			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> > > > > -			    == NOTIFY_STOP)
> > > > > -				return;
> > > > > -			if (reason & NMI_REASON_SERR)
> > > > > -				pci_serr_error(reason, regs);
> > > > > -			else if (reason & NMI_REASON_IOCHK)
> > > > > -				io_check_error(reason, regs);
> > > > > +	raw_spin_lock(&nmi_reason_lock);
> > > > 
> > > > What about using raw_spin_trylock() instead? We don't have to wait
> > > > here since we are already processing it by another cpu.
> > > 
> > > This would avoid a global lock and also deadlocking in case of a
> > > potential #gp in the nmi handler.
> > 
> > I would feel more comfortable with it too.  I can't find a reason where
> > trylock would do harm.
> 
> One possible issue can be as follow:
> 
> - PCI SERR NMI raised on CPU 0
> - IOCHK NMI raised on CPU 1
> 
> If we use try lock, we may get unknown NMI on one CPU. Do you guys think
> so?

This could be a valid point. On the other side the former
implementation to let only handle cpu #0 i/o interrupts didn't trigger
unknown nmis, so try_lock wouldn't change much compared to this. To be
sure we might do a NOTIFY_STOP in the unknown path if we don't get the
lock.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

