Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1EXKrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:47:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EXKrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q2FqIlVEBuNRzj3JkyfcAxaMyuuR68efl+tilFdM6dKTzLUupWJKaxyvSVp1fpgfSo
         CbcbTdPB833/etQ13IgLY91yTD3rC8COIqrBbmHx+gnbwRXPwTSbtivffZArTkVk2R1U
         XNMeLXawMlOoJ8LhDhaYz7b66WRcfxYDl+Tic=
Date: Tue, 24 May 2011 12:28:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110524102834.GC10334@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
 <20110523124314.GA7232@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523124314.GA7232@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, May 23, 2011 at 02:43:14PM +0200, Oleg Nesterov wrote:
> On 05/18, Tejun Heo wrote:
> > I've been thinking about Jan's suggestion to make ATTACH and DETACH
> > not require tracee to trap. We already have this for DETACH for cases
> > where the tracer is killed
> 
> Yes, I still think that the new DETACH_XXX request which doesn't need
> the stopped tracee makes sense. Yes, we have PTRACE_INTERRUPT. But please
> recall the previous discussion, it is possible that the tracee can't
> react to PTRACE_INTERRUPT and trap because it waits for other threads
> we are tracing.

Yeah, untrapped DETACH sounds nice but as you've already acknowledged
in another reply, we have those nasty disable traps.  As the impact on
debugging capability is much lower, having a synchronization barrier
on detach might not be such a bad idea.  As for debugger building
dependency loop with debuggees, I think SIGKILL is the solution there.
Debugger can do that with PTRACE_INTERRUPT regardless of DETACH after
all.

> And. Currently there is no way to detach a zombie leader. Perhaps we
> should change do_wait(), but it is not clear what should we do if the
> tracer is the real parent (we already discussed this a bit).

Hmmm... maybe just allow detaching zombie leader?  As it's guaranteed
to be not running, we don't have problem with ptrace_disable.

> > and for that to be truly useful
> > I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.
> 
> Hmm. Why? we could pass this options along with PTRACE_SEIZE?

Hmmm... I just don't see any reason to combine them.  If the tracer
wants sync points, it can INTERRUPT tracee and adjust options;
otherwise, it can just do it.  Isn't that simpler?

Thanks.

-- 
tejun
