Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1FCL5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:57:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1FCL5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ChTlsGXb92FjarH7W++/JpwcyRhJwTE1mka9FELZX2bCSQgfaTWvquZr/30ED5QuQu
         VzhkGIqnEXixpEXcsIfsUDw9+Hk3yXB+apSLFtOlmcr1/ZRQcycBYPwG6+2TjkcF8tfV
         Pv+mbR1X2Vf3fL3/nSW6iHfdxHJrlopY8JUV4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 13:57:02 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com> <20110603012445.GA14872@mtj.dyndns.org>
In-Reply-To: <20110603012445.GA14872@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201106031357.02859.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 03:24, Tejun Heo wrote:
> > > * Implicit signal on clone.
> > 
> > Best if it is converted to STOP trap (the same is one caused by INTERRUPT).
> > 
> > I guess this may be optionally changed
> > (similar to how PTRACE_O_TRACEEXEC
> > changes post-execve SIGTRAP into PTRACE_EVENT_EXEC).
> > 
> > Why not turn it on *unconditionally* on SEIZE?
> > Because otherwise ptrace users will turn into
> > 
> > if (we_used_SEIZE)
> >     do_something;
> > else
> >     do_something_else;
> > 
> > maze, which is maintenance nightmare.
> > It's possible users will opt to not use new functionality at all
> > instead of going that way.
> 
> Hmmm... I see.  The other side of the argument is that some level of
> "if (SEIZEd)" is inevitable anyway and in the longer run we would be
> better off defaulting to the better behavior than making things
> optional.
> 
> > If everything is monolithically tied into SEIZE, users won't be able
> > to opt to use only easy parts of new functionality (such as
> > PTRACE_INTERRUPT and PTRACE_LISTEN) if this *forces* them
> > to also use harder parts of new functionality, in this case
> > forces them to double and obfuscate their existing code
> > which handles SIGSTOP-on-child-auto-attach. They don't really
> > want to, since this SIGSTOP *in practice* isn't that problematic.
> 
> Anyways, let's think about that, but SIGSTOP on clone is closely
> linked to why SEIZE is used in the first place and I currently lean
> toward tying it to SEIZE.

Ok.

SIGSTOP on clone is less problematic because in practice it's
rather hard to send a real SIGSTOP to a thread which is _just_ created.
So the race window is mostly theoretical - unlike the much more realistic
race on initial attach to an already running process.

But if tracer already uses SEIZE on initial attach, it ought to be
willing to handle the new way of post-clone stop too.
Therefore I'm ok with this idea.


> > > * What to do about events which are reported by genuine SIGTRAP
> > >  generation?
> > 
> > I don't understand what you meant here. Example(s)?
> 
> The syscall, breakpoint, single step SIGTRAPs which can't be
> distinguished from userland generated SIGTRAPs and may be mixed and/or
> lost.  Maybe it's best to leave them alone or maybe we can add some
> way to distinguish them which is mostly backward compatible (which is
> enabled w/ SEIZE and hopefully doesn't require noticeable userland
> changes).

Currently, all PTRACE_EVENTs are enabled with ptrace options.

I propose using the same way instead of using something different.
It works. It's not problematic. Just add more PTRACE_O_foo bits.
Then user who really want it will use it, and users which
would rather use their existing code with less changes aren't
forced to change.

I am not insisting on a separate bit per event,
single blanket PTRACE_O_FLAGTRAPS bit which converts all of these
to PTRACE_EVENTs all once is ok with me.

-- 
vda
