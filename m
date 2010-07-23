Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab0GWRul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:50:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:52302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0GWRuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,249,1278313200"; 
   d="scan'208";a="821037082"
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100722123603.GU26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
	 <1279731838-1522-7-git-send-email-robert.richter@amd.com>
	 <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
	 <20100722123603.GU26154@erda.amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 23 Jul 2010 10:50:05 -0700
Message-Id: <1279907405.2718.6.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 05:36 -0700, Robert Richter wrote:
> On 21.07.10 14:16:02, Suresh Siddha wrote:
> 
> > I think it is cleaner to clear these cpu capabilities in the function
> > which handles no387 boot parameter.
> 
> This does not cover all (of course weird but potentially existing)
> cases. Disabling xsave in the no387 setup would only work if an fpu
> exists. The implementation below disables it if the soft fpu is actual
> used. An artificial condition that would break your approach would be
> no fpu but xsave. There is no hardware like this but maybe virtual
> machines configurations.
> 
> So I think it does not hurt to deactivate xsave directly when enabling
> soft fpu. The only drawback here is if fpu and xsave initialization
> order changes. Hmm...

Then the more appropriate place for this is to check at the beginning of
the xsave init code.

thanks,
suresh

> 
> -Robert
> 
> > 
> > Otherwise Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > thanks.
> > 
> > > 
> > > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > > ---
> > >  arch/x86/kernel/i387.c |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> > > index e73c54e..ff81143 100644
> > > --- a/arch/x86/kernel/i387.c
> > > +++ b/arch/x86/kernel/i387.c
> > > @@ -67,6 +67,12 @@ static void __cpuinit init_thread_xstate(void)
> > >  	 */
> > >  
> > >  	if (!HAVE_HWFP) {
> > > +		/*
> > > +		 * Disable xsave as we do not support it if i387
> > > +		 * emulation is enabled.
> > > +		 */
> > > +		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
> > > +		setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
> > >  		xstate_size = sizeof(struct i387_soft_struct);
> > >  		return;
> > >  	}
> > 
> > 
> 

