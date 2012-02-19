Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2BSM4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 07:56:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51230 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2BSM4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 07:56:10 -0500
Date: Sun, 19 Feb 2012 13:56:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
Message-ID: <20120219125601.GD25900@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329617173.1561.5.camel@acer.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I found that it is possible for userspace to prevent an NMI 
> from triggering while it is running by setting its stack 
> pointer to that of the NMI stack. This tricks the NMI nested 
> algorithm in thinking that the NMI is nested. The easy 
> solution to this is to test the %rip to make sure that the NMI 
> happened in kernel mode before testing for nesting.

Ouch...

> I've tested a program that exhibits the missing NMIs and this 
> patch corrects that behavior.

Does it need a -stable tag?

> Please pull the latest tip/perf/urgent tree, which can be 
> found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: b80ddc7b1636474297815d47fbfed7552f9b8f2c
> 
> 
> Steven Rostedt (1):
>       x86: Test saved %rip in NMI to determine nested NMI
> 
> ----
>  arch/x86/kernel/entry_64.S |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> ---------------------------
> commit b80ddc7b1636474297815d47fbfed7552f9b8f2c
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Sat Feb 18 20:26:52 2012 -0500
> 
>     x86: Test saved %rip in NMI to determine nested NMI
>     
>     Currently, the NMI handler tests if it is nested by checking the
>     special variable saved no the stack (set during NMI handling) and
>     whether the saved stack is the NMI stack as well (to prevent the race
>     when the variable is set to zero). But userspace may set their %rsp
>     to any value as long as the do not derefence it, and it may make it
>     point to the NMI stack, which will prevent NMIs from triggering while
>     the userspace app is running. (I tested this, and it is indeed the case)
>     
>     Add another check to determine nested NMIs by looking at the saved
>     %rip and making sure that it is a kernel pointer (negative).
>     
>     Cc: H. Peter Anvin <hpa@zytor.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 3fe8239..7c35a7a 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1532,6 +1532,14 @@ ENTRY(nmi)
>  	pushq_cfi %rdx
>  
>  	/*
> +	 * If the RIP is not negative then we are in userspace where this is not
> +	 * a nested NMI. 
> +	 */
> +	movq 8(%rsp), %rdx
> +	testq %rdx, %rdx
> +	jns first_nmi

Does this do the right thing for the vDSO as well? It is in 
negative addresses:

ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]

Thanks,

	Ingo
