Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2DXTro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:47:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51892 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2DXTrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAAHN_R2vwv6ZzZLOhVb3XHcucUE+bF955FuAuxMJrr+QRasfCQ@mail.gmail.com>
References: <1335289853-2923-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<alpine.LSU.2.00.1204241148390.18455@eggly.anvils>
	<CAAHN_R2vwv6ZzZLOhVb3XHcucUE+bF955FuAuxMJrr+QRasfCQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 01:17:42 +0530
Message-ID: <CAAHN_R2-quCSKKR43BBcT2Hz+fXjWySayA72j_bdQGMDApfmpA@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in vma length when copying mmap on clone
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2012 01:10, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:
> That was supposed to be errno, not the pointer. I had added my own
> syscall wrappers to eliminate glibc and then reverted it to the
> original smaller-to-read reproducer and this got left behind in the
> process. The demo program is supposed to show "successed" for
> iterations 16383 to 16390 since the overflow happens at 16TB. All
> iterations before it (and after) show a fork failure.
>
> /proc/sys/vm/overcommit_memory is 0.
>
> Perhaps a cleaner demo program would have been:

Ugh, I missed some details once again. The demo below will show
"Unexpected success" without this patch in place. The system I've
tested this patch on is an x86_64 F-16 box with 4GB RAM and 6GB swap.

> #include <stdio.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <errno.h>
>
> #define GIG 1024 * 1024 * 1024L
> #define EXTENT 16393
>
> int main(void)
> {
>        int i, r;
>        void *m;
>        char buf[1024];
>        int prev_failed = 0;
>
>        for (i = 0; i < EXTENT; i++) {
>                m = mmap(NULL, (size_t) 1 * 1024 * 1024 * 1024L,
>                         PROT_READ | PROT_WRITE, MAP_PRIVATE |
> MAP_ANONYMOUS, 0, 0);
>
>                if (m == (void *)-1) {
>                        printf("MMAP Failed: %d\n", errno);
>                        return 1;
>                }
>
>                r = fork();
>
>                if (r == 0) {
>                        return 0;
>                } else if (r < 0) {
>                        prev_failed = 1;
>                        /* Fork failed as expected */
>                }
>                else if (r > 0 && prev_failed) {
>                        printf("Unexpected success at %d\n", i);
>                        wait(NULL);
>                        return 1;
>                }
>        }
>        return 0;
> }
>



-- 
Siddhesh Poyarekar
http://siddhesh.in
