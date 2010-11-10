Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab0KJRNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:13:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56262 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab0KJRNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:13:40 -0500
Message-ID: <4CDAD28A.1000303@oracle.com>
Date: Wed, 10 Nov 2010 09:12:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: randrianasulu@gmail.com, Lin Ming <lin@ming.vg>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.37-rc1 build failure
References: <201011030532.09986.randrianasulu@gmail.com>	 <AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>	 <201011040334.16833.randrianasulu@gmail.com>	 <20101103213439.01d2062d.randy.dunlap@oracle.com> <1289393974.2191.115.camel@laptop>
In-Reply-To: <1289393974.2191.115.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/10 04:59, Peter Zijlstra wrote:
> On Wed, 2010-11-03 at 21:34 -0700, Randy Dunlap wrote:
>> The build fails for me with the given .config file.
>> It's due to selects and depends, finally comes down to HAVE_PERF_EVENTS not being
>> enabled for M386 or M486.  Do you actually have a processor of that vintage?
> 
> FWIW this .config generates a _TON_ of Kconfig dep warnings..

Yeah, they are all MEDIA-related, known about, and someone is working
on the problem.

> Urgh, Kconfig hell.
> 
> config PERF_EVENTS
>         bool "Kernel performance events and counters"
>         default y if (PROFILING || PERF_COUNTERS)
>         depends on HAVE_PERF_EVENTS
>         select ANON_INODES
>         select IRQ_WORK
> 
> 
> # grep PERF_EVENTS borken-build/.config
> CONFIG_PERF_EVENTS=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> 
> 
> 
> So we managed to get PERF_EVENTS=y even though its dependency
> HAVE_PERF_EVENTS=n.
> 
> 
> I bet that's because of:
> 
> config X86
>         select HAVE_PERF_EVENTS if (!M386 && !M486)
>         select PERF_EVENTS 

Yep.

> 
> Ingo, should we simply do something like the below patch?
> 
> ---
> Subject: x86: Remove M[34]86 conditional on HAVE_PERF_EVENTS
> 
> x86 requires PERF_EVENTS because of the hardware breakpoint mess,
> so don't make it conditional on M[34]86.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e832768..e330da2 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -21,7 +21,7 @@ config X86
>  	select HAVE_UNSTABLE_SCHED_CLOCK
>  	select HAVE_IDE
>  	select HAVE_OPROFILE
> -	select HAVE_PERF_EVENTS if (!M386 && !M486)
> +	select HAVE_PERF_EVENTS
>  	select HAVE_IRQ_WORK
>  	select HAVE_IOREMAP_PROT
>  	select HAVE_KPROBES
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
