Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1JTNAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:00:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44985 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1JTNAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:00:45 -0400
Date: Thu, 20 Oct 2011 11:00:41 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111020130041.GB1772@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net>
 <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4B50.1060207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F4B50.1060207@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 04:12:32PM -0600, David Ahern escreveu:
> 
> 
> Getting another crash with the default sym sorting -- the addr is much
> less than the start of the sym so the offset goes negative:
> 
> (gdb) bt
> #0  0x0000000000429de3 in symbol__inc_addr_samples (sym=0x8f0f90,
> map=0x8aae00, evidx=0,
>     addr=329985) at util/annotate.c:73
> #1  0x000000000041b073 in record_precise_ip (he=0x8a2a10, counter=0,
> ip=329985)
>     at builtin-top.c:221
> #2  0x000000000041c821 in perf_event__process_sample (event=0x7fffefbc74c8,
>     sample=0x7fffffffe1b0, session=0x89a140) at builtin-top.c:801
> #3  0x000000000041c8d4 in perf_session__mmap_read_idx (self=0x89a140,
> idx=12)
>     at builtin-top.c:821
> #4  0x000000000041c95b in perf_session__mmap_read (self=0x89a140) at
> builtin-top.c:832
> #5  0x000000000041cdf1 in __cmd_top () at builtin-top.c:960
> #6  0x000000000041d585 in cmd_top (argc=0, argv=0x7fffffffe590, prefix=0x0)
>     at builtin-top.c:1252
> #7  0x00000000004077b9 in run_builtin (p=0x75fb68, argc=2,
> argv=0x7fffffffe590) at perf.c:286
> #8  0x00000000004079bb in handle_internal_command (argc=2,
> argv=0x7fffffffe590) at perf.c:358
> #9  0x0000000000407b07 in run_argv (argcp=0x7fffffffe47c,
> argv=0x7fffffffe470) at perf.c:402
> #10 0x0000000000407dee in main (argc=2, argv=0x7fffffffe590) at perf.c:512
> 
> 
> The following fixes the crash. If it seems reasonable I'll add to the
> other one:
> 
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index bc8f477..f1f20b5 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -63,6 +63,8 @@ int symbol__inc_addr_samples(struct symbol *sym,
> struct map *map,
>         return -ENOMEM;
> 
>     pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map,
> addr));
> +   if (addr < sym->start)
> +       return 0;

But this one seems like papering over some real problem, i.e. why would
we ask to bump an address that is _outside_ this symbol range? I.e.:

In record_precise_ip() this part must be wrong:

        ip = he->ms.map->map_ip(he->ms.map, ip);
        symbol__inc_addr_samples(sym, he->ms.map, counter, ip)

I.e. the map_ip for this method is messing up things, what symbol is
this? I.e. please provide:

p *sym
p *map

- Arnaldo
