Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2ANTVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:21:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32798 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2ANTVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:21:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
	<CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
	<CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
	<CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
	<CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
	<20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
Date: Sat, 14 Jan 2012 13:21:03 -0600
Message-ID: <CABqD9hbTyBcerviYLkvf0PrVMrEam0cM9_FPckBgE8v_8C_Y4w@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
From: Will Drewry <wad@chromium.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 7:30 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Linus Torvalds wrote:
>> On Thu, Jan 12, 2012 at 5:11 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> >
>> > What if you're a daemon that needs something like CAP_NET_BIND but
>> > also wants to be able to run other helpers without CAP_NET_BIND?
>> >
>> > (Also, preventing dropping of privileges will probably make a patch
>> > more complicted -- I'll have to find and update all the places that
>> > allow dropping privileges.)
>>
>> Hey, if it actually makes it more complicated to say "don't change
>> privileges", then I guess my argument that it should be simpler is
>> wrong.
>>
>> That said, the thing you bring up is *not* the actual use-case for the
>> suggestion. The use-case is a "run untrusted code". So the use-case
>> would be to set the flag after you've dropped CAP_NET_BIND, and
>> *before* you actually run the other helpers. You clearly must have a
>> fork() or something like that there, since you want to keep the
>> NET_BIND in the original daemon.
>
> Well suppose you don't trust the daemon either.  It might be running
> in a network namespace where it's safe for untrusted code to bind to
> low ports.
>
> Or maybe you just need to let it bind willy-nilly among a restricted
> subset of low ports - which of course you would like to restrict with
> the seccomp filter.

Unless the port values are the register arguments, seccomp filter
won't help.  It can be used to incrementally drop available system
calls (like socketcall(SYS_LISTEN) or whatever).

> (This can't happen right now because the filter can only look at
> arguments, not memory pointed to - so it can't look at the port
> number.  Can it even see when sys_bind is called on archs like x86
> that use sys_socketcall?!)

Yeah - multiplexed system calls like ipc and socketcall can be filtered
based on the argument value in the register. (socketcall's first argument is
"call".)

> Anyway the principle is there - CAP_NET_BIND doesn't necessarily mean
> the daemon code is trusted.

I think we're comparing apples to oranges. I believe the current proposal is a
bit that says "hey! I'm sandboxed!".   Defensive programming that is often
achieved through continued reduction of capabilities is important, but
orthogonal.  In that model, only once the last vestige of "privilege" is dropped
would the process  set the no_new_privs bit.  Until then, you rely on the
other access contol pieces you've put in place: namespacing, etc.

While I am a fan of capabilities systems, it would be very cool to have a
bottom floor, privilege-freezer which could help against some classes of
sandbox escapes.

cheers!
will
