Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2KGOyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:54:01 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38789 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2KGOx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:53:59 -0500
X-AuditID: b753bd60-97c52ba000002f78-88-509a7604d95d
X-AuditID: b753bd60-97c52ba000002f78-88-509a7604d95d
Message-ID: <509A75F3.3060409@hitachi.com>
Date: Wed, 07 Nov 2012 23:53:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH v2 00/16] perf: add memory access sampling support
References: <20121106205220.GF13629@infradead.org>
In-Reply-To: <20121106205220.GF13629@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/07 5:52), Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 05, 2012 at 02:50:47PM +0100, Stephane Eranian escreveu:
>> Or if one is interested in the data view:
>> $ perf mem -t load rep --sort=symbol_daddr,cost
>> # Samples: 19K of event 'cpu/mem-loads/pp'
>> # Total cost : 1013994
>> # Sort order : symbol_daddr,cost
>> #
>> # Overhead      Samples             Data Symbol     Cost
>> # ........  ...........  ......................  .......
>> #
>>      0.10%            1  [.] 0x00007f67dffe8038      986
>>      0.09%            1  [.] 0x00007f67df91a750      890
>>      0.08%            1  [.] 0x00007f67e288fba8      826
>>
> 
>> CAVEAT: Note that the data addresses are not resolved correctly currently due to a
>> problem in perf data symbol resolution code which I have not been able to
>> uncover so far.
> 
> Stephane,
> 
> 	Those data addresses mostly are on the stack, we need reverse
> resolution using DWARF location expressions to figure out what is the
> name of a variable that is on a particular address, etc.
> 
> 	Masami, have you played with this already? I mean:

No, but it looks interesting. I'll try :)

> 
> [root@sandy acme]# perf mem -t load rep --stdio --sort=symbol,symbol_daddr,cost
> # Samples: 30  of event 'cpu/mem-loads/pp'
> # Total cost : 640
> # Sort order : symbol,symbol_daddr,cost
> #
> # Overhead      Samples                  Symbol             Data Symbol     Cost
> # ........  ...........  ......................  ......................  .......
> #
>     55.00%            1  [k] lookup_fast         [k] 0xffff8803b7521bd4      352
>      5.47%            1  [k] cache_alloc_refill  [k] 0xffff880407705024       35
>      3.44%            1  [k] cache_alloc_refill  [k] 0xffff88041d8527d8       22
>      3.28%            1  [k] run_timer_softirq   [k] 0xffff88041e2c3e90       21
>      2.50%            1  [k] __list_add          [k] 0xffff8803b7521d68       16
>      2.19%            1  [.] __strcoll_l         [.] 0x00007fffa8d44080       14
>      1.88%            1  [.] __strcoll_l         [.] 0x00007fffa8d44104       12
> 
> If we go to the annotation browser to see where is that lookup_fast hitting we get:
> 
> 100.00 │       mov    -0x34(%rbp),%eax
> 
> How to map 0xffff8803b7521bd4 to a stack variable, struct members and all?

If perf stores %rbp value, we can do forward searching from local variables
in this scope block. In some cases, the memory is dereferenced by another
pointer. In that case, it is hard to do that (perhaps, we need to disassemble
it and reverse execution). But in most case of the memory address on a stack,
it will work, I think.

Thank you,

> 
> Humm, for userspace we have PERF_SAMPLE_REGS_USER for the dwarf unwinder we
> need for userspace, but what about reverse mapping of kernel variables? Jiri?
> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


