Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab1EOQf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:35:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46040 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1EOQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L/zZemNyXlZ24aH5uRKhswFzXp9jZjgCuVkpRc0pLTXx6LVDWt3C6+cuJeN7rM3WnZ
         XyBssLfeu4yXd43//ZnIKsYYRAp61J0nhBzojsrghukOqGfQ15fKrkA1L53TxnmywOCu
         vsR8PvbJfbEw4OCVyPoxzTTvv4oNw5LlaEWms=
Date: Sun, 15 May 2011 18:35:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace:
 implement PTRACE_INTERRUPT]
Message-ID: <20110515163523.GH23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <20110515161000.GE31855@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515161000.GE31855@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Sun, May 15, 2011 at 06:10:00PM +0200, Jan Kratochvil wrote:
> I do not think this change is much related to this patchset.
> 
> But having to PTRACE_INTERRUPT the tracee before PTRACE_DETACH has no
> advantage, it is just a performance (see transparent tracking of 10000+ thread
> 	https://lkml.org/lkml/2011/5/15/115
> ) problem and also getting it correct.  As when one wait()s and gets
> WIFSTOPPED one needs to respawn to signal otherwise the signal gets lost on
> PTRACE_ATTACH.  How to respawn it?  By PTRACE_INTERRUPT with DATA==signal?
> Or PTRACE_CONT with DATA==signal?  With rapid signalling of the tracee the
> debugger may never have a chance to correctly quit.  Handling other cases
> transparently for the original parent also may not be fully clear.
> 
> It would be nice to write documentation already while discussing this patch,
> I do not know if PTRACE_INTERRUPT respects DATA etc., it may show ptrace is
> still tricky.

Hmmm... you seem to be a bit confused about different ptrace traps
(again, a lot of this probably stems from incorrect manpage).  They
don't interact with each other that way and there is no correctness
issue (if there is, it's a but and should be fixed) of
INTERRUPT+DETACH compared to DETACH without interrupt.  The only
difference is performance, so let's concentrate on that.

The reason why I'm reluctant to drop trapped requirement from both
SEIZE and DETACH is that removing those synchronization points opens
up a lot of corner cases.  I'm they can all be dealt with but it's
gonna be measurably more complex and possibly fragile.  Given that the
current implementation mandates traps on both ATTACH and DETACH, I'd
like to leave that part alone unless there are pretty strong
arguments, and, sure, performance might as well be strong enough.

But, I'd really like to know how much it actually costs to attach and
detach a lot of tasks before deciding anything.

Thank you.

-- 
tejun
