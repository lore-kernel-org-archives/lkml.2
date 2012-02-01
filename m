Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2BAK5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:57:06 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:48021 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2BAK5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:57:02 -0500
Message-ID: <a5a8d08602ae5eb3bf9191e433136a91.squirrel@webmail.greenhost.nl>
In-Reply-To: <CABqD9ha4x0_YmWjv-h6GmimCk21UARO9u7AqLkXivffDv6vPVg@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
    <1327706681-11959-2-git-send-email-wad@chromium.org>
    <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
    <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
    <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
    <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
    <8a37c5805a9941a8616f1c28245a0880.squirrel@webmail.greenhost.nl>
    <CABqD9hYpiDtCM5gPgjjHOJ6DcFs-HHUORAGi+AMFs1+9EAk1UA@mail.gmail.com>
    <bd6c07e54f2a86916550f69013e4dcc6.squirrel@webmail.greenhost.nl>
    <CABqD9ha4x0_YmWjv-h6GmimCk21UARO9u7AqLkXivffDv6vPVg@mail.gmail.com>
Date: Wed, 1 Feb 2012 11:56:33 +0100
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Will Drewry" <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 4868b52b90b9144be14ceb212c82ef23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, February 1, 2012 10:02, Will Drewry wrote:
> Hrm.  It'd be the addition of a return value which is essentially an
> expansion of the possible filters.  It wouldn't make the existing
> filters any less valid -- it's just that they wouldn't return errors.

True, but there will be a gap of who knows how many years where people
try to run new filters on older (stable) kernels without return support.
It's just an extra cost on top of supporting BPF at all, and creating
filters isn't easy enough that creating another version if the return
one doesn't work is exactly fun.

> However, I realize there's a desire to have all the pieces in place
> upfront. I'll see how much work this really pans out to being. On x86,
> it's easy.  Some other arches, a little less so, but probably not too
> bad.

Please send the updated basic and consolidated version first, I'd like to
see how it ended up looking like.

> That's roughly how it is on x86 now except seccomp is after all the
> slow-path copy stuff.  It'd be cool to bump it up in front of that
> work then pass through its return value.  I'll poke around at this and
> look at the use of __secure_computing on the other arches to make sure
> I understand the impact.  Maybe it is easier than I first thought it'd
> be.

Normal seccomp can be in the fast path, but I thought you need to go
through the slow path to have the registers saved at all sometimes.
I would prefer not slowing down the fast path with seccomp stuff.

> True.  I'm not quite sure that it makes sense to have the BPF program
> decide what the tracer sees or doesn't see.

Only if ptrace agrees, with setting a special option. (And if multiple
filters are installed, they all have to set the ignore flag before ptrace
doesn't see it.)

> I can see it as a nice
> optimization for a sandbox implementation, but I could see something
> similar being done purely by letting a tracer catch disallowed
> syscalls (possibly via it registering an option indicating it wants
> seccomp_events).

If filters can't return errors, tracers never get to see disallowed events.
So all they can do is allow it and let the pracer block it. If you add a
ptrace option to overrule seccomp decisions, then ptrace and seccomp only
get more tangled without much gain.

> It wouldn't be quite as flexible, but it would avoid
> the simple filter becoming a more complex piece of logic and if a
> returned error were allowed (that didn't trigger ptrace), you'd not
> see a ridiculous amount of overhead from pointless syscalls.  I'm not
> sure though.

It's not just that, it's also that not all filters want to kill the task
when it tries to do make a forbidden system call. BPF is more flexible
than the very limited and controlled original seccomp.

> I'll poke at the ptrace bits too and see if one approach seems to fit
> better than another.

Let's do it step by step. That the final patch may have all features
doesn't mean you have to write it all at once. So first get the next
version out, then focus on supporting more archs and see how hard it
would be to have an error return.

Greetings,

Indan


