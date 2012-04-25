Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2DYEFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:05:21 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:38916 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab2DYEFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:05:17 -0400
Message-ID: <4F9777FB.8050109@msgid.tls.msk.ru>
Date: Wed, 25 Apr 2012 08:05:15 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Meyer <thomas@m3y3r.de>, Ian Kent <raven@themaw.net>,
        "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net> <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru> <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com> <4F96D0E7.9060000@msgid.tls.msk.ru> <CA+55aFw=cfYZO7PWDRRuZw1nYxvUk-63qfVVwfdJWevtmZoOig@mail.gmail.com> <1335300159.1393.13.camel@localhost.localdomain> <CA+55aFx9hATsnANWYSoagycc2HnXO=5Oa3gtqBjMr9eoe1obpA@mail.gmail.com>
In-Reply-To: <CA+55aFx9hATsnANWYSoagycc2HnXO=5Oa3gtqBjMr9eoe1obpA@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.04.2012 01:01, Linus Torvalds wrote:
> On Tue, Apr 24, 2012 at 1:42 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>>
>> It broke the autofs feature of systemd (32bit) on a 64bit kernel, which
>> resulted in an endless wait in the boot process. I don't use the autofs
>> tools. I guess the fix in the autofs package to compensate the kernel
>> bug, which has now been fixed, breaks the autofs package.
>> The fix in the kernel makes systemd work correctly.
> 
> Oh damn, I'd forgotten the details. Ok.
> 
> That does mean that we probably just have to do a kernel command line
> option for this. And then the autofs4 code that currently does
> 
>     sbi->compat_daemon = is_compat_task();
> 
> needs to change that to take the command line option into account too.

How about something like

     sbi->compat_daemon = is_compat_task() && strcmp(task->comm, "automount") != 0

instead?  (This task->comm is a pseudocode, just to show the idea, I don't
know where this info can be found in kernel)

Or maybe similar workaround (as in automount) can be placed into systemd
too.  I'd really prefer this one -- historically things has been that way
for quite some time (at least 5 years).

Or yet another solution: let the kernel to compensate, but add some code
in the _negotiation_ phase, when user<=>kernel space initializes things
and exchanges their capabilities - IF there is one.

> We could make it a mount option, but since the whole point is that we
> want to be compatible with existing binaries that don't *use* special
> mount options, I suspect the only reasonable point is at the kernel
> command line.

Well, the last my suggestion -- it will have to use some special option
or a flag or whatever.  But let just make it a part of the interface,
like we just introduced an autofs v6, so existing and currently in WIDE
use (I mean automount from autofs5 which broke) will be fine, and all
NEW binaries will work too.

Kernel command line is - in my opinion - too much for this very issue.
The same way a user can just replace his automount with automount64
(for example) - if something has to be done by the user anyway.

But a mount option which will be specified by all new binaries as a
part of standard interface should work - provided this is the
"negotiation" phase.

This way, we're breaking systemd _again_, but only till the next
version.  The difference between systemd and automount here is that
the latter is much older and is more likely to be used in a mixed
environment and has more "chances" to be seen in the future this
way too, when someone tries to run some old distribution code in
a chroot or a container.  Systemd here is much less used in mixed
environment now and is less widely used in general, so this way
we break less - IMHO anyway.

And/or systemd can adopt in the similar way as automount did --
like, treat this bug as an interface "feature", provide a "large
enough" buffer and just expect a read of up to the trailing zero
in filename as okay too -- this way it will work regardless of
anything else (this is what I proposed initially).

> That is, unless somebody can figure out a way to auto-detect how big
> the user space read is. The problem with that really is that the
> autofs read() system call isn't done directly to some "real autofs"
> file descriptor, autofs literally is using the standard pipe code.
> 
> So the code in fs/pipe.c does actually see the size of the read. But
> the code in fs/autofs4/ does not. And we can't change the interface,
> because the whole pipe is opened in user space iirc.

Yes, that'd be more sane solution - an ability to detect read size.

So, to sum it all up, we've the following options:

1) somehow detect the read size and do a magic in kernel so everything
   Just Work.

2) sbi->compat_daemon = is_compat_task() && strcmp(task->comm, "automount") != 0
   Everything _current_ works.

3) mount option or other change of the interface, reverting the
   patch.  Old automount will continue to work as it did last 5+
   years, systemd will break again.  Can be combined with 2), ie,
   do 2) as an "urgent fix" and implement 3) later after some
   thinking.

Thanks,

/mjt
