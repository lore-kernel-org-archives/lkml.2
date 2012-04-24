Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab2DXVCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:02:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59005 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab2DXVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:02:19 -0400
MIME-Version: 1.0
In-Reply-To: <1335300159.1393.13.camel@localhost.localdomain>
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net>
 <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>
 <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com>
 <4F96D0E7.9060000@msgid.tls.msk.ru> <CA+55aFw=cfYZO7PWDRRuZw1nYxvUk-63qfVVwfdJWevtmZoOig@mail.gmail.com>
 <1335300159.1393.13.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 14:01:57 -0700
X-Google-Sender-Auth: 2tXGl4yAOyCDdzlMQVBSaxB1vDI
Message-ID: <CA+55aFx9hATsnANWYSoagycc2HnXO=5Oa3gtqBjMr9eoe1obpA@mail.gmail.com>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit environment
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Ian Kent <raven@themaw.net>,
        "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 1:42 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>
> It broke the autofs feature of systemd (32bit) on a 64bit kernel, which
> resulted in an endless wait in the boot process. I don't use the autofs
> tools. I guess the fix in the autofs package to compensate the kernel
> bug, which has now been fixed, breaks the autofs package.
> The fix in the kernel makes systemd work correctly.

Oh damn, I'd forgotten the details. Ok.

That does mean that we probably just have to do a kernel command line
option for this. And then the autofs4 code that currently does

    sbi->compat_daemon = is_compat_task();

needs to change that to take the command line option into account too.

We could make it a mount option, but since the whole point is that we
want to be compatible with existing binaries that don't *use* special
mount options, I suspect the only reasonable point is at the kernel
command line.

That is, unless somebody can figure out a way to auto-detect how big
the user space read is. The problem with that really is that the
autofs read() system call isn't done directly to some "real autofs"
file descriptor, autofs literally is using the standard pipe code.

So the code in fs/pipe.c does actually see the size of the read. But
the code in fs/autofs4/ does not. And we can't change the interface,
because the whole pipe is opened in user space iirc.

Ugly.

Anybody willing to write the patch?

                 Linus

Damn.
