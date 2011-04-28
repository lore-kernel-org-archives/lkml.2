Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab1D1SV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:21:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62042 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933356Ab1D1SVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110428173614.GH1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<20110428151241.GD1798@nowhere>
	<BANLkTika4xn5SajxGbRtszqyA4R=4y8M6Q@mail.gmail.com>
	<20110428161304.GG1798@nowhere>
	<BANLkTikr-ScMsLQG4gpAOkVTHjGBRFvsxg@mail.gmail.com>
	<20110428173614.GH1798@nowhere>
Date: Thu, 28 Apr 2011 13:21:18 -0500
Message-ID: <BANLkTinchyMvwgc=PjMV7k_jt6extmjB_A@mail.gmail.com>
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

On Thu, Apr 28, 2011 at 12:36 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Thu, Apr 28, 2011 at 11:48:47AM -0500, Will Drewry wrote:
>> On Thu, Apr 28, 2011 at 11:13 AM, Frederic Weisbecker
>> <fweisbec@gmail.com> wrote:
>> > On Thu, Apr 28, 2011 at 10:29:11AM -0500, Will Drewry wrote:
>> >> On Thu, Apr 28, 2011 at 10:12 AM, Frederic Weisbecker
>> >> <fweisbec@gmail.com> wrote:
>> >> > Instead of having such multiline filter definition with syscall
>> >> > names prepended, it would be nicer to make the parsing simplier.
>> >> >
>> >> > You could have either:
>> >> >
>> >> >        prctl(PR_SET_SECCOMP, mode);
>> >> >        /* Works only if we are in mode 2 */
>> >> >        prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter);
>> >>
>> >> It'd need to be syscall_name instead of syscall_nr.  Otherwise we're
>> >> right back to where Adam's patch was 2+ years ago :)  Using the event
>> >> names from the syscalls infrastructure means the consumer of the
>> >> interface doesn't need to be confident of the syscall number.
>> >
>> > Is it really a problem?
>>
>> I'd prefer using numbers myself since it gives more flexibility around
>> filtering entries that haven't yet made it into ftrace syscalls hooks.
>> However, I think there's some complexity in ensuring it matches the
>> host kernel.  (It would also allow compat_task support which doesn't
>> seem to be possible now.)
>
> You'd have some problems with compat and syscall naming, I think some
> of them are not the same between compat architectures.
>
> Note that your new prctl() request is turning syscall handler names (in-kernel API)
> into a user ABI. We won't be able to change the name of those kernel handlers
> after that. I'm not sure that's desired.
>
> OTOH, syscall numbers are a user ABI,

Makes sense.  I don't mind going the syscall nr route and using a
library for name resolution in userspace, but other users could just
include the libc provided names.  If it doesn't work, the SIGKILL will
make it apparent pretty quickly :p   I don't think it would be a
problem and it makes the kernel side even simpler again.

>
>
>>
>> > There are libraries that can resolve that. Of course I can't recall their name.
>>
>> asm-generic/unistd.h will provide the mapping, if available. It would
>> mean that any helper libraries would need to be matched to the locally
>> running kernel.
>
> Yeah. But syscall numbers don't move inside a given architecture (could they?)
> Or if so then you'd a dynamic library.

Works for me.

>
>> >> > or:
>> >> >        /*
>> >> >         * If mode == 2, set the filter to syscall_nr
>> >> >         * Recall this for each syscall that need a filter.
>> >> >         * If a filter was previously set on the targeted syscall,
>> >> >         * it will be overwritten.
>> >> >         */
>> >> >        prctl(PR_SET_SECCOMP, mode, syscall_nr, filter);
>> >> >
>> >> > One can erase a previous filter by setting the new filter "1".
>> >> >
>> >> > Also, instead of having a bitmap of syscall to accept. You could
>> >> > simply set "0" as a filter to those you want to deactivate:
>> >> >
>> >> > prctl(PR_SET_SECCOMP, 2, 1, 0); <- deactivate the syscall_nr 1
>> >> >
>> >> > Hm?
>> >>
>> >> I like the simplicity in not needing to parse anything extra, but it
>> >> does add the need for extra state - either a bit or a new field - to
>> >> represent "enabled/enforcing".
>> >
>> > And by the way I'm really puzzled about these. I don't understand
>> > well why we need this.
>>
>> Right now, if you are in seccomp mode !=0 , your system calls will be
>> hooked (if TIF_SECCOMP is set too). The current patch begins filtering
>> immediately.  And once filtering is enabled, the process is not
>> allowed to expand its access to the kernel system cals - only shrink
>> it.  An "enabled" bit would be needed to tell it that even though it
>> is running in mode=2, it should/shouldn't kill the process for system
>> call filter violations and it should allow filters to be added, not
>> just dropped.  It's why the current patch does it in one step: set the
>> filters and the mode.  While an enabled bit could be hidden behind
>> whether TIF_SECCOMP is applied, I'm not sure if that would just be
>> confusing.  There'd still be a need to APPLY_FILTERS to get the
>> TIF_SECCOMP flag set to start hooking the system calls.
>
> It seems the filter is only ever needed for the childs, right?
> And moreover when they exec. So Steve's suggestion to apply
> the filters only after the next exec makes sense.
>
> That would solve the problem of both ON_NEXT_SYSCALL and APPLY_FILTER.
>
> I may be missing something obvious though. Do you see a limitation there?
>
>>
>> > As for the enable_on_next_syscall. The documentation says
>> > it's useful if you want the filter to only apply to the
>> > child. So if fork immediately follows, you will be able to fork
>> > but if the child doesn't have the right to exec, it won't be able
>> > to do so. Same for the mmap() that involves...
>> >
>> > So I'm a bit confused about that.
>>
>> Here's an example:
>>   http://static.dataspill.org/seccomp_filter/v1/seccomp_launcher.c
>>
>> You'd use it by calling fork() ... prctl(..., ON_NEXT_SYSCALL) then
>> execve since you'll already have fork()d.  It seems to work, but maybe
>> I'm missing something :)
>
> Nope, I see.
>
>>
>> > But yeah if that's really needed, it looks to me better to
>> > reduce the parsing and cut it that way:
>> >
>> >        prctl(PR_SET_SECCOMP, 2, syscall_name_or_nr, filter);
>> >        prctl(PR_SECCOMP_APPLY_FILTERS, enable_on_next_syscall?)
>> >
>> > or something...
>>
>> Cool - if there are any other flags, it could be something like:
>>   prctl(PR_SECCOMP_SET_FLAGS, SECCOMP_ENFORCE|SECCOMP_DELAYED_ENFORCEMENT);
>>
>> But only if there are other flags worth considering. I had a few
>> others in mind, but now I've completely forgotten :/
>
