Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2ARVNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:13:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60417 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2ARVNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <fbc1f44dffce6079fa7ec827c1b1e40e.squirrel@webmail.greenhost.nl>
References: <20120116183730.GB21112@redhat.com>
	<CABqD9hY3DtOqBWDofMQhHNKeUbz4ebfOENKVJkqE+AjRqZFkZA@mail.gmail.com>
	<20120117164523.GA17070@redhat.com>
	<CABqD9hYZ4yX76EaWgm2G8HuKgYPMxcxWRTHEazmxWNFL-mgY2A@mail.gmail.com>
	<CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>
	<20120117170512.GB17070@redhat.com>
	<CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
	<49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
	<20120118015013.GR11715@one.firstfloor.org>
	<20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
	<20120118022217.GS11715@one.firstfloor.org>
	<fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
	<CAMnK33UzmQ-PdgAovmX9Q9JB5gKxw0mmLt0TZwK7xnWPWCqUzA@mail.gmail.com>
	<fbc1f44dffce6079fa7ec827c1b1e40e.squirrel@webmail.greenhost.nl>
Date: Wed, 18 Jan 2012 13:13:02 -0800
Message-ID: <CAMnK33WAUA7bNFKA8BmLHq9+sdMV9xeOvZ8T1iZSH1GFKNe3ZQ@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!? [was: Re:
 [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF]
From: Chris Evans <scarybeasts@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 4:12 AM, Indan Zupancic <indan@nul.nu> wrote:
> On Wed, January 18, 2012 06:43, Chris Evans wrote:
>>> As far as I know, we fixed all races except symlink races caused by malicious
>>> code outside the jail.
>>
>> Are you sure? I've remembered possibly the worst one I encountered,
>> since my previous e-mail to Jamie:
>>
>> 1) Tracee is compromised; executes fork() which is syscall that isn't allowed
>
> How do you mean compromised? Tracees aren't trusted by definition. And fork is
> allowed in our jail, we're ptracing all tasks within the jail.

Right, the tracee isn't trusted because you're worried it _might_ get
compromised.
If it _does_ get compromised, you don't want it playing various tricks
to break our of the ptrace() sandbox.

>
>> 2) Tracee traps
>> 2b) Tracee could take a SIGKILL here
>> 3) Tracer looks at registers; bad syscall
>> 3b) Or tracee could take a SIGKILL here
>> 4) The only way to stop the bad syscall from executing is to rewrite
>> orig_eax (PTRACE_CONT + SIGKILL only kills the process after the
>> syscall has finished)
>
> Yes, we rewrite it to -1.
>
>> 5) Disaster: the tracee took a SIGKILL so any attempt to address it by
>> pid (such as PTRACE_SETREGS) fails.
>
> I assume that if a task can execute system calls and we get ptrace events
> for that, that we can do other ptrace operations too. Are you saying that
> the kernel has this ptrace gap between SIGKILL and task exit where ptrace
> doesn't work but the task continues executing system calls? That would be
> a huge bug, but it seems very unlikely too, as the task is stopped and
> shouldn't be able to disappear till it is continued by the tracer.
>
> I mean, really? That would be stupid.
>
> If true we have to work around it by disallowing SIGKILL and just sending
> them ourselves within the jail. Meh.
>
>> 6) Syscall fork() executes; possible unsupervised process now running
>> since the tracer wasn't expecting the fork() to be allowed.
>
> We use PTRACE_O_TRACEFORK (or replace it with clone and set CLONE_PTRACE
> for 2.4 kernels. Yes, I check for CLONE_UNTRACED in clone calls.)
>
>>
>> All this ptrace() security headache is why vsftpd is waiting for
>> Will's seccomp enhancements to hit the kernel. Then they will be used
>> pronto.
>
> How will you avoid file path races with BPF?

There is typically no need for file-path based access control in an FTP server.
Take for example anonymous FTP, which will typically be inside a
chroot() to /var/ftp. Inside that filesystem tree -- if you can open()
it, you can have it.


Cheers
Chris

>
> Greetings,
>
> Indan
>
>
