Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2ANVEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:04:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50456 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab2ANVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
 <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
 <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 14 Jan 2012 13:04:21 -0800
X-Google-Sender-Auth: E_gJYpg4xAGcXihs6wjEDolOVeQ
Message-ID: <CAObL_7F2p30P6_VwfBAZVVR-n6JVacrUX-Y1XNzBMMkyq_V0Aw@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 12:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We've had security bugs that were *due* to dropped capabilities -
> people dropped one capability but not another, and fooled code into
> doing things they weren't expecting it to do. So quite frankly, I
> believe that from a security standpoint it's a hell of a lot safer to
> just keep the rules really simple.
>

Which is the point of this patch.  If suid/sgid/file caps/LSM
transitions are disabled, you can't exploit thinks like sendmail
because they don't have any special privileges to exploit.

>
> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
> that no, we should not even allow that. It's simply all too "subtle".
>
> (I don't think Andrew's patch actually touched any of those paths, but
> I didn't check)

Correct.  I did not touch any of these paths.  I think that's the
right choice for at least three reasons:

1. If there's an exploit that does PR_SET_NO_NEW_CAPS, then
setuid/capset/whatever, then runs something and exploits it, it is
likely to work just as will if setuid/capset is called before
PR_SET_NO_NEW_CAPS.

2. Even if I made that change, it wouldn't help.  You can always
simulate dropping capabilities with LD_PRELOAD or something like
seccomp mode 2.  The secure exec stuff that happens when you execve
something with the setuid bit set won't prevent it because the setuid
bit is *disabled* in this mode.  (Again, there is no exploit here --
there are no new privileges to steal.)

3. Simplicity.  It would be easy to miss something subtle.  There's
the dumpable bit and however it interacts with ptrace (especially on
Ubuntu, which seems to have a patched kernel with different rules),
there's capset, there's file capabilities (which can, I think, drop
capabilities as well as adding them), there's cap_bset, securebits,
etc.  Leaving them all alone means I don't need to worry about bitrot
or about missing one.


I'm tempted to submit a followup patch to allow unprivileged users to
use some of the sys_unshare modes if no_new_privs is set so we can
have an example use case.  CLONE_NEWIPC, CLONE_SYSVSEM, and
CLONE_NEWUTS would be a decent start, I think, and the patch would be
trivial.

--Andy
