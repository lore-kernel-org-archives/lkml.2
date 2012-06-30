Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2F3AlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:41:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56619 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2F3AlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:41:01 -0400
Message-ID: <4FEE4B18.1000609@gmail.com>
Date: Fri, 29 Jun 2012 18:40:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, psuriset@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] perf kvm: fix segfault with default guest arguments
References: <1340599286-89757-1-git-send-email-dsahern@gmail.com> <20120628144418.GG4038@infradead.org>
In-Reply-To: <20120628144418.GG4038@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/12 8:44 AM, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jun 24, 2012 at 10:41:26PM -0600, David Ahern escreveu:
>> File generated with:
>> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>>      --guestmodules=/tmp/guest-modules record -a
>>
>> The report command:
>> $ perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms
>>      --guestmodules=/tmp/guest-modules report
>>
>> dies with a SEGFAULT:
>> Program received signal SIGSEGV, Segmentation fault.
>> 0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
>> 715			snprintf(bf, size, "[%s.%d]", "guest.kernel.kallsyms", self->pid);
>>
>> (gdb) bt
>> 0  0x000000000046dd7b in machine__mmap_name (self=0x0, bf=0x7fffffffbd20 "q\021", size=4096) at util/map.c:715
>> 1  0x0000000000444161 in perf_event__process_kernel_mmap (tool=0x7fffffffdd80, event=0x7ffff7fb4120, machine=0x0) at util/event.c:562
>

So this is the root cause of the SEGFAULT:

743eb868657bdb1b26c7b24077ca21c67c82c777 is the first bad commit
commit 743eb868657bdb1b26c7b24077ca21c67c82c777
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Mon Nov 28 07:56:39 2011 -0200

     perf tools: Resolve machine earlier and pass it to perf_event_ops

     Reducing the exposure of perf_session further, so that we can use the
     classes in cases where no perf.data file is created.

     Cc: David Ahern <dsahern@gmail.com>
     Cc: Frederic Weisbecker <fweisbec@gmail.com>
     Cc: Mike Galbraith <efault@gmx.de>
     Cc: Paul Mackerras <paulus@samba.org>
     Cc: Peter Zijlstra <peterz@infradead.org>
     Cc: Stephane Eranian <eranian@google.com>
     Link: 
http://lkml.kernel.org/n/tip-stua66dcscsezzrcdugvbmvd@git.kernel.org
     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 414f7e982a230f633440b3da2900da4d2d9c30ef
3231e148910bd596c61814e18bba77ecf7ad5dfb M  tools


specifically, this part:

-   machine = perf_session__findnew_machine(session, event->mmap.pid);
-   if (!machine) {
-       pr_err("Can't find id %d's machine\n", event->mmap.pid);
-       goto out_problem;
-   }
-

Suggestions on how to fix that part?

More to the perf-kvm story; details in future emails.

David
