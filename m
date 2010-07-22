Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab0GVMj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:39:26 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:18556
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752765Ab0GVMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:39:22 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432N98dN936eM179dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5YLO1-02-382-02
X-M-MSG: 
Date: Thu, 22 Jul 2010 14:36:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
Message-ID: <20100722123603.GU26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
 <1279731838-1522-7-git-send-email-robert.richter@amd.com>
 <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.10 14:16:02, Suresh Siddha wrote:

> I think it is cleaner to clear these cpu capabilities in the function
> which handles no387 boot parameter.

This does not cover all (of course weird but potentially existing)
cases. Disabling xsave in the no387 setup would only work if an fpu
exists. The implementation below disables it if the soft fpu is actual
used. An artificial condition that would break your approach would be
no fpu but xsave. There is no hardware like this but maybe virtual
machines configurations.

So I think it does not hurt to deactivate xsave directly when enabling
soft fpu. The only drawback here is if fpu and xsave initialization
order changes. Hmm...

-Robert

> 
> Otherwise Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> thanks.
> 
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  arch/x86/kernel/i387.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> > index e73c54e..ff81143 100644
> > --- a/arch/x86/kernel/i387.c
> > +++ b/arch/x86/kernel/i387.c
> > @@ -67,6 +67,12 @@ static void __cpuinit init_thread_xstate(void)
> >  	 */
> >  
> >  	if (!HAVE_HWFP) {
> > +		/*
> > +		 * Disable xsave as we do not support it if i387
> > +		 * emulation is enabled.
> > +		 */
> > +		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
> > +		setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
> >  		xstate_size = sizeof(struct i387_soft_struct);
> >  		return;
> >  	}
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

