Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1BAO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:58:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64490 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1BAO6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:58:16 -0500
MIME-Version: 1.0
In-Reply-To: <1294867725.3237.230.camel@localhost.localdomain>
References: <1294867725.3237.230.camel@localhost.localdomain>
Date: Tue, 1 Feb 2011 09:58:13 -0500
Message-ID: <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Eric Paris <eparis@parisplace.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, agl@google.com,
        fweisbec@gmail.com, tzanussi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
> Some time ago Adam posted a patch to allow for a generic seccomp
> implementation (unlike the current seccomp where your choice is all
> syscalls or only read, write, sigreturn, and exit) which got little
> traction and it was suggested he instead do the same thing somehow using
> the tracing code:
> http://thread.gmane.org/gmane.linux.kernel/833556
> The actual method that this could be achieved was apparently left as an
> exercise for the reader.  Since I'd like to do something similar (and
> actually basically reimplemented Adam's code before I found this thread)
> I guess that makes me the reader.  I've never touched
> perf/ftrace/whatever so I'm not even knowledgeably enough to ask good
> questions so please, try to talk to me like a 2 year old.
>
> I started playing a bit having no idea where to start decided to see
> where something like:
> perf stat -e syscalls:sys_enter_read -e syscalls:sys_enter_write -- ./seccomp_test
> Ended up in the kernel.  It ended up I saw in perf_syscall_enter().  So
> I decided to do a little hacking and added this little patch segment:
>
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index bac752f..6653995 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -495,8 +495,12 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
>        int size;
>
>        syscall_nr = syscall_get_nr(current, regs);
> -       if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
> +
> +       if (!test_bit(syscall_nr, enabled_perf_enter_syscalls)) {
> +               if (current->seccomp.mode == 2)
> +                       do_exit(SIGKILL);
>                return;
> +       }
>
>        sys_data = syscall_nr_to_meta(syscall_nr);
>        if (!sys_data)
>
> Which appears to be a necessary, but not sufficient, requirement, since
> another unrelated task could also have a 'watch?' on other syscalls.  So
> I hacked in this little PoS into the filter code.
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index eac7e33..d8c1c8f 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4780,15 +4780,19 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
>                .size = entry_size,
>                .data = record,
>        };
> +       int found = 0;
>
>        perf_sample_data_init(&data, addr);
>        data.raw = &raw;
>
>        hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
> -               if (perf_tp_event_match(event, &data, regs))
> +               if (perf_tp_event_match(event, &data, regs)) {
> +                       found = 1;
>                        perf_swevent_event(event, count, 1, &data, regs);
> +               }
>        }
> -
> +       if (current->seccomp.mode == 2 && !found)
> +               do_exit(SIGKILL);
>        perf_swevent_put_recursion_context(rctx);
>  }
>  EXPORT_SYMBOL_GPL(perf_tp_event);
>
> Which seems to get me a 'working' version of generic seccomp on top of
> ftrace.  Problem is it makes me feel dirty, I'm logging a bunch of trace
> stuff I don't care about, and I'm sure its being done wrong 1001 ways.
> I know that do_exit(SIGKILL) is actually really wrong since it ends up
> giving me this crap (but i don't know how to do it better from there)
>
> note: seccomp-test[2485] exited with preempt_count 1
> BUG: sleeping function called from invalid context at kernel/rwsem.c:21
>
> So, finally, onto the question.  How would you guys do it?  The tracing
> code seems to me to be built on the idea of recording information on a
> very small limited set of events, not blocking access on the complement
> of a small limited set of events.
>
> I'm not seeing how the tracing code is better than the generic seccomp
> code that Adam wrote, but hopefully someone can enlighten me as to how
> this can be done reasonably.  I need all the guidance you can offer
> because I don't really see what next steps should be!

Ping tracing people.  I'm not seeing steps forward.  At this point I'm
going to start looking at Adam's code again.  I can think of a couple
of cleanups and simplifications to his code.  I just don't see how
using tracing is supposed to work better.....

-Eric
