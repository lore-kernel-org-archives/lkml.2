Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1CIJlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:41:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59800 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab1CIJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cEJ88CVGwf0bwp5G3pRH0rxHbR+v5Gao4KnVJcokJohav5bSxYXH+YSFfAHD5exDkJ
         uaghfgvEEfQbZyh8cABe2NUF7p3UTWaoDJ1chuI2YvqV2cOwjOhOgG8uv1isRavVHcQb
         JsnC3pnUgoSXg5wTBMEHHfcwLlTmie0DqCQBU=
Date: Wed, 9 Mar 2011 10:41:19 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: PTRACE_SEIZE/INTERRUPT: [RFC] Proposal for ptrace improvements
Message-ID: <20110309094119.GB27010@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307150803.GA16521@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307150803.GA16521@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Mar 07, 2011 at 04:08:03PM +0100, Oleg Nesterov wrote:
> Now that we more or less agree with Tejun's ideas,

Yay! I finally succeeded at wearing down everyone.  :-)

> > I can't see much, if any, benefit in implementing ATTACH and INTERRUPT
> > separately.
> 
> I can ;) Although the benefit is minor.
> 
> First of all, the single request can "hide" the user-space bugs.
> For example, gdb is very complex, suppose that it uses the wrong
> pid during the debugging session. In this case it would be nice if
> the kernel returns the error instead of attaching to the wrong
> thread.
> 
> Of course, gdb can use the wrong pid during attach as well, but
> this is less likely. Sometimes gdb doesn't even know that some
> thread has gone away, suppose that it blindly does PTRACE_SEIZE
> after that and this pid was alredy reused.
> 
> Or. Suppose that gdb tries to attach the whole thread group (it
> always does this), and attaches to the same thread twice by mistake.
> The kernel can help in this case and return the error.

Hmmm, okay, I see.

> And I think there are other reasons. Say, suppose we want to add
> the options for ATTACH/INTERRUPT. Right now I do not see the need,
> but who knows.

I think it would actually be better to share the option flags.  The
two operations (whether implemented as separate operations or not)
share the interrupting aspect and I think using separate set of
options can be a bit confusing.  Hmmm... maybe it's actually better to
make them have different prefixes and let the attach also accept the
interrupt flags.

> And. Error codes. Currently ptrace_check_attach() can only return
> ESRCH, this doesn't look very convenient. If we add INTERRUPT we
> can make this more informative. The same for PTRACE_ATTACH, btw.
> EPERM should mean security error, nothing else. IOW, error codes
> should be different depending on attach/interrupt mode.

I think there are two ways - two separate operations, say SEIZE (I
want to a different verb from ATTACH to avoid confusion) and
INTERRUPT, or let SEIZE take an option which enables attach mode, but
if we're gonna distinguish them it's probably better to opt for
separate opcodes.

> Final note... Previously I thought that we should not (I meant, can
> not) change the current behaviour of PTRACE_O_TRACECLONE/etc which
> sends SIGSTOP during the auto-attach. Now I am not sure, probably
> we can avoid SIGSTOP if the forking task was PTRACE_SEIZE'ed. IOW,
> perhaps the new ATTACH can have other "side effects". But, otoh,
> this can complicate the transition to the new requests. Say, you
> can't simply change strace to use PTRACE_SEIZE without auditing
> the "-f" code.

We can add attach option SIGSTOP_ON_AUTOATTACH to help the transition
but then again it requires userland application change anyway so I
think it would be better to simply enforce the new behavior when the
new attach is used.  It's not like lack of SIGSTOP is gonna be super
subtle.

> And. This is off-topic, but we can also add PTRACE_DETACH_XXX which
> does not require the stopped tracee. strace certainly needs it,
> although INTERRUPT can solve most of the problems.

I don't know.  The thing is that guaranteeing the tracee is in
TASK_TRACED on attach/detach prevents a lot of subtle corner cases.
Unless there are pretty compelling reasons, I'd like to keep that
invariant intact.  What else does strace require that can't be
provided by INTERRUPT + DETACH?

Thanks.

-- 
tejun
