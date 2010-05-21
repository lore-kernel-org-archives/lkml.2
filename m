Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0EUIQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:16:17 -0400
Received: from ozlabs.org ([203.10.76.45]:37338 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab0EUIQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:16:15 -0400
Date: Fri, 21 May 2010 18:15:21 +1000
From: Anton Blanchard <anton@samba.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/6] perf: Fix orphan callchain branches
Message-ID: <20100521081521.GA7402@kryten>
References: <1269274173-20328-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269274173-20328-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Callchains have markers inside their capture to tell we
> enter a context (kernel, user, ...).
> 
> Those are not displayed in the callchains but they are
> incidentally an active part of the radix tree where
> callchains are stored, just like any other address.
> 
> If we have the two following callchains:
> 
> addr1 -> addr2 -> user context -> addr3
> addr1 -> addr2 -> user context -> addr4
> addr1 -> addr2 -> addr 5
> 
> This is pretty common if addr1 and addr2 are part of an
> interrupt path, addr3 and addr4 are user addresses and
> addr5 is a kernel non interrupt path.
> 
> This will be stored as follows in the tree:
> 
>                    addr1
>                    addr2
>                    /   \
>                   /     addr5
>             user context
>                /    \
>              addr3  addr4
> 
> But we ignore the context markers in the report, hence
> the addr3 and addr4 will appear as orphan branches:
> 
>     |--28.30%-- hrtimer_interrupt
>     |          smp_apic_timer_interrupt
>     |          apic_timer_interrupt
>     |          |           <------------- here, no parent!
>     |          |          |
>     |          |          |--11.11%-- 0x7fae7bccb875
>     |          |          |
>     |          |          |--11.11%-- 0xffffffffff60013b
>     |          |          |
>     |          |          |--11.11%-- __pthread_mutex_lock_internal
>     |          |          |
>     |          |          |--11.11%-- __errno_location
> 
> Fix this by removing the context markers when we process the
> callchains to the tree.

I noticed some weird perf report output from a git pull today:

    38.61%      yes  libc-2.9.so         [.] fputs_unlocked
                |
                --- fputs_unlocked
                    fputs_unlocked
                   |          
                   |--94.43%-- 0x10001370
                   |          0xfff869ad33c
                   |          __libc_start_main
                   |          (nil)
                   |          
                    --5.57%-- 0xfff869ad33c
                              __libc_start_main
                              (nil)

                |
                --- _IO_file_xsputn
                    fputs_unlocked
                   |          
                   |--90.33%-- 0x10001370
                   |          0xfff869ad33c
                   |          __libc_start_main
                   |          (nil)
                   |          
                    --9.67%-- fputs_unlocked
                              0x10001370
                              0xfff869ad33c
                              __libc_start_main
                              (nil)

Notice how percentages are missing from fputs_unlocked and _IO_file_xsputn,
and there is no ascii art line joining them. If I backout this patch things
look better:

    38.61%      yes  libc-2.9.so         [.] fputs_unlocked
                |          
                |--42.92%-- fputs_unlocked
                |          fputs_unlocked
                |          |          
                |          |--94.43%-- 0x10001370
                |          |          0xfff869ad33c
                |          |          __libc_start_main
                |          |          (nil)
                |          |          
                |           --5.57%-- 0xfff869ad33c
                |                     __libc_start_main
                |                     (nil)
                |          
                |--28.94%-- _IO_file_xsputn
                |          fputs_unlocked
                |          |          
                |          |--90.33%-- 0x10001370
                |          |          0xfff869ad33c
                |          |          __libc_start_main
                |          |          (nil)
                |          |          
                |           --9.67%-- fputs_unlocked
                |                     0x10001370
                |                     0xfff869ad33c
                |                     __libc_start_main
                |                     (nil)


All of these backtraces are completely in userspace and so shouldn't have any
context markers. A check of a few raw backtraces confirms it:

0x70e860 [0x60]: PERF_RECORD_SAMPLE(IP, 2): 11799/11799: 0xfff86a161a0 period: 366
... chain: nr:7
.....  0: fffffffffffffe00
.....  1: 00000fff86a161d0
.....  2: 00000fff86a065d4
.....  3: 0000000010001370
.....  4: 00000fff869ad33c
.....  5: 00000fff869ad55c
.....  6: 0000000000000000

Anton
