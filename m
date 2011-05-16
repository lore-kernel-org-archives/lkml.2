Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1EPJBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:01:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1EPJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g1+rLIeCmJB7GZHuWbLDLCT1qmSoQcJ6dV0vYZAsfJ+l3K8pZXZ9Y4TMd3N0WXl0uh
         IehneNXbZ0aDS+znqMY0JEt3zZ9qXOCtes8/p4J1zOkybIz2FbN1bWTrkAXH4gauJ9VO
         N+6NRkEhJuQpJxFTJJRUl+rAVHNAVhr3Rzo38=
Date: Mon, 16 May 2011 11:01:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace:
 implement PTRACE_INTERRUPT]
Message-ID: <20110516090125.GP23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <20110515161000.GE31855@host1.jankratochvil.net>
 <20110515163523.GH23665@htj.dyndns.org>
 <20110515173940.GA26241@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515173940.GA26241@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, May 15, 2011 at 07:39:40PM +0200, Jan Kratochvil wrote:
> #include <unistd.h>
> #include <sys/wait.h>
> #include <sys/ptrace.h>
> #include <stdio.h>
> #include <stdlib.h>
> static int status;
> static pid_t child;
> void
> handler (int signo)
> {
>   puts ("PASS");
>   exit (0);
> }
> /* Ensure CHILD is stopped even if it is running now - for PTRACE_DETACH.  */
> void
> stop_child_for_detach (void)
> {
>   kill (child, SIGCONT);	/* To be PTRACE_INTERRUPT in the future.  */
>   /* The problem - here a signal may get lost.  */
>   wait (&status);
> }
> int
> main (void)
> {
>   child = fork ();
>   switch (child)
>     {
>     case 0:
>       signal (SIGUSR2, handler);
>       ptrace (PTRACE_TRACEME, 0, NULL, NULL);
>       raise (SIGUSR1);
>       puts ("FAIL");
>       exit (1);
>     default:
>       wait (&status);
>       /* Sent by arbitrary external program.  */
>       kill (child, SIGUSR2);
>       /* Comment out for PTRACE_DETACH not requiring stopped tracee.  */
> #if 1
>       ptrace (PTRACE_CONT, child, NULL, NULL);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can lose signal here.  You must check which trap happened why and
then take action accordingly.  Argh... we really need better
documentation of ptrace behaviors and traps.  Anyways, sans the
confusion between debugger sent signals and signals from other sources
and the side effects caused by debugger sent ones, the current ptrace
interface isn't broken to the point where you just lose signal.

>       stop_child_for_detach ();
> #endif
>       ptrace (PTRACE_DETACH, child, NULL, NULL);
>     }
>   return 0;
> }
> 
> 
> > The reason why I'm reluctant to drop trapped requirement from both
> > SEIZE and DETACH is that removing those synchronization points opens
> > up a lot of corner cases.
> 
> They are either (currently) in the userland or they would be in the kernel.

Nope.  What userland is currently dealing with isn't that type of
conditions.  It's dealing with nasty side effects of implied and
required signals, which will be removed with the new interface.  Those
attach/detach sync points are currently in the kernel and wouldn't
change with the proposed updates.  You're suggesting to remove them.

So, it's not about moving them, at all.  It's about removing them.

That said, it might not be such a bad idea.  Let's see how difficult
or easy it actually is.

Thanks.

-- 
tejun
