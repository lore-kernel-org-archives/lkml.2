Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1GVSzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:55:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24403 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1GVSzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:55:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LyGHVsgH1LoWScTcjKZ/xaTSYxz+SlAbROLM3RasKjW9ZOigK42KN+c2f7gevJZSB
	J5hxqmJQXclJ9QWmMCybQ==
MIME-Version: 1.0
In-Reply-To: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
Date: Fri, 22 Jul 2011 11:55:41 -0700
Message-ID: <CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: memory load/store events generalization
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

On Mon, Jul 4, 2011 at 1:02 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi, all
>
> Intel PMU provides 2 facilities to monitor memory operation: load latency and precise store.
> This patchset tries to generalize memory load/store events.
> So other arches may also add such features.
>
> A new sub-command "mem" is added,
>
> $ perf mem
>
>  usage: perf mem [<options>] {record <command> |report}
>
>    -t, --type <type>     memory operations(load/store)
>    -L, --latency <n>     latency to sample(only for load op)
>
That looks okay as a first approach tool. But what people are most
often interested in is to see where the misses occur, i.e., you need
to display load/store addresses somehow, especially for the more
costly misses (the ones the compiler cannot really hide by hoisting
loads).

> $ perf mem -t load record make -j8
>
> <building kernel ..., monitoring memory load opeartion>
>
> $ perf mem -t load report
>
> Memory load operation statistics
> ================================
>                      L1-local: total latency=   28027, count=    3355(avg=8)

That's wrong. On Intel, you need to subtract 4 cycles from the latency
you get out of PEBS-LL. The kernel can do that.

>                      L2-snoop: total latency=    1430, count=      29(avg=49)

I suspect L2-snoop is not correct. If this line item relates to bit 2 of
the data source, then it corresponds to a secondary miss. That means
you have a load to a cache-line that is already being requested.

>                      L2-local: total latency=     124, count=       8(avg=15)
>             L3-snoop, found M: total latency=     452, count=       4(avg=113)
>          L3-snoop, found no M: total latency=       0, count=       0(avg=0)
> L3-snoop, no coherency actions: total latency=     875, count=      18(avg=48)
>        L3-miss, snoop, shared: total latency=       0, count=       0(avg=0)
>     L3-miss, local, exclusive: total latency=       0, count=       0(avg=0)
>        L3-miss, local, shared: total latency=       0, count=       0(avg=0)
>    L3-miss, remote, exclusive: total latency=       0, count=       0(avg=0)
>       L3-miss, remote, shared: total latency=       0, count=       0(avg=0)
>                    Unknown L3: total latency=       0, count=       0(avg=0)
>                            IO: total latency=       0, count=       0(avg=0)
>                      Uncached: total latency=     464, count=      30(avg=15)
>
I think it would be more useful to print the % of loads captured for
each category.

> $ perf mem -t store record make -j8
>
> <building kernel ..., monitoring memory store opeartion>
>
> $ perf mem -t store report
>
> Memory store operation statistics
> =================================
>                data-cache hit:     8138
>               data-cache miss:        0
>                      STLB hit:     8138
>                     STLB miss:        0
>                 Locked access:        0
>               Unlocked access:     8138
>
> Any comment is appreciated.
>
> Thanks,
> Lin Ming
>
