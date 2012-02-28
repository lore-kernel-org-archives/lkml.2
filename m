Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2B1Hwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:52:33 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46894 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015Ab2B1Hwb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:52:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.60.12.103 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <b983ece9dc6209269876869188303518.squirrel@webmail.greenhost.nl>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-6-git-send-email-wad@chromium.org>
	<b983ece9dc6209269876869188303518.squirrel@webmail.greenhost.nl>
Date: Mon, 27 Feb 2012 23:52:28 -0800
X-Google-Sender-Auth: 3gWUxgLwgmdAUz4VIQMHCG3S9po
Message-ID: <CAGXu5j+ZsP1q97=-DKxbyteNtX6zcw1LLWnKbTSKW90LN-_FHQ@mail.gmail.com>
Subject: Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
From: Kees Cook <keescook@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 10:51 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Sat, February 25, 2012 04:21, Will Drewry wrote:
>> @@ -169,6 +170,7 @@ void free_task(struct task_struct *tsk)
>>       free_thread_info(tsk->stack);
>>       rt_mutex_debug_task_free(tsk);
>>       ftrace_graph_exit_task(tsk);
>> +     put_seccomp_filter(tsk->seccomp.filter);
>>       free_task_struct(tsk);
>> }
>> EXPORT_SYMBOL(free_task);
>> @@ -1113,6 +1115,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>               goto fork_out;
>>
>>       ftrace_graph_init_task(p);
>> +     copy_seccomp(&p->seccomp, &current->seccomp);
>
> I agree it's more symmetrical when get_seccomp_filter() is used here
> directly instead of copy_seccomp(). That should put Kees at ease.

Yeah, that does feel more symmetrical.

>> +static void seccomp_filter_log_failure(int syscall)
>> +{
>> +     int compat = 0;
>> +#ifdef CONFIG_COMPAT
>> +     compat = is_compat_task();
>> +#endif
>> +     pr_info("%s[%d]: %ssystem call %d blocked at 0x%lx\n",
>> +             current->comm, task_pid_nr(current),
>> +             (compat ? "compat " : ""),
>> +             syscall, KSTK_EIP(current));
>> +}
>
> This should be at least rate limited, but could be dropped altogether,
> as it's mostly useful for debugging filters. There is no kernel message
> when a process is killed because it exceeds a ulimit either. The death
> by SIGSYS is hopefully clear enough for users, and filter writers can
> return different errno values when debugging where it goes wrong.

I've already sent a patch to take care of this. It was redundant with
the later call to audit_seccomp() on the exit path.
https://lkml.org/lkml/2012/2/26/70
https://lkml.org/lkml/2012/2/27/369

>> @@ -48,6 +308,14 @@ void __secure_computing(int this_syscall)
>>                               return;
>>               } while (*++syscall);
>>               break;
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +     case SECCOMP_MODE_FILTER:
>> +             if (seccomp_run_filters(this_syscall) == SECCOMP_RET_ALLOW)
>> +                     return;
>> +             seccomp_filter_log_failure(this_syscall);
>> +             exit_code = SIGSYS;
>
> Wouldn't it make more sense to always kill with SIGSYS, also for mode 1?
> I suppose it's too late for that now.

Right, this should (somewhat unfortunately) stay SIGKILL for mode 1.

-Kees

-- 
Kees Cook
ChromeOS Security
