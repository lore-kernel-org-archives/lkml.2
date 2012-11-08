Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2KHND5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:03:57 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:13060 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2KHNDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:53 -0500
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
To: oleg@redhat.com (Oleg Nesterov)
Date: Fri, 9 Nov 2012 00:03:48 +1100 (EST)
Cc: dvlasenk@redhat.com (Denys Vlasenko),
        mtk.manpages@gmail.com (Michael Kerrisk),
        serge.hallyn@canonical.com (Serge Hallyn),
        scarybeasts@gmail.com (Chris Evans),
        dhowells@redhat.com (David Howells),
        ebiederm@xmission.com (Eric W. Biederman),
        akpm@linux-foundation.org (Andrew Morton), u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121108123716.GA20917@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121108130348.4F9CB592017@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Again,

> Or the child can check getppid() == saved_parent_pid after PTRACE_TRACEME.

In fact that's what I did when I  tested the new option - the child ran:

	volatile long ready = 0;
	int saved_parent_pid = getpid();

	if(!(son = fork())
	{
		while(!ready)
		{
			sched_yield();
			if(getppid() != saved_parent_pid)
				exit(1);
		}
		execve(...);
	}
	ptrace(PTRACE_ATTACH, son, 0, 0);
	waitpid(son, ...);
	ptrace(PTRACE_SETOPTIONS, son, 0, PTRACE_P_TRACEFORK|PTRACE_O_EXITKILL);
	ptrace(PTRACE_POKEDATA, son, &ready, 1);
	/* continue tracing */

I also checked that PTRACE_O_EXITKILL is inherited to grandchildren.

Yes, I may also use PTRACE_SEIZE, but since it is not yet documented,
I will need to read the kernel code more to make extra sure it has no
unwanted side effects.

Best Regards,
Amnon.


Oleg Nesterov wrote:
> 
> Hi Amnon,
> 
> On 11/08, Amnon Shiloh wrote:
> >
> > Thanks for the patch, I tried it and it works nicely!
> 
> OK, thanks. I'll wait for other comments a bit and then send
> the patch to Andrew.
> 
> > Also, I just noticed that this new option (PTRACE_O_EXITKILL) is not
> > safe with ptrace(PTRACE_TRACEME)+execve, because the parent may die
> > before even having a chance to set PTRACE_O_EXITKILL!
> 
> Not safe? I guess you meant that PTRACE_O_EXITKILL can't prevent
> this race? Yes sure. Or the parent can die before it does
> PTRACE_O_EXITKILL.
> 
> > However, that's easy to fix by using PTRACE_ATTACH instead.
> 
> Or the child can check getppid() == saved_parent_pid after PTRACE_TRACEME.
> 
> But if you switch to PTRACE_ATTACH, I'd suggest to use PTRACE_SEIZE.
> Note that, in particular, this allows you to specify the options at
> attach.
> 
> As for PF_NO_SIGSTOP, I'll write another email.
> 
> Oleg.
> 
> 

