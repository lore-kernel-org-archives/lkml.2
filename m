Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2KRTev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:34:51 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59217 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2KRTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
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
	<CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com>
	<alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
	<CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com>
	<alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz>
	<CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com>
	<alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
Date: Sun, 18 Nov 2012 11:34:48 -0800
X-Google-Sender-Auth: biPUU25AaxbgQp6o7GSnI4B7v94
Message-ID: <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Kees Cook <keescook@chromium.org>
To: P J P <ppandit@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 11:04 AM, P J P <ppandit@redhat.com> wrote:
> +-- On Fri, 16 Nov 2012, Kees Cook wrote --+
> | Hrm? It should be showing only the live heap-allocated interp -- are
> | you seeing uninitialized contents?
>
>  I don't see uninitialised content; I see interpreter names from previous
> iterations. Which was the case earlier as well. The - interp - array is
> initialised with the interpreter name, before being assigned to bprm->interp.
>
> These - interp - bytes are *leaked* because after 4 recursions, when
> load_script returns -ENOEXEC, - bprm->interp - becomes invalid for it starts
> pointing to an invalid stack memory location.
>
> Crux of the problem is in the fact that the recursion limit -
> BINPRM_MAX_RECURSION(4) - exceeds after ones been rightly adhered to.
>
>         (bprm->recursion_depth > BINPRM_MAX_RECURSION))
>                 return -ENOEXEC;
>
> This check fails due to specific condition, which still exists.
>
> Dynamically allocating memory fixes the leak by making the memory area live
> and valid.

Right. There are two problems. This fixes the first, which is the
memory content leak.

> It does not fix the problem which caused the leak in the first place by
> exceeding the BINPRM_MAX_RECURSION, not by 1 or 2 but possible 2^6
> recursions. Isn't that performance hit?

This is the second problem. I view this as less critical because it's
only 64 instead of 4, but it certainly should be solved as well.

-Kees

-- 
Kees Cook
Chrome OS Security
