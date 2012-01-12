Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2ALSTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 13:19:21 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47138 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988Ab2ALSTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 13:19:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
 <1326385635.7642.89.camel@gandalf.stny.rr.com> <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 10:18:55 -0800
X-Google-Sender-Auth: nYQpKWIZqK1cvnpHIETr65rzUr8
Message-ID: <CAObL_7HE6_NE79tKASQcAxyvCS_7L=vMqfjvZDbCe99pa2t8Wg@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Will Drewry <wad@chromium.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 9:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 12, 2012 at 8:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> In that case, just have execv fail if filtering is enabled and we are
>> execing a setuid program. But I don't see why non "magical" execv's
>> should be prohibited.
>
> The whole "fail security escalations" thing goes way beyond just
> filtering, I think we could seriously try to make it a generic
> feature.
>
> For example, somebody just asked me the other day why "chroot()"
> requires admin privileges, since it would be good to limit even
> non-root things.
>
> And it's really the exact same issue as filtering: in some sense,
> chroot() "filters" FS name lookups, and can be used to fool programs
> that are written to be secure.
>
> We could easily introduce a per-process flag that just says "cannot
> escalate privileges". Which basically just disables execve() of
> suid/sgid programs (and possibly other things too), and locks the
> process to the current privileges. And then make the rule be that *if*
> that flag is set, you can then filter across an execve, or chroot as a
> normal user, or whatever.

Like this?

http://lkml.indiana.edu/hypermail/linux/kernel/1003.3/01225.html

(This depends on execve_nosecurity, which is controversial, but that
dependency would be trivial to remove.)

Note that there's a huge can of worms if execve is allowed but
suid/sgid is not: selinux may elevate privileges on exec of pretty
much anything.  (I think that this is a really awful idea, but it's in
the kernel, so we're stuck with it.)

--Andy
