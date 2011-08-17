Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HQNTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:19:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1HQNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:19:08 -0400
Date: Wed, 17 Aug 2011 15:19:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, "Huang, Ying" <ying.huang@intel.com>,
        "He, Fan F" <fan.f.he@intel.com>
Subject: Re: perf: problem of 32bit mmap call graph recording
Message-ID: <20110817131900.GF32132@somewhere.redhat.com>
References: <1313569203.4115.149.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313569203.4115.149.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 04:20:03PM +0800, Lin Ming wrote:
> Hi all, 
> 
> On 32 bit machine, we have problem to get the usersapce call graph of
> mmap syscall.
> 
> You can reproduce it with below command on 32bit machine.
> 
> sudo perf record -f -g -e raw_syscalls:sys_enter --filter "id==192" ls
> 
> sudo perf report |less
> 
> # Events: 26 
> #
> # Overhead  Command      Shared Object  Symbol
> # ........  .......  .................  ......
> #
>    100.00%       ls  [kernel.kallsyms]  [k] syscall_trace_enter
>                  |
>                  --- syscall_trace_enter
>                      syscall_trace_entry
>                     |          
>                     |--88.46%-- __mmap  <--- only __mmap, no more userspace call stacks
>                     |          
>                      --11.54%-- 0xffffe424
> 
> 
> Kernel relies on userspace bp register to get call graph information.
> But for mmap syscall, the bp register is used to pass in the sixth
> parameter(offset).
> 
> void *mmap(void *addr, size_t length, int prot, int flags,
>                   int fd, off_t offset);
> 
> Anyway to fix this issue on 32bit machine?

Ah... Well we can't do much about that I fear :)
The only way would be to rely on dwarf informations to do the
unwind. The upside is that it would work about everywhere
even on places that don't have frame pointers, the downside
is some overhead on sample records (dump a bunch of stack every
sample) and a lot of work :)
