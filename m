Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0I1OC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:02:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0I1OCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P/Ju+79J/d5FMhNE8zc636HNpE9eI70XoxH1oEtk+hyM4VPotaAzIK5GDI+ncTYCuL
         iD1yiCFivKT3soHprRlM23ushKhwHmZubQoEFmns6clDeUt6+/mvkwp1R1Fdh3D81iaf
         tLi8+SHrEdsLuBvapFo5UsWHbCsamOoTOH2Vw=
Date: Tue, 28 Sep 2010 16:02:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] x86: Barf when faults happen in NMI
Message-ID: <20100928140158.GA5449@nowhere>
References: <1285615833-5324-1-git-send-regression-fweisbec@gmail.com> <20100928103618.GB8514@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928103618.GB8514@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:36:18PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > In x86, faults exit by executing the iret instruction, which then 
> > reenables NMIs if we faulted in NMI context. Then if a fault happens 
> > in NMI, another NMI can nest after the fault exits.
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
> > I first thought about putting it in the vmalloc fault path only. But 
> > then I saw more occasions for the kernel to fault (kmemcheck or so), 
> > and so I thought it should be better put in the all in one path. But I 
> > suspect you won't like that conditional in the big x86 fault path.
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
> > +
> 
> Hm, this is a fastpath, so it would be nice to put this into the vmalloc 
> and kmemcheck paths (even though it's less clean that way).
> 
> Also, a WARN_ON_ONCE() would probably help more in getting bug reports 
> out of such systems, than a BUG_ON() crashed kernel.
> 
> Thanks,
> 
> 	Ingo


Ok, will resend then.

Thanks.

