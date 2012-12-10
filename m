Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2LJTbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:31:17 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:52270 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2LJTbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:31:16 -0500
MIME-Version: 1.0
In-Reply-To: <1355166920.17101.239.camel@gandalf.local.home>
References: <1355160900.17101.229.camel@gandalf.local.home>
 <1355165264.17101.233.camel@gandalf.local.home> <20121210190247.GA32119@kroah.com>
 <1355166920.17101.239.camel@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Dec 2012 11:30:55 -0800
X-Google-Sender-Auth: PItU3Ns_xOmJD37hWmS5zqcfjYw
Message-ID: <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
Subject: Re: Missing tags in my local stable git repo
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:15 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> That's a scary thought... git gc will just prune stuff you haven't used
> in a while? I hope that's not the case.

git gc should only prune stuff that is no longer *reachable*.

If the alternate tree is entirely stable, that should be perfectly fine.

HOWEVER.

Any tree that is an alternate and ever has *any* objects in it that
can become unreachable is a really really really bad idea.

Note that the "any objects" can be because it has fetched temporary
branches (even if they were never merged). So you may think that you
didn't do anything unstable, but even just using that tree to fetch
something to look at - and then not using the end result - is a major
mistake in an alternates tree.

Also, you should never *ever* make an alternate object store be
*another* alternate object store, and I think that may be the problem
in your case. Iirc git doesn't follow alternates recursively. So what
can happen is that you got objects in the "middle" alternate, that
then get pruned away by "git gc" (because they exist in the origin
repository), but they got pruned away from the furthest alternate in
the meantime, and now the objects are "two hops" away, and will not
ever be seen.

Moral of the story: be *very* careful when using alternates. Only ever
point the alternate file at a *real* repository (not another one with
alternates), and only one that never has references removed.

                     Linus
