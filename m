Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1EPNvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:51:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39053 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1EPNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IjHRBwktrA45/zZwjutAnajHmubNAvTh4/C2gO0HL+YaveLSsDCcb2/US4o6z758kj
         AlUhu5zUUcFxolbgj8HU7Dr69fFfHcV/QyIq8X748ageqBOriUWfJT3cEMUnNhR3S1Je
         v9kS8yZW4Wl+vPwgKv7SzFF/4+nm+VzmZKbXE=
Date: Mon, 16 May 2011 15:51:41 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516135141.GB23665@htj.dyndns.org>
References: <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516122642.GD10469@host1.jankratochvil.net>
 <20110516124259.GU23665@htj.dyndns.org>
 <20110516130339.GA12539@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516130339.GA12539@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Mon, May 16, 2011 at 03:03:39PM +0200, Jan Kratochvil wrote:
> If you check the GDB debugging session transcript I gave GDB stopped in
> a moment when all the threads already returned from tkill()s sending SIGUSR1s
> and SIGUSR2.

Yeap.

> All threads are stopped, user is investigating the situation.  And GDB tells
> the user (only) SIGUSR1 was delivered.  The user has no chance to find out
> SIGUSR2 is already pending / to be delivered.  This is one of the many reasons
> why debugging various racy cases is a nightmare.
> 
> I was trying to suggest some ways how to give user the complete overview of
> the debuggee situation - where both SIGUSR1 and SIGUSR2 would be reported on
> the first stop.
> 
> You are right GDB could examine SigCgt, SigBlk (not sure if others) and report
> those signals.  Maybe it is right that way and we can forget about it.

Yes, I think this is the correct way to deal with it.  Multiple
signals can be pending and/or blocked but a single thread can only
deliver a single signal at any given time, which may involve userland
execution.  Parallel delivery simply isn't defined, so I think what
you want here is the list of pending signals, not deliveries, and then
consulting the pending mask is the obvious thing to do.

> There is (was) a larger problem of signals reordering which I fixed in
> 	[patch 3/4]#3 linux-nat: Do not respawn signals
> 	http://sourceware.org/ml/gdb-patches/2010-09/msg00360.html
> but that mess you should have fixed by PTRACE_INTERRUPT which no longer
> interacts with signals.  But it gave me the idea of another situation above
> where the debugger may want to know all the currently pending signals at once.

Yeap, I agree that it would be nice if gdb informs the user of the
pending signals when it stops for signal delivery.

Thank you.

-- 
tejun
