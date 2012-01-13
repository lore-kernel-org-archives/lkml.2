Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2AMTBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:01:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43655 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2AMTBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:01:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120113182422.28e648fb@pyramind.ukuu.org.uk>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jan 2012 11:00:51 -0800
Message-ID: <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:24 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> This still appears to be a bit broken
>
> There are three problems here
>
> 1. I can stop an app changing privs which in some SELinux or APParmour
> cases might mean I prevent it being dropped into a less privileged
> position. That's something only the security policy knows.
>
> So for SELinux and Apparmour and the like in some situations you are
> potentially adding a security hole. That one seems hard to fix unless you
> fail the exec if it causes a security transition, as opposed to just
> keeping the old one. For non change cases we can however still pass the
> filter on, which is the usual sane case.

SELinux can already control this via exec_no_trans.

Changing it to fail the exec when a transition would occur will make
seccomp considerably less useful to selinux users -- the presence of
MAC policy on a program (regardless of what that policy is) will make
it unusable inside a sandbox.

<rant>This is exactly why I think that changing security context on
execve() is an awful idea.  If administrators and distros want to
define fancy contexts, fine.  But programs should *ask* to enter the
contexts.  (This would be easy enough with some glibc / libselinux
magic.)  And the use of MAC should not prevent the use of IMO
considerably more secure user-controlled sandbox technologies.
execve_nosecurity was my first attempt to fix it without hitting this
issue.</rant>

>
> 2. ptrace
>
> You neeed to also stop ptrace otherwise the locked down process can use
> ptrace to proxy its activity via another task with the same uid. That's
> easy enough to add fortunately.
>
> 3. file access
>
> You have the same attacks via patching files of running apps etc. In the
> intended circumstances I'm not sure this matters or is cleanly fixable.
> It's the point at which you need a real system wide policy and SELinux
> etc anyway.

I disagree, but maybe this is a sign that no_new_privs is a bad name.
no_new_privs is not intended to be a sandbox at all -- it's a way to
make it safe for a task to manipulate itself in a way that would allow
it to subvert its own children (or itself after execve).  So ptrace
isn't a problem at all -- PR_SET_NO_NEW_PRIVS + chroot + ptrace is
exactly as unsafe as ptrace without PR_SET_NO_NEW_PRIVS.  Neither one
allows privilege escalation beyond what you started with.

If you want a sandbox, call PR_SET_NO_NEW_PRIVS, then enable seccomp
(or whatever) to disable ptrace, evil file access, connections on unix
sockets that authenticate via uid, etc.  (IMO MAC has no place here --
maybe we need a new buzzword like "Voluntary Access Control".)

--Andy
