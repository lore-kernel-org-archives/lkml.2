Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1ERJzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:55:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab1ERJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=La351H+BlrHgyw58uEThrO4ad3FlsIfKH9mUSZyj4tg3wGH6XST/Yr1TFZNga4B8J2
         4L6eQkVcGUCW1X++l7kb91CjpVekhXzBKHMS0CLOgXRuxBWNL7NhL9OuOf+O1DFVJgAx
         BHsIbTIxhLcdFoDFpLKhOODdPwL0yOu+xuQE0=
Date: Wed, 18 May 2011 11:55:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110518095539.GU20624@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105180240.56754.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Wed, May 18, 2011 at 02:40:56AM +0200, Denys Vlasenko wrote:
> This makes PTRACE_EVENT_STOP similar to other PTRACE_EVENTs.
> The only difference is that it can't be set by PTRACE_SETOPTIONS
> as other events do, but activated implicitly by PTRACE_SEIZE.

Also by PTRACE_INTERRUPT and group stop.

> This made me thinking.
> 
> How about making API even more similar to existing one?
> 
> Create PTRACE_O_TRACESTOP, make it settable by PTRACE_SETOPTIONS too.
> 
> Make PTRACE_SEIZE take the mask of PTRACE_O_xyz flags
> as data argument.
> If PTRACE_O_TRACESTOP is set, it works as you described above.
> If PTRACE_O_TRACESTOP is not set, then it works as good old PTRACE_ATTACH.
> In both cases, immediately at attach it sets opts a-la PTRACE_SETOPTIONS.
>
> We can even avoid introducing PTRACE_SEIZE at all, because
> currently PTRACE_ATTACH ignores its data argument.
> 
> I know, I know, "this changes API", but did we ever promise
> that PTRACE_ATTACH with nonzero data arg is a valid usage?
> Also, I perused first 10 pages of google code search results
> and I see that everybody passes 0 or NULL.

But as SEIZE introduces behavior differences throughout ptrace
operation, I think it's actually beneficial to use a distinctively new
request.  It's not like it costs anything or we're short on request
number space.

Similar issue with PTRACE_O_TRACESTOP.  It won't only enable TRACESTOP
it will change other behaviors too and I think allowing clearing the
option while attached would open up a lot of new issues without much
benefit.  Making it a PTRACE_O_ flag and not allowing clearing is
weird too.

I've been thinking about Jan's suggestion to make ATTACH and DETACH
not require tracee to trap.  We already have this for DETACH for cases
where the tracer is killed and it seems it wouldn't be too difficult
to make that happen for ATTACH either and for that to be truly useful
I suppose PTRACE_SETOPTIONS shouldn't require trapped state either.
Jan, would that be enough for the use cases you have on mind?

So, if we do that, there would be a clear separation between SEIZE and
INTERRUPT and there wouldn't be any reason to make SEIZE to set
PTRACE_O_ options or whatever.  It just attaches and the rest can be
done with appropriate requests.  SEIZE might not be the best name with
this functionality but I think ATTACH_NOINTERRUPT would be too
confusing in that it implies that the only difference is not
interrupting.  Can somebody think of a better verb?

Oleg, what do you think?

Thanks.

-- 
tejun
