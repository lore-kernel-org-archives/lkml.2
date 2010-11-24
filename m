Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0KXUc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:32:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0KXUc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:32:57 -0500
Message-ID: <4CED7642.8070600@redhat.com>
Date: Wed, 24 Nov 2010 21:32:02 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "All since 2.6.33.x" <stable@kernel.org>
Subject: Re: [PATCH 1/2] x86: Ignore trap bits on single step exceptions
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com> <1289684273-26770-2-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1289684273-26770-2-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frederic,

On 11/13/2010 10:37 PM, Frederic Weisbecker wrote:
> When a single step exception fires, the trap bits, used to
> signal hardware breakpoints, are in a random state.
>
> These trap bits might be set if another exception will follow,
> like a breakpoint in the next instruction, or a watchpoint in the
> previous one. Or there can be any junk there.
>
> So if we handle these trap bits during the single step exception,
> we are going to handle an exception twice, or we are going to
> handle junk.
>
> Just ignore them in this case.
>
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=21332
sorry for the delay in testing this.

I have cherry-picked this patch on top of v2.6.37-rc3-102-gea49b16 and 
the ntdll/exception tests pass now.

Many thanks
bye
	michael

>
> Reported-by: Michael Stefaniuc<mstefani@redhat.com>
> Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Rafael J. Wysocki<rjw@sisk.pl>
> Cc: Maciej Rutecki<maciej.rutecki@gmail.com>
> Cc: Alexandre Julliard<julliard@winehq.org>
> Cc: Jason Wessel<jason.wessel@windriver.com>
> Cc: All since 2.6.33.x<stable@kernel.org>
> ---
>   arch/x86/kernel/hw_breakpoint.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index ff15c9d..42c5942 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -433,6 +433,10 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>   	dr6_p = (unsigned long *)ERR_PTR(args->err);
>   	dr6 = *dr6_p;
>
> +	/* If it's a single step, TRAP bits are random */
> +	if (dr6&  DR_STEP)
> +		return NOTIFY_DONE;
> +
>   	/* Do an early return if no trap bits are set in DR6 */
>   	if ((dr6&  DR_TRAP_BITS) == 0)
>   		return NOTIFY_DONE;


-- 
Michael Stefaniuc                           Tel.: +49-711-96437-199
Consulting Communications Engineer          Fax.: +49-711-96437-111
--------------------------------------------------------------------
Reg. Adresse: Red Hat GmbH, Otto-Hahn-Strasse 20, 85609 Dornach
Handelsregister: Amtsgericht Muenchen HRB 153243
Geschäftsführer: Brendan Lane, Charlie Peters, Michael Cunningham,
                  Charles Cachera
