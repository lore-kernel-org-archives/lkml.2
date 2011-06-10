Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1FJJqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:46:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54665 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1FJJqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:46:54 -0400
Date: Fri, 10 Jun 2011 11:46:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address
 granuality
Message-ID: <20110610094637.GD1621@aftab>
References: <4df13c362729376e2@agluck-desktop.sc.intel.com>
 <4DF1D0B1.1020302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF1D0B1.1020302@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:07:13AM -0400, Hidetoshi Seto wrote:
> (2011/06/10 6:33), Luck, Tony wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > 
> > SER enabled systems report the address granuality for each
> > reported address in a machine check. But the bits below
> > the granuality are undefined. Mask them out before
> > logging the machine check.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce.c |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 0349e87..ffc8d11 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -539,8 +539,18 @@ static void mce_read_aux(struct mce *m, int i)
> >  {
> >  	if (m->status & MCI_STATUS_MISCV)
> >  		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
> > -	if (m->status & MCI_STATUS_ADDRV)
> > +	if (m->status & MCI_STATUS_ADDRV) {
> >  		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
> > +
> > +		/*
> > +		 * Mask the reported address by the reported granuality.
> > +		 */
> > +		if (mce_ser && (m->status & MCI_STATUS_MISCV)) {
> > +			u8 shift = m->misc & 0x1f;
> > +			m->addr >>= shift;
> > +			m->addr <<= shift;
> > +		}
> > +	}
> >  }
> >  
> >  DEFINE_PER_CPU(unsigned, mce_poll_count);
> 
> Why do you have to mask it out in kernel, why not in user/logger?
> 
> One possible story is:
>   "... the brand-new Xeon XXXX has new MCx_***_VALID bit in ****
>   register, if it is set the lower bits of MCx_ADDR indicates
>   ****, otherwise the bits are undefined ..."
> 
> So I think that kernel should convey the raw value from hardware to
> userland.  Even if it contains some noise on it, user can determine
> whether it is useful or not.  And more, since this is an error record,
> there will be no second chance to retrieve the data afterward.

I think they need the correct address for the poisoning later:

                if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
                        mce_ring_add(m.addr >> PAGE_SHIFT);


Tony?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
