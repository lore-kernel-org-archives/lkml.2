Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2LLVtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:49:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34673 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2LLVtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:49:02 -0500
Date: Wed, 12 Dec 2012 22:48:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Subject: Re: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Message-ID: <20121212214858.GI8760@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>,
	Tony Luck <tony.luck@intel.com>, Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net,
	user-mode-linux-user@lists.sourceforge.net
References: <cover.1355335227.git.joe@perches.com>
 <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
 <20121212210959.GH8760@liondog.tnic>
 <1355347803.8538.16.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355347803.8538.16.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:30:03PM -0800, Joe Perches wrote:
> > I think I'd go ahead and ACK this unless Tony has some comments. I'm
> > not happy about the two pr_emerg calls based on the conditional.
>
> It was done to avoid interleaving.

Right.

> > Or, Tony, what do you think, could we get away if we printed empty
> > string for when m->cs != __KERNEL_CS? I'm thinking of not breaking any
> > userspace which is parsing that output and seeing "... {}" in that case.
> > 
> > This assumes that vsprintf can print (void *)0 when passed as an
> > argument through %pSR. Joe?
> 
> Definitely yes when not #defined CONFIG_KALLSYMS
> 
> I believe no object exists at address 0 for all
> arches so I believe yes for CONFIG_KALLSYMS too,

Ok, here's what I'm thinking more specifically. Have single call like this:

	pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> {%pSR}\n",
			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
			m->cs, m->ip,
			(m->cs == __KERNEL_CS) ? (void *)m->ip : (void *)0);

and when vsprintf gets to it, it recognizes the special case of
(void *)0 and dumps the empty string "" for that argument.

Hmm.

> My preference is to eventually do away with all the
> 	"[%0(size)lx] %pSR", addr, (void *)addr
> uses and create another %pSx that emits the pointer
> address and the function/offset in one go in a
> standardized style without caring about the pointer
> size.
> 
> Something like:
> 
> 	"%pSp", (void *)addr
> 
> would emit
> 
> 	[<7def0123>] function_name+offset/size

Right, this is another way of looking it. And in order to make it more
robust, it should be able to handle the (void *)0 case so that callers
don't have to check the arg.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
