Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2AMTjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:39:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51472 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2AMTj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:39:28 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com> <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jan 2012 11:39:06 -0800
Message-ID: <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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

On Fri, Jan 13, 2012 at 11:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 13, 2012 at 11:00 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Changing it to fail the exec when a transition would occur will make
>> seccomp considerably less useful to selinux users -- the presence of
>> MAC policy on a program (regardless of what that policy is) will make
>> it unusable inside a sandbox.
>
> I don't agree. I think that's exactly what we want sandboxing for, to
> avoid any kind of subtle security issues.
>
> And in 99.99% of all sandboxes, you would never ever want to execute
> something with a different MAC policy on it. In fact, most of the
> whole point of the sandboxing tends to be to make sure that the user
> stays inside the exact *small* environment that was provided just for
> that thing.

Some day I want to run entire fancy desktop apps inside
non-root-controlled sandboxes.  We're not there yet, but we're not
*that* far.  Also, running things like MATLAB inside a chroot or mount
namespace is very useful (I've done it -- there are MATLAB programs
with remarkable dependencies on very particular versions of system
libraries), and being able to do it without custom setuid wrappers to
set everything up would be nice.

>
> So I bet the google chrome people are not at all interested in
> "running random binaries", and might want execve() very much for
> "running some specific binaries that we ship with or install from the
> browser".

I want to be able to run "magic_seccomp_sandbox gv somefile.ps".  And
I want that to still work even if my distro gets fancy and uses
selinux policy to prevent gv from accessing the network (which would
not be an unreasonable thing to do).  The chromium project already has
a little seccomp wrapper that can (sort of) do this.

>
> So I really think that the *only* valid model is the "fail the execve
> on any changes", not the "mnt-nosuid" approach of trying to run things
> with the wrong permissions and get perhaps odd results. And I think it
> works even - and perhaps *especially* - in models like selinux or
> apparmor that do have a lot of "implicit MAC knowledge" on specific
> binaries.

Is the current exec_no_trans check enough for you?  With my patch,
selinux can already block the execve if it wants.  (The policy is the
same as it would be if a program explicitly asked to run the new
executable with an unchanged security context.)  I'd be happy to fail
the exec in AppArmor, and then maybe AppArmor will change its mind
if/when users get annoyed :)

--Andy
