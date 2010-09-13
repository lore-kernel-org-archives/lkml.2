Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab0IMGYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:24:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0IMGYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:24:51 -0400
Date: Mon, 13 Sep 2010 08:24:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 6/6] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100913062427.GC14040@elte.hu>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-6-git-send-email-ying.huang@intel.com>
 <20100910161319.GI4879@redhat.com>
 <1284344836.3269.87.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284344836.3269.87.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1075]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> On Sat, 2010-09-11 at 00:13 +0800, Don Zickus wrote:
> > On Fri, Sep 10, 2010 at 10:51:05AM +0800, Huang Ying wrote:
> > >  
> > > +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> > > +extern int nmi_watchdog_tick(struct pt_regs *regs);
> > > +#else
> > > +static inline int nmi_watchdog_tick(struct pt_regs *regs)
> > > +{
> > > +	return 0;
> > > +}
> > > +#endif
> > > +
> > >  extern atomic_t nmi_active;
> > >  extern unsigned int nmi_watchdog;
> > >  #define NMI_NONE	0
> > 
> > <snip>
> > 
> > > @@ -421,12 +429,8 @@ static notrace __kprobes void default_do
> > >  	}
> > >  	raw_spin_unlock(&nmi_reason_lock);
> > >  
> > > -#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> > > -	if (nmi_watchdog_tick(regs, reason))
> > > -		return;
> > > -	if (do_nmi_callback(regs, smp_processor_id()))
> > > +	if (nmi_watchdog_tick(regs))
> > >  		return;
> > > -#endif
> > >  
> > >  	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
> > >  	    == NOTIFY_STOP)
> > 
> > I wonder if these two chunks are going to confuse people when they read
> > the code.  The old nmi watchdog exists in the arch/x86 area but the new
> > nmi watchdog code is now in kernel/watchdog.c.
> > 
> > If someone sees nmi_watchdog_tick() here will they assume the nmi watchdog
> > code is still inside arch/x86?
> > 
> > I would suggest keep it wrapped with CONFIG_LOCKUP_DETECTOR to make it
> > obvious.  Thoughts?
> 
> Is it planned to remove old NMI watchdog implementation in near 
> future?

Yes. With the new Pentium4 PMU driver we've covered the last 
old-NMI-watchdog hardware support corner too, so we can and should 
remove the old code. (keeping the boot option to stay compatible)

Thanks,

	Ingo
