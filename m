Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1BVDW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:22:26 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47772 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1BVDWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:22:25 -0500
X-AuditID: b753bd60-a50bbba000004916-39-4d632beeaee8
X-AuditID: b753bd60-a50bbba000004916-39-4d632beeaee8
Message-ID: <4D632BE9.6090108@hitachi.com>
Date: Tue, 22 Feb 2011 12:22:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, acme@redhat.com, fweisbec@gmail.com, hpa@zytor.com,
        ananth@in.ibm.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, a.p.zijlstra@chello.nl, eric.dumazet@gmail.com,
        2nddept-manager@sdl.hitachi.co.jp,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH 2/2] kprobes: disabling optimized kprobes for entry text
 section
References: <20110220125948.GC25700@elte.hu> <1298298313-5980-1-git-send-email-jolsa@redhat.com> <1298298313-5980-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1298298313-5980-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/21 23:25), Jiri Olsa wrote:
> You can crash the kernel using kprobe tracer by running:
> 
> echo "p system_call_after_swapgs" > ./kprobe_events
> echo 1 > ./events/kprobes/enable
> 
> The reason is that at the system_call_after_swapgs label, the kernel
> stack is not set up. If optimized kprobes are enabled, the user space
> stack is being used in this case (see optimized kprobe template) and
> this might result in a crash.
> 
> There are several places like this over the entry code (entry_$BIT).
> As it seems there's no any reasonable/maintainable way to disable only
> those places where the stack is not ready, I switched off the whole
> entry code from kprobe optimizing.

Thank you very much!

> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  arch/x86/kernel/kprobes.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index d91c477..d03bc1e 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1276,6 +1276,14 @@ static int __kprobes can_optimize(unsigned long paddr)
>  	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
>  		return 0;
>  
> +	/*
> +	 * Do not optimize in the entry code due to the unstable
> +	 * stack handling.
> +	 */
> +	if ((paddr >= (unsigned long ) __entry_text_start) &&
> +	    (paddr <  (unsigned long ) __entry_text_end))
> +		return 0;
> +
>  	/* Check there is enough space for a relative jump. */
>  	if (size - offset < RELATIVEJUMP_SIZE)
>  		return 0;


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
