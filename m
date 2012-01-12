Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2ALQze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:55:34 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50567 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2ALQza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:55:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120112145040.GA19472@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112145040.GA19472@redhat.com>
Date: Thu, 12 Jan 2012 10:55:27 -0600
Message-ID: <CABqD9hZJdQxO4Z=FqiC-ZPF2rNPUG4VO76MAJOnW+LVZYvLVBw@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 8:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/11, Will Drewry wrote:
>>
>> This patch adds support for seccomp mode 2.  This mode enables dynamic
>> enforcement of system call filtering policy in the kernel as specified
>> by a userland task.  The policy is expressed in terms of a BPF program,
>> as is used for userland-exposed socket filtering.  Instead of network
>> data, the BPF program is evaluated over struct user_regs_struct at the
>> time of the system call (as retrieved using regviews).
>
> Cool ;)
>
> I didn't really read this patch yet, just one nit.
>
>> +#define seccomp_filter_init_task(_tsk) do { \
>> +     (_tsk)->seccomp.filter = NULL; \
>> +} while (0);
>
> Cosmetic and subjective, but imho it would be better to add inline
> functions instead of define's.

Refactoring it a bit to make that possible.  Since seccomp fork/init/free
never needs access to the whole task_structs, I'll just pass in what's
needed (and avoid the sched.h inclusion recursion).

Comments on the next round will most definitely be appreciated!

>> @@ -166,6 +167,7 @@ void free_task(struct task_struct *tsk)
>>       free_thread_info(tsk->stack);
>>       rt_mutex_debug_task_free(tsk);
>>       ftrace_graph_exit_task(tsk);
>> +     seccomp_filter_free_task(tsk);
>>       free_task_struct(tsk);
>>  }
>>  EXPORT_SYMBOL(free_task);
>> @@ -1209,6 +1211,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       /* Perform scheduler related setup. Assign this task to a CPU. */
>>       sched_fork(p);
>>
>> +     seccomp_filter_init_task(p);
>
> This doesn't look right or I missed something. something seccomp_filter_init_task()
> should be called right after dup_task_struct(), at least before copy process can
> fail.
>
> Otherwise copy_process()->free_fork()->seccomp_filter_free_task() can put
> current->seccomp.filter copied by arch_dup_task_struct().

Ah - makes sense!  I moved it under dup_task_struct before any goto's
to bad_fork_free.

>> +struct seccomp_filter {
>> +     struct kref usage;
>> +     struct pid *creator;
>
> Why? seccomp_filter->creator is never used, no?

Removing it. It is from a related patch I'm experimenting with (adding
optional tracehook support), but it has no bearing here.

Thanks - new patch revision incoming!
will
