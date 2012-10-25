Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2JYMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:09:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45425 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2JYMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:09:56 -0400
Date: Thu, 25 Oct 2012 13:09:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: P J P <ppandit@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
Message-ID: <20121025120952.GI2616@ZenIV.linux.org.uk>
References: <20121024232032.GA31129@www.outflux.net>
 <20121025041620.GH2616@ZenIV.linux.org.uk>
 <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
 <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:16:22PM +0530, P J P wrote:
> 
>   Hello Kees,
> 
> +-- On Wed, 24 Oct 2012, Kees Cook wrote --+
> | What should the code here _actually_ be doing? The _script and _misc 
> | handlers expect to rewrite the bprm contents and recurse, but the module 
> | loader want to try again. It's not clear to me what the binfmt module 
> | handler is even there for; I don't see any binfmt-XXXX aliases in the tree. 
> | If nothing uses it, should we just rip it out? That would solve it too.

; grep binfmt- /etc/*/* 2>/dev/null 
/etc/modprobe.d/aliases.conf:install binfmt-0000 /bin/true
/etc/modprobe.d/aliases.conf:alias binfmt-204 binfmt_aout
/etc/modprobe.d/aliases.conf:alias binfmt-263 binfmt_aout
/etc/modprobe.d/aliases.conf:alias binfmt-264 binfmt_aout
/etc/modprobe.d/aliases.conf:alias binfmt-267 binfmt_aout
/etc/modprobe.d/aliases.conf:alias binfmt-387 binfmt_aout
; dpkg -S /etc/modprobe.d/aliases.conf 
module-init-tools: /etc/modprobe.d/aliases.conf

> I've been following this issue and updated versions of HDs patch. Below is a 
> small patch to search_binary_handler() routine, which attempts to make the 
> request_module call before calling load_script routine.
> 
> Besides fixing the stack disclosure issue it also helps to *simplify* the 
> search_binary_handler routine by removing the -for (try=0;try<2;try++)- loop.
> 
> I'd really appreciate any comments/suggestions you may have.

Suggestion: try testing your patches once in a while.  Stopping to think
for a minute would also help - you've turned every execve() into "do
request_module() first".  How do you suppose request_module() works?  And
how would modprobe be able to run?  IOW, this request_module() will be
stopped by protection against infinite loops, at which point execve will
proceed with already present binfmt, without having loaded anything.
But that's even worse than slowdown on each execve (with a lot of whining
in process), because *every* request_module() will fail now due to the same
loop prevention.
