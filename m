Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2J1DcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 23:32:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57160 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab2J1DcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 23:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net>
	<20121025041620.GH2616@ZenIV.linux.org.uk>
	<CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
	<alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
	<20121025120952.GI2616@ZenIV.linux.org.uk>
	<20121025123843.GJ2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
	<20121026183601.GR2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
	<CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com>
	<alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
Date: Sat, 27 Oct 2012 20:32:14 -0700
X-Google-Sender-Auth: oa_PY4GurSeAnTfQGaAF_LYavyI
Message-ID: <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Kees Cook <keescook@chromium.org>
To: P J P <ppandit@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 1:16 PM, P J P <ppandit@redhat.com> wrote:
> +-- On Sat, 27 Oct 2012, Kees Cook wrote --+
> | Al showed a list of them earlier in the thread.
>
>   Yeah, the list Al showed and I came across mostly has - binfmt_aout - entry.
> Do people still use - a.out - format? (considering ELF has been the default
> standard for so many years)

No one sane has CONFIG_BINFMT_AOUT any more. :)

> | I don't have any on the various distros I checked.
>
>   Same here, my F17 machine has no entries for binfmt-xxxx modules, in fact I
> don't even have the /etc/modprobe.d/aliases.conf file.
>
> Documentation/binfmt_misc.txt talks about executing Java, Python, DOSEMU and
> Windows programs which could be supported by loadable modules.

Right, but those are all registered from userspace and binfmt_misc
will catch them.

> | The problem I see here is that we only want to do module loading in the "no
> | match" case. But that means that either we need to restart with the original
> | bprm, or we need to keep bprm changes off the stack. Leading with a module
> | load is going to wreck performance.
>
>   I beg to *slightly* differ here. I agree we currently have a small overhead
> of find_module() -> request_module() only when binfmt_xxxx module is already
> loaded, partly because find_module can not resolve aliases.

Al's point here is that non of the binfmts are named "binfmt-NNNN".
Those are only aliases, and those are only visible from userspace,
even after they're loaded, so the find_module() call in your example
will never match anything. Which means if there is a non-printable in
a binary, the kernel will exec modprobe even if there is already a
binfmt that will load it.

> I guess this small overhead is worth it if it helps to make things less
> confusing and easy to follow. Besides this overhead does not exist for regular
> executables ELFs and scripts alike.
>
> If the required module is missing, a call to request_module() will anyway
> happen and its cost remains the same whether it happens before or after the
> "match".

Well, we'll always do the modprobe call-out on a missing binfmt (so
for that reason I like the addition of the printk, though it should
probably be rate-limited), but we still need to only load modules at
fall-back time. Which means means we need to return from the recursive
loading attempt, which means we need to restart the bprm (slow) or we
need to do a heap alloc for the changed interp (less slow).

If we change binfmt_script to not make a recursive call, then we still
need to keep the interp change somewhere off the stack. I still think
my patchset is the least bad.

Al, do you have something else in mind?

-Kees

-- 
Kees Cook
Chrome OS Security
