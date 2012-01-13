Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2AMUGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:06:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53507 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab2AMUGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <20120113164547.GA22061@redhat.com> <20120113182422.28e648fb@pyramind.ukuu.org.uk>
 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
 <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com> <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jan 2012 12:05:55 -0800
Message-ID: <CALCETrU=7Xs_Kf1d45=68zbXCkjLVTs9+fUFg58ZZTQZfHZ_1A@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 11:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 13, 2012 at 11:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Is the current exec_no_trans check enough for you?  With my patch,
>> selinux can already block the execve if it wants.
>
> If this feature has "selinux can do xyz if it wants", it is broken.
>
> The *whole* point is to get the f*^%ing crazy "security managers can
> do xyz" things away from it.
>
> The flag - when set - should give a 100% guarantee that security
> context doesn't change, and an operation that would change it would
> error out.
>
> Not a "selinux can block it if it wants". None of that "wants" crap.
> None of the "you can configure security rules to do xyz" crap.
>
> One simple rule: no security changes from the context that set the flag.
>
> Any other rule will inevitably cause random gray areas where some
> random security manager does something stupid. We have enough of those
> already. No more.

I'm confused.  The patch does "no security context changes on execve".

My interpretation of the flag is "LSMs, file caps, and suid/sgid, stay
away".  It does that.  Users are welcome to shoot themselves in the
foot with this behavior (e.g. by setting the flag, running something
that selinux would otherwise have restricted, and getting it without
the restrictions).

If you are *already* in a selinux context that is forbidden from
executing something without changing security context, then you can't
execute the program.  If no_new_privs is set or if you ask (via
selinuxfs) for no transition, then execve fails when selinux refuses
exec_no_trans.  The exec_no_trans callback cannot *change* context --
it just asks whether *not* changing context is okay.

I think this is exactly the desired behavior.  And I misunderstanding
you?  (I can't speak for the AppArmor part of the patch -- I haven't
looked closely enough.  But I think we want the equivalent behavior on
AppArmor.)

If this behavior is *not* okay, then I would rather just have the flag
disable execve entirely and consider execve_nosecurity instead.  I
don't want a situation where fancy seccomp/chroot/whatever apps don't
even run on Fedora because of the mere existence of selinux policy.
If we go that route, I'd rather they didn't run anywhere so the
sandbox authors work around the problem appropriately.

--Andy
