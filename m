Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2D1FV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 01:21:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46400 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2D1FV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 01:21:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F9B7BBA.7030504@openvz.org>
References: <20120425112623.26927.43229.stgit@zurg> <20120425112636.26927.27124.stgit@zurg>
 <4F9B7BBA.7030504@openvz.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 22:21:04 -0700
X-Google-Sender-Auth: eCIXIQekPAAkJ8f3GQ81HarwSH4
Message-ID: <CA+55aFw98ncQu0psXNCKoBkp1XK37QPdHPNJmtA_N7j9-O0jKQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] bug: mark disabled BUG() as unreachable() code
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 10:10 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
>
> With this patch gcc throw out loop at the end of do_exit():

I think that's the least of our problems - that loop only exists to
get rid of a warning, and the return from that schedule() really is
supposed to be unreachable().

What makes me much more worried is that iirc, gcc will use
"unreachable()" to also get rid of function epilogues etc, which is
perfectly fine if it really is something entirely unreachable. But the
kernel use of BUG() is often as a kind of "assert()", and if gcc
generates actively bad code for it (and it does, with unreachable()),
it turns the turned-off BUG() into something *really* horrible that
makes for a debugging disaster.

So some pattern like

   if (badness)
      BUG();

would generate code that is actively insane, instead of (like now)
generating basically a no-op.

And THAT makes me go "Eww". "unreachable()" should only be used in
situations that really are very very unreachable() (eg after an "asm"
that goes off to la-la-land or a call to "exit()" in user land etc).

The kernel kinds of "assert" is *hopefully* not reachable, but if we
ever reach it, we don't want to make things worse. The BUG() was there
to give us a nicer debug message about what went wrong, and I think
your patch actively destroys that whole thing and makes for something
*worse*.

                    Linus
