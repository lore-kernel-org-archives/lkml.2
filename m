Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1EILL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:11:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1EILL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:11:56 -0400
Date: Mon, 9 May 2011 13:11:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] kprobes,x86: disable irq durinr optimized callback
Message-ID: <20110509111149.GB3981@jolsa.brq.redhat.com>
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
 <20110426134625.GA21840@home.goodmis.org>
 <20110426141903.GC1896@jolsa.brq.redhat.com>
 <4DB7688B.7010503@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB7688B.7010503@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 09:51:23AM +0900, Masami Hiramatsu wrote:
> (2011/04/26 23:19), Jiri Olsa wrote:
> > On Tue, Apr 26, 2011 at 09:46:25AM -0400, Steven Rostedt wrote:
> >> On Tue, Apr 26, 2011 at 03:01:31PM +0200, Jiri Olsa wrote:

SNIP

> >>> hi,
> > 
> > makes the optimized kprobes to be missed. None is missed
> > if the kprobe optimatization is disabled.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> 
> Ingo, could you pull this as a bugfix?

hi,
could this be pulled in?

thanks,
jirka

> 
> Thank you!
> 
> 
> > ---
> >  arch/x86/kernel/kprobes.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> > index c969fd9..f1a6244 100644
> > --- a/arch/x86/kernel/kprobes.c
> > +++ b/arch/x86/kernel/kprobes.c
> > @@ -1183,12 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
> >  					 struct pt_regs *regs)
> >  {
> >  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> > +	unsigned long flags;
> >  
> >  	/* This is possible if op is under delayed unoptimizing */
> >  	if (kprobe_disabled(&op->kp))
> >  		return;
> >  
> > -	preempt_disable();
> > +	local_irq_save(flags);
> >  	if (kprobe_running()) {
> >  		kprobes_inc_nmissed_count(&op->kp);
> >  	} else {
> > @@ -1207,7 +1208,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
> >  		opt_pre_handler(&op->kp, regs);
> >  		__this_cpu_write(current_kprobe, NULL);
> >  	}
> > -	preempt_enable_no_resched();
> > +	local_irq_restore(flags);
> >  }
> >  
> >  static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
