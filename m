Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1G2TYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:24:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54079 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1G2TYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:24:04 -0400
Date: Fri, 29 Jul 2011 21:23:58 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Message-ID: <20110729192358.GB31717@mtj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jul 27, 2011 at 06:31:59PM +0200, Oleg Nesterov wrote:
> 	- is it safe to exit/stop on !x86 machine???
> 
> 	  I do not know. May be this needs some #ifdef's around
> 	  wait_for_completion_interruptible(). I am not sure that,
> 	  say, arch_ptrace_stop() can't abuse the ->mm shared with
> 	  the child.
>
> 	  OTOH. This can happen anyway, do_fork() does ptrace_event()
> 	  before wait_for_completion().

The only affected architecture would be ia64 thanks to the rolling
register stack.  I suspected it would unroll on fork but couldn't
determine whether it actually does that.  At any rate, it should be
safe as the child isn't allowed to return from the forking function
and arch_ptrace_stop() unrolling the register stack shouldn't affect
the child.  Eh... too much speculation, probably best to ask ia64 ppl.

A wild, possibly bat-shit crazy idea about the whole series:

If the current implementation is too nasty, an alternative approach
could be handling vfork waiting as a type of job control stop.
ie. while a task has vforked children, it's considered to have sticky
STOP state and can't leave get_signal_to_deliver() unless killed.  I
think this could be a bit more natural than trying to allow restart of
vfork().

So, very roughly, something like the following for the parent.

* On vfork(), mark vfork child exists and set TIF_SIGPENDING.

* When entering get_signal_to_deliver(), if vfork child exists, save
  sigmask and block all blockable signals.

* If dequeue_signal() returns 0 && vfork child exists, enter STOP.

* When leaving get_signal_to_deliver(), restore sigmask if saved on
  entry.

Haven't really thought a lot about the details so this might end up
uglier than the current attempt.  :)

Thanks.

-- 
tejun
