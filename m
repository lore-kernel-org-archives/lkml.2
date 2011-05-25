Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1EYSt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:49:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab1EYSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110525180100.GY19633@outflux.net>
References: <20110517131902.GF21441@elte.hu> <BANLkTikBK3-KZ10eErQ6Eex_L6Qe2aZang@mail.gmail.com>
 <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 11:42:44 -0700
Message-ID: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: Kees Cook <kees.cook@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:01 AM, Kees Cook <kees.cook@canonical.com> wrote:
>
> Can we just go back to the original spec? A lot of people were excited
> about the prctl() API as done in Will's earlier patchset, we don't lose the
> extremely useful "enable_on_exec" feature, and we can get away from all
> this disagreement.

.. and quite frankly, I'm not even convinced about the original simpler spec.

Security is a morass. People come up with cool ideas every day, and
nobody actually uses them - or if they use them, they are just a
maintenance nightmare.

Quite frankly, limiting pathname access by some prefix is "cool", but
it's basically useless.

That's not where security problems are.

Security problems are in the odd corners - ioctl's, /proc files,
random small interfaces that aren't just about file access.

And who would *use* this thing in real life? Nobody. In order to sell
me on a new security interface, give me a real actual use case that is
security-conscious and relevant to real users.

For things like web servers that actually want to limit filename
lookup, we'd be <i>much</i> better off with a few new flags to
pathname lookup that say "don't follow symlinks" and "don't follow
'..'". Things like that can actually be beneficial to
security-conscious programming, with very little overhead. Some of
those things currently look up pathnames one component at a time,
because they can't afford to not do so. That's a *much* better model
for the whole "only limit to this subtree" case that was quoted
sometime early in this thread.

And per-system-call permissions are very dubious. What system calls
don't you want to succeed? That ioctl? You just made it impossible to
do a modern graphical application. Yet the kind of thing where we
would _want_ to help users is in making it easier to sandbox something
like the adobe flash player. But without accelerated direct rendering,
that's not going to fly, is it?

So I'm sorry for throwing cold water on you guys, but the whole "let's
come up with a new security gadget" thing just makes me go "oh no, not
again".

                    Linus
