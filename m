Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2B0Mpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:45:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48271 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2B0Mpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:45:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of namhyung@gmail.com designates 10.68.197.163 as permitted sender) smtp.mail=namhyung@gmail.com; dkim=pass header.i=namhyung@gmail.com
Subject: Re: [PATCH] hw breakpoint: Fix possible memory leak
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1330340694.11248.64.camel@twins>
References: <1330311739-24302-1-git-send-email-namhyung.kim@lge.com>
	 <1330338785.11248.49.camel@twins> <20120227104452.GA6082@elte.hu>
	 <1330340694.11248.64.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 21:45:42 +0900
Message-ID: <1330346742.1782.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-27 (Mon), 12:04 +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-27 at 11:44 +0100, Ingo Molnar wrote:
> > I edited that code earlier today - is the form below OK, or can 
> > you see a simpler method? It's not yet pushed out so can still 
> > edit it. 
> 
> I think something like the below should do, but then I didn't really
> think much about it, my thoughts went like:
> 
> ... *shees* that's ugly
>   ... that error path already does a loop
>     ... what the problem is!? -- reread changelog
>       ... err_cpu == cpu is placed wrong!
> 
> 
> So I replied and marked read.. waiting to either hear if there's a good
> reason to do ugly or find a new (tested) patch in my inbox.. :-)
> 
> ---
>  kernel/events/hw_breakpoint.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index b0309f7..3330022 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -658,10 +658,10 @@ int __init init_hw_breakpoint(void)
>  
>   err_alloc:
>  	for_each_possible_cpu(err_cpu) {
> -		if (err_cpu == cpu)
> -			break;
>  		for (i = 0; i < TYPE_MAX; i++)
>  			kfree(per_cpu(nr_task_bp_pinned[i], cpu));
> +		if (err_cpu == cpu)
> +			break;
>  	}
>  
>  	return -ENOMEM;
> 

This would depend on the initial value of the percpu memory, and thus
have no problem in this case. It looks better to me, too :)


-- 
Regards,
Namhyung Kim


