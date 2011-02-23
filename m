Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1BWRMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:12:19 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5199 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:12:18 -0500
Message-ID: <4D653FED.5080202@caviumnetworks.com>
Date: Wed, 23 Feb 2011 09:12:13 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jump label: introduce static_branch() interface
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
In-Reply-To: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 17:12:14.0174 (UTC) FILETIME=[D0BE77E0:01CBD37C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 02:28 PM, Jason Baron wrote:
> Hi,
>
> API and core updates for jump labels. (I also included changes for mips,
> and sparc, (compile tested only), so hopefully the respective arch gurus,
> can ACK those bits). Applies on top of latest -tip tree.
>
> Introduce:
>
> static __always_inline bool static_branch(struct jump_label_key *key);
>
> instead of the old JUMP_LABEL(key, label) macro.
>
> In this way, jump labels become really easy to use:
>
> Define:
>
>          struct jump_label_key jump_key;
>
> Can be used as:
>
>          if (static_branch(&jump_key))
>                  do unlikely code
>
> enable/disale via:
>
>          jump_label_enable(&jump_key);
>          jump_label_disable(&jump_key);
>
> that's it!
>
> For the jump labels disabled case, the static_branch() becomes an
> atomic_read(), and jump_label_enable()/disable() are simply atomic_inc(),
> atomic_dec() operations. We show testing results for this change below.
> Thanks to H. Peter Anvin for suggesting the 'static_branch()' construct.
>
> Since we now require a 'struct jump_label_key *key', we can store a pointer into
> the jump table addresses. In this way, we can enable/disable jump labels, in
> basically constant time. This change allows us to completely remove the previous
> hashtable scheme. Thanks to Peter Zijlstra for this re-write.
>
> Testing:
>
> I ran a series of 'tbench 20' runs 5 times (with reboots) for 3
> configurations, where tracepoints were disabled.
>
> jump label configured in
> avg: 815.6
>
> jump label *not* configured in (using atomic reads)
> avg: 800.1
>
> jump label *not* configured in (regular reads)
> avg: 803.4
>
> thanks,
>
> -Jason
>
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Jason Baron<jbaron@redhat.com>
> Suggested-by: H. Peter Anvin<hpa@linux.intel.com>

Thanks Jason.  I tested this patch  on MIPS (mips64 Octeon to be exact), 
and the code is looking good.  The dynamic printk things are correctly 
moved out of the main code path.

You can add:

Tested-by: David Daney <ddaney@caviumnetworks.com>


> ---
>   arch/mips/include/asm/jump_label.h  |   22 +-
>   arch/mips/kernel/jump_label.c       |    2 +-
>   arch/sparc/include/asm/jump_label.h |   25 +-
>   arch/x86/include/asm/alternative.h  |    3 +-
>   arch/x86/include/asm/jump_label.h   |   26 +-
>   arch/x86/kernel/alternative.c       |    2 +-
>   arch/x86/kernel/jump_label.c        |    2 +-
>   arch/x86/kernel/module.c            |    1 +
>   include/asm-generic/vmlinux.lds.h   |   14 +-
>   include/linux/dynamic_debug.h       |   35 ++-
>   include/linux/jump_label.h          |   82 ++++---
>   include/linux/jump_label_ref.h      |   44 ---
>   include/linux/perf_event.h          |   26 +-
>   include/linux/tracepoint.h          |    8 +-
>   kernel/jump_label.c                 |  532 ++++++++++++++---------------------
>   kernel/perf_event.c                 |    4 +-
>   kernel/tracepoint.c                 |   23 +-
>   lib/dynamic_debug.c                 |   13 +-
>   18 files changed, 368 insertions(+), 496 deletions(-)
>   delete mode 100644 include/linux/jump_label_ref.h
>
[...]
