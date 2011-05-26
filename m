Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1EZKBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:01:47 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:41435 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1EZKBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:01:46 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Thu, 26 May 2011 11:01:42 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <20110525181856.GA16575@redhat.com> <20110526091041.GC9715@htj.dyndns.org>
In-Reply-To: <20110526091041.GC9715@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261101.43237.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011 10:10:41, Tejun Heo wrote:
> > Btw. Speaking of SEIZE->execvd->INTERRUPT which makes the tracee see
> > a SIGTRAP. 

I was told before that when SEIZE was in effect, there's no magic
SIGTRAP on exec.

> > Stupid question. Perhaps PTRACE_SEIZE should set
> > PT_TRACESYSGOOD | PT_TRACE_EXEC along with PT_SEIZED automatically?
> > PT_SEIZED implies the new behaviour anyway.
> 
> Yeap, it makes sense to set them by default.  

SYSGOOD makes sense, it just enables a means to distinguish syscall
SIGTRAPs from regular SIGTRAPs -- it doesn't cause child stops itself.
TRACE_EXEC, I'm not so sure.  (and it appears to have been proposed
on the premise that SEIZE would still report the SIGTRAP).
Why would that make sense, and not TRACE_FORK, for example?  I can imagine
a tracer only caring for syscall entry/exit, and not needing a special
event on exec.  IMO, any kind of event that forces a child stop that
would't happen if the child wasn't traced should have to be enabled
explicitly.

Heck, GDB passes a subset of signals straight down to
the child without informing the user (e.g., see "handle SIGALRM"
command), and it would be an improvement in
the tracer-affects-tracee's-scheduling department to have a means to
let ptrace know a tracer isn't interested in such-and-such signals.
Conversely, going with the non-intrusive tracing theme, it would
even make sense for the tracer to have to request "let me know
about signals (all or a subset) sent to tracee too"

-- 
Pedro Alves
