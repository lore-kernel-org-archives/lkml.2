Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2ASA3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:29:24 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37370 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2ASA3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:29:18 -0500
Message-ID: <00bf0264d35a5bd69294b0f3a79d37ff.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120118170006.GA16835@redhat.com>
References: <CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
    <20120117170512.GB17070@redhat.com>
    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
    <20120118015013.GR11715@one.firstfloor.org>
    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
    <20120118022217.GS11715@one.firstfloor.org>
    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
    <CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
    <20120118170006.GA16835@redhat.com>
Date: Thu, 19 Jan 2012 01:29:04 +0100
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: "Indan Zupancic" <indan@nul.nu>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Chris Evans" <scarybeasts@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Jamie Lokier" <jamie@shareable.org>,
        "Andrew Lutomirski" <luto@mit.edu>, "Will Drewry" <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        "Roland McGrath" <mcgrathr@chromium.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 1.4
X-Scan-Signature: a2d32f98be707cbcda8602d5fffa976a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, January 18, 2012 18:00, Oleg Nesterov wrote:
> On 01/17, Chris Evans wrote:
>>
>> 1) Tracee is compromised; executes fork() which is syscall that isn't allowed
>> 2) Tracee traps
>> 2b) Tracee could take a SIGKILL here
>> 3) Tracer looks at registers; bad syscall
>> 3b) Or tracee could take a SIGKILL here
>> 4) The only way to stop the bad syscall from executing is to rewrite
>> orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
>> syscall has finished)
>> 5) Disaster: the tracee took a SIGKILL so any attempt to address it by
>> pid (such as PTRACE_SETREGS) fails.
>> 6) Syscall fork() executes; possible unsupervised process now running
>> since the tracer wasn't expecting the fork() to be allowed.
>
> As for fork() in particular, it can't succeed after SIGKILL.

That was sadly exactly the system call I used for testing my code...

> But I agree, probably it makes sense to change ptrace_stop() to check
> fatal_signal_pending() and do do_group_exit(SIGKILL) after it sleeps
> in TASK_TRACED. Or we can change tracehook_report_syscall_entry()
>
> 	-	return 0;
> 	+	return !fatal_signal_pending();
>
> (no, I do not literally mean the change above)
>
> Not only for security. The current behaviour sometime confuses the
> users. Debugger sends SIGKILL to the tracee and assumes it should
> die asap, but the tracee exits only after syscall.

I didn't expect the tracer to die asap when sending SIGKILL, but I
did for PTRACE_KILL.

Improving this behaviour is highly appreciated, thanks!

Greetings,

Indan


