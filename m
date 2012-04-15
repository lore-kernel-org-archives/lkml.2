Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab2DOVcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:32:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2DOVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:32:44 -0400
Message-ID: <4F8B3E78.7080809@gmail.com>
Date: Sun, 15 Apr 2012 15:32:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com> <1334233262-5679-2-git-send-email-jolsa@redhat.com> <4F86E965.4010506@gmail.com> <20120413113207.GB3384@m.brq.redhat.com> <4F881A62.8060109@gmail.com> <20120413124129.GC3384@m.brq.redhat.com> <4F8834F5.9040605@gmail.com> <20120415140513.GA2588@m.redhat.com>
In-Reply-To: <20120415140513.GA2588@m.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/12 8:05 AM, Jiri Olsa wrote:
> how about the patch below? it ensures there's machine record for
> the guest. The segfault issue still stays..
>
> jirka
>
> ---
> Running 'perf kvm record' without any of following options:
>   --guestmount
>   --guestvmlinux
>   --guestkallsyms
>   --guestmodules
>
> is causing the guest machine to be ommited from the data file,
> and all guest samples are counted in nr_unprocessable_samples.
>
> This patch makes sure the 'perf kvm record' command is not
> let through if guest machine isn't defined.


Doesn't work: it requires a 'default' vmlinux/modules/kallsyms even when 
a proper guestmount has been specified.

Today guestmount works for the report path because of the hook in 
machines__findnew() which creates a machine on first lookup. Really, the 
guestmount argument should not be required for the report which could be 
using a local symbol tree (symfs argument) -- e.g., capture on a host OS 
which could have kallsyms/module information for each VM / VM being 
profiled and then report file taken to another system for analysis where 
that system has access to symbols.

Perhaps what is needed is for the machine to be created for the pid == 
DEFAULT_GUEST_KERNEL_ID on first need. This is not the right place -- 
but shows the sentiment:

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1efd3be..20420fc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -824,6 +824,7 @@ static struct machine *
     perf_session__find_machine_for_cpumode(struct perf_session *session,
                            union perf_event *event)
  {
+    struct machine *mach;
     const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;

     if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
@@ -834,7 +835,10 @@ static struct machine *
         else
             pid = event->ip.pid;

-       return perf_session__find_machine(session, pid);
+       mach = perf_session__find_machine(session, pid);
+        if (!mach && pid == 0)
+            mach = machines__add(&session->machines, pid, "/dev/null");
+        return mach;
     }

     return perf_session__find_host_machine(session);

So basically it allows kernel maps to be attached to a pid 0 machine but 
that machine has no tree for further symbols. If nothing else perf-kvm 
does not segfault.

I am seeing other problems with perf-kvm too. e.g.,
perf kvm --guest --host --guestmount /tmp/guestmount  record -p 21234 -- 
sleep 10


Dumping the samples:
perf script -i perf.data.guest
--> shows no samples (2 'openssl speed' commands are running in the 
2-vcpu guest so something should be generated)

perf script -i perf.data.kvm

Failed to open [guest.kernel.kallsyms.21234]_text, continuing without 
symbols
         qemu-kvm 21234 cycles:  ffffffff8103edaa [unknown] 
([guest.kernel.kallsyms.21234]_text)

Anyways, perf-kvm needs some love. Gotta run.

David
