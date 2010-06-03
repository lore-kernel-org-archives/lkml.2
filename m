Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0FCUHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:07:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:46267 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755239Ab0FCUHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:07:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,356,1272870000"; 
   d="scan'208";a="573104763"
Message-ID: <4C080850.1090907@linux.intel.com>
Date: Thu, 03 Jun 2010 12:53:52 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make save_stack_address() !CONFIG_FRAME_POINTER
 friendly
References: <20100603193239.GA31530@redhat.com>
In-Reply-To: <20100603193239.GA31530@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2010 12:32 PM, Oleg Nesterov wrote:
> If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
> non-reliable addresses on stack, this is all we have if dump_trace(bp)
> is called with the wrong or zero bp.
>
> For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.
>
> This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
> it reverts 1650743c "x86: don't save unreliable stack trace entries".
>    

would be nice if there was a compile time thing to detect if frame 
pointers are on ratehr than an ifdef.

you're now also changing the rules; until now, you would ALWAYS get a 
backtrace without noise....
now that's changing quite a bit. How are various tools (like perf and 
sysprof) going to cope with that?

> Also, remove the unnecessary type-cast.
>
> Signed-off-by: Oleg Nesterov<oleg@redhat.com>
> ---
>
>   arch/x86/kernel/stacktrace.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> --- 34-rc1/arch/x86/kernel/stacktrace.c~SAVE_STACK_WO_FP	2010-06-03 18:43:27.000000000 +0200
> +++ 34-rc1/arch/x86/kernel/stacktrace.c	2010-06-03 21:29:52.000000000 +0200
> @@ -26,8 +26,10 @@ static int save_stack_stack(void *data,
>   static void save_stack_address(void *data, unsigned long addr, int reliable)
>   {
>   	struct stack_trace *trace = data;
> +#ifdef CONFIG_FRAME_POINTER
>   	if (!reliable)
>   		return;
> +#endif
>   	if (trace->skip>  0) {
>   		trace->skip--;
>   		return;
> @@ -39,9 +41,11 @@ static void save_stack_address(void *dat
>   static void
>   save_stack_address_nosched(void *data, unsigned long addr, int reliable)
>   {
> -	struct stack_trace *trace = (struct stack_trace *)data;
> +	struct stack_trace *trace = data;
> +#ifdef CONFIG_FRAME_POINTER
>   	if (!reliable)
>   		return;
> +#endif
>   	if (in_sched_functions(addr))
>   		return;
>   	if (trace->skip>  0) {
>
>    

