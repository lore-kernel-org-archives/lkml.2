Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2KFUwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:52:30 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63024 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2KFUw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:52:29 -0500
Date: Tue, 6 Nov 2012 17:52:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 00/16] perf: add memory access sampling support
Message-ID: <20121106205220.GF13629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352123463-7346-1-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 05, 2012 at 02:50:47PM +0100, Stephane Eranian escreveu:
> Or if one is interested in the data view:
> $ perf mem -t load rep --sort=symbol_daddr,cost
> # Samples: 19K of event 'cpu/mem-loads/pp'
> # Total cost : 1013994
> # Sort order : symbol_daddr,cost
> #
> # Overhead      Samples             Data Symbol     Cost
> # ........  ...........  ......................  .......
> #
>      0.10%            1  [.] 0x00007f67dffe8038      986
>      0.09%            1  [.] 0x00007f67df91a750      890
>      0.08%            1  [.] 0x00007f67e288fba8      826
> 

> CAVEAT: Note that the data addresses are not resolved correctly currently due to a
> problem in perf data symbol resolution code which I have not been able to
> uncover so far.

Stephane,

	Those data addresses mostly are on the stack, we need reverse
resolution using DWARF location expressions to figure out what is the
name of a variable that is on a particular address, etc.

	Masami, have you played with this already? I mean:

[root@sandy acme]# perf mem -t load rep --stdio --sort=symbol,symbol_daddr,cost
# Samples: 30  of event 'cpu/mem-loads/pp'
# Total cost : 640
# Sort order : symbol,symbol_daddr,cost
#
# Overhead      Samples                  Symbol             Data Symbol     Cost
# ........  ...........  ......................  ......................  .......
#
    55.00%            1  [k] lookup_fast         [k] 0xffff8803b7521bd4      352
     5.47%            1  [k] cache_alloc_refill  [k] 0xffff880407705024       35
     3.44%            1  [k] cache_alloc_refill  [k] 0xffff88041d8527d8       22
     3.28%            1  [k] run_timer_softirq   [k] 0xffff88041e2c3e90       21
     2.50%            1  [k] __list_add          [k] 0xffff8803b7521d68       16
     2.19%            1  [.] __strcoll_l         [.] 0x00007fffa8d44080       14
     1.88%            1  [.] __strcoll_l         [.] 0x00007fffa8d44104       12

If we go to the annotation browser to see where is that lookup_fast hitting we get:

100.00 │       mov    -0x34(%rbp),%eax

How to map 0xffff8803b7521bd4 to a stack variable, struct members and all?

Humm, for userspace we have PERF_SAMPLE_REGS_USER for the dwarf unwinder we
need for userspace, but what about reverse mapping of kernel variables? Jiri?

- Arnaldo
