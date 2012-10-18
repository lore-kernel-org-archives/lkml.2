Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2JRANh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:13:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46402 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2JRANf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyxuHTbqFHKoZ4Pqy28ivfginONowvfF0P9ctdiLmVqng@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
	<CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
	<CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com>
	<CA+55aFyxuHTbqFHKoZ4Pqy28ivfginONowvfF0P9ctdiLmVqng@mail.gmail.com>
Date: Wed, 17 Oct 2012 20:13:34 -0400
Message-ID: <CA+5PVA7fAtL3BEOjf8Ku1SBRbMvnneRXLkb=VRSpHkG=Bk7tzQ@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
From: Josh Boyer <jwboyer@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 7:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 17, 2012 at 4:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Hmm. It *should* work for them too, because the debuginfo modules stay
>> around in the object tree, and never get stripped there. None of this
>> is different from what we used to do before: we stripped the modules
>> as we copied them to /lib/modules (where the RPM build obviously would
>> have that $RPM_BUILD_ROOT prefix on the module install path).
>
> Ok, I read your description of the odd way fedora builds debuginfo kernels.
>
> I actually think that works fine too. I do agree with adding a "make
> sign_modules" target, but it would *re-sign* them after "make
> modules_install" has already signed them once.
>
> Why?
>
> What you'd do for your debuginfo requirements is:
>
>  - do the normal kernel build, and install modules (with *my* patch,
> which does signing at install time)
>
>    This does the normal (conditionally stripped - you just wouldn't
> strip them, but you cannot have done that before either) modules,
> installs them, and signs then.
>
>    Ta-daa, you have your debuginfo modules installed, and they are
> signed. Create the debuginfo rpm.
>
>  - now, strip the modules. This obviously destroys the signatures

find-debuginfo.sh is what creates the debuginfo RPM.  It strips the
module debug symbols (and the signature), so there's no need to further
strip things at this point.

>  - do the extra "make sign_modules" that you added, that re-signs the
> already installed modules, and now you can create the non-debuginfo
> rpm.

OK, sounds sane at first glance.

> Voila. "make modules_install" does the right thing for everybody -
> including normal users. And it does so without the incredible baroque
> code. And no normal user is expected to ever use the new "make
> sign_modules", but it allows for the Fedora "we'll want to sign them
> again".
>
> That said, you could even just do "make sign-modules" on your own
> without any makefile targets. After all, it would just be something
> like
>
>    find $MODULEDIR --name '*.ko | while read i; do script/sign-file
> keyfile x509file $i; done
>
> so it could even be done in that rpm script directly.

Sure, as long as the script is in the kernel tree (or at least I would
like it to be).  When I wrote the patch, _none_ of the modsign stuff was
in-tree at the time so I had to carry and adapt things as the code
changed along the way.  In my defense, I did say I have to clean it up
still. :)

josh
