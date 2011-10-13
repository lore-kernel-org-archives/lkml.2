Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1JMKMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:12:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53482 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1JMKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:12:04 -0400
Date: Thu, 13 Oct 2011 15:42:04 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Maneesh Soni <manesoni@cisco.com>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, david.daney@cavium.com, kamensky@cisco.com
Subject: Re: [PATCH] MIPS Kprobes: Support branch instructions probing
Message-ID: <20111013101204.GB19054@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20111013090749.GB16761@cisco.com> <20111013094137.GA19054@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013094137.GA19054@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
x-cbid: 11101310-3534-0000-0000-0000009D643C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 03:11:37PM +0530, Ananth N Mavinakayanahalli wrote:
> On Thu, Oct 13, 2011 at 02:37:49PM +0530, Maneesh Soni wrote:
> 
> ...
> 
> I know nothing of MIPS internals, but...
>  
> >  static int __kprobes kprobe_handler(struct pt_regs *regs)
> > @@ -239,8 +531,13 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
> >  			save_previous_kprobe(kcb);
> >  			set_current_kprobe(p, regs, kcb);
> >  			kprobes_inc_nmissed_count(p);
> > -			prepare_singlestep(p, regs);
> > +			prepare_singlestep(p, regs, kcb);
> >  			kcb->kprobe_status = KPROBE_REENTER;
> > +			if (kcb->flags & SKIP_DELAYSLOT) {
> > +				resume_execution(p, regs, kcb);
> > +				restore_previous_kprobe(kcb);
> > +				preempt_enable_no_resched();
> > +			}
> >  			return 1;
> >  		} else {
> >  			if (addr->word != breakpoint_insn.word) {
> > @@ -284,8 +581,15 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
> >  	}
> > 
> >  ss_probe:
> > -	prepare_singlestep(p, regs);
> > -	kcb->kprobe_status = KPROBE_HIT_SS;
> > +	prepare_singlestep(p, regs, kcb);
> > +	if (kcb->flags & SKIP_DELAYSLOT) {
> > +		kcb->kprobe_status = KPROBE_HIT_SSDONE;
> > +		if (p->post_handler)
> > +			p->post_handler(p, regs, 0);
> > +		resume_execution(p, regs, kcb);
> 
> You are missing a preempt_disable_no_resched() here.

Oops! I meant preempt_enable_no_resched().

Ananth

