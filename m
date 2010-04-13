Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0DMQ5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 12:57:05 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:56894 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381Ab0DMQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 12:57:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMI+xEtGGNwY/2dsb2JhbACbS3K9fIUNBA
Date: Tue, 13 Apr 2010 12:56:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 0/9] jump label v6
Message-ID: <20100413165659.GA23931@Krystal>
References: <cover.1270839564.git.jbaron@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:40:11 up 6 days,  2:34,  2 users,  load average: 0.05, 0.08,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> Hi,
> 
> Refresh of jump labeling patches aginst -tip tree. For bacground see: 
> http://marc.info/?l=linux-kernel&m=125858436505941&w=2
> 
> I believe I've addressed all the reviews from v5.

Hi Jason,

I would appreciate if you could add pointers to the Immediate Values
benchmarks (or possibly some benchmark information altogether) and a
notice that some parts of the design are inspired from Immediate Values
in the jump label code.

I recognise that you did great work on getting jump label in shape both
at the Linux kernel and gcc level, but it's usually appropriate to
acknowledge prior work it is based on. Only then can I justify that
Immediate Values have been useful in the whole process.

Thanks,

Mathieu


> 
> Changes in v6:
> 
> * I've moved Steve Rostedt's 'ftrace_dyn_arch_init()' to alternative.c to
> put it into a common area for used by both ftrace and jump labels. By
> default we put a 'jmp 5' in the nop slot. Then, when we detect the best
> runtime no-op we patch over the 'jmp 5' with the appropriate nop.
> 
> * build time sort of the jump label table. The jump label table is more
> optimally accessed if the entries are continguous. Sorting the table
> accomplishes this. Do the sort at build-time. Adds a '-j' option to 
> 'modpost' which replaces the vmlinux, with a sorted jump label section vmlinux.
> I've tested this on x86 with relocatable and it works fine there as well. Note
> that I have not sorted the jump label table in modules. This is b/c the jump
> label names can be exported by the core kernel, and thus I don't have them
> available at buildtime. This could be solved by either finding the correct
> ones in the vmlinux, or by embedding the name of the jump label in the module
> tables (and not just a pointer), but the module tables tend to be smaller, and
> thus there is less value to this kind of change anyway. The kernel continues to
> do the sort, just in case, but at least for the vmlinux, this is just a
> verfication b/c the jump label table has already been sorted.
> 
> * added jump_label_text_reserved(), so that other routines that want to patch
> the code, can first verify that they are not stomping on jump label addresses.
> 
> thanks,
> 
> -Jason
> 
> Jason Baron (8):
>   jump label: base patch
>   jump label: x86 support
>   jump label: tracepoint support
>   jump label: add module support
>   jump label: move ftrace_dyn_arch_init to common code
>   jump label: sort jump table at build-time
>   jump label: initialize workqueue tracepoints *before* they are
>     registered
>   jump label: jump_label_text_reserved() to reserve our jump points
> 
> Mathieu Desnoyers (1):
>   jump label: notifier atomic call chain notrace
> 
>  Makefile                           |    4 +
>  arch/x86/include/asm/alternative.h |   14 ++
>  arch/x86/include/asm/jump_label.h  |   27 +++
>  arch/x86/kernel/Makefile           |    2 +-
>  arch/x86/kernel/alternative.c      |   71 ++++++-
>  arch/x86/kernel/ftrace.c           |   70 +------
>  arch/x86/kernel/jump_label.c       |   42 ++++
>  arch/x86/kernel/kprobes.c          |    3 +-
>  arch/x86/kernel/module.c           |    3 +
>  arch/x86/kernel/ptrace.c           |    1 +
>  arch/x86/kernel/setup.c            |    2 +
>  include/asm-generic/vmlinux.lds.h  |   22 ++-
>  include/linux/jump_label.h         |   76 +++++++
>  include/linux/module.h             |    5 +-
>  include/linux/tracepoint.h         |   34 ++--
>  kernel/Makefile                    |    2 +-
>  kernel/jump_label.c                |  428 ++++++++++++++++++++++++++++++++++++
>  kernel/kprobes.c                   |    3 +-
>  kernel/module.c                    |    7 +
>  kernel/notifier.c                  |    6 +-
>  kernel/trace/ftrace.c              |   13 +-
>  kernel/trace/trace_workqueue.c     |   10 +-
>  kernel/tracepoint.c                |    8 +
>  scripts/mod/modpost.c              |   69 ++++++-
>  scripts/mod/modpost.h              |    9 +
>  25 files changed, 816 insertions(+), 115 deletions(-)
>  create mode 100644 arch/x86/include/asm/jump_label.h
>  create mode 100644 arch/x86/kernel/jump_label.c
>  create mode 100644 include/linux/jump_label.h
>  create mode 100644 kernel/jump_label.c
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
