Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2ANNbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 08:31:38 -0500
Received: from mail2.shareable.org ([80.68.89.115]:33479 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2ANNbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 08:31:34 -0500
Date: Sat, 14 Jan 2012 13:30:53 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
Message-ID: <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
 <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, Jan 12, 2012 at 5:11 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> >
> > What if you're a daemon that needs something like CAP_NET_BIND but
> > also wants to be able to run other helpers without CAP_NET_BIND?
> >
> > (Also, preventing dropping of privileges will probably make a patch
> > more complicted -- I'll have to find and update all the places that
> > allow dropping privileges.)
> 
> Hey, if it actually makes it more complicated to say "don't change
> privileges", then I guess my argument that it should be simpler is
> wrong.
> 
> That said, the thing you bring up is *not* the actual use-case for the
> suggestion. The use-case is a "run untrusted code". So the use-case
> would be to set the flag after you've dropped CAP_NET_BIND, and
> *before* you actually run the other helpers. You clearly must have a
> fork() or something like that there, since you want to keep the
> NET_BIND in the original daemon.

Well suppose you don't trust the daemon either.  It might be running
in a network namespace where it's safe for untrusted code to bind to
low ports.

Or maybe you just need to let it bind willy-nilly among a restricted
subset of low ports - which of course you would like to restrict with
the seccomp filter.

(This can't happen right now because the filter can only look at
arguments, not memory pointed to - so it can't look at the port
number.  Can it even see when sys_bind is called on archs like x86
that use sys_socketcall?!)

Anyway the principle is there - CAP_NET_BIND doesn't necessarily mean
the daemon code is trusted.

-- Jamie
