Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2BGOkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:40:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2BGOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:40:41 -0500
Date: Tue, 7 Feb 2012 12:40:33 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Anton Blanchard <anton@samba.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
Message-ID: <20120207144033.GB2172@infradead.org>
References: <20120207145535.71b9f22d@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207145535.71b9f22d@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 02:55:35PM +1100, Anton Blanchard escreveu:
> 
> A perf annotate of a kernel function written in assembly shows
> very strange percentages:

Thanks! I think this is the same problem Mike Galbraith noticed and
reported me (I guess that was in a private message), Mike, can you
please test it so that I can add more Foo-by stamps to this one?

- Arnaldo
 
>          :      _GLOBAL(__copy_tofrom_user_base)
> 
> ...
> 
>          :              addi    r3,r3,1
>    99.67 :      c00000000004d78c:       addi    r3,r3,1
>          :
>     0.00 :      1:      bf      cr7*4+2,2f
>     0.07 :      c00000000004d790:       bne-    cr7,c00000000004d7a4
>          :      err1;   lhz     r0,0(r4)
>     0.00 :      c00000000004d794:       lhz     r0,0(r4)
>          :              addi    r4,r4,2
>     0.00 :      c00000000004d798:       addi    r4,r4,2
>          :      err1;   sth     r0,0(r3)
>     0.00 :      c00000000004d79c:       sth     r0,0(r3)
>          :              addi    r3,r3,2
>    99.60 :      c00000000004d7a0:       addi    r3,r3,2
>          :
>     0.00 :      2:      bf      cr7*4+1,3f
>     0.12 :      c00000000004d7a4:       ble-    cr7,c00000000004d7b8
>          :      err1;   lwz     r0,0(r4)
>     0.00 :      c00000000004d7a8:       lwz     r0,0(r4)
>          :              addi    r4,r4,4
>     0.00 :      c00000000004d7ac:       addi    r4,r4,4
>          :      err1;   stw     r0,0(r3)
>     0.00 :      c00000000004d7b0:       stw     r0,0(r3)
>          :              addi    r3,r3,4
>    99.48 :      c00000000004d7b4:       addi    r3,r3,4
> 
> ~300% in one function. Urgh.
> 
> This is caused by the way we parse objdump -S output, eg:
> 
>         addi    r3,r3,1
> c00000000004d78c:       addi    r3,r3,1
> 
> 1:      bf      cr7*4+2,2f
> c00000000004d790:       bne-    cr7,c00000000004d7a4 
> 
> We assume the asm label (1:) is an address, compute a bogus offset
> into the function and then screw up the matching of samples to lines.
> I notice this also fails with c inline assembly in a similar
> manner.
> 
> We already have a sanity check that the address is not beyond the end
> of the function, so add a check against the start too.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> Cc: <stable@kernel.org>
> 
> Index: linux-tip/tools/perf/util/annotate.c
> ===================================================================
> --- linux-tip.orig/tools/perf/util/annotate.c	2012-01-09 17:45:09.056373433 +1100
> +++ linux-tip/tools/perf/util/annotate.c	2012-02-07 13:53:01.610970209 +1100
> @@ -244,7 +244,7 @@ static int symbol__parse_objdump_line(st
>  		    end = map__rip_2objdump(map, sym->end);
>  
>  		offset = line_ip - start;
> -		if (offset < 0 || (u64)line_ip > end)
> +		if (offset < 0 || (u64)line_ip < start || (u64)line_ip > end)
>  			offset = -1;
>  	}
>  
