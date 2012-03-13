Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2CMGN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:13:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64937 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab2CMGNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <1331617001-20906-5-git-send-email-apenwarr@gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
	<1331617001-20906-5-git-send-email-apenwarr@gmail.com>
Date: Mon, 12 Mar 2012 23:13:24 -0700
X-Google-Sender-Auth: CMom0V2o6-5Ddas8I6AgUakrUO8
Message-ID: <CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
Subject: Re: [PATCH 4/5] printk: use alloc_bootmem() instead of memblock_alloc().
From: Yinghai Lu <yinghai@kernel.org>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:36 PM, Avery Pennarun <apenwarr@gmail.com> wrote:
> The code in setup_log_buf() had two memory allocation branches, depending
> on the value of 'early'.  If early==1, it would use memblock_alloc(); if
> early==0, it would use alloc_bootmem_nopanic().
>
> bootmem should already configured by the time setup_log_buf(early=1) is
> called, so there's no reason to have the separation.  Furthermore, on
> arches with nobootmem, memblock_alloc is essentially the same as
> alloc_bootmem anyway.  x86 is one such arch, and also the only one
> that uses early=1.
>
> Signed-off-by: Avery Pennarun <apenwarr@gmail.com>
> ---
>  kernel/printk.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 32690a0..bf96a7d 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -31,7 +31,6 @@
>  #include <linux/smp.h>
>  #include <linux/security.h>
>  #include <linux/bootmem.h>
> -#include <linux/memblock.h>
>  #include <linux/syscalls.h>
>  #include <linux/kexec.h>
>  #include <linux/kdb.h>
> @@ -195,17 +194,7 @@ void __init setup_log_buf(int early)
>        if (!new_log_buf_len)
>                return;
>
> -       if (early) {
> -               unsigned long mem;
> -
> -               mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
> -               if (!mem)
> -                       return;
> -               new_log_buf = __va(mem);
> -       } else {
> -               new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
> -       }
> -
> +       new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
>        if (unlikely(!new_log_buf)) {
>                pr_err("log_buf_len: %ld bytes not available\n",
>                        new_log_buf_len);
> --

that seems not right.

for x86, setup_log_buf(1) is quite early called in setup_arch() before
bootmem is there.

bootmem should be killed after memblock is supported for arch that
current support bootmem.

Yinghai
