Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab1ELOsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:48:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1ELOsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Wd+UqqhZVz3it39DVamMeYkZa5FmOGrF7tNzW9YC+7+MJErsme8tOdJJr+wa7rLtJK
         1eKZ+YaJMQkAstrIeP9A==
MIME-Version: 1.0
Date: Thu, 12 May 2011 16:48:46 +0200
Message-ID: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
Subject: [BUG] perf: bogus correlation of kernel symbols
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think there is a serious problem with kernel symbol correlation
with the latest perf in 2.6.39-rc7-tip.

Here is a simple example with a stupid program that only
does open()/close on /dev/null:

$ perf record -e cycles:k openclose
$ perf report --stdio

# Events: 2K cycles
#
# Overhead    Command     Shared Object           Symbol
# ........  .........  ................  ...............
#
    99.76%  openclose  [binfmt_misc]     [k] 0xffffffff81010fe6
     0.13%  openclose  libc-2.12.1.so    [.] __open_nocancel
     0.09%  openclose  libc-2.12.1.so    [.] __GI_close

The DSO (binfmt_misc) is bogus. That's not where time is spent.

But if I ran the same test as root:

$ sudo perf record -e cycles:k openclose
$ sudo perf report --stdio

# Events: 2K cycles
#
# Overhead    Command      Shared Object                         Symbol
# ........  .........  .................  .............................
#
    17.13%  openclose  [kernel.kallsyms]  [k] __lock_acquire
    11.77%  openclose  [kernel.kallsyms]  [k] native_sched_clock
     7.36%  openclose  [kernel.kallsyms]  [k] sched_clock_local
     5.99%  openclose  [kernel.kallsyms]  [k] lock_release
     5.38%  openclose  [kernel.kallsyms]  [k] local_clock
     4.43%  openclose  [kernel.kallsyms]  [k] lock_acquired
     4.05%  openclose  [kernel.kallsyms]  [k] lock_acquire
     3.95%  openclose  [kernel.kallsyms]  [k] lock_is_held
     3.51%  openclose  [kernel.kallsyms]  [k] sched_clock_cpu
     3.24%  openclose  [kernel.kallsyms]  [k] trace_hardirqs_off_caller

This is much more meaningful.

This is not related to the paranoid level (1 for me).

Looking at perf report -D, the same kernel address is associated to different
module based on my permission level.

first perf.data:
416749738927 0x4210 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 4886/4886:
0xffffffff8107c1d8 period: 2262681
 ... thread: openclose:4886
 ...... dso: /lib/modules/2.6.39-rc7-tip/kernel/fs/binfmt_misc.ko

second perf.data:
436879910722 0xc950 [0x28]: PERF_RECORD_SAMPLE(IP, 1): 4894/4894:
0xffffffff8107c1d8 period: 2280253
 ... thread: openclose:4894
 ...... dso: vmlinux

Same address different mapping!

My path to vmlinux is all accessible to me.

If there were permission problems, I would expect perf record or perf report
to tell me and not fallback to some bogus mappings.
