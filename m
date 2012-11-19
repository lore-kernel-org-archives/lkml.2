Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab2KSUlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:41:25 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56498 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KSUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:41:23 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net>
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
	<CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com>
	<alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz>
Date: Mon, 19 Nov 2012 12:41:22 -0800
X-Google-Sender-Auth: TZu7g46JTQkyeOAKJXRBv_eKX4k
Message-ID: <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
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

On Sun, Nov 18, 2012 at 10:57 PM, P J P <ppandit@redhat.com> wrote:
> +-- On Sun, 18 Nov 2012, Kees Cook wrote --+
> | This is the second problem. I view this as less critical because it's only
> | 64 instead of 4, but it certainly should be solved as well.
>
>   I don't mean to be rude, but the patch I had sent solves both of these
> problems with much less performance hit.
>
> Please see -> https://lkml.org/lkml/2012/10/26/442
>
> Worst case: instead of 2^6(64) recursions, it would make only 4 calls to
> request_module() function. find_module() does not resolve module aliases, it
> could be removed from the above patch.
>
> Please pardon me if I came across rude or offensive, I'm only trying to make a
> case.

I don't think you're being rude at all. You're defending your
solution. :) I wasn't very verbose in my objection to it, so I
apologize for that and now attempt to make up for it in this email. :)

I felt that your patch made certain things worse, but perhaps I was
seeing it incorrectly. Just to have a common point of reference, here
are some of the exec cases I've been considering. This is without
either of our patches applied:

An exec of ELF directly:

- bprm created
- search_binary_handler called
  - each fmt->load_binary called
    - ELF handler hits
- done: 0 request_module calls, 0 leaks

An exec of a a file handled by binfmt_misc:

- bprm created
- search_binary_handler called (depth == 0)
  - each fmt->load_binary called
    - misc handler hits
      - rewrites various bprm things, including bprm->interp
      - search_binary_handler called (depth == 1)
        - each fmt->load_binary called
        - ELF handler hits (usually, depends on specific binfmt_misc
interpreter config)
- done: 0 request_module calls, 0 leaks

An exec of a script that calls ELF:

- bprm created
- search_binary_handler called (depth == 0)
  - each fmt->load_binary called
    - script handler hits
      - rewrites various bprm things, including bprm->interp
      - search_binary_handler called (depth == 1)
        - each fmt->load_binary called
        - ELF handler hits
- done: 0 request_module calls, 0 leaks

An exec of an binary with unprintables where a module exists:

- bprm created
- search_binary_handler called (depth == 0)
  - each fmt->load_binary called
  - nothing hits, retval == ENOEXEC
  - request_module("binfmt-%04x") called
  - search_binary_handler loop starts again
  - each fmt->load_binary called
  - new handler hits
- done: 1 request_module call, 1 leak

An exec of a chain of abusive scripts that contains unprintables:

- bprm created
- search_binary_handler called (depth == 0)
  - each fmt->load_binary called
    - script handler hits
      - rewrites various bprm things, including bprm->interp
      - search_binary_handler called (depth == 1)
        - each fmt->load_binary called
          - script handler hits
          - rewrites various bprm things, including bprm->interp
          - search_binary_handler called (depth == 2 ...)
            ...
            - each fmt->load_binary called
              - at depth > BINPRM_MAX_RECURSION, script handler returns -ENOEXEC
            - retval == ENOEXEC
            - request_module("binfmt-%04x") called
            - search_binary_handler loop starts again
            - each fmt->load_binary called
              - at depth > BINPRM_MAX_RECURSION, script handler returns -ENOEXEC
       ... unwind and retry continues all the way back up
  - retval == ENOEXEC
  - request_module("binfmt-%04x") called
  - search_binary_handler loop starts again
  - each fmt->load_binary called
- done: 63 calls to request_module (one in each search_binary_handler
call, to depth 5 (32 wide)), 63 leaks

So, my interp-on-heap patch doesn't change the request_module call
count, but it changes the stack reference leaks to kalloc/kfree pairs.

Your patch changes a number of things. The obvious part is that is
solves the abusive chain of script example by stopping at depth == 5,
after 5 calls to request_module, and eliminates the retries so there
are 0 stack reference leaks.

However, it also changes the conditions for when a module is loaded
(i.e. 0x7f no longer triggers a module_load, so anything needing that
would break -- I'm not sure if this really qualifies for ABI breakage,
I don't use any obscure binfmt modules so I can't say).

And, most importantly, it triggers request_module for any binary with
unprintables that binfmt_misc may already handle (for example, the
very common case of handling DOS MZ files, which only define 2 bytes
as magic (MZ) and exampes I find show things like "@\x00" trailing it,
or JAR files which are PK\x03\x04). Which means each exec of these
kinds of files would trigger a needless request_module() call on every
exec.

I feel that this too radically changes the behavioral characteristics
of exec for common cases. The original logic is:
- try all existing binfmt handlers
- if none found, try to load a module for it in it had unprintables
(including 0x7f)
- try them all again

Your new logic would be:
- try to load a module if there are unprintables (excluding 0x7f)
- try all existing binfmt handlers

I really don't think this change is sensible. We need to only do the
module request when none of the handlers hit, and things haven't gone
wrong.

I think to avoid the explosion of request_module calls in the abusive
case, we could simply return ELOOP instead of ENOEXEC on max
recursion. This would mean an immediate return on max depth failures.
Also, after looking at the recursion tracking here, it really seems
like search_binary_handler should track it, not the binfmt handlers.
I'll send the patch.

Both the interp-on-heap patch and this proposed ELOOP patch are needed
to handle the case of binfmt_script and/or binfmt_misc being modules
(first binfmt walk fails with -ENOEXEC, loads binfmt_script, retries
loop, hits binfmt_script rewriting interp to a PE file, recurses,
fails with -ENOEXEC, loads binfmt_misc via a modalias for PE files,
retries loop, hits binfmt_misc rewriting interp to an ELF, recurses,
loads ELF, happiness). Without the heap patch, we could be pointing
into old stack (rewritten e.g. during module load or taking an
interrupt, etc) on the loop retries. Without the ELOOP patch, the
recursion could explode with an abusive script chain.

-Kees

-- 
Kees Cook
Chrome OS Security
