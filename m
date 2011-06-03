Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1FCBYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:24:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58724 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab1FCBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Jlv4m0uuICupAf2g8FmS3GDCzYYlZgSWWmW0Xqt+lSnVlxrFejyhbLXbGLD4gQ+a+O
         E+UY2XKiU9fuBrib+SJ9c1s28pIe/q0SC41QJrWs6Of69JnI94QIS/RkSpkWFAo+u/1U
         WWohaLbsP+5D+meBkM6A7KTxozdYOIl35/OBo=
Date: Fri, 3 Jun 2011 10:24:45 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and
 group stop notification, take#4
Message-ID: <20110603012445.GA14872@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <20110530154211.GA11325@redhat.com>
 <20110601053903.GE23067@mtj.dyndns.org>
 <20110602123105.GD10410@mtj.dyndns.org>
 <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik5hV8dnyspyGz8YAAdtoQNQDyOSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Denys.

On Thu, Jun 02, 2011 at 04:51:48PM +0200, Denys Vlasenko wrote:
> SIGSTOP/TSTP/TTIN/TTOU on entering group-stop,
> SIGCONT on leaving group-stop.

Yeah and SIGTRAP on INTERRUPT.  It makes sense.

> > * Implicit signal on clone.
> 
> Best if it is converted to STOP trap (the same is one caused by INTERRUPT).
> 
> I guess this may be optionally changed
> (similar to how PTRACE_O_TRACEEXEC
> changes post-execve SIGTRAP into PTRACE_EVENT_EXEC).
> 
> Why not turn it on *unconditionally* on SEIZE?
> Because otherwise ptrace users will turn into
> 
> if (we_used_SEIZE)
>     do_something;
> else
>     do_something_else;
> 
> maze, which is maintenance nightmare.
> It's possible users will opt to not use new functionality at all
> instead of going that way.

Hmmm... I see.  The other side of the argument is that some level of
"if (SEIZEd)" is inevitable anyway and in the longer run we would be
better off defaulting to the better behavior than making things
optional.

> If everything is monolithically tied into SEIZE, users won't be able
> to opt to use only easy parts of new functionality (such as
> PTRACE_INTERRUPT and PTRACE_LISTEN) if this *forces* them
> to also use harder parts of new functionality, in this case
> forces them to double and obfuscate their existing code
> which handles SIGSTOP-on-child-auto-attach. They don't really
> want to, since this SIGSTOP *in practice* isn't that problematic.

Anyways, let's think about that, but SIGSTOP on clone is closely
linked to why SEIZE is used in the first place and I currently lean
toward tying it to SEIZE.

> > * What to do about events which are reported by genuine SIGTRAP
> >  generation?
> 
> I don't understand what you meant here. Example(s)?

The syscall, breakpoint, single step SIGTRAPs which can't be
distinguished from userland generated SIGTRAPs and may be mixed and/or
lost.  Maybe it's best to leave them alone or maybe we can add some
way to distinguish them which is mostly backward compatible (which is
enabled w/ SEIZE and hopefully doesn't require noticeable userland
changes).

> > * Group leader exit issue.
> 
> Ohhh this is an ugly one. It turns out it is linked to the question
> of "how execve works under ptrace", in a non-obvious way.
> I will respond in the second thread, with an example of current
> kernel's breakage.

I haven't followed the thread yet.  Let's talk about it in that
thread.

Thanks.

-- 
tejun
