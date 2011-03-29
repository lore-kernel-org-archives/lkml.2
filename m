Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1C2GY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:24:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57013 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab1C2GY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:24:28 -0400
Date: Tue, 29 Mar 2011 08:24:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/6] x86-64: Omit frame pointers on vread_tsc
Message-ID: <20110329062413.GD27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu>
 <d9d16ed0f0ac93ab3a9cdb6aac92538d6327d66c.1301324270.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d16ed0f0ac93ab3a9cdb6aac92538d6327d66c.1301324270.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Andy Lutomirski <luto@MIT.EDU> wrote:

> vread_tsc is short and hot, and it's userspace code so the usual
> reasons to keep frame pointers around don't apply.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
> 
> It might be nicer to move vread_tsc into a separate file and change
> the options directly.
> 
>  arch/x86/kernel/tsc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a159fba..1aea4a6 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -764,6 +764,8 @@ static cycle_t read_tsc(struct clocksource *cs)
>  }
>  
>  #ifdef CONFIG_X86_64
> +#pragma GCC push_options
> +#pragma GCC optimize ("omit-frame-pointer")
>  static cycle_t __vsyscall_fn vread_tsc(void)
>  {
>  	cycle_t ret;
> @@ -807,6 +809,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
>  	asm volatile ("");
>  	return last;
>  }
> +#pragma GCC pop_options
>  #endif

The cleaner option would be to put the __vsyscall functions into a new .c file 
and build it with framepointers off in the Makefile, which can be done via:

CFLAGS_vtsc.o := -fno-omit-frame-pointer

or so.

We could also consider putting this function into a .S too. Not sure it works 
out in a maintainable fashion though.

Thanks,

	Ingo
