Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2HUTiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:38:12 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40525 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab2HUTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:38:10 -0400
MIME-Version: 1.0
In-Reply-To: <1345575839-9389-4-git-send-email-miklos@szeredi.hu>
References: <1345575839-9389-1-git-send-email-miklos@szeredi.hu> <1345575839-9389-4-git-send-email-miklos@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Aug 2012 12:37:48 -0700
X-Google-Sender-Auth: Oa5cMPymHajMVKTs58KiUCb641M
Message-ID: <CA+55aFyqAKacNmbuu1oY3P_eaMxHNBzcbQiNcDvb10f-9MK53Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] audit: clean up refcounting in audit-tree
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: eparis@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 12:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> +       /*
> +        * We are guaranteed to have at least one reference to the mark from
> +        * either the inode or the caller of fsnotify_destroy_mark().
> +        */
> +       BUG_ON(atomic_read(&entry->refcnt) < 1);

I pulled, but *please* don't use BUG_ON() as some kind of "let's
assert some random crap" thing. We've literally had DoS security
issues due to code having BUG_ON()'s and killing the machine, and
BUG_ON() often makes things *worse* if it ends up happening in irq
context or with some critical lock held, and then the machine is just
dead with no logging and no messages left anywhere.

So before adding a BUG_ON(), you should ask yourself the following questions:

 (a) is this something I need to even test?

     There are lots of rules we have in the kernel. We don't add
BUG_ON() for each and every one of them. Is it such a critical data
structure that I really need to test for that condition that should
never happen?

 (b) Is this data structure *so* central that I need to immediately
kill everything, or do I just want it logged?

     If it's just a "I want people to know about it, but I don't
expect it to happen, I'm just adding a debug thing to make sure", then
WARN_ON_ONCE() is likely the right thing. It's *more* likely to get
reported, exactly because the machine is more likely to survive a
WARN_ON_ONCE().

 (c) am I sure that none of the callers hold any central locks that
make the BUG_ON() be worse than the alternatives?

BUG_ON() is really drastic. Some machines will reboot on bugs. Others
will halt. And a even the common ones that are just set to kill the
particular process can effectively kill the whole machine due to locks
or preemption counts etc that never get released.

The kind of place that deserves a BUG_ON() is some really *central*
code where you have major issues, and there's just not anything you
can do to continue. If somebody passes kfree() a bad pointer, there's
just nothing kfree() can sanely do about it. If somebody does a
list_del() with list debugging enabled, and it notices that the list
pointer are crap, what are you going to do? You can't continue.

But some random data structure that has the wrong refcount? If you
*can* return with a warning (and ONCE, at that, so that not only does
it get logged, the log doesn't get spammed and useless because it gets
too big), that's likely what you should do.

And this is *doubly* true if it's a patch in the -rc series and you
added the code because you weren't sure you tested all possible random
cases. Don't potentially kill the machine because you weren't sure you
got all cases!

            Linus
