Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1AMLDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:03:07 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57617 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab1AMLDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:03:06 -0500
X-AuditID: b753bd60-9db5dba000000f65-c7-4d2edbe6b47b
Message-ID: <4D2EDBE4.3060608@hitachi.com>
Date: Thu, 13 Jan 2011 20:03:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        lkml <linux-kernel@vger.kernel.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: make "perf-probe -L <function>" display the
 absolute path and absolute line number
References: <m38vyp85qv.fsf@gmail.com>
In-Reply-To: <m38vyp85qv.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/13 19:20), Franck Bui-Huu wrote:
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> It should be more usefull to get the full location of the function
> (absolute line number + full path) instead of repeating the name of
> the function and the start line number given by the command line.
> 
> So we had before:
> 
>    $ perf probe -L schedule | head -n3
>    <schedule:0>
>          0  asmlinkage void __sched schedule(void)
>          1  {
> 
> and now we get:
> 
>    $ perf probe -L schedule | head -n3
>    </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
>          0  asmlinkage void __sched schedule(void)
>          1  {

Indeed, it could be useful for users to see where the function is...

However, I think that should be optional, because the output lines
have the relative line numbers from the function, and those numbers
are important for users who want to probe a specific line by using
function relative line numbers. e.g. "schedule:10"

And with that option, I'd suggest to show absolute line numbers on each line.

  $ perf probe -L schedule:0-1 --by-source
  </usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:3813>
     3813  asmlinkage void __sched schedule(void)
     3814  {

Or, just show source file as an additional information.

  $ perf probe -L schedule:0-1
  <schedule@/usr/src/debug/kernel-2.6.35.fc14/linux-2.6.35.x86_64/kernel/sched.c:0>
        0  asmlinkage void __sched schedule(void)
        1  {

I just would like to keep the consistency of the output/input format.
In above cases, users can define a new event just by replacing the last
number with the line number which they see.

Thank you,

> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> ---
>  tools/perf/util/probe-event.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index fcbb543..bd09b87 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -382,11 +382,7 @@ int show_line_range(struct line_range *lr, const char *module)
>  
>  	setup_pager();
>  
> -	if (lr->function)
> -		fprintf(stdout, "<%s:%d>\n", lr->function,
> -			lr->start - lr->offset);
> -	else
> -		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
> +	fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
>  
>  	fp = fopen(lr->path, "r");
>  	if (fp == NULL) {


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
