Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AHMqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:46:07 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37132 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3AHMqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130106163100.GI4939@ZenIV.linux.org.uk>
References: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
 <20120912011654.GQ13973@ZenIV.linux.org.uk> <20130106163100.GI4939@ZenIV.linux.org.uk>
From: Meredydd Luff <meredydd@senatehouse.org>
Date: Tue, 8 Jan 2013 12:39:48 +0000
Message-ID: <CAD=T17Fs4bMJedpuO9JEDbrzEBOQcd+5v3BxUDkNH_NRRkh64A@mail.gmail.com>
Subject: Re: [PATCH signal#execve2] syscalls,x86: Add execveat() system call (v3)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 4:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK, now that sys_execve() unification has settled down, let's get back
> to this one.  The real problem is what you are doing with bprm->filename
> and bprm->interp; blind use of ->d_name is completely wrong.
ACK. I've blocked out tomorrow to dive in and figure out what I should
be doing instead. My current plan is "look at how we get a string
value out when readlink()ing /proc/self/fd/N, then copy that
approach". Feel free to save me from wasting time if this is a bad
idea.

> For what it's worth, how should it work for e.g. shell scripts?  That's
> the main user of bprm->{filename,interp}, after all - other places are
> either seriously exotic or are just using it for printks.
>
> For shell scripts, however, these guys are really used - we have the original
> argv[0] removed and <shell name> <optional argument> <filename> pushed in
> its place.

As I see it, this is a question of how much can be supported.
Fundamentally, a hash-bang interpreter is handed a filename. This will
inevitably break in a world in which not everything you want to
execute can be reliably named by a path in the interpreter's
namespace. The demand for a "real" fexecve() argues that this world is
desirable, and under those circumstances the best you can hope for is
probably to fail gracefully, or at least predictably.

> How will it work with execveat()?  If we have procfs in place, we can
> cook an equivalent pathname (/proc/self/fd/<n>/<relative part of pathname>),
> but then why not do just that in userland and be done with that?
A pure-userland execveat() suffers all the problems of a pure-userland
fexecve(). I think it's important to be able to use this in
environments where /proc is absent or not trustworthy (weird embedded
systems, sandboxes, etc).

If I'm understanding this right, the behaviour I was originally
planning would leave the hash-bang interpreter with a pathname that
"should" resolve to the script, barring jiggery-pokery with passing
FDs between namespaces - but without the atomicity of the *at() call.
This places execveat() into the category of "desirable things whose
atomicity guarantees interact poorly with shell scripts" (a group with
a long and [ig]noble history).

I suppose the munging could be conditional: "If /proc is owned by root
and mounted as procfs, we'll give you a /proc/self/fd/... path.
Otherwise you're on your own and getting whatever
readlink(/proc/self/fd/<n>) would have given you." But that would
still require the kernel knowing something about the filesystem
layout.

Either way, it seems, we leave a rake in the grass for somebody...

Meredydd
