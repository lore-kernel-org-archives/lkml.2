Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2ECQQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:16:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55085 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2ECQQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120503064722.GN6871@ZenIV.linux.org.uk>
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com> <20120503064722.GN6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 May 2012 09:15:41 -0700
X-Google-Sender-Auth: t9CwKbOKSP4DKr2STtglTSNE7UE
Message-ID: <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, Jana Saout <jana@saout.de>,
        Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 11:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What I'd really like to know is whether we can hit the same kind of "steps
> off the end of page" crap on pagecache based symlinks with very long bodies.
> The upper limit is 4K, which allows that sucker to reach the end of page
> on most of the architectures.  And that can be done on just about any fs
> supporting symlinks at all - create a symlink with the long body (up to the
> limit), something like (("./"x2047)."a").

Sure. And I've even tested that. You don't need a symlink, you can
have just a regular system call that passes a filename that is 4095
bytes long, and ends in a short component. We *will* access the next
page.

And that was always understood to be the case for the
DCACHE_WORD_ACCESS patches. It's just that accessing the next page
should be entirely harmless on any actual real x86 implementation.

Well, except for the DEBUG_PAGEALLOC case, which is why it's disabled
for that case.

And apparently except for some Xen PV case, where we have similar
issues, and which seems to be the reason Jana sees the problems.

I don't know the Xen paravirtualization code, but it looks like it is
punching holes in the kernel memory map, so you get the same issue you
get with DEBUG_PAGEALLOC.

Actually, looking at things, I think there's another case that can do
it: the AMD gart_64 code also does set_memory_np(), which can cause
problems.

So I guess I need to do the exception handling that I was hoping I
wouldn't have to. Give me a jiffy.

                   Linus
