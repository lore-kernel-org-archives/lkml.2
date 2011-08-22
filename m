Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1HVPZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:25:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1HVPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:25:32 -0400
Date: Mon, 22 Aug 2011 11:25:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110822152523.GD2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-5-git-send-email-dzickus@redhat.com>
 <1314022935.24275.35.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314022935.24275.35.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:22:15PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> > @@ -260,6 +260,8 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >         pr_emerg("Dazed and confused, but trying to continue\n");
> >  }
> >  
> > +DEFINE_PER_CPU(bool, swallow_nmi);
> > +
> >  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >  {
> >         unsigned char reason = 0;
> > @@ -271,8 +273,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >          * NMI can not be detected/processed on other CPUs.
> >          */
> >         handled = nmi_handle(NMI_LOCAL, regs);
> > -       if (handled)
> > +       if (handled) {
> > +               /*
> > +                * When handling multiple NMI events, we are not
> > +                * sure if the second NMI was dropped (because of
> > +                * too many NMIs), piggy-backed on the same NMI
> > +                * (perf) or is queued right behind this NMI.
> > +                * In the last case, we may accidentally get an
> > +                * unknown NMI because the event is already handled.
> > +                * Flag for this condition and swallow it later.
> > +                *
> > +                * FIXME: This detection has holes in it mainly
> > +                * because we can't tell _when_ the next NMI comes
> > +                * in.  A multi-handled NMI event followed by an 
> > +                * unknown NMI a second later, clearly should not
> > +                * be swallowed.
> > +                */
> > +               if (handled > 1)
> > +                       __this_cpu_write(swallow_nmi, true);
> > +               else
> > +                       __this_cpu_write(swallow_nmi, false);
> >                 return;
> > +       }
> >  
> >         /* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> >         raw_spin_lock(&nmi_reason_lock);
> > @@ -296,6 +318,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >         raw_spin_unlock(&nmi_reason_lock);
> >  
> >         unknown_nmi_error(reason, regs);
> > +
> > +       __this_cpu_write(swallow_nmi, false);
> >  } 
> 
> All writes, no reads... the actual dropping of NMIs got lost and now
> lives in patch 5 which purports to be about statistics only.

Oops.  I screwed up when breaking up the changes into multiple patches.
I'll fix that.  Thanks for catching that.

Cheers,
Don

