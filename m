Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2GYMLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630Ab2GYMLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:11:34 -0400
Date: Wed, 25 Jul 2012 14:11:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/11] perf kvm: fix bug resolving guest kernel syms - v2
Message-ID: <20120725121121.GB946@krava.brq.redhat.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-5-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:25:49PM -0600, David Ahern wrote:
> Guest kernel symbols are not resolved despite passing the information
> needed to resolve them. e.g.,
> 
> perf kvm --guest --guestmount=/tmp/guest-mount record -a -- sleep 1
> perf kvm --guest --guestmount=/tmp/guest-mount report --stdio
> 
>     36.55%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>     33.19%  [guest/10474]  [unknown]         [g] 0x00000000c0116e00
>     30.26%  [guest/11094]  [unknown]         [g] 0xffffffff8100a288
>     43.69%  [guest/10474]  [unknown]         [g] 0x00000000c0103d90
>     37.38%  [guest/11399]  [unknown]         [g] 0xffffffff81600bc8
>     12.24%  [guest/11094]  [unknown]         [g] 0xffffffff810aa91d
>      6.69%  [guest/11094]  [unknown]         [u] 0x00007fa784d721c3
> 
> which is just pathetic.
> 
> After a maddening 2 days sifting through perf minutia I found it --
> id_hdr_size is not initialized for guest machines. This shows up on the
> report side as random garbage for the cpu and timestamp, e.g.,
> 
> 29816 7310572949125804849 0x1ac0 [0x50]: PERF_RECORD_MMAP ...
> 
> That messes up the sample sorting such that synthesized guest maps are
> processed last.
> 
> With this patch you get a much more helpful report:
> 
>   12.11%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] irqtime_account_process_tick
>   10.58%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] run_timer_softirq
>    6.95%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] printk_needs_cpu
>    6.50%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] do_timer
>    6.45%  [guest/11399]  [guest.kernel.kallsyms.11399]  [g] idle_balance
>    4.90%  [guest/11094]  [guest.kernel.kallsyms.11094]  [g] native_read_tsc
>     ...
> 
> v2:
> - changed rbtree walk to use rb_first per Namhyung's suggestion
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

Tested-by: Jiri Olsa <jolsa@redhat.com>
