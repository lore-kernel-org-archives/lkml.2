Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2LDWoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:44:55 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:22584 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2LDWoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:44:54 -0500
Message-ID: <743c03cb8deee5e2f4533d4ddc784383.squirrel@mail.sublimeip.com>
In-Reply-To: <20121204175933.GA11537@redhat.com>
References: <20121125225533.GA24905@redhat.com>
    <20121125234834.DAC34592076@miso.sublimeip.com>
    <20121202193058.GA4264@redhat.com>
    <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com>
    <20121204175933.GA11537@redhat.com>
Date: Wed, 5 Dec 2012 09:44:51 +1100
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
From: u3557@miso.sublimeip.com
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: u3557@miso.sublimeip.com, "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Pedro Alves" <palves@redhat.com>,
        "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Reply-To: mosix@mosix.com.au
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Oleg,

> Yes, I understand, so DR_RW_EXECUTE should probably work. And I even
> sent the patch (untested/uncompiled). But given that even the simple
> bugfix which started this thread was ignored by maintainers, I am
> not sure how we can convince them this change makes sense ;)

Just to confirm, DR_RW_EXECUTE won't only "probably" work - it DOES work,
I have tested it.

A fully super-duper automatic and transparent emulation of PTRACE_SYSCALL,
including the faking of user-registers, would undoubtedly be great, but
it's complex and will require a large patch, while here is a trivial 1-2
line fix which doesn't harm anyone and allows ptracers to trap a vsyscall
in no time.

> But If we want to allow to trace vsyscall's, hw bp doesn't look very
> nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them all.

The next solution in line, in terms of patch-size, if we don't want to
waste debug registers, is to have the execute permission of the vsyscall
page changed on context switches when a process/ptracer requests so, in a
manner similar to prctl(PR_SET_TSC).

Best Regards,
Amnon.

>>
>> > However. Of course it would be nice to avoid the new option. IMO it
>> > would be better to do nothing ;) vsyscall is deprecated, and EMULATE
>> > is x86-specific.
>>
>> The problem is that the current static glibc invokes the vsyscall page,
>
> Yes I know.
>
> Still I'd like to avoid to change the ptrace API, even if the change is
> simple. This emulate_vsyscall() is too "exotic" imho.
>
>> > You forgot again that EMULATE does not execute the code in the
>> > vsyscall page.
>>
>> The beauty of using the x86 debug-registers, is that they do not
>> trap the instruction, but rather the fact that the program-counter
>> has a given value.
>
> Yes, I understand, so DR_RW_EXECUTE should probably work. And I even
> sent the patch (untested/uncompiled). But given that even the simple
> bugfix which started this thread was ignored by maintainers, I am
> not sure how we can convince them this change makes sense ;)
>
> However. This looks like a hack to me, because this code is never
> executed. But this is sudjective and I am not saying this can't work.
> And yes, this doesn't add new ptrace hacks.
>
>
>
> But If we want to allow to trace vsyscall's, hw bp doesn't look very
> nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them all.
>
> And what about strace? It won't be easy to change it to use hwbp.
>
>
> That is why I think PTRACE_SYSCALL should "simply work" somehow. And
> so far I think that "just report syscall_exit with orig_ax = -1" is
> the best (and simple) solution.
>
> OK. We can do more. We can report both syscall_enter/exit and we can
> change orig_ax/ax temporary to "fool" the tracer, so that everything
> will look as a "normal" syscall. Like vsyscall_seccomp() does.
>
> But this needs much more changes.
>
> Oleg.
>
>


