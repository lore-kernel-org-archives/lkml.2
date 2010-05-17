Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0EQOTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:19:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:48209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0EQOTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:19:40 -0400
Date: Mon, 17 May 2010 11:19:10 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix bug mismatch with -c option definition
Message-ID: <20100517141910.GA14367@ghostprotocols.net>
References: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 17, 2010 at 12:04:01PM +0200, Stephane Eranian escreveu:
>   The -c option defines the user requested sampling period. It was implemented
>   using an unsigned int variable but the type of the option was OPT_LONG. Thus,
>   the option parser was overwriting memory belonging to other variables, namely
>   the mmap_pages leading to a zero page sampling buffer. The bug was exposed
>   only when compiling at -O0, probably because the compiler was padding
>   variables at higher optimization levels.

Well spotted!
 
>   This patch fixes this problem by declaring user_interval as u64. This also
>   avoids wrap-around issues for large period on 32-bit systems.
>  
>   Signed-off-by: Stephane Eranian <eranian@google.com>
> --
>  tools/perf/builtin-record.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 0f467cf..78f64cc 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -33,8 +33,8 @@ enum write_mode_t {
>  
>  static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
>  
> -static unsigned int		user_interval 			= UINT_MAX;
> -static long			default_interval		=      0;
> +static u64			user_interval			= ULLONG_MAX;
> +static u64			default_interval		=      0;

The parsing code uses this for OPT_LONG:

        case OPTION_LONG:
                if (unset) {
                        *(long *)opt->value = 0;
                        return 0;
                }
                if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
                        *(long *)opt->value = opt->defval;
                        return 0;
                }
                if (get_arg(p, opt, flags, &arg))
                        return -1;
                *(long *)opt->value = strtol(arg, (char **)&s, 10);

So I think we should augment the parsing code to have OPTION_ULONG, and,
for handling u64, OPTION_ULLONG.

I'll add that and then modify your patch to use it.

- Arnaldo
