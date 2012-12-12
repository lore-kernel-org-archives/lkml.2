Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2LLVKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:10:07 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2LLVKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:10:04 -0500
Date: Wed, 12 Dec 2012 22:09:59 +0100
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
Message-ID: <20121212210959.GH8760@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 10:19:05AM -0800, Joe Perches wrote:
> Use the new vsprintf extension to avoid any possible
> message interleaving.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   13 +++++++------
>  arch/x86/kernel/dumpstack.c      |    5 ++---
>  arch/x86/kernel/process_32.c     |    2 +-
>  arch/x86/mm/mmio-mod.c           |    4 ++--
>  arch/x86/um/sysrq_32.c           |    9 +++------
>  5 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 80dbda8..996f98a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -242,13 +242,14 @@ static void print_mce(struct mce *m)
>  	       m->extcpu, m->mcgstatus, m->bank, m->status);
>  
>  	if (m->ip) {
> -		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
> -			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> -				m->cs, m->ip);
> -
>  		if (m->cs == __KERNEL_CS)
> -			print_symbol("{%s}", m->ip);
> -		pr_cont("\n");
> +			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> {%pSR}\n",
> +				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> +				 m->cs, m->ip, (void *)m->ip);
> +		else
> +			pr_emerg(HW_ERR "RIP%s %02x:<%016Lx>\n",
> +				 !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
> +				 m->cs, m->ip);
>  	}

I think I'd go ahead and ACK this unless Tony has some comments. I'm not
happy about the two pr_emerg calls based on the conditional.

Or, Tony, what do you think, could we get away if we printed empty
string for when m->cs != __KERNEL_CS? I'm thinking of not breaking any
userspace which is parsing that output and seeing "... {}" in that case.

This assumes that vsprintf can print (void *)0 when passed as an
argument through %pSR. Joe?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
