Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0I3B5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:57:20 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:40032 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0I3B5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:57:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 21:57:19 EDT
Date: Thu, 30 Sep 2010 02:50:17 +0100 (BST)
From: "Maciej W. Rozycki" <macro@codesourcery.com>
To: David Daney <ddaney@caviumnetworks.com>
cc: Al Viro <viro@ftp.linux.org.uk>, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 3/5] mips: sanitize restart logics
In-Reply-To: <4CA38538.8000007@caviumnetworks.com>
Message-ID: <alpine.DEB.1.10.1009300218380.25860@tp.orcam.me.uk>
References: <E1P0eK5-0006j5-4q@ZenIV.linux.org.uk> <4CA38538.8000007@caviumnetworks.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010, David Daney wrote:

> > Put the original syscall number into ->regs[0] when we leave syscall
> > with error.  Use it in restart logics.  Everything else will have
> > it 0 since we pass through SAVE_SOME on all the ways in.  Note that
> > in places like bad_stack and inllegal_syscall we leave it 0 - it's
> > not restartable.
> > 
> 
> IIRC Userspace getcontext/setcontext rely on regs[0] having a value of zero in
> the when the signal handlers are invoked.

 Not exactly.  These GNU C library functions rely on the magic value of 
"1" there to recognise contexts they created themselves and which must 
therefore be handled by themselves internally (these contexts are not 
complete and only preserve the call-saved registers as specified by the 
respective MIPS ABIs, and are therefore unsafe to be passed to the 
rt_sigreturn(2) syscall).  All the other values, including of course "0", 
are not treated specially and the context is passed to rt_sigreturn(2) as 
usually.  This only matters in cases where e.g. setcontext(3) is used to 
exit from or return to a signal handler.

> I haven't fully traced through the code, but I hope that this 'invariant'
> holds both before and after this patch.  I think Maciej did the work on
> getcontext/setcontext, he may know for sure what the requirements are.

 Thanks for the heads-up, David -- I would have surely missed this e-mail 
from the flood I get.  I think the change is safe as MIPS/Linux only uses 
syscall numbers from 4000 up (not sure why such a non-round number was 
chosen; one like 4096 would seem more appropriate to me but there you go), 
so there should be no clash unless an invalid syscall number has a chance 
to be stored there.

 For how exactly the magic value is used please have a look at 
sysdeps/unix/sysv/linux/mips/*context.S in glibc-ports and search for 
"magic flag" (yes, I know these pieces of assembly butchered and mixed 
with CPP mince require some mind-twistedness to parse; sorry about that, 
but I tried my best and put some comments throughout so that the magic 
flag is easy to find ;) ).

  Maciej
