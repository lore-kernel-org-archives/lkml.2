Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2ALTIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:08:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35195 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2ALTIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:08:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7GXw8XpVHJrBABUQt9u9pXFDnzUP3nxagS1+g7tPE1kew@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
 <1326385635.7642.89.camel@gandalf.stny.rr.com> <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
 <CAObL_7HE6_NE79tKASQcAxyvCS_7L=vMqfjvZDbCe99pa2t8Wg@mail.gmail.com>
 <CA+55aFwLoOT-5oRn0k9oErAhTW4hT0_-bMXsn-mf00zcxmHheQ@mail.gmail.com> <CAObL_7GXw8XpVHJrBABUQt9u9pXFDnzUP3nxagS1+g7tPE1kew@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Thu, 12 Jan 2012 14:08:18 -0500
Message-ID: <CAGZ=bq+E3PFm8aZ1eaJaLnHK2dL_nxKBJ_F6MDR-uON+6T-87A@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 13:44, Andrew Lutomirski <luto@mit.edu> wrote:
> On Thu, Jan 12, 2012 at 10:32 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Thu, Jan 12, 2012 at 10:18 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> Like this?
>>>
>>> http://lkml.indiana.edu/hypermail/linux/kernel/1003.3/01225.html
>>
>> I don't know the execve_nosecurity patches, so the diff makes little
>> sense to me, but yeah, I wouldn't expect it to be more than a couple
>> of lines. Exactly *how* you set the bit etc is not something I care
>> deeply about, prctl seems about as good as anything.
>>
>>> Note that there's a huge can of worms if execve is allowed but
>>> suid/sgid is not: selinux may elevate privileges on exec of pretty
>>> much anything.  (I think that this is a really awful idea, but it's in
>>> the kernel, so we're stuck with it.)
>>
>> You can do any amount of crazy things with selinux, but the other side
>> of the coin is that it would also be trivial to teach selinux about
>> this same "restricted environment" bit, and just say that a process
>> with that bit set doesn't get to match whatever selinux privilege
>> escalation rules..
>>
>> I really don't think this is just about "execve cannot do setuid". I
>> think it's about the process being marked as restricted.
>>
>> So in your patch, I think that "PR_RESTRICT_EXEC" bit is wrong. It
>> should simply be "PR_RESTRICT_ME", and be done with it, and not try to
>> artificially limit it to be some "execve feature", and more think of
>> it as a "this is a process that has *no* extra privileges at all, and
>> can never get them".
>
> execve_nosecurity was my attempt to sidestep selinux issues.  It's a
> different syscall that does all of the non-security-related things
> that execve does but does not escalate (or even change) any
> privileges.  Maybe I'll try to rework that for newer kernels as well.
> The idea is that programs that expect to run in sandboxes / chroots /
> namespaces / whatever can use it, and older programs that might
> malfunction dangerously if the semantics of execve change will just
> fail instead.

I don't see any issues with SELinux support for this feature.

Specifically, when you try to execute something in SELinux, it will
first look at the types and try to "execute" (involving a type
transition IE: security label change).

But if that fails in many cases it may still be allowed to
"execute_no_trans" (IE: regular non-privileged exec() without a
transition).

If you add this feature, it should just disable the normal "execute"
with transition path and unconditionally fall back to
"execute_no_trans".

Likewise, enabling these bits should also disable the "transition" and
"dyntransition" process access vectors, and I'm on the fence about
whether "setfscreate", etc should be allowed.

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
