Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2JYMDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:03:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50061 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2JYMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:03:52 -0400
X-Nat-Received: from [202.181.97.72]:51868 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1351166599.2662
To: ppandit@redhat.com, keescook@chromium.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, josh@joshtriplett.org,
        serge.hallyn@canonical.com, linux-fsdevel@vger.kernel.org,
        me@halfdog.net
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20121024232032.GA31129@www.outflux.net>
	<20121025041620.GH2616@ZenIV.linux.org.uk>
	<CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
	<alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
In-Reply-To: <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
Message-Id: <201210252103.BJG56875.OtHFLOOVSFFQMJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 25 Oct 2012 21:03:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25102012 #8190028, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P J P wrote:
> 
>   Hello Kees,
> 
> +-- On Wed, 24 Oct 2012, Kees Cook wrote --+
> | What should the code here _actually_ be doing? The _script and _misc 
> | handlers expect to rewrite the bprm contents and recurse, but the module 
> | loader want to try again. It's not clear to me what the binfmt module 
> | handler is even there for; I don't see any binfmt-XXXX aliases in the tree. 
> | If nothing uses it, should we just rip it out? That would solve it too.
> 
> I've been following this issue and updated versions of HDs patch. Below is a 
> small patch to search_binary_handler() routine, which attempts to make the 
> request_module call before calling load_script routine.
> 
> Besides fixing the stack disclosure issue it also helps to *simplify* the 
> search_binary_handler routine by removing the -for (try=0;try<2;try++)- loop.
> 
> I'd really appreciate any comments/suggestions you may have.

Excuse me, but why do you change definition of printable(c) ?
Looks like a regression.

Wouldn't your patch trigger call request_module() whenever a script
starting with "#!/bin/sh" is executed? 

And if you meant

if (!(printable(bprm->buf[0]) && printable(bprm->buf[1])
	&& printable(bprm->buf[2]) && printable(bprm->buf[3])))

then, wouldn't that trigger request_module() recursion?
