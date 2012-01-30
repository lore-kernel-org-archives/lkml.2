Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2A3WwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:52:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41521 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2A3WwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9habGczrDUxGUWpRQ1=bREjCx-6rPeYArnGXe76fW3K2zw@mail.gmail.com>
References: <cover.1327858005.git.luto@amacapital.net> <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
 <1327960736.5355.5.camel@lenny> <1327961884.5882.11.camel@gandalf.stny.rr.com>
 <CABqD9habGczrDUxGUWpRQ1=bREjCx-6rPeYArnGXe76fW3K2zw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jan 2012 14:51:54 -0800
Message-ID: <CALCETrX6xRCvkHBz0TKVxffgOFRfvnb7ZbmyiN3zruwgBXjhKw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] Allow unprivileged chroot when safe
To: Will Drewry <wad@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Colin Walters <walters@verbum.org>,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, jmorris@namei.org,
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

On Mon, Jan 30, 2012 at 2:38 PM, Will Drewry <wad@chromium.org> wrote:
> On Mon, Jan 30, 2012 at 4:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, 2012-01-30 at 16:58 -0500, Colin Walters wrote:
>>> On Mon, 2012-01-30 at 08:17 -0800, Andy Lutomirski wrote:
>>> > Chroot can easily be used to subvert setuid programs.  If no_new_privs,
>>> > then setuid programs don't gain any privilege, so allow chroot.
>>>
>>> Is this needed/desired by anyone now, or are you just using it to "demo"
>>> NO_NEW_PRIVS?  I don't see it as very useful on its own, since in any
>>> "container"-type chroot you really want /proc and /dev, and your patch
>>> doesn't help with that.
>>>
>>> System daemons that do chroot for a modicum of security already start
>>> privileged, so this doesn't help them either.
>>
>> I thought this was all for sandboxing? If a browers (or user) wants to
>> run some untrusted code, perhaps a chroot is the best way to do so. It
>> just will break if it needs to access /proc or /dev. And perhaps we
>> don't want untrusted code accessing /proc and /dev.
>
> Interestingly, I believe this change would work for the Chromium
> setuid sandbox[1]. It uses a fancy clone trick (CLONE_FS) to start the
> process then chroot once all its dependencies are loaded. It then
> chroot()s to /proc/self/fd_info (or another empty process-specific
> directory).  Of course, pid namespacing still wouldn't be there, but
> it'd be nice to have a fallback if someone doesn't want the sandboxing
> setup code to have privileges (or can only install unpriv'd code).
>
> cheers!
> will
> 1 - http://code.google.com/p/setuid-sandbox/source/browse/privdrop.c

That's neat!  CLONE_NEWPID might be safe with no_new_privs, too.
Unprivileged CLONE_NEWPID would also be a nice, straightforward way to
start up a process hierarchy and then reliably kill the whole thing
when you're done with it.

I'll add this to v5 as yet another optional patch.  All we need is
someone to pick up the patches for 3.4 :)

(Incidentally, I think privdrop.c wants CLONE_NEWIPC as well.)

--Andy
