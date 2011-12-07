Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1LGRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:21:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40062 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1LGRVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:21:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112061734450.26844@chino.kir.corp.google.com>
References: <1322770029-10297-1-git-send-email-yinghan@google.com>
	<alpine.DEB.2.00.1112061734450.26844@chino.kir.corp.google.com>
Date: Wed, 7 Dec 2011 09:21:15 -0800
Message-ID: <CALWz4izNE6So17q0QqE34k1PoZD0hHJvm3L6V_yCaa19szzOrQ@mail.gmail.com>
Subject: Re: [PATCH V6] Eliminate task stack trace duplication
From: Ying Han <yinghan@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 5:35 PM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 1 Dec 2011, Ying Han wrote:
>
>> The problem with small dmesg ring buffer like 512k is that only limited number
>> of task traces will be logged. Sometimes we lose important information only
>> because of too many duplicated stack traces. This problem occurs when dumping
>> lots of stacks in a single operation, such as sysrq-T.
>>
>> This patch tries to reduce the duplication of task stack trace in the dump
>> message by hashing the task stack. The hashtable is a 32k pre-allocated buffer
>> during bootup. Each time if we find the identical task trace in the task stack,
>> we dump only the pid of the task which has the task trace dumped. So it is easy
>> to back track to the full stack with the pid.
>>
>> When we do the hashing, we eliminate garbage entries from stack traces. Those
>> entries are still being printed in the dump to provide more debugging
>> informations.
>>
>> [   58.469730] kworker/0:0     S 0000000000000000     0     4      2 0x00000000
>> [   58.469735]  ffff88082fcfde80 0000000000000046 ffff88082e9d8000 ffff88082fcfc010
>> [   58.469739]  ffff88082fce9860 0000000000011440 ffff88082fcfdfd8 ffff88082fcfdfd8
>> [   58.469743]  0000000000011440 0000000000000000 ffff88082fcee180 ffff88082fce9860
>> [   58.469747] Call Trace:
>> [   58.469751]  [<ffffffff8108525a>] worker_thread+0x24b/0x250
>> [   58.469754]  [<ffffffff8108500f>] ? manage_workers+0x192/0x192
>> [   58.469757]  [<ffffffff810885bd>] kthread+0x82/0x8a
>> [   58.469760]  [<ffffffff8141aed4>] kernel_thread_helper+0x4/0x10
>> [   58.469763]  [<ffffffff8108853b>] ? kthread_worker_fn+0x112/0x112
>> [   58.469765]  [<ffffffff8141aed0>] ? gs_change+0xb/0xb
>> [   58.469768] kworker/u:0     S 0000000000000004     0     5      2 0x00000000
>> [   58.469773]  ffff88082fcffe80 0000000000000046 ffff880800000000 ffff88082fcfe010
>> [   58.469777]  ffff88082fcea080 0000000000011440 ffff88082fcfffd8 ffff88082fcfffd8
>> [   58.469781]  0000000000011440 0000000000000000 ffff88082fd4e9a0 ffff88082fcea080
>> [   58.469785] Call Trace:
>> [   58.469786] <Same stack as pid 4>
>> [   58.470235] kworker/0:1     S 0000000000000000     0    13      2 0x00000000
>> [   58.470255]  ffff88082fd3fe80 0000000000000046 ffff880800000000 ffff88082fd3e010
>> [   58.470279]  ffff88082fcee180 0000000000011440 ffff88082fd3ffd8 ffff88082fd3ffd8
>> [   58.470301]  0000000000011440 0000000000000000 ffffffff8180b020 ffff88082fcee180
>> [   58.470325] Call Trace:
>> [   58.470332] <Same stack as pid 4>
>>
>> changelog v6..v5:
>> 1. clear saved stack trace before printing a set of stacks. this ensures the printed
>> stack traces are not omitted messages.
>> 2. add log level in printing duplicate stack.
>> 3. remove the show_stack() API change, and non-x86 arch won't need further change.
>> 4. add more inline documentations.
>>
>> changelog v5..v4:
>> 1. removed changes to Kconfig file
>> 2. changed hashtable to keep only hash value and length of stack
>> 3. simplified hashtable lookup
>>
>> changelog v4..v3:
>> 1. improve de-duplication by eliminating garbage entries from stack traces.
>> with this change 793/825 stack traces were recognized as duplicates. in v3
>> only 482/839 were duplicates.
>>
>> changelog v3..v2:
>> 1. again better documentation on the patch description.
>> 2. make the stack_hash_table to be allocated at compile time.
>> 3. have better name of variable index
>> 4. move save_dup_stack_trace() in kernel/stacktrace.c
>>
>> changelog v2..v1:
>> 1. better documentation on the patch description
>> 2. move the spinlock inside the hash lockup, so reducing the holding time.
>>
>> Note:
>> 1. with pid namespace, we might have same pid number for different processes. i
>> wonder how the stack trace (w/o dedup) handles the case, it uses tsk->pid as well
>> as far as I checked.
>> 2. the core functionality is in x86-specific code, this could be moved out to
>> support other architectures.
>> 3. Andrew made the suggestion of doing appending to stack_hash_table[].
>>
>> Signed-off-by: Ying Han <yinghan@google.com>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> ---
>>  arch/x86/include/asm/stacktrace.h |   11 +++-
>>  arch/x86/kernel/dumpstack.c       |   24 ++++++-
>>  arch/x86/kernel/dumpstack_32.c    |    7 +-
>>  arch/x86/kernel/dumpstack_64.c    |    7 +-
>>  arch/x86/kernel/stacktrace.c      |  123 +++++++++++++++++++++++++++++++++++++
>>  include/linux/sched.h             |    3 +
>>  include/linux/stacktrace.h        |    4 +
>>  kernel/sched.c                    |   32 +++++++++-
>>  kernel/stacktrace.c               |   15 +++++
>>  9 files changed, 211 insertions(+), 15 deletions(-)
>>
>
> Looks like something that would go through x86/debug?  Probably best to cc
> Ingo, Peter, and Thomas.

Thank you David, I was about to add linux-kernel into the cc list
yesterday as well.

--Ying
