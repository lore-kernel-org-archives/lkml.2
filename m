Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab0I0XwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:52:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab0I0XwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E0f4FI8suqvsKqGWm+dznbVu1xA7nJQHgtP0CJ43Po1m76m2OQcVxnn81QJOKX8pDj
         xwXrCTSRyV5e3zwHXPtsu9Lyq8SSvZOgKDoz30Wf+VPWp5SoBmOEHhlhv0Qqco+yPMk7
         tEcMogTtIFgtLR0XFE41ZBdEDmiMQ2Kd2ig30=
Date: Tue, 28 Sep 2010 01:52:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] x86: Barf when faults happen in NMI
Message-ID: <20100927235206.GB6316@nowhere>
References: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com> <20100927211401.GA20402@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927211401.GA20402@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 05:14:01PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > In x86, faults exit by executing the iret instruction, which then
> > reenables NMIs if we faulted in NMI context. Then if a fault
> > happens in NMI, another NMI can nest after the fault exits.
> > 
> > But we don't yet support nested NMIs because we have only one NMI
> > stack. To prevent that, trigger a bug when a fault happens in NMI
> > context.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> > 
> > I first thought about putting it in the vmalloc fault path only.
> > But then I saw more occasions for the kernel to fault (kmemcheck
> > or so), and so I thought it should be better put in the all in one
> > path. But I suspect you won't like that conditional in the big
> > x86 fault path.
> > 
> > 
> >  arch/x86/mm/fault.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 4c4508e..80c997e 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -955,6 +955,8 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  	int write;
> >  	int fault;
> >  
> > +	BUG_ON(in_nmi());
> 
> Alternative idea: we could put the test at the beginning of the NMI handler, so
> if a NMI handler nests over a processor already "in_nmi", then we bug. I agree
> that this will trigger less easily than bugging in the fault handler (because we
> need to hit the actual nmi-coming-in-because-iret-reenabled-them-too-early
> scenario, but it's far less intrusive.
> 
> Thoughts ?


In fact we have that already in nmi_enter(). Now as you said that alone is probably
too light to find the reason of a nested NMI or to prevent it.

