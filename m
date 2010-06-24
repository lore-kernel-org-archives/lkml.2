Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0FXPj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:39:56 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54706 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab0FXPjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:39:54 -0400
Date: Thu, 24 Jun 2010 17:41:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mauro@elte.hu" <mauro@elte.hu>
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624154124.GA6647@aftab>
References: <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
 <20100624132032.GA4474@kryptos.osrc.amd.com>
 <20100624133323.GN578@basil.fritz.box>
 <20100624134609.GB30323@elte.hu>
 <20100624140143.GO578@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624140143.GO578@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Thu, Jun 24, 2010 at 10:01:43AM -0400

> > Please, as Peter and Boris asked you already, quote a concrete, specific 
> > example:
> 
> It was already in my answer to Peter.
> 
> > 
> >   'Specific event X occurs, kernel wants/needs to do Y. This cannot be done
> >    via the suggested method due to Z.'
> > 
> > Your generic arguments look wrong (to the extent they are specified) and it 
> > makes it much easier and faster to address your points if you dont blur them 
> > by vagaries.
> 
> It's one of the fundamental properties of recoverable errors.
> 
> Error happens.
> Machine check or NMI or other exception happens. 
> 	That exception runs on the exception stack
> 	The error is not fatal, but recoverable.
> For example you want to kill a process or call hwpoison or do some other
> 	recovery action. These generally have to sleep to do anything
> 	interesting.
> You cannot do the sleeping on the exception stack, so you push it to
> another context.
> 
> Now just because an error is recoverable doesn't mean it's not critical
> (I think that was the mistake Boris made).

It wasn't a mistake - I was simply trying to lure you into giving a more
concrete example so that we all land on the same page and we know what
the heck you/we/all are talking about.

> If you don't do something
> (like killing or recovery) you could end up in a loop or consume
> corrupted data or something else bad. 
> 
> So the error has to have a fail safe path from detection to handling.

So we are talking about a more involved and "could-sleep" error
recovery.

> That's quite different from logging or performance counting etc.
> where dropping events on overload is normal and expected.

So I went back and reread the whole thread, and correct me if I'm
wrong but the whole run softirq after NMI has one use case for now -
"could-sleep" error handling for MCEs _only_ on x86. So you're changing
a bunch of generic and x86 kernel code just for error handling. Hmm,
that's a kinda big hammer in my book.

A slimmer solution is a much better way to go, IMHO. I think Peter said
something about irq_exit(), which should be just fine.

But AFAICT an arch-specific solution would be even better, e.g.
if you call into your deferred work helper from paranoid_exit in
<arch/x86/kernel/entry_64.S>. I.e, something like

#ifdef CONFIG_X86_MCE
testl $_TIF_NEED_POST_NMI,%ebx
jnz do_post_nmi_work
#endif

Or even slimmer, rewrite the paranoidzeroentry to a MCE-specific variant
which does the added functionality. But that wouldn't be extensible if
other entities want post-NMI work later.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
