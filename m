Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2AMBRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:17:53 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37470 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2AMBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com> <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 17:17:31 -0800
X-Google-Sender-Auth: GfMrP_gSIG1Rln01NxLNz86yk9o
Message-ID: <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Andrew Lutomirski <luto@mit.edu>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:11 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> What if you're a daemon that needs something like CAP_NET_BIND but
> also wants to be able to run other helpers without CAP_NET_BIND?
>
> (Also, preventing dropping of privileges will probably make a patch
> more complicted -- I'll have to find and update all the places that
> allow dropping privileges.)

Hey, if it actually makes it more complicated to say "don't change
privileges", then I guess my argument that it should be simpler is
wrong.

That said, the thing you bring up is *not* the actual use-case for the
suggestion. The use-case is a "run untrusted code". So the use-case
would be to set the flag after you've dropped CAP_NET_BIND, and
*before* you actually run the other helpers. You clearly must have a
fork() or something like that there, since you want to keep the
NET_BIND in the original daemon.

So I don't t think your example is actually the expected situation.
The obvious approach for your example is
 - run deamon with CAP_NET_BIND
 - per connection, fork, drop privileges in child, then set
"restricted" flag, and run the untrusted code.

(where the restricted mode setting may well obviously also do other
things - like limit allowed system calls etc)

                      Linus
