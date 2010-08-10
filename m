Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab0HJQVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:21:46 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:9317 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab0HJQVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:21:41 -0400
Message-ID: <4C617C94.5010808@tilera.com>
Date: Tue, 10 Aug 2010 12:21:40 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT] writable_limits for 2.6.36
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com>
In-Reply-To: <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2010 12:01 PM, Linus Torvalds wrote:
> 2010/8/7 Jiri Slaby <jslaby@suse.cz>:
>   
>> please consider the following repository for 2.6.36. It introduces a new
>> syscall for arch independent resource limits handling. It also adds a
>> support for runtime limits changing. This feature is needed mostly by
>> daemons servicing databases and similar service where limits are needed
>> to be changed without services being restarted on production systems.
>>     
> Ok, so the code looks fine, and I don't have any real objections any
> more. I don't know how much use this will get, but it doesn't appear
> to be "wrong" in any way. So I was going to pull it.
>
> However, in the meantime we have commit 5360bd776f73 ("Fix up the
> "generic" unistd.h ABI to be more useful") that clashes with it. Now,
> the conflict is trivial to resolve, and I could do that easily - it's
> not a technical problem. But that commit code comments say
>
>   + * Architectures may provide up to 16 syscalls of their own
>   + * starting with this value.
>   + */
>   +#define __NR_arch_specific_syscall 244
>
> and the new writable rlimits syscall is obviously 244.
>   

Jiri and I actually discussed this back on July 20th on LKML when it
first conflicted in linux-next, and at the time he said he'd move
prlimit64 to 261 in <asm-generic/unistd.h>.  It looks like what actually
stuck in linux-next was different, however.  It's partly my fault for
not following up on this.

> Now, looking at it all, I think that commit was badly done - not
> leaving any room for new generic system calls is pretty iffy. And if I
> had happened to take the Tilera merge later, I'd have had no problems
> with just changing it. As is, though, I want to check with Arnd and
> Chris first.
>   

In any case, obviously the larger question is how many
architecture-specific syscalls are appropriate, and where they should be
located in the syscall number space.  To be clear, the model for new
generic system calls is that they just continue on after the 16
architecture-specific ones, and in fact __NR_wait4 is already an example
of just this -- done that way to avoid making trouble for the "score"
architecture, since it was deprecated and then later un-deprecated.  So
new generic syscalls are not a problem.

There is definitely some tension between allowing architectures free
reign with their own set of unlimited additional syscalls on the one
hand, and having a contiguous and small array of syscalls on the other
hand.  I suspect it's slightly nicer to have a contiguous and small
array, as long as we've provided enough room for architectures to add
extra syscalls, but I'm not strongly married to this position.

For what it's worth, from Tilera's point of view we can certainly
tolerate changes in this area; we have not released any of this new
syscall ABI stuff to customers yet, so thrashing this just involves an
internal flag day for our developers, which is not too big a deal.

> Arnd, Chris - how about making the "arch-specific" system calls start
> at 256 or something? Or even higher, like 512? Yes, it makes the
> system call array bigger, but is that really a problem? Especially as
> we start the "deprecated" system calls at 1024, it would seem to make
> sense to raise it to 512, and leave the low numbers for the "regular"
> system calls.
>
> [ I'm leaving the quoted email for the edification of Chris/Arnd that
> I added to the discussion ]
>
>                                    Linus
>
> ---
>   
>>  git://decibel.fi.muni.cz/~xslaby/linux writable_limits
>>
>> Jiri Slaby (10):
>>      rlimits: security, add task_struct to setrlimit
>>      rlimits: add task_struct to update_rlimit_cpu
>>      rlimits: split sys_setrlimit
>>      rlimits: allow setrlimit to non-current tasks
>>      rlimits: do security check under task_lock
>>      rlimits: add rlimit64 structure
>>      rlimits: redo do_setrlimit to more generic do_prlimit
>>      rlimits: switch more rlimit syscalls to do_prlimit
>>      rlimits: implement prlimit64 syscall
>>      unistd: add __NR_prlimit64 syscall numbers
>>
>> Oleg Nesterov (2):
>>      rlimits: make sure ->rlim_max never grows in sys_setrlimit
>>      rlimits: selinux, do rlimits changes under task_lock
>>
>>  arch/x86/ia32/ia32entry.S          |    1 +
>>  arch/x86/include/asm/unistd_32.h   |    3 +-
>>  arch/x86/include/asm/unistd_64.h   |    2 +
>>  arch/x86/kernel/syscall_table_32.S |    1 +
>>  include/asm-generic/unistd.h       |    4 +-
>>  include/linux/posix-timers.h       |    2 +-
>>  include/linux/resource.h           |    9 ++
>>  include/linux/security.h           |    9 +-
>>  include/linux/syscalls.h           |    4 +
>>  kernel/compat.c                    |   17 +---
>>  kernel/posix-cpu-timers.c          |    8 +-
>>  kernel/sys.c                       |  202 ++++++++++++++++++++++++++++--------
>>  security/capability.c              |    3 +-
>>  security/security.c                |    5 +-
>>  security/selinux/hooks.c           |   12 ++-
>>  15 files changed, 207 insertions(+), 75 deletions(-)
>>
>> thanks,
>> --
>> js
>> suse labs
>>
>>     

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

