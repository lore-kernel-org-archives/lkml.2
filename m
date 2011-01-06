Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1AFPpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:45:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35374 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1AFPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HtPx9R4v63VZQDYZOOvg6EJe4NKH0jPVFVRyadTT50rj/A/ARKIatyp0AxmMk2RUem
         TGzJwBUFqlWmh0XXNeJUf2HRRmCB81sHCe6Wb5r2SHhiAmuAXb1s6UrTXfDP9uSTqjfV
         iKO+fwAvo8aQNoesLesdTxvQmUhJVsDh4x+Gw=
Date: Thu, 6 Jan 2011 16:45:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: "H. Peter Anvin" <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110106154536.GA2308@nowhere>
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
 <1294325513-14276-2-git-send-email-fweisbec@gmail.com>
 <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D25EB4B020000780002ABF7@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:18:19PM +0000, Jan Beulich wrote:
> >>> On 06.01.11 at 15:51, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > From the x86_64 low level interrupt handlers, the frame pointer is
> > saved in pt_regs in the wrong place, in the offset of rbx.
> > 
> > rbx is not part of the irq partial saved registers, so it's not
> > critical, but later code that uses get_irq_regs() to get the
> > interrupted frame pointer instead get a stale rbx value, causing
> > unwinding code to fail miserably.
> 
> Code using get_irq_regs() can't rely on the not explicitly
> saved registers' fields of pt_regs anyway; you now fix this
> for %rbp, but someone else might look at a different
> register and want that to be saved too. You just shouldn't,
> and the fact that %rbp happens to be saved at all shouldn't
> be taken to mean you can access it via the provided
> pt_regs pointer. This saving of %rbp could go away or be
> done in a different way at any point.

Right. That was something I was wondering about: is rbp saved here
as the beginning of the proc stack, or was is supposed to be
part of the pt_regs although mistakenly recorded in rbp?

So given what you are explaining me, it rather seem it wasn't supposed
to be of part pt_regs and it's there because it begins the frame of the irq
handler.

I agree that in the case of common irqs, rbp is not supposed to be part
of saved regs. I think may be we can change that semantic though as it
requires very few changes. In fact the only added overhead is that addq
below.

I'm waiting for opinions though.

 
> > @@ -808,6 +813,8 @@ ret_from_intr:
> >  	TRACE_IRQS_OFF
> >  	decl PER_CPU_VAR(irq_count)
> >  	leaveq
> > +	/* we did not save rbx, restore only from ARGOFFSET */
> > +	addq $8, %rsp
> >  	CFI_RESTORE		rbp
> >  	CFI_DEF_CFA_REGISTER	rsp
> >  	CFI_ADJUST_CFA_OFFSET	-8
> 
> *If* the patch was to be taken anyway, I would strongly suggest
> getting this mis-insertion fixed first: CFI annotations belong to the
> immediately preceding instruction, and hence you must not insert
> new instructions between an existing one and its annotation.

Good to know, will fix.

> Furthermore, an adjustment to %rsp (when it serves as the frame
> pointer as is the case here, though would be better visible if the
> added instruction was at the right place) needs to be annotated
> itself.


Hmm, I'm not familiar with those CFI adjustments.
Before we had:


	leaveq

	CFI_RESTORE             rbp
	CFI_DEF_CFA_REGISTER    rsp
	CFI_ADJUST_CFA_OFFSET   -8

So CFI_RESTORE means rbp has now the value of the base frame of
the calling frame (the base frame pointer of the interrupted proc) ?

And what follows means that rsp-8 points to the return address?
But it doesn't seem to be the case, the return address here beeing
rip stored in pt_regs...

I'm confused.
