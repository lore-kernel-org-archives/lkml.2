Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2LLVaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:30:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59317 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754815Ab2LLVaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:30:05 -0500
Message-ID: <1355347803.8538.16.camel@joe-AO722>
Subject: Re: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Date: Wed, 12 Dec 2012 13:30:03 -0800
In-Reply-To: <20121212210959.GH8760@liondog.tnic>
References: <cover.1355335227.git.joe@perches.com>
	 <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
	 <20121212210959.GH8760@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 22:09 +0100, Borislav Petkov wrote:
> On Wed, Dec 12, 2012 at 10:19:05AM -0800, Joe Perches wrote:
> > Use the new vsprintf extension to avoid any possible
> > message interleaving.
[]
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
[]
> > @@ -242,13 +242,14 @@ static void print_mce(struct mce *m)
> >  	       m->extcpu, m->mcgstatus, m->bank, m->status);
> >  
> >  	if (m->ip) {
> > -		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
> > -			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> > -				m->cs, m->ip);
> > -
> >  		if (m->cs == __KERNEL_CS)
> > -			print_symbol("{%s}", m->ip);
> > -		pr_cont("\n");
> > +			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> {%pSR}\n",
> > +				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> > +				 m->cs, m->ip, (void *)m->ip);
> > +		else
> > +			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx>\n",
> > +				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> > +				 m->cs, m->ip);
> >  	}
> 
> I think I'd go ahead and ACK this unless Tony has some comments. I'm not
> happy about the two pr_emerg calls based on the conditional.

It was done to avoid interleaving.

> Or, Tony, what do you think, could we get away if we printed empty
> string for when m->cs != __KERNEL_CS? I'm thinking of not breaking any
> userspace which is parsing that output and seeing "... {}" in that case.
> 
> This assumes that vsprintf can print (void *)0 when passed as an
> argument through %pSR. Joe?

Definitely yes when not #defined CONFIG_KALLSYMS

I believe no object exists at address 0 for all
arches so I believe yes for CONFIG_KALLSYMS too,

My preference is to eventually do away with all the
	"[%0(size)lx] %pSR", addr, (void *)addr
uses and create another %pSx that emits the pointer
address and the function/offset in one go in a
standardized style without caring about the pointer
size.

Something like:

	"%pSp", (void *)addr

would emit

	[<7def0123>] function_name+offset/size


