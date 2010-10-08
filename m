Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab0JHRJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:09:44 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:36308 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab0JHRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:09:43 -0400
Date: Fri, 8 Oct 2010 18:09:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>, linux-mips@linux-mips.org
Subject: Re: [PATCH 2/4] HWPOISON: Copy si_addr_lsb to user
Message-ID: <20101008170941.GA3025@linux-mips.org>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286398141-13749-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 10:48:59PM +0200, Andi Kleen wrote:

> The original hwpoison code added a new siginfo field si_addr_lsb to
> pass the granuality of the fault address to user space. Unfortunately
> this field was never copied to user space. Fix this here.
> 
> I added explicit checks for the MCEERR codes to avoid having
> to patch all potential callers to initialize the field.

That doesn't fly, see below.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2215,6 +2215,14 @@ int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
>  #ifdef __ARCH_SI_TRAPNO
>  		err |= __put_user(from->si_trapno, &to->si_trapno);
>  #endif
> +#ifdef BUS_MCEERR_AO
> +		/* 
> +		 * Other callers might not initialize the si_lsb field,
> +	 	 * so check explicitely for the right codes here.
> +		 */
> +		if (from->si_code == BUS_MCEERR_AR || from->si_code == BUS_MCEERR_AO)
> +			err |= __put_user(from->si_addr_lsb, &to->si_addr_lsb);
> +#endif

include/asm-generic/siginfo.h defines BUS_MCEERR_AR unconditionally and is
getting include in all <asm/siginfo.h> so that #ifdef condition is always
true.  struct siginfo.si_addr_lsb is defined only for the generic struct
siginfo.  The architectures that define HAVE_ARCH_SIGINFO_T (MIPS and
IA-64) do not define this field so the build breaks.

  Ralf
