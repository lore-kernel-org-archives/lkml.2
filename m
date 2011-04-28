Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1D1P3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:29:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45463 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab1D1P3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110428151241.GD1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<20110428151241.GD1798@nowhere>
Date: Thu, 28 Apr 2011 10:29:11 -0500
Message-ID: <BANLkTika4xn5SajxGbRtszqyA4R=4y8M6Q@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:12 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Wed, Apr 27, 2011 at 10:08:47PM -0500, Will Drewry wrote:
>> This change adds a new seccomp mode based on the work by
>> agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
>> an optional linked list of seccomp_filter objects. When in mode 2, all
>> system calls are first checked against the bitmask to determine if they
>> are allowed or denied.  If allowed, the list of filters is checked for
>> the given syscall number. If all filter predicates for the system call
>> match or the system call was allowed without restriction, the process
>> continues. Otherwise, it is killed and a KERN_INFO notification is
>> posted.
>>
>> The filter language itself is provided by the ftrace filter engine.
>> Related patches tweak to the perf filter trace and free allow the calls
>> to be shared. Filters inherit their understanding of types and arguments
>> for each system call from the CONFIG_FTRACE_SYSCALLS subsystem which
>> predefines this information in syscall_metadata associated enter_event
>> (and exit_event) structures.
>>
>> The result is that a process may reduce its available interfaces to
>> the kernel through prctl() without knowing the appropriate system call
>> number a priori and with the flexibility of filtering based on
>> register-stored arguments.  (String checks suffer from TOCTOU issues and
>> should be left to LSMs to provide policy for! Don't get greedy :)
>>
>> A sample filterset for a process that only needs to interact over stdin
>> and stdout and exit cleanly is shown below:
>>   sys_read: fd == 0
>>   sys_write: fd == 1
>>   sys_exit_group: 1
>>
>> The filters may be specified once prior to entering the reduced access
>> state:
>>   prctl(PR_SET_SECCOMP, 2, filters);
>
> Instead of having such multiline filter definition with syscall
> names prepended, it would be nicer to make the parsing simplier.
>
> You could have either:
>
>        prctl(PR_SET_SECCOMP, mode);
>        /* Works only if we are in mode 2 */
>        prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter);

It'd need to be syscall_name instead of syscall_nr.  Otherwise we're
right back to where Adam's patch was 2+ years ago :)  Using the event
names from the syscalls infrastructure means the consumer of the
interface doesn't need to be confident of the syscall number.  That
said, it would be nice to be able to specify the number as well.  If
there were no complaints, it'd be nice to support both, imo.

> or:
>        /*
>         * If mode == 2, set the filter to syscall_nr
>         * Recall this for each syscall that need a filter.
>         * If a filter was previously set on the targeted syscall,
>         * it will be overwritten.
>         */
>        prctl(PR_SET_SECCOMP, mode, syscall_nr, filter);
>
> One can erase a previous filter by setting the new filter "1".
>
> Also, instead of having a bitmap of syscall to accept. You could
> simply set "0" as a filter to those you want to deactivate:
>
> prctl(PR_SET_SECCOMP, 2, 1, 0); <- deactivate the syscall_nr 1
>
> Hm?

I like the simplicity in not needing to parse anything extra, but it
does add the need for extra state - either a bit or a new field - to
represent "enabled/enforcing".

The only way to do it without a third mode would be to take a
blacklist model - where all syscalls are allowed by default and the
caller has to enumerate them all and drop them. That would definitely
not be the right approach :)

If a new bit of state was added,  it could be used as:
  prctl(PR_SET_SECCOMP, 2);
  prctl(PR_SET_SECCOMP, 2, "sys_read", "fd == 1");  /* add a read filter */
  prctl(PR_SET_SECCOMP, 2, "sys_write", "fd == 0");  /* add a read filter */
  ...
  prctl(PR_SET_SECCOMP, 2, "sys_read", "0");  /* clear the sys_read
filters and block it */  (or NULL?)
  prctl(PR_SET_SECCOMP, 2, "enable");  /* Start enforcing */
  prctl(PR_SET_SECCOMP, 2, "sys_write", "0");  /* Reduce attack
surface on the fly */


As to the "0" filter instead of a bitmask, would it make sense to just
cut over to an hlist now and drop the bitmask?  It looks like perf
uses that model, and I'd hope it wouldn't incur too much additional
overhead.  (The linked list approach now is certainly not scalable for
a large number of filters!)

If that interface seems sane, I can certainly start exploring it and
see if I hit any surprises (and put it in the next version of the
patch :).  I think it'll simplify a fair amount of the add/drop code!

thanks!
will
